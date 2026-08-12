<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.MedicalStaff" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    MedicalStaff ms = (MedicalStaff) session.getAttribute("medicalObj");
    if (ms == null) {
        response.sendRedirect("../medical_login.jsp");
        return;
    }

    Connection conn = DBConnect.getConn();
    int lowStockCount = 0;
    try {
        PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM medical_inventory WHERE stock_quantity < 20");
        ResultSet rs = ps.executeQuery();
        if (rs.next()) lowStockCount = rs.getInt(1);
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Medical Command Center & Pharmacy Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f5f3ff; }
        .page-header { background: linear-gradient(135deg, #3730a3 0%, #4338ca 100%); color: white; padding: 32px; border-radius: 16px; margin-bottom: 28px; }
        .card-stat { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 24px; transition: all 0.25s; border: 1px solid #e0e7ff; }
        .card-stat:hover { transform: translateY(-4px); box-shadow: 0 10px 25px rgba(67, 56, 202, 0.12); }
        .stat-icon { width: 56px; height: 56px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 24px; }
    </style>
</head>
<body>
<%@include file="navbar.jsp" %><br>

<div class="container mt-4 mb-5">
    <!-- Page Header -->
    <div class="page-header d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
            <h2 class="fw-bold mb-1"><i class="fas fa-capsules me-2 text-warning"></i>Medical Store & Pharmacy Command Center</h2>
            <p class="opacity-75 mb-0">Welcome, <%= ms.getFullName() %> (License #: <%= ms.getLicenseNo() %>)</p>
        </div>
        <span class="badge bg-success fs-6 p-3 shadow-sm rounded-pill">
            🟢 Cold-Chain Temp: 4.2°C (Optimal)
        </span>
    </div>

    <!-- 4 Operational Stat Cards -->
    <div class="row g-4 mb-4">
        <!-- 1. Prescriptions Pending -->
        <div class="col-md-3">
            <div class="card-stat d-flex align-items-center gap-3">
                <div class="stat-icon bg-indigo-subtle text-indigo" style="background:#e0e7ff; color:#4338ca"><i class="fas fa-prescription-bottle-alt"></i></div>
                <div>
                    <small class="text-muted d-block">Pending Prescriptions</small>
                    <h3 class="fw-bold text-dark mb-0">12</h3>
                </div>
            </div>
        </div>

        <!-- 2. Cold Chain Temp -->
        <div class="col-md-3">
            <div class="card-stat d-flex align-items-center gap-3">
                <div class="stat-icon" style="background:#d1fae5; color:#059669"><i class="fas fa-snowflake"></i></div>
                <div>
                    <small class="text-muted d-block">Vaccine Cold-Chain</small>
                    <h3 class="fw-bold text-success mb-0">4.2°C</h3>
                </div>
            </div>
        </div>

        <!-- 3. Low Stock Reorder Alert -->
        <div class="col-md-3">
            <div class="card-stat d-flex align-items-center gap-3">
                <div class="stat-icon" style="background:#fee2e2; color:#dc3545"><i class="fas fa-exclamation-triangle"></i></div>
                <div>
                    <small class="text-muted d-block">Low Stock Reorders</small>
                    <h3 class="fw-bold text-danger mb-0"><%= lowStockCount %> Items</h3>
                </div>
            </div>
        </div>

        <!-- 4. Lab Reports Analyzed -->
        <div class="col-md-3">
            <div class="card-stat d-flex align-items-center gap-3">
                <div class="stat-icon" style="background:#fef3c7; color:#d97706"><i class="fas fa-vial"></i></div>
                <div>
                    <small class="text-muted d-block">Lab Tests Processed</small>
                    <h3 class="fw-bold text-warning mb-0">28</h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Action Modules Grid -->
    <div class="row g-4">
        <!-- AI Smart Dispenser -->
        <div class="col-md-6">
            <div class="card-stat p-4 h-100">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <i class="fas fa-pills fa-2x text-indigo" style="color:#4338ca"></i>
                    <div>
                        <h4 class="fw-bold mb-0">AI Smart Medicine Dispenser</h4>
                        <small class="text-muted">FEFO Expiry Logic & Generic Substitute Matcher</small>
                    </div>
                </div>
                <p class="text-secondary small">Automatically verifies prescription dosages, audits First-Expired First-Out (FEFO) batches, and matches generic equivalents when brand stock is low.</p>
                <a href="dispense_medicine.jsp" class="btn btn-indigo fw-bold rounded-pill text-white px-4" style="background:#4338ca">
                    Open Smart Dispenser <i class="fas fa-arrow-right ms-1"></i>
                </a>
            </div>
        </div>

        <!-- Lab Diagnostic Analyzer -->
        <div class="col-md-6">
            <div class="card-stat p-4 h-100">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <i class="fas fa-vial fa-2x text-warning"></i>
                    <div>
                        <h4 class="fw-bold mb-0">Smart Diagnostic Lab Analyzer</h4>
                        <input type="hidden" id="dummy">
                        <small class="text-muted">Auto-Detect Out-of-Range Clinical Values</small>
                    </div>
                </div>
                <p class="text-secondary small">Input patient CBC, Lipid, and Renal lab findings to auto-flag critical out-of-range values in RED and generate signed diagnostic summaries.</p>
                <a href="lab_analyzer.jsp" class="btn btn-warning fw-bold rounded-pill px-4">
                    Open Lab Diagnostic Analyzer <i class="fas fa-arrow-right ms-1"></i>
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
