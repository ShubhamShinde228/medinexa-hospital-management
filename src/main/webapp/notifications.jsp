<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.NotificationDao" %>
<%@ page import="com.entity.Notification, com.entity.User, com.entity.Doctor, com.entity.Staff" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%
    // Detect logged-in role
    String role = null;
    int userId = 0;
    String dashboardLink = "index.jsp";

    Object userObj  = session.getAttribute("userObj");
    Object docObj   = session.getAttribute("doctObj") != null ? session.getAttribute("doctObj") : session.getAttribute("doctorObj");
    Object staffObj = session.getAttribute("staffObj");
    Object adminObj = session.getAttribute("adminObj");

    if (adminObj != null) { role = "ADMIN";  userId = 1; dashboardLink = "admin/index.jsp"; }
    else if (docObj != null) { role = "DOCTOR"; userId = ((Doctor) docObj).getId(); dashboardLink = "doctor/index.jsp"; }
    else if (staffObj != null) { role = "STAFF"; userId = ((Staff) staffObj).getId(); dashboardLink = "staff/index.jsp"; }
    else if (userObj != null) { role = "USER"; userId = ((User) userObj).getId(); dashboardLink = "index.jsp"; }
    else { response.sendRedirect("index.jsp"); return; }

    List<Notification> notifications = new ArrayList<>();
    try {
        NotificationDao nDao = new NotificationDao(DBConnect.getConn());
        nDao.markAllRead(role, userId);
        notifications = nDao.getAll(role, userId);
    } catch (Exception _nEx) {
        // Notification table may not exist yet — silently ignore
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notifications — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f9f4; }
        .page-header { background: linear-gradient(135deg, #198754 0%, #0d5c38 100%); color: white; padding: 40px 0; }
        .notif-card { background: white; border-radius: 14px; padding: 20px 24px; margin-bottom: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.05); display: flex; align-items: flex-start; gap: 18px; border-left: 4px solid #198754; transition: transform 0.18s; cursor: pointer; }
        .notif-card:hover { transform: translateX(4px); }
        .notif-card.unread { border-left-color: #3b82f6; background: #eff6ff; }
        .notif-icon { width: 44px; height: 44px; border-radius: 50%; background: linear-gradient(135deg, #198754, #10b981); color: white; display: flex; align-items: center; justify-content: center; font-size: 18px; flex-shrink: 0; }
        .notif-time { font-size: 12px; color: #9ca3af; margin-top: 4px; }
        .empty-state { text-align: center; padding: 80px 20px; color: #9ca3af; }
    </style>
</head>
<body>


<div class="page-header">
    <div class="container text-center">
        <h2 class="fw-bold mb-1"><i class="fas fa-bell me-3"></i>Notifications</h2>
        <p class="opacity-75 mb-0">All notifications for your account — <%=role%></p>
    </div>
</div>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h5 class="fw-bold"><%=notifications.size()%> notification(s)</h5>
        <a href="<%=dashboardLink%>" class="btn btn-outline-success btn-sm">
            <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
        </a>
    </div>

    <% if (notifications.isEmpty()) { %>
    <div class="empty-state">
        <i class="fas fa-bell-slash fa-4x mb-4" style="color:#d1fae5"></i>
        <h4>No Notifications</h4>
        <p>You're all caught up! New notifications will appear here.</p>
    </div>
    <% } else {
        for (Notification n : notifications) { %>
    <div class="notif-card <%=!n.isRead()?"unread":""%>"
         onclick="window.location='<%=n.getLink()!=null?n.getLink():"#"%>'">
        <div class="notif-icon">
            <i class="fas fa-bell"></i>
        </div>
        <div class="flex-grow-1">
            <div class="fw-semibold"><%=n.getMessage() != null ? n.getMessage() : ""%></div>
            <div class="notif-time">
                <i class="fas fa-clock me-1"></i>
                <%=n.getCreatedAt() != null ? n.getCreatedAt().substring(0, Math.min(16, n.getCreatedAt().length())) : ""%>
            </div>
        </div>
        <% if (!n.isRead()) { %>
        <span class="badge bg-primary align-self-start" style="font-size:10px">NEW</span>
        <% } %>
    </div>
    <% } } %>
</div>
</body>
</html>
