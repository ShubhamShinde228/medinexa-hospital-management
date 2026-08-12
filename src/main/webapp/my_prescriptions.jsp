<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.User, com.entity.Prescription" %>
<%@ page import="com.dao.PrescriptionDao" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("userObj");
    if (user == null) { response.sendRedirect("user_login.jsp"); return; }

    PrescriptionDao prDao = new PrescriptionDao(DBConnect.getConn());
    List<Prescription> prescriptions = prDao.getPrescriptionsByUserId(user.getId());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Prescriptions — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f9f4; }
        .presc-card { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 24px; margin-bottom: 20px; border-left: 5px solid #198754; transition: transform 0.2s; }
        .presc-card:hover { transform: translateY(-3px); }
        .medicine-badge { background: linear-gradient(135deg, #198754, #10b981); color: white; padding: 8px 18px; border-radius: 20px; font-weight: 700; font-size: 16px; display: inline-block; margin-bottom: 12px; }
        .info-chip { background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 8px; padding: 6px 12px; font-size: 13px; display: inline-flex; align-items: center; gap: 6px; margin: 3px; }
        .page-header { background: linear-gradient(135deg, #198754 0%, #0d5c38 100%); color: white; padding: 40px 0; }
        .empty-state { text-align: center; padding: 80px 20px; color: #9ca3af; }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %>

<div class="page-header">
    <div class="container text-center">
        <h2 class="fw-bold mb-1"><i class="fas fa-prescription-bottle-alt me-3"></i>My Prescriptions</h2>
        <p class="opacity-75 mb-0">All prescriptions written by your doctors</p>
    </div>
</div>

<div class="container py-5">
    <% if (prescriptions.isEmpty()) { %>
    <div class="empty-state">
        <i class="fas fa-prescription-bottle fa-4x mb-4" style="color:#d1fae5"></i>
        <h4 class="text-muted">No Prescriptions Yet</h4>
        <p>Your doctor's prescriptions will appear here after your appointments.</p>
        <a href="slot_booking.jsp" class="btn btn-success mt-2">
            <i class="fas fa-calendar-check me-2"></i>Book an Appointment
        </a>
    </div>
    <% } else { %>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h5 class="fw-bold">Total: <%=prescriptions.size()%> prescription(s)</h5>
    </div>

    <% // Group by appointment date — show each prescription as a card
       for (Prescription p : prescriptions) { %>
    <div class="presc-card">
        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3">
            <div class="flex-grow-1">
                <div class="medicine-badge"><i class="fas fa-pills me-2"></i><%=p.getMedicineName()%></div>
                <div class="mt-2">
                    <% if (p.getDosage() != null && !p.getDosage().isEmpty()) { %>
                    <span class="info-chip"><i class="fas fa-weight-hanging text-success"></i><%=p.getDosage()%></span>
                    <% } %>
                    <% if (p.getFrequency() != null && !p.getFrequency().isEmpty()) { %>
                    <span class="info-chip"><i class="fas fa-clock text-primary"></i><%=p.getFrequency()%></span>
                    <% } %>
                    <span class="info-chip"><i class="fas fa-calendar-alt text-warning"></i><%=p.getDurationDays()%> days</span>
                    <% if (p.getDoctorName() != null) { %>
                    <span class="info-chip"><i class="fas fa-user-md text-success"></i>Dr. <%=p.getDoctorName()%></span>
                    <% } %>
                    <span class="info-chip"><i class="fas fa-calendar text-secondary"></i>
                        <%=p.getCreatedAt()!=null?p.getCreatedAt().substring(0,10):""%>
                    </span>
                </div>
                <% if (p.getNotes() != null && !p.getNotes().isEmpty()) { %>
                <div class="mt-3 p-3 bg-light rounded">
                    <small><i class="fas fa-sticky-note text-warning me-2"></i><strong>Note:</strong> <%=p.getNotes()%></small>
                </div>
                <% } %>
            </div>
            <div class="d-flex flex-column gap-2">
                <a href="prescriptionPdf?appointmentId=<%=p.getAppointmentId()%>"
                   class="btn btn-success" target="_blank">
                    <i class="fas fa-file-pdf me-2"></i>Download PDF
                </a>
                <small class="text-center text-muted">Appointment #<%=p.getAppointmentId()%></small>
            </div>
        </div>
    </div>
    <% } %>
    <% } %>
</div>
</body>
</html>
