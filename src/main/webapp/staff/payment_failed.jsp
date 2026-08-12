<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String errorMsg = (String) session.getAttribute("errorMsg");
    session.removeAttribute("errorMsg");
    String urlError = request.getParameter("error");
    String displayError = (errorMsg != null && !errorMsg.isEmpty()) ? errorMsg
                        : (urlError != null && !urlError.isEmpty()) ? urlError
                        : "Payment was not completed. Please try again.";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Failed — Staff Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #dc3545, #fd7e14); min-height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Segoe UI', sans-serif; padding: 20px; }
        .card { border-radius: 24px; padding: 48px 36px; max-width: 480px; width: 100%; text-align: center; box-shadow: 0 24px 64px rgba(0,0,0,.3); animation: shake .5s; }
        @keyframes shake { 0%,100%{transform:translateX(0)} 20%,60%{transform:translateX(-8px)} 40%,80%{transform:translateX(8px)} }
        .fail-circle { width: 90px; height: 90px; border-radius: 50%; background: linear-gradient(135deg, #dc3545, #fd7e14); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 20px; }
        .fail-circle i { font-size: 2.4rem; color: white; }
    </style>
</head>
<body>
<div class="card bg-white">
    <div class="fail-circle"><i class="fas fa-times"></i></div>
    <h2 class="fw-bold mb-2">Payment Failed</h2>
    <p class="text-muted mb-3">The payment could not be completed.</p>
    <div class="alert alert-danger text-start mb-3" style="border-radius:12px;font-size:.9rem;">
        <i class="fas fa-exclamation-triangle me-2"></i><%= displayError %>
    </div>
    <div class="alert alert-warning text-start mb-4" style="border-radius:12px;font-size:.85rem;">
        <i class="fas fa-info-circle me-2"></i>If any amount was deducted, it will be refunded within 5–7 working days.
    </div>
    <a href="javascript:history.back()" class="btn btn-danger rounded-pill px-4 me-2"><i class="fas fa-redo me-1"></i>Try Again</a>
    <a href="../staff/index.jsp" class="btn btn-outline-secondary rounded-pill px-4"><i class="fas fa-home me-1"></i>Dashboard</a>
</div>
</body>
</html>
