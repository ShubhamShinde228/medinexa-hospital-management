package com.payment;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.dao.BillingDao;
import com.dao.PaymentDao;
import com.dao.AdmitPatientDAO;
import com.db.DBConnect;
import com.entity.Billing;
import com.entity.BillingItem;
import com.entity.Payment;
import com.entity.User;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        Connection conn = DBConnect.getConn();
        BillingDao billingDao = new BillingDao(conn);

        if ("view".equals(action)) {
            String billIdStr = req.getParameter("billId");
            if (billIdStr != null && !billIdStr.isBlank()) {
                try {
                    int billId = Integer.parseInt(billIdStr);
                    Billing bill = billingDao.getBillById(billId);
                    List<BillingItem> items = billingDao.getBillingItems(billId);
                    req.setAttribute("bill", bill);
                    req.setAttribute("items", items);
                    req.getRequestDispatcher("staff/billing.jsp").forward(req, resp);
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        resp.sendRedirect(req.getContextPath() + "/staff/index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        Connection conn = DBConnect.getConn();
        BillingDao billingDao = new BillingDao(conn);
        PaymentDao paymentDao = new PaymentDao(conn);
        AdmitPatientDAO admitPatientDao = new AdmitPatientDAO(conn);
        HttpSession session = req.getSession();

        if ("create".equals(action)) {
            try {
                int admissionId = Integer.parseInt(req.getParameter("admissionId"));
                String patientName = req.getParameter("patientName");
                String doctorName = req.getParameter("doctorName");
                String admissionDate = req.getParameter("admissionDate");
                String dischargeDate = req.getParameter("dischargeDate");
                String notes = req.getParameter("notes");

                double discount = 0.0;
                String discountStr = req.getParameter("discount");
                if (discountStr != null && !discountStr.isBlank()) {
                    discount = Double.parseDouble(discountStr);
                }

                double tax = 0.0;
                String taxStr = req.getParameter("tax");
                if (taxStr != null && !taxStr.isBlank()) {
                    tax = Double.parseDouble(taxStr);
                }

                String[] itemTypes = req.getParameterValues("itemType[]");
                if (itemTypes == null) itemTypes = req.getParameterValues("itemType");

                String[] itemDescs = req.getParameterValues("itemDesc[]");
                if (itemDescs == null) itemDescs = req.getParameterValues("itemDesc");

                String[] itemQties = req.getParameterValues("itemQty[]");
                if (itemQties == null) itemQties = req.getParameterValues("itemQty");

                String[] itemPrices = req.getParameterValues("itemPrice[]");
                if (itemPrices == null) itemPrices = req.getParameterValues("itemPrice");

                double subtotal = 0.0;
                if (itemTypes != null) {
                    for (int i = 0; i < itemTypes.length; i++) {
                        int qty = Integer.parseInt(itemQties[i]);
                        double price = Double.parseDouble(itemPrices[i]);
                        subtotal += qty * price;
                    }
                }

                double grandTotal = subtotal - discount + tax;
                String invoiceNumber = billingDao.generateInvoiceNumber();

                Billing bill = new Billing();
                bill.setAdmissionId(admissionId);
                bill.setPatientName(patientName);
                bill.setDoctorName(doctorName);
                bill.setAdmissionDate(admissionDate);
                bill.setDischargeDate(dischargeDate);
                bill.setSubtotal(subtotal);
                bill.setDiscount(discount);
                bill.setTax(tax);
                bill.setGrandTotal(grandTotal);
                bill.setPaymentStatus("PENDING");
                bill.setInvoiceNumber(invoiceNumber);
                bill.setNotes(notes);

                int billId = billingDao.createBill(bill);
                if (billId > 0) {
                    if (itemTypes != null) {
                        for (int i = 0; i < itemTypes.length; i++) {
                            BillingItem item = new BillingItem();
                            item.setBillId(billId);
                            item.setItemType(itemTypes[i]);
                            item.setDescription(itemDescs[i]);
                            int qty = Integer.parseInt(itemQties[i]);
                            double price = Double.parseDouble(itemPrices[i]);
                            item.setQuantity(qty);
                            item.setUnitPrice(price);
                            item.setTotalPrice(qty * price);
                            billingDao.addBillingItem(item);
                        }
                    }
                    admitPatientDao.updatePatientStatus(admissionId, "BILLING_PENDING");
                    session.setAttribute("sucMsg", "Bill created successfully!");
                    resp.sendRedirect(req.getContextPath() + "/staff/billing.jsp?billId=" + billId);
                } else {
                    session.setAttribute("errorMsg", "Failed to create bill. Please try again.");
                    resp.sendRedirect(req.getContextPath() + "/staff/ViewAdmittedPatients.jsp");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMsg", "Error processing billing request: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/staff/ViewAdmittedPatients.jsp");
            }

        } else if ("cashPayment".equals(action)) {
            try {
                int billId = Integer.parseInt(req.getParameter("billId"));
                String paymentMethod = req.getParameter("paymentMethod");
                double amount = Double.parseDouble(req.getParameter("amount"));

                Billing bill = billingDao.getBillById(billId);
                if (bill != null) {
                    User user = (User) session.getAttribute("userObj");
                    Payment p = new Payment();
                    p.setUserId(user != null ? user.getId() : null);
                    p.setAppointmentId(null);
                    p.setAdmissionId(bill.getAdmissionId());
                    p.setBillId(billId);
                    p.setPaymentType("DISCHARGE_BILL");
                    p.setAmount(amount);
                    p.setCurrency("INR");
                    p.setPaymentMethod(paymentMethod);
                    p.setRazorpayOrderId(null);
                    p.setRazorpayPaymentId("CASH-" + System.currentTimeMillis());
                    p.setStatus("SUCCESS");
                    p.setPatientName(bill.getPatientName());
                    p.setPatientEmail(null);
                    p.setReceiptNumber(PaymentUtils.generateReceiptNumber());

                    int paymentId = paymentDao.savePayment(p);
                    if (paymentId > 0) {
                        billingDao.updateBillPaymentStatus(billId, "PAID");
                        admitPatientDao.updatePatientStatus(bill.getAdmissionId(), "DISCHARGED");
                        admitPatientDao.dischargePatient(bill.getAdmissionId(), bill.getDischargeDate(), amount);
                        session.setAttribute("sucMsg", "Cash payment received and patient discharged successfully!");
                    } else {
                        session.setAttribute("errorMsg", "Failed to save cash payment transaction.");
                    }
                } else {
                    session.setAttribute("errorMsg", "Bill not found.");
                }
                resp.sendRedirect(req.getContextPath() + "/staff/billing.jsp?billId=" + billId);
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMsg", "Error processing cash payment: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/staff/index.jsp");
            }
        }
    }
}
