<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.db.DBConnect"%>
<%@ page import="com.dao.PaymentDao"%>
<%@ page import="com.entity.Payment"%>
<%@ page import="com.entity.User"%>
<%
    User user = (User) session.getAttribute("userObj");
    if (user == null) {
        session.setAttribute("errorMsg", "Please login to view payment history.");
        response.sendRedirect("user_login.jsp");
        return;
    }
    List<Payment> payments = new PaymentDao(DBConnect.getConn()).getPaymentsByUser(user.getId());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment History - MEDI HOME</title>
    <%@ include file="component/allcss.jsp" %>
</head>
<body>
    <%@ include file="component/navbar.jsp" %>

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="text-success fw-bold mb-1"><i class="fa-solid fa-receipt me-2"></i> Payment History</h3>
                <p class="text-muted mb-0 small">Overview of all your payments and transaction receipts.</p>
            </div>
            <a class="btn btn-success btn-sm fw-semibold" href="view_appointment.jsp">
                <i class="fa-solid fa-calendar-check me-1"></i> Booked Appointments
            </a>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-body p-4">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr class="table-success">
                                <th>Receipt Number</th>
                                <th>Date & Time</th>
                                <th>Purpose</th>
                                <th>Amount</th>
                                <th>Method</th>
                                <th>Status</th>
                                <th class="text-center">Invoice</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% if (payments == null || payments.isEmpty()) { %>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">No payment history found.</td>
                            </tr>
                        <% } else {
                            for (Payment p : payments) { %>
                                <tr>
                                    <td><strong><%= p.getReceiptNumber() != null ? p.getReceiptNumber() : "-" %></strong></td>
                                    <td class="small"><%= p.getCreatedAt() %></td>
                                    <td><span class="badge bg-secondary"><%= p.getPaymentType().replace("_", " ") %></span></td>
                                    <td class="fw-semibold text-dark">INR <%= String.format("%.2f", p.getAmount()) %></td>
                                    <td><%= p.getPaymentMethod() %></td>
                                    <td>
                                        <% if ("SUCCESS".equalsIgnoreCase(p.getStatus())) { %>
                                            <span class="badge bg-success">SUCCESS</span>
                                        <% } else if ("FAILED".equalsIgnoreCase(p.getStatus())) { %>
                                            <span class="badge bg-danger">FAILED</span>
                                        <% } else { %>
                                            <span class="badge bg-warning text-dark"><%= p.getStatus() %></span>
                                        <% } %>
                                    </td>
                                    <td class="text-center">
                                        <% if ("SUCCESS".equalsIgnoreCase(p.getStatus()) && p.getBillId() != null && p.getBillId() > 0) { %>
                                            <a href="generateInvoice?billId=<%= p.getBillId() %>" class="btn btn-outline-success btn-sm py-1 px-2">
                                                <i class="fa-solid fa-file-pdf"></i> PDF
                                            </a>
                                        <% } else { %>
                                            <span class="text-muted small">-</span>
                                        <% } %>
                                    </td>
                                </tr>
                        <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
