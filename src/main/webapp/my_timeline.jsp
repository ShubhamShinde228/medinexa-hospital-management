<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.User, com.entity.MedicalHistory" %>
<%@ page import="com.dao.MedicalHistoryDao" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("userObj");
    if (user == null) { response.sendRedirect("user_login.jsp"); return; }

    MedicalHistoryDao mhDao = new MedicalHistoryDao(DBConnect.getConn());
    List<MedicalHistory> events = mhDao.getHistoryByUserId(user.getId());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Medical History — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f9f4; }
        .page-header { background: linear-gradient(135deg, #198754 0%, #0d5c38 100%); color: white; padding: 48px 0; }
        /* Timeline Styles */
        .timeline { position: relative; padding: 0; }
        .timeline::before { content: ''; position: absolute; left: 40px; top: 0; bottom: 0; width: 3px; background: linear-gradient(to bottom, #198754, #a7f3d0); }
        .tl-item { display: flex; align-items: flex-start; gap: 20px; margin-bottom: 32px; position: relative; animation: fadeSlideIn 0.5s ease both; }
        .tl-icon { width: 56px; height: 56px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; position: relative; z-index: 1; box-shadow: 0 4px 12px rgba(0,0,0,0.15); }
        .tl-content { background: white; border-radius: 16px; padding: 20px 24px; box-shadow: 0 4px 16px rgba(0,0,0,0.06); flex: 1; border-left: 4px solid transparent; transition: transform 0.2s; }
        .tl-content:hover { transform: translateX(4px); }
        .tl-date { font-size: 12px; color: #9ca3af; margin-top: 6px; }

        /* Event type colors */
        .type-APPOINTMENT  { background: #dbeafe; } .type-APPOINTMENT  .tl-icon { background: #3b82f6; color: white; } .type-APPOINTMENT  .tl-content { border-color: #3b82f6; }
        .type-ADMISSION    { background: #fef3c7; } .type-ADMISSION    .tl-icon { background: #f59e0b; color: white; } .type-ADMISSION    .tl-content { border-color: #f59e0b; }
        .type-PRESCRIPTION { background: #d1fae5; } .type-PRESCRIPTION .tl-icon { background: #198754; color: white; } .type-PRESCRIPTION .tl-content { border-color: #198754; }
        .type-DISCHARGE    { background: #fce7f3; } .type-DISCHARGE    .tl-icon { background: #ec4899; color: white; } .type-DISCHARGE    .tl-content { border-color: #ec4899; }
        .type-PAYMENT      { background: #ede9fe; } .type-PAYMENT      .tl-icon { background: #7c3aed; color: white; } .type-PAYMENT      .tl-content { border-color: #7c3aed; }
        .type-LAB          { background: #ffedd5; } .type-LAB          .tl-icon { background: #f97316; color: white; } .type-LAB          .tl-content { border-color: #f97316; }
        .type-NOTE         { background: #f0fdf4; } .type-NOTE         .tl-icon { background: #6b7280; color: white; } .type-NOTE         .tl-content { border-color: #6b7280; }

        @keyframes fadeSlideIn { from { opacity: 0; transform: translateX(-20px); } to { opacity: 1; transform: translateX(0); } }
        .empty-state { text-align: center; padding: 80px 20px; }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %>

<div class="page-header">
    <div class="container text-center">
        <h2 class="fw-bold mb-1"><i class="fas fa-notes-medical me-3"></i>My Medical History</h2>
        <p class="opacity-75 mb-0">Your complete health record timeline — appointments, prescriptions, and more</p>
    </div>
</div>

<div class="container py-5">
    <% if (events.isEmpty()) { %>
    <div class="empty-state">
        <i class="fas fa-heartbeat fa-4x mb-4" style="color:#d1fae5"></i>
        <h4 class="text-muted">No Medical History Yet</h4>
        <p class="text-muted">Your medical journey will appear here as you book appointments, get prescriptions, and more.</p>
        <a href="slot_booking.jsp" class="btn btn-success mt-2">
            <i class="fas fa-calendar-check me-2"></i>Book Your First Appointment
        </a>
    </div>
    <% } else { %>
    <div class="mb-3 text-muted small">
        <i class="fas fa-info-circle me-1"></i>Showing <%=events.size()%> events — most recent first
    </div>
    <div class="timeline">
        <% for (int i = 0; i < events.size(); i++) {
               MedicalHistory mh = events.get(i);
               String type = mh.getEventType() != null ? mh.getEventType() : "NOTE";
               String icon = "fa-notes-medical";
               String label = "Event";
               switch (type) {
                   case "APPOINTMENT":  icon = "fa-calendar-check"; label = "Appointment"; break;
                   case "ADMISSION":    icon = "fa-hospital";        label = "Admission";   break;
                   case "PRESCRIPTION": icon = "fa-pills";           label = "Prescription";break;
                   case "DISCHARGE":    icon = "fa-sign-out-alt";    label = "Discharge";   break;
                   case "PAYMENT":      icon = "fa-credit-card";     label = "Payment";     break;
                   case "LAB":          icon = "fa-flask";           label = "Lab Test";    break;
                   default:             icon = "fa-sticky-note";     label = "Note";
               }
        %>
        <div class="tl-item type-<%=type%>" style="animation-delay: <%=i*0.08%>s">
            <div class="tl-icon"><i class="fas <%=icon%>"></i></div>
            <div class="tl-content">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <span class="badge me-2" style="background:rgba(0,0,0,0.1);color:inherit"><%=label%></span>
                        <p class="mb-1 fw-semibold mt-1"><%=mh.getDescription() != null ? mh.getDescription() : ""%></p>
                    </div>
                    <% if (mh.getAppointmentId() > 0) { %>
                    <small class="text-muted text-nowrap ms-2">Appt #<%=mh.getAppointmentId()%></small>
                    <% } %>
                </div>
                <div class="tl-date">
                    <i class="fas fa-clock me-1"></i>
                    <%=mh.getEventDate() != null ? mh.getEventDate().replace("T", " ").substring(0, Math.min(16, mh.getEventDate().length())) : ""%>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>
