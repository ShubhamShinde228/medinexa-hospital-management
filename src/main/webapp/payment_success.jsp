<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.User" %>
<%
    /* ------------------------------------------------------------------
     * Payment Success Page — reads from session attrs set by VerifyPaymentServlet
     * ------------------------------------------------------------------ */
    User loggedUser = (User) session.getAttribute("userObj");
    if (loggedUser == null) loggedUser = (User) session.getAttribute("staffObj");
    if (loggedUser == null) {
        response.sendRedirect("user_login.jsp");
        return;
    }

    // Read payment details set by VerifyPaymentServlet
    String receipt     = (String) session.getAttribute("lastPaymentReceipt");
    Object amtObj      = session.getAttribute("lastPaymentAmount");
    String txnId       = (String) session.getAttribute("lastPaymentId");
    String payType     = (String) session.getAttribute("lastPaymentType");
    String sucMsg      = (String) session.getAttribute("sucMsg");

    // Clear session attrs
    session.removeAttribute("lastPaymentReceipt");
    session.removeAttribute("lastPaymentAmount");
    session.removeAttribute("lastPaymentId");
    session.removeAttribute("lastPaymentType");
    session.removeAttribute("sucMsg");

    double amt = (amtObj instanceof Double) ? (Double) amtObj : 0.0;

    String purposeLabel = "APPOINTMENT_FEE".equals(payType) ? "Appointment Booking Fee"
                        : "DISCHARGE_BILL".equals(payType)  ? "Hospital Discharge Bill"
                        : "Admission Deposit";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful — Medi Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #198754, #0d6efd); min-height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Segoe UI', sans-serif; padding: 20px; }
        .success-card { background: white; border-radius: 24px; padding: 48px 36px; max-width: 480px; width: 100%; text-align: center; box-shadow: 0 24px 64px rgba(0,0,0,.3); animation: pop .5s cubic-bezier(.36,.07,.19,.97); }
        @keyframes pop { 0% { transform: scale(.7); opacity: 0; } 80% { transform: scale(1.04); } 100% { transform: scale(1); opacity: 1; } }
        .check-circle { width: 90px; height: 90px; border-radius: 50%; background: linear-gradient(135deg, #198754, #20c997); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 20px; animation: scaleIn .4s .2s both; box-shadow: 0 8px 24px rgba(25,135,84,.4); }
        @keyframes scaleIn { from { transform: scale(0); } to { transform: scale(1); } }
        .check-circle i { font-size: 2.4rem; color: white; }
        h2 { font-size: 1.7rem; font-weight: 800; color: #1a1a2e; margin-bottom: 6px; }
        .subtitle { color: #6c757d; font-size: .95rem; margin-bottom: 28px; }
        .info-table { background: #f8f9fa; border-radius: 14px; overflow: hidden; margin-bottom: 28px; }
        .info-row { display: flex; justify-content: space-between; padding: 12px 18px; border-bottom: 1px solid #e9ecef; font-size: .91rem; }
        .info-row:last-child { border-bottom: none; }
        .info-label { color: #6c757d; }
        .info-val { font-weight: 700; color: #1a1a2e; }
        .amount-highlight { font-size: 2rem; font-weight: 800; color: #198754; margin: 10px 0 24px; }
        .btn-home { background: linear-gradient(135deg, #0d6efd, #198754); color: white; border: none; border-radius: 50px; padding: 12px 30px; font-weight: 600; font-size: .95rem; text-decoration: none; display: inline-block; margin: 4px; transition: all .25s; }
        .btn-home:hover { color: white; transform: translateY(-2px); box-shadow: 0 10px 24px rgba(13,110,253,.35); }
        .btn-outline-sec { background: transparent; color: #0d6efd; border: 2px solid #0d6efd; border-radius: 50px; padding: 10px 28px; font-weight: 600; font-size: .95rem; text-decoration: none; display: inline-block; margin: 4px; transition: all .25s; }
        .btn-outline-sec:hover { background: #0d6efd; color: white; }
    </style>
</head>
<body>
<div class="success-card">
    <div class="check-circle"><i class="fas fa-check"></i></div>
    <h2>Payment Successful!</h2>
    <p class="subtitle">Your payment has been verified and processed securely.</p>

    <% if (amt > 0) { %>
    <div class="amount-highlight">&#8377;<%= String.format("%.2f", amt) %></div>
    <% } %>

    <div class="info-table">
        <% if (receipt != null && !receipt.isEmpty()) { %>
        <div class="info-row">
            <span class="info-label"><i class="fas fa-receipt me-1"></i>Receipt No.</span>
            <span class="info-val"><%= receipt %></span>
        </div>
        <% } %>
        <% if (txnId != null && !txnId.isEmpty()) { %>
        <div class="info-row">
            <span class="info-label"><i class="fas fa-hashtag me-1"></i>Transaction ID</span>
            <span class="info-val" style="word-break:break-all;font-size:.82rem;"><%= txnId %></span>
        </div>
        <% } %>
        <% if (payType != null && !payType.isEmpty()) { %>
        <div class="info-row">
            <span class="info-label"><i class="fas fa-tag me-1"></i>Purpose</span>
            <span class="info-val"><%= purposeLabel %></span>
        </div>
        <% } %>
        <div class="info-row">
            <span class="info-label"><i class="fas fa-shield-alt me-1"></i>Status</span>
            <span class="info-val" style="color:#198754;">&#10003; Verified</span>
        </div>
    </div>

    <% if (sucMsg != null) { %>
    <div class="alert alert-success py-2 mb-20" style="font-size:.88rem; margin-bottom:20px;border-radius:10px;">
        <i class="fas fa-check-circle me-1"></i><%= sucMsg %>
    </div>
    <% } %>

    <a href="index.jsp" class="btn-home"><i class="fas fa-home me-1"></i>Home</a>
    <a href="view_appointment.jsp" class="btn-outline-sec"><i class="fas fa-calendar me-1"></i>My Appointments</a>
</div>
</body>
</html>
