<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.User" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="com.entity.Appointment" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("userObj");
    List<Appointment> myAppointments = null;
    if (user != null) {
        AppointmentDao apDao = new AppointmentDao(DBConnect.getConn());
        myAppointments = apDao.getAllAppointmentByLoginUser(user.getId());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contactless QR Health Passport — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f8fafc; }
        .hero-qr { background: linear-gradient(135deg, #0f172a 0%, #334155 100%); color: white; padding: 40px 0; border-radius: 0 0 20px 20px; margin-bottom: 30px; text-align: center; }
        .card-passport { background: white; border-radius: 20px; box-shadow: 0 8px 30px rgba(0,0,0,0.08); padding: 32px; border: 2px solid #e2e8f0; }
        .qr-code-img { width: 220px; height: 220px; border-radius: 12px; border: 4px solid #0f172a; padding: 8px; background: white; }
        .passport-header { background: linear-gradient(135deg, #198754, #0d5c38); color: white; border-radius: 12px; padding: 16px; margin-bottom: 24px; }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %>

<div class="hero-qr">
    <div class="container">
        <h1 class="fw-bold mb-2"><i class="fas fa-qrcode me-2"></i> Patient QR Health Passport</h1>
        <p class="fs-5 opacity-75 mb-0">Contactless 1-second hospital kiosk check-in & digital health pass</p>
    </div>
</div>

<div class="container mb-5">
    <% if (user == null) { %>
        <div class="card-passport text-center py-5">
            <i class="fas fa-id-card fa-4x text-muted mb-3"></i>
            <h4 class="fw-bold">Please Login to Access Your QR Health Passport</h4>
            <p class="text-muted">Log in with your patient account to generate your digital barcode pass.</p>
            <a href="user_login.jsp" class="btn btn-success btn-lg rounded-pill px-5">Login Now</a>
        </div>
    <% } else { 
        String qrData = "PATIENT_ID:" + user.getId() + "|NAME:" + user.getFullName() + "|EMAIL:" + user.getEmail() + "|HMS2_VERIFIED";
        String qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=" + java.net.URLEncoder.encode(qrData, "UTF-8");
    %>
    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="card-passport">
                <!-- Passport Header -->
                <div class="passport-header d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="fw-bold mb-0"><i class="fas fa-hospital-symbol me-2"></i>HospitalCare Health Pass</h4>
                        <small class="opacity-75">Verified Inpatient & Outpatient Pass</small>
                    </div>
                    <span class="badge bg-warning text-dark fw-bold">ACTIVE</span>
                </div>

                <div class="row align-items-center text-center text-md-start">
                    <!-- QR Code -->
                    <div class="col-md-5 text-center mb-4 mb-md-0">
                        <img src="<%= qrUrl %>" alt="QR Code" class="qr-code-img shadow-sm"><br>
                        <small class="text-muted mt-2 d-block"><i class="fas fa-camera me-1"></i>Scan at Reception Kiosk</small>
                    </div>

                    <!-- Patient Metadata -->
                    <div class="col-md-7">
                        <h3 class="fw-bold mb-1 text-dark"><%= user.getFullName() %></h3>
                        <p class="text-muted mb-3"><i class="fas fa-id-badge me-1"></i> Patient ID: #<%= user.getId() %></p>

                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light">
                                    <small class="text-muted d-block">Email</small>
                                    <strong class="text-truncate d-block"><%= user.getEmail() %></strong>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="p-2 border rounded bg-light">
                                    <small class="text-muted d-block">Blood Group</small>
                                    <strong class="text-danger">O+ (Positive)</strong>
                                </div>
                            </div>
                        </div>

                        <div class="p-3 border border-success rounded-3 bg-success-subtle mb-3">
                            <small class="text-success fw-bold d-block mb-1"><i class="fas fa-calendar-check me-1"></i> Active Appointment Status:</small>
                            <% if (myAppointments != null && !myAppointments.isEmpty()) { 
                                   Appointment latest = myAppointments.get(0);
                            %>
                                <div><strong>Dr. Appointment:</strong> <%= latest.getAppoinDate() %></div>
                                <div class="small text-muted"><%= latest.getDiseases() %> | Status: <span class="badge bg-success"><%= latest.getStatus() %></span></div>
                            <% } else { %>
                                <small class="text-muted">No upcoming appointments scheduled.</small>
                            <% } %>
                        </div>

                        <button type="button" onclick="window.print()" class="btn btn-outline-dark btn-sm rounded-pill w-100">
                            <i class="fas fa-print me-1"></i> Print Digital Pass
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <% } %>
</div>
</body>
</html>
