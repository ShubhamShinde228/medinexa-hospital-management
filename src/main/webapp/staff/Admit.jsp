<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="com.dao.AdmitPatientDAO, com.dao.DoctorDao, com.dao.WardDao" %>
<%@ page import="com.entity.AdmitPatient, com.entity.Doctor, com.entity.Ward, com.entity.Staff" %>
<%@ page import="java.util.List, java.sql.Connection" %>
<%
    Staff staff = (Staff) session.getAttribute("staffObj");
    if (staff == null) {
        response.sendRedirect("../staff_login.jsp");
        return;
    }

    Connection conn = DBConnect.getConn();
    DoctorDao docDao = new DoctorDao(conn);
    WardDao wardDao = new WardDao(conn);
    AdmitPatientDAO admitDao = new AdmitPatientDAO(conn);

    List<Doctor> docList = docDao.getAllDoctors();
    List<Ward> wardList = wardDao.getAllWards();
    List<AdmitPatient> activePatients = admitDao.getAdmittedPatientsOnly();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admit Patient — Staff Portal</title>
    <%@include file="../component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f7f3; }
        .page-header { background: linear-gradient(135deg, #0d5c38 0%, #198754 100%); color: white; padding: 32px; border-radius: 16px; margin-bottom: 28px; }
        .card-custom { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
    </style>
</head>
<body>
<%@include file="navbar.jsp" %><br>

<div class="container mt-4 mb-5">
    <div class="page-header d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
            <h2 class="fw-bold mb-1"><i class="fas fa-user-plus me-2 text-warning"></i>Admit New Patient</h2>
            <p class="opacity-75 mb-0">Assign doctor, room/ward, and register inpatient admission</p>
        </div>
        <a href="ViewAdmittedPatients.jsp" class="btn btn-warning fw-bold rounded-pill px-4">
            <i class="fas fa-list me-1"></i> Patient Directory
        </a>
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
        <!-- Admit Form -->
        <div class="col-lg-5">
            <div class="card-custom">
                <h4 class="fw-bold text-success mb-4"><i class="fas fa-hospital-user me-2"></i>Admission Form</h4>
                
                <form action="../AdmitPatient" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Patient Full Name</label>
                        <input type="text" name="name" class="form-control form-control-lg" placeholder="Enter patient name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Disease / Diagnosis</label>
                        <input type="text" name="disease" class="form-control" placeholder="e.g. Acute Appendicitis, High Fever" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Address</label>
                        <input type="text" name="address" class="form-control" placeholder="City, State" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Admitted Date</label>
                        <input type="date" name="admittedDate" class="form-control"
                               value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Attending Doctor</label>
                        <select name="doctorId" class="form-select" required>
                            <option value="">— Select Doctor —</option>
                            <% for (Doctor d : docList) { %>
                                <option value="<%= d.getId() %>">Dr. <%= d.getFullName() %> (<%= d.getSpecialist() %>)</option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Assign Ward / Room Number</label>
                        <select name="roomNumber" class="form-select" required>
                            <option value="">— Choose Ward / Room —</option>
                            <% if (wardList != null && !wardList.isEmpty()) { 
                                   for (Ward w : wardList) { 
                                       int free = Math.max(0, w.getCapacity() - w.getCurrentOccupancy());
                            %>
                                <option value="<%= w.getWardName() %>">
                                    🏥 <%= w.getWardName() %> (<%= w.getWardType() %>) — <%= free %> beds free
                                </option>
                            <%     } 
                               } else { %>
                                <option value="General Ward 1">General Ward 1</option>
                                <option value="ICU Room 101">ICU Room 101</option>
                                <option value="Special Ward A">Special Ward A</option>
                            <% } %>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-success btn-lg w-100 fw-bold rounded-pill shadow-sm">
                        <i class="fas fa-check-circle me-2"></i>Admit Patient Now
                    </button>
                </form>
            </div>
        </div>

        <!-- Currently Admitted Patients -->
        <div class="col-lg-7">
            <div class="card-custom">
                <h4 class="fw-bold text-success mb-4"><i class="fas fa-users me-2"></i>Active Admitted Inpatients</h4>
                <% if (activePatients.isEmpty()) { %>
                    <div class="text-center text-muted py-5">No active admitted patients found.</div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-success">
                                <tr>
                                    <th># ID</th>
                                    <th>Patient</th>
                                    <th>Disease</th>
                                    <th>Room</th>
                                    <th>Admitted Date</th>
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
                                    <td>
                                        <a href="vitals_tracker.jsp" class="btn btn-sm btn-outline-danger me-1">
                                            <i class="fas fa-heartbeat"></i> Vitals
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
    </div>
</div>
</body>
</html>
