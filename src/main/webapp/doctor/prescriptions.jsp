<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.Doctor, com.entity.Appointment, com.entity.Prescription" %>
<%@ page import="com.dao.AppointmentDao, com.dao.PrescriptionDao" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.util.List" %>
<%
    Doctor doctor = (Doctor) session.getAttribute("doctObj");
    if (doctor == null) {
        doctor = (Doctor) session.getAttribute("doctorObj");
    }
    if (doctor == null) { response.sendRedirect("../doctor_login.jsp"); return; }

    AppointmentDao apDao = new AppointmentDao(DBConnect.getConn());
    PrescriptionDao prDao = new PrescriptionDao(DBConnect.getConn());

    List<Appointment> appointments = apDao.getAllAppointmentByDoctorLogin(doctor.getId());
    List<Prescription> myPrescriptions = prDao.getPrescriptionsByDoctorId(doctor.getId());

    // If viewing a specific appointment's prescription history
    String apIdStr = request.getParameter("appointmentId");
    Appointment selectedAp = null;
    List<Prescription> apPrescriptions = null;
    if (apIdStr != null && !apIdStr.isEmpty()) {
        int apId = Integer.parseInt(apIdStr);
        selectedAp = apDao.getAppointmentById(apId);
        apPrescriptions = prDao.getPrescriptionsByAppointmentId(apId);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Prescriptions — Doctor Portal</title>
    <%@include file="../component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f9f4; }
        .panel { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
        .presc-row { border-left: 4px solid #198754; padding: 12px 16px; background: #f0fdf4; border-radius: 8px; margin-bottom: 10px; }
        .presc-pill { background: #d1fae5; color: #065f46; border-radius: 20px; padding: 3px 12px; font-size: 12px; font-weight: 600; }
        .ap-card { border: 1px solid #e5e7eb; border-radius: 10px; padding: 14px; transition: all 0.2s; cursor: pointer; margin-bottom: 8px; }
        .ap-card:hover { border-color: #198754; background: #f0fdf4; }
        .modal-header { background: linear-gradient(135deg, #198754, #0d5c38); color: white; }
        .modal-header .btn-close { filter: invert(1); }
    </style>
</head>
<body>
<%@include file="navbar.jsp" %><br>

<%
String sucMsg = (String) session.getAttribute("sucMsg");
String errMsg = (String) session.getAttribute("errorMsg");
if (sucMsg != null) { session.removeAttribute("sucMsg"); %>
    <script>swal("Success", "<%=sucMsg%>", "success");</script>
<% } if (errMsg != null) { session.removeAttribute("errorMsg"); %>
    <script>swal("Error", "<%=errMsg%>", "error");</script>
<% } %>

<div class="container mt-4">
    <div class="panel">
        <h4 class="fw-bold"><i class="fas fa-prescription-bottle-alt text-success me-2"></i>Write Prescription</h4>
        <p class="text-muted">Select a patient appointment and write their prescription.</p>
        <hr>

        <div class="row">
            <!-- Patient List -->
            <div class="col-md-5">
                <h6 class="fw-semibold mb-3 text-muted">YOUR PATIENTS</h6>
                <% if (appointments.isEmpty()) { %>
                    <div class="text-center text-muted py-4">
                        <i class="fas fa-users fa-2x mb-2"></i><br>No appointments yet.
                    </div>
                <% } else { for (Appointment ap : appointments) { %>
                <div class="ap-card" onclick="fillPatientInfo(<%=ap.getId()%>, '<%=ap.getFullname().replace("'","")%>', '<%=ap.getEmail()%>')">
                    <div class="d-flex justify-content-between">
                        <div>
                            <strong><%=ap.getFullname()%></strong>
                            <div class="small text-muted"><%=ap.getDiseases()%> | <%=ap.getAppoinDate()%></div>
                        </div>
                        <span class="badge <%="Approved".equalsIgnoreCase(ap.getStatus())?"bg-success":"bg-warning"%>">
                            <%=ap.getStatus()%>
                        </span>
                    </div>
                </div>
                <% } } %>
            </div>

            <!-- Prescription Form -->
            <div class="col-md-7">
                <form action="../savePrescription" method="post" id="prescForm">
                    <input type="hidden" name="appointmentId" id="appointmentId" value="<%=selectedAp!=null?selectedAp.getId():""%>">
                    <input type="hidden" name="patientEmail" id="patientEmail" value="<%=selectedAp!=null?selectedAp.getEmail():""%>">

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Patient Name</label>
                        <input type="text" name="patientName" id="patientName" class="form-control" readonly
                               value="<%=selectedAp!=null?selectedAp.getFullname():""%>" placeholder="Select a patient →">
                    </div>
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-semibold">Medicine Name</label>
                            <input type="text" name="medicine" class="form-control" required placeholder="e.g., Paracetamol 500mg">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Dosage</label>
                            <input type="text" name="dosage" class="form-control" placeholder="e.g., 500mg">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Frequency</label>
                            <select name="frequency" class="form-select">
                                <option>Once daily</option>
                                <option>Twice daily</option>
                                <option>Thrice daily</option>
                                <option>Every 6 hours</option>
                                <option>Every 8 hours</option>
                                <option>As needed</option>
                                <option>Before meals</option>
                                <option>After meals</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Duration (days)</label>
                            <input type="number" name="duration" class="form-control" min="1" value="5">
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Notes / Instructions</label>
                            <textarea name="notes" class="form-control" rows="2" placeholder="Any special instructions..."></textarea>
                        </div>
                    </div>
                    <div class="d-flex gap-2 mt-4">
                        <button type="submit" class="btn btn-success flex-grow-1" id="submitBtn">
                            <i class="fas fa-save me-2"></i>Save Prescription + Notify Patient
                        </button>
                        <button type="button" class="btn btn-outline-secondary" onclick="addMore()">
                            <i class="fas fa-plus"></i> Add Another Medicine
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- My Prescription History -->
    <div class="panel">
        <h5 class="fw-bold mb-4"><i class="fas fa-history text-success me-2"></i>Prescription History</h5>
        <% if (myPrescriptions.isEmpty()) { %>
            <div class="text-center text-muted py-3">No prescriptions written yet.</div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover">
                <thead style="background:#198754;color:white">
                    <tr><th>Patient</th><th>Medicine</th><th>Dosage</th><th>Frequency</th><th>Duration</th><th>Date</th><th>PDF</th></tr>
                </thead>
                <tbody>
                    <% for (Prescription p : myPrescriptions) { %>
                    <tr>
                        <td><strong><%=p.getPatientName()!=null?p.getPatientName():""%></strong></td>
                        <td><%=p.getMedicineName()%></td>
                        <td><span class="presc-pill"><%=p.getDosage()!=null?p.getDosage():""%></span></td>
                        <td><%=p.getFrequency()!=null?p.getFrequency():""%></td>
                        <td><%=p.getDurationDays()%> days</td>
                        <td><small class="text-muted"><%=p.getCreatedAt()!=null?p.getCreatedAt().substring(0,10):""%></small></td>
                        <td>
                            <a href="../prescriptionPdf?appointmentId=<%=p.getAppointmentId()%>"
                               class="btn btn-sm btn-outline-success" target="_blank">
                                <i class="fas fa-file-pdf"></i>
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

<script>
function fillPatientInfo(apId, name, email) {
    document.getElementById('appointmentId').value = apId;
    document.getElementById('patientName').value = name;
    document.getElementById('patientEmail').value = email;
    document.querySelectorAll('.ap-card').forEach(c => c.style.borderColor = '');
    event.currentTarget.style.borderColor = '#198754';
}

document.getElementById('prescForm').addEventListener('submit', function(e) {
    if (!document.getElementById('appointmentId').value) {
        e.preventDefault();
        swal('Select Patient', 'Please click a patient card first.', 'warning');
    }
});
</script>
</body>
</html>
