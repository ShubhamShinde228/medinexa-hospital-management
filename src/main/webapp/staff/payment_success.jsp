<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Staff payment success — reads same session attrs as the user version
    String receipt  = (String) session.getAttribute("lastPaymentReceipt");
    Object amtObj   = session.getAttribute("lastPaymentAmount");
    String txnId    = (String) session.getAttribute("lastPaymentId");
    String payType  = (String) session.getAttribute("lastPaymentType");
    String sucMsg   = (String) session.getAttribute("sucMsg");
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
    <title>Payment Successful — Staff Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #198754, #0d6efd); min-height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Segoe UI', sans-serif; padding: 20px; }
        .card { border-radius: 24px; padding: 48px 36px; max-width: 480px; width: 100%; text-align: center; box-shadow: 0 24px 64px rgba(0,0,0,.3); }
        .check-circle { width: 90px; height: 90px; border-radius: 50%; background: linear-gradient(135deg, #198754, #20c997); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 20px; box-shadow: 0 8px 24px rgba(25,135,84,.4); }
        .check-circle i { font-size: 2.4rem; color: white; }
        .info-table { background: #f8f9fa; border-radius: 14px; overflow: hidden; margin: 20px 0; }
        .info-row { display: flex; justify-content: space-between; padding: 12px 18px; border-bottom: 1px solid #e9ecef; font-size: .91rem; }
        .info-row:last-child { border-bottom: none; }
    </style>
</head>
<body>
<div class="card bg-white">
    <div class="check-circle"><i class="fas fa-check"></i></div>
    <h2 class="fw-bold mb-2">Payment Successful!</h2>
    <p class="text-muted mb-3">Payment has been verified and recorded.</p>
    <% if (amt > 0) { %>
    <h3 class="text-success fw-bold mb-3">&#8377;<%= String.format("%.2f", amt) %></h3>
    <% } %>
    <div class="info-table">
        <% if (receipt != null && !receipt.isEmpty()) { %>
        <div class="info-row"><span class="text-muted">Receipt</span><span class="fw-bold"><%= receipt %></span></div>
        <% } %>
        <% if (txnId != null && !txnId.isEmpty()) { %>
        <div class="info-row"><span class="text-muted">Transaction ID</span><span class="fw-bold" style="font-size:.8rem;word-break:break-all;"><%= txnId %></span></div>
        <% } %>
        <div class="info-row"><span class="text-muted">Purpose</span><span class="fw-bold"><%= purposeLabel %></span></div>
        <div class="info-row"><span class="text-muted">Status</span><span class="fw-bold text-success">&#10003; Verified</span></div>
    </div>
    <% if (sucMsg != null) { %><div class="alert alert-success py-2 mb-3" style="border-radius:10px;font-size:.88rem;"><%= sucMsg %></div><% } %>
    <a href="../staff/index.jsp" class="btn btn-success rounded-pill px-4 me-2"><i class="fas fa-home me-1"></i>Staff Dashboard</a>
    <a href="../staff/Discharge.jsp" class="btn btn-outline-primary rounded-pill px-4"><i class="fas fa-hospital me-1"></i>Discharge</a>
</div>
</body>
</html>
