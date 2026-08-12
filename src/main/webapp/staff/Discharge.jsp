<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.db.DBConnect, com.dao.AdmitPatientDAO, com.entity.AdmitPatient, com.entity.Staff, java.util.List, com.dao.BillingDao, com.entity.Billing" %>
<%
    Staff staff = (Staff) session.getAttribute("staffObj");
    if (staff == null) {
        response.sendRedirect("../staff_login.jsp");
        return;
    }

    AdmitPatientDAO patientDAO = new AdmitPatientDAO(DBConnect.getConn());
    BillingDao billingDao = new BillingDao(DBConnect.getConn());
    List<AdmitPatient> activePatients = patientDAO.getAdmittedPatientsOnly();
    List<AdmitPatient> allPatients = patientDAO.getAdmittedPatients();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Discharge Patient — Staff Portal</title>
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
    <!-- Header Banner -->
    <div class="page-header d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
            <h2 class="fw-bold mb-1"><i class="fas fa-user-check me-2 text-warning"></i>Discharge Patient & Billing</h2>
            <p class="opacity-75 mb-0">Process patient discharge, release ward beds, and generate invoices</p>
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
        <!-- Discharge Form -->
        <div class="col-lg-5">
            <div class="card-custom">
                <h4 class="fw-bold text-success mb-4"><i class="fas fa-sign-out-alt me-2"></i>Discharge Form</h4>
                <form action="../DischargePatient" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Select Admitted Patient</label>
                        <select name="id" class="form-select form-select-lg" required>
                            <option value="">— Select Patient —</option>
                            <% for (AdmitPatient p : activePatients) { %>
                                <option value="<%= p.getId() %>">
                                    #<%= p.getId() %> — <%= p.getName() %> (Room: <%= p.getRoomNumber() != null ? p.getRoomNumber() : "N/A" %>)
                                </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Discharge Date</label>
                        <input type="date" name="discharge_date" class="form-control"
                               value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Final Discharge Payment / Bill Amount (₹)</label>
                        <input type="number" step="0.01" name="payment" class="form-control form-control-lg" placeholder="e.g. 2500.00" required>
                    </div>
                    <button type="submit" class="btn btn-warning btn-lg w-100 fw-bold rounded-pill shadow-sm">
                        <i class="fas fa-user-check me-2"></i>Complete Discharge & Release Bed
                    </button>
                </form>
            </div>
        </div>

        <!-- Admitted & Discharged Patients Table -->
        <div class="col-lg-7">
            <div class="card-custom">
                <h4 class="fw-bold text-success mb-4"><i class="fas fa-list me-2"></i>Patient Discharge Status</h4>
                <% if (allPatients.isEmpty()) { %>
                    <div class="text-center text-muted py-4">No patients recorded.</div>
                <% } else { %>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-success">
                            <tr>
                                <th># ID</th>
                                <th>Patient Name</th>
                                <th>Admitted</th>
                                <th>Discharged</th>
                                <th>Status / Invoice</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (AdmitPatient p : allPatients) { 
                                   Billing b = billingDao.getBillingByAdmissionId(p.getId());
                                   int bId = (b != null) ? b.getId() : -1;
                                   String pStatus = p.getPatientStatus();
                            %>
                            <tr>
                                <td>#<%= p.getId() %></td>
                                <td><strong><%= p.getName() %></strong><br><small class="text-muted"><%= p.getDisease() %></small></td>
                                <td><small><%= p.getAdmittedDate() %></small></td>
                                <td><small><%= p.getDischargeDate() != null ? p.getDischargeDate() : "Active Stay" %></small></td>
                                <td>
                                    <% if ("DISCHARGED".equals(pStatus) || p.getDischargeDate() != null) { %>
                                        <span class="badge bg-secondary mb-1">DISCHARGED</span>
                                        <% if (bId != -1) { %>
                                            <a href="../generateInvoice?billId=<%= bId %>" class="btn btn-sm btn-info text-white d-block fw-bold" style="font-size:11px">
                                                <i class="fas fa-file-pdf me-1"></i> Invoice PDF
                                            </a>
                                        <% } %>
                                    <% } else { %>
                                        <a href="billing.jsp?admissionId=<%= p.getId() %>" class="btn btn-sm btn-success fw-bold">
                                            Process Discharge Bill
                                        </a>
                                    <% } %>
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
