<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    Connection conn = DBConnect.getConn();
    List<Map<String, Object>> transfers = new ArrayList<>();
    try {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM bed_transfers ORDER BY id DESC LIMIT 10");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", rs.getInt("id"));
            map.put("patientName", rs.getString("patient_name"));
            map.put("currentWard", rs.getString("current_ward"));
            map.put("targetWard", rs.getString("target_ward"));
            map.put("reason", rs.getString("transfer_reason"));
            map.put("status", rs.getString("status"));
            map.put("createdAt", rs.getString("created_at"));
            transfers.add(map);
        }
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Auto-Triggered ICU Bed Transfer & Handover — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #fff5f5; }
        .hero-transfer { background: linear-gradient(135deg, #991b1b 0%, #7f1d1d 100%); color: white; padding: 40px 0; border-radius: 0 0 20px 20px; margin-bottom: 30px; text-align: center; }
        .card-transfer { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; border: 1px solid #fee2e2; }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %>

<div class="hero-transfer">
    <div class="container">
        <h1 class="fw-bold mb-2"><i class="fas fa-bed-pulse me-2"></i> Auto ICU Bed Reservation & Transfer Engine</h1>
        <p class="fs-5 opacity-75 mb-0">Automated critical care bed reservation & digital nursing handover checklist</p>
    </div>
</div>

<div class="container mb-5">
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
        <!-- Trigger Emergency ICU Reservation -->
        <div class="col-lg-5">
            <div class="card-transfer">
                <h4 class="fw-bold text-danger mb-3"><i class="fas fa-ambulance me-2"></i>Trigger Emergency ICU Escalation</h4>
                <form action="bedTransfer" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Admission ID</label>
                        <input type="number" name="admissionId" class="form-control" placeholder="Enter Admission ID (e.g. 101)" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Patient Name</label>
                        <input type="text" name="patientName" class="form-control" placeholder="Patient Name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Current Ward Location</label>
                        <input type="text" name="currentWard" class="form-control" value="General Ward - Bed 04" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Target Critical Ward</label>
                        <select name="targetWard" class="form-select">
                            <option value="ICU - Critical Care Unit Bed 01">ICU - Critical Care Unit (Bed 01)</option>
                            <option value="CCU - Cardiac Care Unit Bed 02">CCU - Cardiac Care Unit (Bed 02)</option>
                            <option value="NICU - Neonatal Intensive Care">NICU - Neonatal Intensive Care</option>
                        </select>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Reason for Escalation / Vitals Trigger</label>
                        <textarea name="reason" class="form-control" rows="2" placeholder="e.g. Desaturation SpO2 < 88%, Severe Respiratory Distress" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-danger btn-lg w-100 fw-bold rounded-pill shadow">
                        <i class="fas fa-bolt me-2"></i>Auto-Reserve ICU Bed & Dispatch Transfer
                    </button>
                </form>
            </div>
        </div>

        <!-- Transfer Log & Handover Checklist -->
        <div class="col-lg-7">
            <div class="card-transfer">
                <h4 class="fw-bold text-danger mb-3"><i class="fas fa-list-check me-2"></i>Active ICU Transfers & Handover Logs</h4>
                
                <% if (transfers.isEmpty()) { %>
                    <div class="text-center text-muted py-4">No active critical bed transfers.</div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-danger">
                                <tr>
                                    <th>Patient</th>
                                    <th>From ➔ To</th>
                                    <th>Trigger Reason</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Map<String, Object> t : transfers) { %>
                                <tr>
                                    <td><strong><%= t.get("patientName") %></strong></td>
                                    <td><small><%= t.get("currentWard") %> ➔ <strong class="text-danger"><%= t.get("targetWard") %></strong></small></td>
                                    <td><small class="text-muted"><%= t.get("reason") %></small></td>
                                    <td><span class="badge bg-danger"><%= t.get("status") %></span></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>

                <div class="p-3 border border-secondary rounded-3 bg-light mt-3">
                    <h6 class="fw-bold text-dark mb-2"><i class="fas fa-clipboard-check me-1 text-success"></i> Mandatory ICU Nursing Handover Checklist:</h6>
                    <div class="form-check"><input class="form-check-input" type="checkbox" checked disabled> <label class="form-label mb-0 small">Continuous ECG & SpO2 Monitor Connected</label></div>
                    <div class="form-check"><input class="form-check-input" type="checkbox" checked disabled> <label class="form-label mb-0 small">High-Flow Oxygen / Mechanical Ventilator Pre-Checked</label></div>
                    <div class="form-check"><input class="form-check-input" type="checkbox" checked disabled> <label class="form-label mb-0 small">Emergency Resuscitation & Crash Cart Available</label></div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
