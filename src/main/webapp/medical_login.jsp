<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Medical Store & Pharmacy Login — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #312e81 0%, #1e1b4b 100%); min-height: 100vh; display: flex; flex-direction: column; }
        .login-card { background: white; border-radius: 20px; box-shadow: 0 10px 40px rgba(0,0,0,0.25); padding: 40px; width: 100%; max-width: 440px; margin: auto; }
        .login-header { text-align: center; margin-bottom: 28px; }
        .login-icon { width: 70px; height: 70px; background: #e0e7ff; color: #4338ca; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 32px; margin: 0 auto 16px auto; }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %>

<div class="container my-auto py-5">
    <div class="login-card">
        <div class="login-header">
            <div class="login-icon"><i class="fa-solid fa-capsules"></i></div>
            <h3 class="fw-bold text-dark mb-1">Medical Portal</h3>
            <p class="text-muted small mb-0">Pharmacy, Diagnostics & Cold-Chain Inventory</p>
        </div>

        <%
            String sucMsg = (String) session.getAttribute("sucMsg");
            String errMsg = (String) session.getAttribute("errorMsg");
            if (sucMsg != null) { session.removeAttribute("sucMsg"); %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-1"></i> <%= sucMsg %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } if (errMsg != null) { session.removeAttribute("errorMsg"); %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-1"></i> <%= errMsg %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

        <form action="medicalLogin" method="post">
            <div class="mb-3">
                <label class="form-label fw-semibold">Medical Staff Email</label>
                <input type="email" name="email" class="form-control form-control-lg" value="medical@hospital.com" placeholder="medical@hospital.com" required>
            </div>
            <div class="mb-4">
                <label class="form-label fw-semibold">Password</label>
                <input type="password" name="password" class="form-control form-control-lg" value="123456" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn btn-indigo btn-lg w-100 fw-bold rounded-pill text-white shadow" style="background:#4338ca">
                <i class="fas fa-sign-in-alt me-2"></i>Sign In to Medical Portal
            </button>
        </form>
    </div>
</div>
</body>
</html>
