package com.payment;

import java.io.IOException;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import com.entity.AdmitPatient;
import com.entity.Payment;
import com.entity.User;

@WebServlet("/verifyPayment")
public class VerifyPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        // Support patient (userObj), staff (staffObj), and admin (adminObj) sessions
        Object sessionUser = session.getAttribute("userObj");
        boolean isStaff = false;
        if (sessionUser == null) {
            sessionUser = session.getAttribute("staffObj");
            isStaff = true;
        }
        if (sessionUser == null) {
            sessionUser = session.getAttribute("adminObj");
        }
        if (sessionUser == null) {
            resp.sendRedirect("user_login.jsp");
            return;
        }

        String orderId    = req.getParameter("razorpay_order_id");
        String paymentId  = req.getParameter("razorpay_payment_id");
        String signature  = req.getParameter("razorpay_signature");
        String type       = req.getParameter("type");

        String appointmentIdStr = req.getParameter("appointmentId");
        Integer appointmentId = null;
        if (appointmentIdStr != null && !appointmentIdStr.isBlank()) {
            try { appointmentId = Integer.parseInt(appointmentIdStr); } catch (NumberFormatException e) { /* ignore */ }
        }

        String admissionIdStr = req.getParameter("admissionId");
        Integer admissionId = null;
        if (admissionIdStr != null && !admissionIdStr.isBlank()) {
            try { admissionId = Integer.parseInt(admissionIdStr); } catch (NumberFormatException e) { /* ignore */ }
        }

        String billIdStr = req.getParameter("billId");
        Integer billId = null;
        if (billIdStr != null && !billIdStr.isBlank()) {
            try { billId = Integer.parseInt(billIdStr); } catch (NumberFormatException e) { /* ignore */ }
        }

        // Verify Razorpay signature (HMAC-SHA256)
        boolean verified = PaymentUtils.verifyRazorpaySignature(orderId, paymentId, signature);

        Connection conn = DBConnect.getConn();
        PaymentDao paymentDao       = new PaymentDao(conn);
        AppointmentDao appointmentDao = new AppointmentDao(conn);
        BillingDao billingDao       = new BillingDao(conn);
        AdmitPatientDAO admitDao    = new AdmitPatientDAO(conn);

        if (verified) {
            paymentDao.updatePaymentVerification(orderId, paymentId, signature, "SUCCESS");

            if ("APPOINTMENT_FEE".equals(type) && appointmentId != null) {
                appointmentDao.updatePaymentStatus(appointmentId, "PAID");

            } else if ("DISCHARGE_BILL".equals(type) && billId != null) {
                billingDao.updateBillPaymentStatus(billId, "PAID");
                Payment p = paymentDao.getPaymentByOrderId(orderId);
                double amount = (p != null) ? p.getAmount() : 0.0;
                if (admissionId != null) {
                    AdmitPatient patient = admitDao.getPatientById(admissionId);
                    String dischargeDate = (patient != null && patient.getDischargeDate() != null)
                            ? patient.getDischargeDate()
                            : new SimpleDateFormat("yyyy-MM-dd").format(new Date());
                    admitDao.dischargePatient(admissionId, dischargeDate, amount);
                    admitDao.updatePatientStatus(admissionId, "DISCHARGED");
                }

            } else if ("ADMISSION_DEPOSIT".equals(type) && admissionId != null) {
                admitDao.updatePatientStatus(admissionId, "ADMITTED");
                Payment p = paymentDao.getPaymentByOrderId(orderId);
                double amount = (p != null) ? p.getAmount() : 0.0;
                AdmitPatient patient = admitDao.getPatientById(admissionId);
                String adDate = (patient != null && patient.getAdmittedDate() != null) ? patient.getAdmittedDate() : "";
                admitDao.dischargePatient(admissionId, adDate, amount);
            }

            // Put success details in session so payment_success.jsp can display them
            Payment successPay = paymentDao.getPaymentByOrderId(orderId);
            if (successPay != null) {
                session.setAttribute("lastPaymentReceipt", successPay.getReceiptNumber());
                session.setAttribute("lastPaymentAmount",  successPay.getAmount());
                session.setAttribute("lastPaymentId",      successPay.getRazorpayPaymentId());
                session.setAttribute("lastPaymentType",    successPay.getPaymentType());
            }
            session.setAttribute("sucMsg", "Payment verified and completed successfully!");
            if (isStaff) {
                resp.sendRedirect("staff/payment_success.jsp");
            } else {
                resp.sendRedirect("payment_success.jsp");
            }

        } else {
            paymentDao.updatePaymentVerification(orderId, paymentId, signature, "FAILED");
            session.setAttribute("errorMsg", "Payment signature verification failed. If money was deducted, contact hospital admin.");
            if (isStaff) {
                resp.sendRedirect("staff/payment_failed.jsp");
            } else {
                resp.sendRedirect("payment_failed.jsp");
            }
        }
    }
}
