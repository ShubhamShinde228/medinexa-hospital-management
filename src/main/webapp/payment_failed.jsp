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
    <title>Payment Failed — Medi Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #dc3545, #fd7e14); min-height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Segoe UI', sans-serif; padding: 20px; }
        .fail-card { background: white; border-radius: 24px; padding: 48px 36px; max-width: 480px; width: 100%; text-align: center; box-shadow: 0 24px 64px rgba(0,0,0,.3); animation: shake .5s; }
        @keyframes shake { 0%,100%{transform:translateX(0)} 10%,30%,50%,70%,90%{transform:translateX(-8px)} 20%,40%,60%,80%{transform:translateX(8px)} }
        .fail-circle { width: 90px; height: 90px; border-radius: 50%; background: linear-gradient(135deg, #dc3545, #fd7e14); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 20px; box-shadow: 0 8px 24px rgba(220,53,69,.4); }
        .fail-circle i { font-size: 2.4rem; color: white; }
        h2 { font-size: 1.7rem; font-weight: 800; color: #1a1a2e; margin-bottom: 6px; }
        .subtitle { color: #6c757d; font-size: .93rem; margin-bottom: 24px; }
        .error-box { background: #fff5f5; border: 1px solid #f5c6cb; border-radius: 12px; padding: 16px; margin-bottom: 28px; font-size: .9rem; color: #721c24; text-align: left; }
        .info-box { background: #fff3cd; border: 1px solid #ffeeba; border-radius: 12px; padding: 14px 18px; font-size: .85rem; color: #856404; margin-bottom: 24px; }
        .btn-retry { background: linear-gradient(135deg, #0d6efd, #198754); color: white; border: none; border-radius: 50px; padding: 12px 30px; font-weight: 600; font-size: .95rem; text-decoration: none; display: inline-block; margin: 4px; transition: all .25s; }
        .btn-retry:hover { color: white; transform: translateY(-2px); box-shadow: 0 10px 24px rgba(13,110,253,.35); }
        .btn-outline-back { background: transparent; color: #6c757d; border: 2px solid #dee2e6; border-radius: 50px; padding: 10px 28px; font-weight: 600; font-size: .95rem; text-decoration: none; display: inline-block; margin: 4px; transition: all .25s; }
        .btn-outline-back:hover { background: #f8f9fa; color: #1a1a2e; }
    </style>
</head>
<body>
<div class="fail-card">
    <div class="fail-circle"><i class="fas fa-times"></i></div>
    <h2>Payment Failed</h2>
    <p class="subtitle">Your payment could not be processed.</p>

    <div class="error-box">
        <i class="fas fa-exclamation-triangle me-2"></i><strong>Reason:</strong><br>
        <%= displayError %>
    </div>

    <div class="info-box">
        <i class="fas fa-info-circle me-2"></i>
        <strong>Note:</strong> If any amount was deducted from your account, it will be automatically refunded within 5–7 working days.
        Contact hospital admin if you need immediate assistance.
    </div>

    <a href="javascript:history.back()" class="btn-retry"><i class="fas fa-redo me-1"></i>Try Again</a>
    <a href="index.jsp" class="btn-outline-back"><i class="fas fa-home me-1"></i>Go Home</a>
</div>
</body>
</html>
