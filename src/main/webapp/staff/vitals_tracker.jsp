<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.AdmitPatientDAO, com.dao.PatientVitalsDao" %>
<%@ page import="com.entity.AdmitPatient, com.entity.PatientVitals, com.entity.Staff" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.util.List" %>
<%
    Object staffObj = session.getAttribute("staffObj");
    if (staffObj == null) {
        response.sendRedirect("../staff_login.jsp");
        return;
    }

    AdmitPatientDAO admitDao = new AdmitPatientDAO(DBConnect.getConn());
    PatientVitalsDao vitalsDao = new PatientVitalsDao(DBConnect.getConn());

    List<AdmitPatient> activePatients = admitDao.getAdmittedPatientsOnly();
    List<PatientVitals> recentVitals = vitalsDao.getAllRecentVitals();
    int criticalCount = vitalsDao.countCriticalPatients();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Patient Vitals & Triage Tracker — Staff Portal</title>
    <%@include file="../component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f7f3; }
        .page-header { background: linear-gradient(135deg, #0d5c38 0%, #198754 100%); color: white; padding: 32px; border-radius: 16px; margin-bottom: 28px; }
        .card-custom { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
        .triage-badge { font-size: 13px; font-weight: 700; padding: 6px 14px; border-radius: 20px; text-transform: uppercase; }
        .triage-STABLE { background: #d1fae5; color: #065f46; border: 1px solid #6ee7b7; }
        .triage-WARNING { background: #fef3c7; color: #92400e; border: 1px solid #fde68a; }
        .triage-CRITICAL { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; animation: pulse 1.5s infinite; }
        @keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.6; } 100% { opacity: 1; } }
    </style>
</head>
<body>
<%@include file="navbar.jsp" %><br>

<div class="container mt-4">
    <!-- Header Banner -->
    <div class="page-header d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
            <h2 class="fw-bold mb-1"><i class="fas fa-heartbeat me-2 text-warning"></i>Patient Vitals & Triage Tracker</h2>
            <p class="opacity-75 mb-0">Record vitals & triage status for active admitted patients</p>
        </div>
        <div>
            <span class="badge bg-danger fs-6 p-3 shadow-sm rounded-pill">
                <i class="fas fa-exclamation-triangle me-1"></i> <%= criticalCount %> Critical Patient(s)
            </span>
        </div>
    </div>

    <%
        String sucMsg = (String) session.getAttribute("sucMsg");
        String errMsg = (String) session.getAttribute("errorMsg");
        if (sucMsg != null) { session.removeAttribute("sucMsg"); %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> <%= sucMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } if (errMsg != null) { session.removeAttribute("errorMsg"); %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> <%= errMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

    <div class="row g-4">
        <!-- Form: Record Patient Vitals -->
        <div class="col-lg-5">
            <div class="card-custom">
                <h4 class="fw-bold text-success mb-4"><i class="fas fa-plus-circle me-2"></i>Record Patient Vitals</h4>
                
                <% if (activePatients.isEmpty()) { %>
                    <div class="alert alert-warning text-center">
                        <i class="fas fa-info-circle me-1"></i> No active admitted patients found. Admit a patient first.
                    </div>
                <% } else { %>
                <form action="recordVitals" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Select Admitted Patient</label>
                        <select name="admissionId" class="form-select form-select-lg" required>
                            <option value="">— Select Patient —</option>
                            <% for (AdmitPatient p : activePatients) { %>
                                <option value="<%= p.getId() %>">#<%= p.getId() %> — <%= p.getName() %> (Room: <%= p.getRoomNumber() != null ? p.getRoomNumber() : "N/A" %>)</option>
                            <% } %>
                        </select>
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <label class="form-label fw-semibold">Pulse Rate (BPM)</label>
                            <input type="number" name="pulseRate" class="form-control" placeholder="e.g. 72" min="30" max="220" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold">Blood Pressure</label>
                            <input type="text" name="bloodPressure" class="form-control" placeholder="e.g. 120/80" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold">Temperature (°F)</label>
                            <input type="number" step="0.1" name="temperatureF" class="form-control" placeholder="e.g. 98.6" min="90" max="110" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold">SpO2 Oxygen (%)</label>
                            <input type="number" name="spo2Percentage" class="form-control" placeholder="e.g. 98" min="50" max="100" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-success btn-lg w-100 fw-bold rounded-pill shadow-sm">
                        <i class="fas fa-save me-2"></i>Record & Check Triage
                    </button>
                </form>
                <% } %>
            </div>
        </div>

        <!-- Table: Recent Patient Vitals Log -->
        <div class="col-lg-7">
            <div class="card-custom">
                <h4 class="fw-bold text-success mb-4"><i class="fas fa-list me-2"></i>Recent Vitals Log</h4>
                <% if (recentVitals.isEmpty()) { %>
                    <div class="text-center text-muted py-4">No vitals recorded yet.</div>
                <% } else { %>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-success">
                            <tr>
                                <th>Patient</th>
                                <th>Vitals (Pulse/BP/Temp/SpO2)</th>
                                <th>Triage Status</th>
                                <th>Recorded</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (PatientVitals v : recentVitals) { %>
                            <tr>
                                <td>
                                    <strong><%= v.getPatientName() %></strong><br>
                                    <small class="text-muted">Admission #<%= v.getAdmissionId() %></small>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border me-1">💓 <%= v.getPulseRate() %> bpm</span>
                                    <span class="badge bg-light text-dark border me-1">🩸 <%= v.getBloodPressure() %></span><br>
                                    <span class="badge bg-light text-dark border me-1">🌡️ <%= v.getTemperatureF() %>°F</span>
                                    <span class="badge bg-light text-dark border me-1">🫁 <%= v.getSpo2Percentage() %>% SpO2</span>
                                </td>
                                <td>
                                    <span class="triage-badge triage-<%= v.getTriageStatus() %>">
                                        <%= v.getTriageStatus() %>
                                    </span>
                                </td>
                                <td><small class="text-muted"><%= v.getRecordedAt() != null ? v.getRecordedAt().substring(0, 16) : "" %></small></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>
<br>
</body>
</html>
