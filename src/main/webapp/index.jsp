<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.User" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HospitalCare — Enterprise Healthcare Management System</title>

<%@include file="component/allcss.jsp" %>
<%@include file="component/Scrollcss.jsp" %>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
<style>
    body {
      font-family: 'Inter', sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f8fafc;
      color: #1e293b;
    }
    
    .hero {
        background: linear-gradient(135deg, #0d5c38 0%, #198754 100%);
        color: white;
        padding: 70px 20px;
        text-align: center;
        border-radius: 0 0 24px 24px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    }

    .hero h2 {
        font-size: 42px;
        font-weight: 800;
        margin-bottom: 16px;
    }

    .hero p {
        font-size: 20px;
        opacity: 0.9;
        margin-bottom: 24px;
    }

    /* 4 Module Entry Cards */
    .portal-card {
        background: white;
        border-radius: 18px;
        padding: 28px 20px;
        text-align: center;
        box-shadow: 0 4px 20px rgba(0,0,0,0.06);
        border: 2px solid #e2e8f0;
        transition: all 0.3s ease;
        height: 100%;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }
    .portal-card:hover {
        transform: translateY(-6px);
        box-shadow: 0 12px 30px rgba(0,0,0,0.12);
    }
    .portal-card-admin:hover  { border-color: #1e293b; }
    .portal-card-doctor:hover { border-color: #0284c7; }
    .portal-card-staff:hover  { border-color: #059669; }
    .portal-card-user:hover   { border-color: #d97706; }

    .portal-icon {
        width: 64px;
        height: 64px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 28px;
        margin: 0 auto 18px auto;
    }

    .btn-portal-admin  { background: #1e293b; color: white; border-radius: 25px; font-weight: 700; }
    .btn-portal-doctor { background: #0284c7; color: white; border-radius: 25px; font-weight: 700; }
    .btn-portal-staff  { background: #059669; color: white; border-radius: 25px; font-weight: 700; }
    .btn-portal-user   { background: #d97706; color: white; border-radius: 25px; font-weight: 700; }

    .btn-portal-admin:hover  { background: #0f172a; color: white; }
    .btn-portal-doctor:hover { background: #0369a1; color: white; }
    .btn-portal-staff:hover  { background: #047857; color: white; }
    .btn-portal-user:hover   { background: #b45309; color: white; }

    .footer {
      background-color: #0d5c38;
      color: white;
      padding: 24px;
      text-align: center;
    }
</style>
</head>
<body>
   <%@include file="component/navbar.jsp" %>
   
    <!-- Hero Banner -->
    <section id="home" class="hero mb-4">
        <div class="container text-center">
            <h2><i class="fa-solid fa-hospital-user me-2"></i> Welcome to HospitalCare</h2>
            <p>Enterprise Medical Management & Patient Care System</p>
            <div>
                <a href="user_login.jsp" class="btn btn-warning btn-lg fw-bold rounded-pill px-5 shadow">
                    <i class="fa-solid fa-calendar-check me-2"></i> Patient Login / Book Appointment
                </a>
            </div>
        </div>
    </section> 

    <!-- 4 System Core Portals Grid -->
    <div class="container my-5">
        <div class="text-center mb-4">
            <h3 class="fw-bold text-success mb-1">Access System Portals</h3>
            <p class="text-muted">Select your designated module portal to sign in</p>
        </div>
        <div class="row g-4 justify-content-center">
            <!-- 1. Admin Portal Card -->
            <div class="col-md-3">
                <div class="portal-card portal-card-admin">
                    <div>
                        <div class="portal-icon" style="background:#f1f5f9; color:#1e293b"><i class="fa-solid fa-user-tie"></i></div>
                        <h4 class="fw-bold mb-2">Admin Portal</h4>
                        <p class="text-muted small mb-4">System oversight, doctor/staff management, analytics & reports.</p>
                    </div>
                    <a href="admin_login.jsp" class="btn btn-portal-admin w-100 py-2">
                        Admin Login <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>

            <!-- 2. Doctor Portal Card -->
            <div class="col-md-3">
                <div class="portal-card portal-card-doctor">
                    <div>
                        <div class="portal-icon" style="background:#e0f2fe; color:#0284c7"><i class="fa-solid fa-user-md"></i></div>
                        <h4 class="fw-bold mb-2">Doctor Portal</h4>
                        <p class="text-muted small mb-4">Appointments, patient prescriptions & drug safety CDSS.</p>
                    </div>
                    <a href="doctor_login.jsp" class="btn btn-portal-doctor w-100 py-2">
                        Doctor Login <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>

            <!-- 3. Staff Portal Card -->
            <div class="col-md-4 col-lg-2">
                <div class="portal-card portal-card-staff">
                    <div>
                        <div class="portal-icon" style="background:#d1fae5; color:#059669"><i class="fa-solid fa-user-nurse"></i></div>
                        <h4 class="fw-bold mb-2 fs-5">Staff Portal</h4>
                        <p class="text-muted small mb-3">Patient admissions, vitals & triage tracking.</p>
                    </div>
                    <a href="staff_login.jsp" class="btn btn-portal-staff w-100 py-2">
                        Staff Login <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>

            <!-- 4. Medical Portal Card -->
            <div class="col-md-4 col-lg-3">
                <div class="portal-card" style="border-color:#818cf8">
                    <div>
                        <div class="portal-icon" style="background:#e0e7ff; color:#4338ca"><i class="fa-solid fa-capsules"></i></div>
                        <h4 class="fw-bold mb-2 fs-5">Medical Portal</h4>
                        <p class="text-muted small mb-3">FEFO dispenser, cold-chain & lab diagnostics.</p>
                    </div>
                    <a href="medical_login.jsp" class="btn text-white w-100 py-2 fw-bold" style="background:#4338ca; border-radius:25px">
                        Medical Login <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>

            <!-- 5. Patient Portal Card -->
            <div class="col-md-4 col-lg-2">
                <div class="portal-card portal-card-user">
                    <div>
                        <div class="portal-icon" style="background:#fef3c7; color:#d97706"><i class="fa-solid fa-user"></i></div>
                        <h4 class="fw-bold mb-2 fs-5">Patient Portal</h4>
                        <p class="text-muted small mb-3">Slot booking, teleconsult & health passport.</p>
                    </div>
                    <a href="user_login.jsp" class="btn btn-portal-user w-100 py-2">
                        Patient Login <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
	
    <!-- Carousel Gallery -->
	<div id="carouselExampleIndicators" class="carousel slide container my-5" data-bs-ride="carousel">
      <div class="carousel-inner rounded-3 shadow">
        <div class="carousel-item active">
          <img src="img/hostfront1.jpg" class="d-block w-100" alt="..." height="420px" style="object-fit:cover;">
        </div>
        <div class="carousel-item">
          <img src="img/host2.jpg" class="d-block w-100" alt="..." height="420px" style="object-fit:cover;">
        </div>
        <div class="carousel-item">
          <img src="img/host3.jpg" class="d-block w-100" alt="..." height="420px" style="object-fit:cover;">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>

    <!-- Why Choose Us Features -->
    <div class="container my-5">
        <h3 class="text-center fw-bold mb-4 text-success">Why Choose HospitalCare?</h3>
        <div class="row g-4">
            <div class="col-md-3">
                <div class="card text-center p-4 h-100 border-0 shadow-sm rounded-3">
                    <i class="fa-solid fa-user-md fa-3x mb-3 text-success"></i>
                    <h5 class="fw-bold">Expert Doctors</h5>
                    <p class="text-muted small mb-0">Our team of qualified specialists ensures high-quality medical care.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center p-4 h-100 border-0 shadow-sm rounded-3">
                    <i class="fa-solid fa-stethoscope fa-3x mb-3 text-success"></i>
                    <h5 class="fw-bold">Advanced CDSS</h5>
                    <p class="text-muted small mb-0">Automated AI drug safety checking & patient triage monitoring.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center p-4 h-100 border-0 shadow-sm rounded-3">
                    <i class="fa-solid fa-hospital fa-3x mb-3 text-success"></i>
                    <h5 class="fw-bold">Interactive Wards</h5>
                    <p class="text-muted small mb-0">Real-time bed utilization mapping & capacity management.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center p-4 h-100 border-0 shadow-sm rounded-3">
                    <i class="fa-solid fa-phone-volume fa-3x mb-3 text-success"></i>
                    <h5 class="fw-bold">24/7 Emergency SOS</h5>
                    <p class="text-muted small mb-0">GPS-based paramedic ambulance dispatch system.</p>
                </div>
            </div>
        </div>
    </div>

    <div class="scroll-container my-4">
        <div class="scroll-text">Welcome to Hospital Management System — Developed by Shubham Shinde & Rajesh Galavi</div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <p class="mb-0">&copy; 2026 HospitalCare Enterprise System. All rights reserved. | <a href="#" class="text-warning">Privacy Policy</a></p>
    </footer>
</body>
</html>
