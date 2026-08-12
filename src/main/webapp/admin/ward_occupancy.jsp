<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.WardDao, com.dao.AdmitPatientDAO, com.dao.DoctorDao" %>
<%@ page import="com.entity.Ward, com.entity.AdmitPatient, com.entity.Doctor" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.util.List, java.sql.*, java.util.ArrayList" %>
<%
    Object adminObj = session.getAttribute("adminObj");
    Object staffObj = session.getAttribute("staffObj");
    if (adminObj == null && staffObj == null) {
        response.sendRedirect("../admin_login.jsp");
        return;
    }
    boolean isAdmin = (adminObj != null);

    Connection conn = DBConnect.getConn();
    WardDao wardDao = new WardDao(conn);
    AdmitPatientDAO admitDao = new AdmitPatientDAO(conn);

    List<Ward> wards = wardDao.getAllWards();
    List<AdmitPatient> patients = admitDao.getAdmittedPatientsOnly();

    int totalBeds = 0, occupiedBeds = 0;
    for (Ward w : wards) { 
        totalBeds += w.getCapacity(); 
        occupiedBeds += w.getCurrentOccupancy(); 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ward Occupancy & Bed Map — HospitalCare</title>
    <%@include file="../component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f9f4; }
        .page-header { background: linear-gradient(135deg, #198754 0%, #0d5c38 100%); color: white; padding: 36px; border-radius: 16px; margin-bottom: 28px; }
        .panel { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
        .metric-card { background: white; border-radius: 12px; padding: 20px; text-align: center; box-shadow: 0 2px 12px rgba(0,0,0,0.05); }
        .metric-num { font-size: 42px; font-weight: 800; line-height: 1; }
        
        /* Bed grid design */
        .ward-section { border: 2px solid #e5e7eb; border-radius: 14px; padding: 20px; margin-bottom: 20px; transition: all 0.2s; }
        .ward-section:hover { border-color: #198754; }
        .ward-title { font-weight: 700; font-size: 18px; margin-bottom: 14px; display: flex; align-items: center; gap: 10px; }
        .bed-grid { display: flex; flex-wrap: wrap; gap: 12px; }
        .bed { width: 64px; height: 56px; border-radius: 10px; display: flex; flex-direction: column; align-items: center; justify-content: center; font-size: 11px; font-weight: 600; cursor: pointer; transition: all 0.2s; position: relative; }
        .bed:hover { transform: scale(1.1); z-index: 2; box-shadow: 0 4px 12px rgba(0,0,0,0.15); }
        .bed-free { background: #d1fae5; color: #065f46; border: 2px solid #6ee7b7; }
        .bed-occ  { background: #fee2e2; color: #991b1b; border: 2px solid #fca5a5; }
        .bed-icon { font-size: 18px; }
        .progress-ward { height: 12px; border-radius: 6px; }
        .occupancy-pct { font-size: 14px; font-weight: 700; }
        .legend { display: flex; gap: 16px; flex-wrap: wrap; }
        .legend-item { display: flex; align-items: center; gap: 6px; font-size: 13px; }
        .legend-dot { width: 14px; height: 14px; border-radius: 4px; }
    </style>
</head>
<body>
<% if (isAdmin) { %>
    <%@include file="navbar.jsp" %>
<% } else { %>
    <%@include file="../staff/navbar.jsp" %>
<% } %>
<br>

<div class="container mt-4">
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <h2 class="fw-bold mb-1"><i class="fas fa-hospital-alt me-3"></i>Interactive Ward Bed Map</h2>
                <p class="opacity-75 mb-0">Real-time bed availability & occupancy tracking across all wards</p>
            </div>
            <div class="legend">
                <span class="legend-item"><span class="legend-dot" style="background:#6ee7b7"></span> Free Bed</span>
                <span class="legend-item"><span class="legend-dot" style="background:#fca5a5"></span> Occupied Bed</span>
            </div>
        </div>
    </div>

    <!-- Summary Metrics -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="metric-card">
                <div class="metric-num text-success"><%=totalBeds%></div>
                <div class="text-muted mt-1 fw-semibold">Total Capacity</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="metric-card">
                <div class="metric-num text-danger"><%=occupiedBeds%></div>
                <div class="text-muted mt-1 fw-semibold">Occupied Beds</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="metric-card">
                <div class="metric-num text-success"><%=totalBeds - occupiedBeds%></div>
                <div class="text-muted mt-1 fw-semibold">Available Beds</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="metric-card">
                <div class="metric-num text-warning">
                    <%=totalBeds > 0 ? String.format("%.0f", (occupiedBeds * 100.0 / totalBeds)) : 0%>%
                </div>
                <div class="text-muted mt-1 fw-semibold">Occupancy Rate</div>
            </div>
        </div>
    </div>

    <!-- Overall Progress Bar -->
    <div class="panel mb-4">
        <div class="d-flex justify-content-between mb-2">
            <strong>Overall Hospital Bed Utilization</strong>
            <span class="occupancy-pct"><%=occupiedBeds%> / <%=totalBeds%> Beds</span>
        </div>
        <div class="progress progress-ward">
            <div class="progress-bar bg-success progress-bar-striped progress-bar-animated" role="progressbar"
                 style="width: <%=totalBeds>0?(occupiedBeds*100/totalBeds):0%>%"></div>
        </div>
    </div>

    <!-- Per-Ward Bed Grid -->
    <% if (wards.isEmpty()) { %>
    <div class="panel text-center text-muted py-5">
        <i class="fas fa-hospital fa-3x mb-3"></i>
        <p class="fs-5">No wards added yet. Please add wards from the Admin Panel.</p>
        <% if (isAdmin) { %><a href="addward.jsp" class="btn btn-success btn-lg"><i class="fas fa-plus me-2"></i>Add Ward</a><% } %>
    </div>
    <% } else {
       for (Ward ward : wards) {
           int cap = ward.getCapacity();
           int occ = ward.getCurrentOccupancy();
           int free = Math.max(0, cap - occ);
           int pct = cap > 0 ? (occ * 100 / cap) : 0;
           String pbColor = pct >= 90 ? "bg-danger" : pct >= 70 ? "bg-warning" : "bg-success";
    %>
    <div class="panel ward-section">
        <div class="ward-title">
            <span style="font-size:24px">🏥</span>
            <div>
                <div><%=ward.getWardName()%></div>
                <small class="text-muted fw-normal"><%=ward.getWardType()%></small>
            </div>
            <div class="ms-auto text-end">
                <span class="occupancy-pct <%=pct>=90?"text-danger":pct>=70?"text-warning":"text-success"%>">
                    <%=occ%> / <%=cap%> beds (<%=pct%>%)
                </span>
            </div>
        </div>
        <div class="progress progress-ward mb-3">
            <div class="progress-bar <%=pbColor%>" style="width:<%=pct%>%"></div>
        </div>
        
        <!-- Bed Visualization -->
        <div class="bed-grid">
            <% for (int b = 1; b <= cap; b++) {
               boolean isOccupied = (b <= occ);
            %>
            <div class="bed <%=isOccupied?"bed-occ":"bed-free"%>"
                 title="Bed #<%=b%>: <%=isOccupied?"Occupied":"Available"%>">
                <div class="bed-icon"><i class="fas fa-bed"></i></div>
                <div>#<%=b%></div>
            </div>
            <% } %>
        </div>
        <div class="mt-3 d-flex gap-4 text-sm small text-muted">
            <span><i class="fas fa-circle text-danger me-1"></i><%=occ%> Occupied</span>
            <span><i class="fas fa-circle text-success me-1"></i><%=free%> Available</span>
        </div>
    </div>
    <% } } %>

    <!-- Currently Admitted Patients Table -->
    <div class="panel">
        <h5 class="fw-bold mb-4"><i class="fas fa-users text-success me-2"></i>Currently Admitted Patients</h5>
        <% if (patients.isEmpty()) { %>
        <div class="text-center text-muted py-3">No active patients currently admitted.</div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-success">
                    <tr><th>ID</th><th>Patient Name</th><th>Disease</th><th>Ward / Room</th><th>Admitted Date</th><th>Status</th></tr>
                </thead>
                <tbody>
                    <% for (AdmitPatient p : patients) { %>
                    <tr>
                        <td>#<%=p.getId()%></td>
                        <td><strong><%=p.getName()%></strong></td>
                        <td><%=p.getDisease()%></td>
                        <td><span class="badge bg-primary fs-6"><%=p.getRoomNumber()!=null?p.getRoomNumber():"N/A"%></span></td>
                        <td><%=p.getAdmittedDate()%></td>
                        <td><span class="badge bg-<%="ADMITTED".equals(p.getPatientStatus())?"success":"warning"%>">
                            <%=p.getPatientStatus()%></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>
<br>
</body>
</html>
