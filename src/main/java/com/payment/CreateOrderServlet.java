package com.payment;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.dao.AppointmentDao;
import com.dao.PaymentDao;
import com.dao.BillingDao;
import com.dao.AdmitPatientDAO;
import com.db.DBConnect;
import com.entity.Appointment;
import com.entity.Payment;
import com.entity.User;
import com.entity.Billing;
import com.entity.AdmitPatient;

@WebServlet("/createOrder")
public class CreateOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        // -------------------------------------------------------
        // Outer try-catch: ensures we ALWAYS return JSON, never raw HTTP 500
        // -------------------------------------------------------
        try {
            HttpSession session = req.getSession(false);
            if (session == null) {
                out.write("{\"success\":false,\"message\":\"Session expired. Please log in again.\"}");
                return;
            }

            // Support patient (userObj), staff (staffObj), and admin (adminObj) sessions
            Object sessionUser = session.getAttribute("userObj");
            if (sessionUser == null) {
                sessionUser = session.getAttribute("staffObj");
            }
            if (sessionUser == null) {
                sessionUser = session.getAttribute("adminObj");
            }
            if (sessionUser == null) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.write("{\"success\":false,\"message\":\"Not authenticated. Please log in.\"}");
                return;
            }

            int userIdVal = 0;
            String patientName = "Patient";
            String patientEmail = "";
            if (sessionUser instanceof User) {
                User u = (User) sessionUser;
                userIdVal = u.getId();
                patientName = (u.getFullName() != null) ? u.getFullName() : "Patient";
                patientEmail = (u.getEmail() != null) ? u.getEmail() : "";
            } else if (sessionUser instanceof com.entity.Staff) {
                com.entity.Staff s = (com.entity.Staff) sessionUser;
                userIdVal = s.getId();
                patientName = (s.getFullName() != null) ? s.getFullName() : "Staff";
                patientEmail = (s.getEmail() != null) ? s.getEmail() : "";
            }

            // Check Razorpay keys configured
            String keyId     = PaymentConfig.getKeyId();
            String keySecret = PaymentConfig.getKeySecret();
            if (keyId == null || keyId.isBlank() || keySecret == null || keySecret.isBlank()) {
                out.write("{\"success\":false,\"message\":\"Payment gateway not configured. Contact admin.\"}");
                return;
            }

            // Read + validate params
            String type      = req.getParameter("type");
            String amountStr = req.getParameter("amount");

            if (type == null || type.isBlank()) {
                out.write("{\"success\":false,\"message\":\"Missing parameter: type\"}");
                return;
            }
            if (amountStr == null || amountStr.isBlank()) {
                out.write("{\"success\":false,\"message\":\"Missing parameter: amount\"}");
                return;
            }

            double amount;
            try {
                amount = Double.parseDouble(amountStr.trim());
                if (amount <= 0) throw new NumberFormatException("Amount must be positive");
            } catch (NumberFormatException e) {
                out.write("{\"success\":false,\"message\":\"Invalid amount value: " + amountStr + "\"}");
                return;
            }

            Integer appointmentId = parseNullableInt(req.getParameter("appointmentId"));
            Integer admissionId   = parseNullableInt(req.getParameter("admissionId"));
            Integer billId        = parseNullableInt(req.getParameter("billId"));

            // Get DB connection — this is the most likely silent failure point
            Connection conn = DBConnect.getConn();
            if (conn == null) {
                out.write("{\"success\":false,\"message\":\"Database connection failed. Please try again.\"}");
                return;
            }

            AppointmentDao appointmentDao = new AppointmentDao(conn);
            PaymentDao     paymentDao     = new PaymentDao(conn);
            BillingDao     billingDao     = new BillingDao(conn);
            AdmitPatientDAO admitDao      = new AdmitPatientDAO(conn);

            // ---- Validate APPOINTMENT_FEE ----
            if ("APPOINTMENT_FEE".equals(type)) {
                if (appointmentId == null) {
                    out.write("{\"success\":false,\"message\":\"Appointment ID is required.\"}");
                    return;
                }
                Appointment appt = appointmentDao.getAppointmentById(appointmentId);
                if (appt == null) {
                    out.write("{\"success\":false,\"message\":\"Appointment #" + appointmentId + " not found.\"}");
                    return;
                }
                // Check duplicate payment
                java.util.List<Payment> existing = paymentDao.getPaymentsByAppointment(appointmentId);
                if (existing != null && !existing.isEmpty()) {
                    out.write("{\"success\":false,\"message\":\"Appointment fee already paid.\"}");
                    return;
                }
            }

            // ---- Create Razorpay order ----
            int amountPaise = (int) Math.round(amount * 100);
            String receipt  = PaymentUtils.generateReceiptNumber();

            String orderResp = PaymentUtils.postRazorpayOrder(amountPaise, receipt);
            if (orderResp == null || orderResp.isBlank()) {
                out.write("{\"success\":false,\"message\":\"Could not reach Razorpay. Check internet and try again.\"}");
                return;
            }

            String orderId = PaymentUtils.extractJsonValue(orderResp, "id");
            if (orderId == null || orderId.isBlank()) {
                // Razorpay returned an error — extract the error description
                String errDesc = PaymentUtils.extractJsonValue(orderResp, "description");
                if (errDesc == null) errDesc = orderResp.replace("\"", "'");
                out.write("{\"success\":false,\"message\":\"Razorpay error: " + errDesc + "\"}");
                return;
            }

            // ---- Determine patient name/email ----
            if ("APPOINTMENT_FEE".equals(type) && appointmentId != null) {
                Appointment ap = appointmentDao.getAppointmentById(appointmentId);
                if (ap != null) {
                    patientName  = ap.getFullname() != null ? ap.getFullname() : patientName;
                    patientEmail = ap.getEmail()    != null ? ap.getEmail()    : patientEmail;
                }
            } else if ("DISCHARGE_BILL".equals(type) && billId != null) {
                Billing bill = billingDao.getBillById(billId);
                if (bill != null && bill.getPatientName() != null) patientName = bill.getPatientName();
            } else if ("ADMISSION_DEPOSIT".equals(type) && admissionId != null) {
                AdmitPatient patient = admitDao.getPatientById(admissionId);
                if (patient != null && patient.getName() != null) patientName = patient.getName();
            }

            // ---- Save CREATED payment record ----
            Payment p = new Payment();
            p.setUserId(userIdVal);
            p.setAppointmentId(appointmentId);
            p.setAdmissionId(admissionId);
            p.setBillId(billId);
            p.setPaymentType(type);
            p.setAmount(amount);
            p.setCurrency("INR");
            p.setPaymentMethod("RAZORPAY");
            p.setRazorpayOrderId(orderId);
            p.setStatus("CREATED");
            p.setPatientName(patientName);
            p.setPatientEmail(patientEmail);
            p.setReceiptNumber(receipt);

            int savedId = paymentDao.savePayment(p);
            if (savedId <= 0) {
                out.write("{\"success\":false,\"message\":\"Failed to save payment record. Please try again.\"}");
                return;
            }

            // ---- Return success JSON ----
            out.write("{\"success\":true,\"orderId\":\"" + orderId + "\",\"amount\":" + amountPaise
                    + ",\"key\":\"" + keyId + "\",\"receipt\":\"" + receipt + "\"}");

        } catch (Exception ex) {
            // Log the real exception to Tomcat console
            ex.printStackTrace();
            // Return a clean JSON 500 instead of raw HTTP 500 page
            try {
                out.write("{\"success\":false,\"message\":\"Server error: " 
                        + ex.getClass().getSimpleName() + " — " 
                        + ex.getMessage().replace("\"", "'") + "\"}");
            } catch (Exception ignored) { /* response already committed */ }
        }
    }

    /** Returns null if str is null, blank, or non-numeric; otherwise returns parsed Integer. */
    private static Integer parseNullableInt(String str) {
        if (str == null || str.isBlank()) return null;
        try { return Integer.parseInt(str.trim()); } catch (NumberFormatException e) { return null; }
    }
}
