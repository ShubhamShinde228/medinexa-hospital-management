<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.AdmitPatientDAO, com.dao.DoctorDao, com.dao.PatientVitalsDao, com.dao.WardDao" %>
<%@ page import="com.entity.Staff, com.entity.AdmitPatient, com.entity.Doctor" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.util.List, java.sql.Connection" %>
<%
    Staff staff = (Staff) session.getAttribute("staffObj");
    if (staff == null) {
        response.sendRedirect("../staff_login.jsp");
        return;
    }

    Connection conn = DBConnect.getConn();
    AdmitPatientDAO admitDao = new AdmitPatientDAO(conn);
    DoctorDao doctorDao = new DoctorDao(conn);
    PatientVitalsDao vitalsDao = new PatientVitalsDao(conn);
    WardDao wardDao = new WardDao(conn);

    List<AdmitPatient> activePatients = admitDao.getAdmittedPatientsOnly();
    int activeAdmissionsCount = activePatients.size();
    int criticalCount = vitalsDao.countCriticalPatients();
    int doctorCount = doctorDao.countDoctor();
    int totalWards = wardDao.getAllWards().size();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Command Dashboard — HospitalCare</title>
    <%@include file="../component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f7f3; }
        .hero-staff { background: linear-gradient(135deg, #0d5c38 0%, #198754 100%); color: white; padding: 36px 0; border-radius: 0 0 24px 24px; margin-bottom: 30px; }
        .stat-card { background: white; border-radius: 16px; padding: 24px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); transition: all 0.25s; border-left: 5px solid #198754; }
        .stat-card:hover { transform: translateY(-4px); box-shadow: 0 8px 30px rgba(25, 135, 84, 0.15); }
        .stat-num { font-size: 38px; font-weight: 800; line-height: 1; color: #0d5c38; }
        .action-card { background: white; border-radius: 16px; padding: 24px; text-align: center; box-shadow: 0 4px 20px rgba(0,0,0,0.06); border: 2px solid transparent; transition: all 0.25s; text-decoration: none; color: inherit; display: block; }
        .action-card:hover { border-color: #198754; transform: translateY(-4px); box-shadow: 0 8px 30px rgba(25, 135, 84, 0.15); color: #198754; }
        .action-icon { width: 64px; height: 64px; background: #e8f5e9; color: #198754; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 26px; margin: 0 auto 16px auto; }
        .panel-table { background: white; border-radius: 16px; padding: 28px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); }
    </style>
</head>
<body>
<%@include file="navbar.jsp" %>

<!-- Hero Header -->
<div class="hero-staff">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <h2 class="fw-bold mb-1"><i class="fas fa-user-nurse me-2 text-warning"></i>Welcome, <%= staff.getFullName() %> 👋</h2>
                <p class="opacity-75 mb-0">Role: <span class="badge bg-warning text-dark"><%= staff.getSpecialist() %></span> | Shift Operations Command Center</p>
            </div>
            <div>
                <a href="vitals_tracker.jsp" class="btn btn-warning fw-bold px-4 py-2 rounded-pill shadow-sm">
                    <i class="fas fa-heartbeat me-1"></i> Triage Alert Log
                </a>
            </div>
        </div>
    </div>
</div>

<div class="container mb-5">
    <!-- Stat Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="stat-card" style="border-color: #198754;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-num"><%= activeAdmissionsCount %></div>
                        <div class="text-muted fw-semibold mt-1">Admitted Patients</div>
                    </div>
                    <i class="fas fa-procedures fa-2x text-success opacity-50"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="border-color: #dc3545;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-num text-danger"><%= criticalCount %></div>
                        <div class="text-muted fw-semibold mt-1">Critical Triage Patients</div>
                    </div>
                    <i class="fas fa-exclamation-triangle fa-2x text-danger opacity-50"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="border-color: #0d6efd;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-num text-primary"><%= totalWards %></div>
                        <div class="text-muted fw-semibold mt-1">Active Hospital Wards</div>
                    </div>
                    <i class="fas fa-hospital-alt fa-2x text-primary opacity-50"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="border-color: #ffc107;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-num text-warning"><%= doctorCount %></div>
                        <div class="text-muted fw-semibold mt-1">Available Doctors</div>
                    </div>
                    <i class="fas fa-user-md fa-2x text-warning opacity-50"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Action Cards -->
    <h5 class="fw-bold mb-3 text-success"><i class="fas fa-bolt me-2"></i>Quick Staff Actions</h5>
    <div class="row g-4 mb-5">
        <div class="col-6 col-md-3">
            <a href="vitals_tracker.jsp" class="action-card">
                <div class="action-icon" style="background:#fee2e2;color:#dc3545"><i class="fas fa-heartbeat"></i></div>
                <h6 class="fw-bold mb-1">Vitals & Triage</h6>
                <small class="text-muted">Record BP, Pulse, SpO2</small>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="Admit.jsp" class="action-card">
                <div class="action-icon"><i class="fas fa-user-plus"></i></div>
                <h6 class="fw-bold mb-1">Admit Patient</h6>
                <small class="text-muted">Assign room & ward</small>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="Discharge.jsp" class="action-card">
                <div class="action-icon" style="background:#fef3c7;color:#d97706"><i class="fas fa-user-check"></i></div>
                <h6 class="fw-bold mb-1">Discharge Patient</h6>
                <small class="text-muted">Process discharge & bill</small>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="../admin/ward_occupancy.jsp" class="action-card">
                <div class="action-icon" style="background:#e0f2fe;color:#0284c7"><i class="fas fa-bed"></i></div>
                <h6 class="fw-bold mb-1">Ward Bed Map</h6>
                <small class="text-muted">Live bed availability</small>
            </a>
        </div>
    </div>

    <!-- Currently Admitted Patients Table -->
    <div class="panel-table">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="fw-bold mb-0 text-success"><i class="fas fa-users me-2"></i>Currently Admitted Patients</h5>
            <a href="ViewAdmittedPatients.jsp" class="btn btn-outline-success btn-sm rounded-pill">View All Patients</a>
        </div>

        <% if (activePatients.isEmpty()) { %>
            <div class="text-center text-muted py-4">No active patients currently admitted.</div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-success">
                        <tr>
                            <th># ID</th>
                            <th>Patient Name</th>
                            <th>Disease</th>
                            <th>Room / Ward</th>
                            <th>Admitted Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (AdmitPatient p : activePatients) { %>
                        <tr>
                            <td>#<%= p.getId() %></td>
                            <td><strong><%= p.getName() %></strong></td>
                            <td><%= p.getDisease() %></td>
                            <td><span class="badge bg-primary fs-6"><%= p.getRoomNumber() != null ? p.getRoomNumber() : "N/A" %></span></td>
                            <td><%= p.getAdmittedDate() %></td>
                            <td><span class="badge bg-success"><%= p.getPatientStatus() %></span></td>
                            <td>
                                <a href="vitals_tracker.jsp" class="btn btn-sm btn-outline-danger me-1" title="Record Vitals">
                                    <i class="fas fa-heartbeat"></i> Vitals
                                </a>
                                <a href="Discharge.jsp" class="btn btn-sm btn-outline-warning" title="Discharge Patient">
                                    <i class="fas fa-sign-out-alt"></i> Discharge
                                </a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>

<%
    String sucMsg = (String) session.getAttribute("sucMsg");
    String errMsg = (String) session.getAttribute("errorMsg");
    if (sucMsg != null) { session.removeAttribute("sucMsg"); %>
        <script>swal("Success", "<%= sucMsg %>", "success");</script>
    <% } if (errMsg != null) { session.removeAttribute("errorMsg"); %>
        <script>swal("Error", "<%= errMsg %>", "error");</script>
    <% } %>
</body>
</html>
