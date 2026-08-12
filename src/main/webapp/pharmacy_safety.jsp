<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.DrugSafetyChecker, com.util.DrugSafetyChecker.InteractionResult" %>
<%@ page import="java.util.*" %>
<%
    String[] selectedMeds = request.getParameterValues("medicines");
    List<InteractionResult> conflicts = null;
    List<String> medList = new ArrayList<>();
    if (selectedMeds != null && selectedMeds.length > 0) {
        medList = Arrays.asList(selectedMeds);
        conflicts = DrugSafetyChecker.checkInteractions(medList);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Drug Safety & Interaction Checker — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f4f8; }
        .hero-safety { background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%); color: white; padding: 40px 0; border-radius: 0 0 20px 20px; margin-bottom: 30px; text-align: center; }
        .card-safety { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
        .med-chip { display: inline-flex; align-items: center; gap: 8px; background: #eff6ff; color: #1e40af; border: 2px solid #bfdbfe; border-radius: 25px; padding: 8px 18px; margin: 6px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .med-chip:hover { background: #dbeafe; transform: translateY(-2px); }
        .med-chip input[type=checkbox] { accent-color: #2563eb; width: 18px; height: 18px; }
        .severity-badge { font-weight: 800; padding: 6px 14px; border-radius: 20px; text-transform: uppercase; font-size: 12px; }
        .sev-SEVERE { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }
        .sev-MODERATE { background: #fef3c7; color: #92400e; border: 1px solid #fde68a; }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %>

<div class="hero-safety">
    <div class="container">
        <h1 class="fw-bold mb-2"><i class="fas fa-pills me-2"></i> Clinical Drug Interaction Checker</h1>
        <p class="fs-5 opacity-75 mb-0">Clinical Decision Support System (CDSS) for automated drug conflict detection</p>
    </div>
</div>

<div class="container mb-5">
    <div class="card-safety">
        <h4 class="fw-bold text-primary mb-3"><i class="fas fa-prescription-bottle-alt me-2"></i> Select Prescribed Medications to Analyze:</h4>
        
        <form action="pharmacy_safety.jsp" method="get">
            <div class="d-flex flex-wrap mb-4">
                <label class="med-chip"><input type="checkbox" name="medicines" value="Aspirin"> 💊 Aspirin (Antiplatelet)</label>
                <label class="med-chip"><input type="checkbox" name="medicines" value="Warfarin"> 🩸 Warfarin (Anticoagulant)</label>
                <label class="med-chip"><input type="checkbox" name="medicines" value="Metformin"> 🩺 Metformin (Antidiabetic)</label>
                <label class="med-chip"><input type="checkbox" name="medicines" value="Contrast Dye"> 🔬 Contrast Dye (Radiology)</label>

                <label class="med-chip"><input type="checkbox" name="medicines" value="Ibuprofen"> 🩹 Ibuprofen (NSAID)</label>
                <label class="med-chip"><input type="checkbox" name="medicines" value="Lisinopril"> ❤️ Lisinopril (ACE Inhibitor)</label>

                <label class="med-chip"><input type="checkbox" name="medicines" value="Sildenafil"> ⚡ Sildenafil</label>
                <label class="med-chip"><input type="checkbox" name="medicines" value="Nitroglycerin"> 🫀 Nitroglycerin (Nitrate)</label>

                <label class="med-chip"><input type="checkbox" name="medicines" value="Amoxicillin"> 🧫 Amoxicillin (Antibiotic)</label>
                <label class="med-chip"><input type="checkbox" name="medicines" value="Paracetamol"> 🌡️ Paracetamol (Analgesic)</label>
            </div>

            <div class="text-center">
                <button type="submit" class="btn btn-primary btn-lg px-5 rounded-pill shadow fw-bold">
                    <i class="fas fa-shield-virus me-2"></i> Run Safety Conflict Analysis
                </button>
            </div>
        </form>
    </div>

    <% if (conflicts != null) { %>
    <div class="card-safety">
        <h4 class="fw-bold text-primary mb-4"><i class="fas fa-clipboard-check me-2"></i> Analysis Results:</h4>
        
        <% if (conflicts.isEmpty()) { %>
            <div class="alert alert-success d-flex align-items-center p-4 rounded-3">
                <i class="fas fa-check-circle fa-3x me-3"></i>
                <div>
                    <h5 class="fw-bold mb-1">No Dangerous Drug Interactions Detected!</h5>
                    <p class="mb-0">The selected medication combination (<%= String.join(", ", medList) %>) is safe according to clinical guidelines.</p>
                </div>
            </div>
        <% } else { %>
            <div class="alert alert-danger d-flex align-items-center mb-4 p-3 rounded-3">
                <i class="fas fa-exclamation-triangle fa-2x me-3"></i>
                <div class="fw-bold fs-5"><%= conflicts.size() %> Potential Drug Conflict(s) Identified!</div>
            </div>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-primary">
                        <tr>
                            <th>Conflicting Drug Pair</th>
                            <th>Severity</th>
                            <th>Clinical Risk Description</th>
                            <th>Medical Recommendation</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (InteractionResult res : conflicts) { %>
                        <tr>
                            <td><strong class="text-danger"><%= res.getDrugA() %></strong> ⚡ <strong class="text-danger"><%= res.getDrugB() %></strong></td>
                            <td><span class="severity-badge sev-<%= res.getSeverity() %>"><%= res.getSeverity() %></span></td>
                            <td><%= res.getDescription() %></td>
                            <td><span class="badge bg-primary-subtle text-primary border border-primary p-2"><%= res.getRecommendation() %></span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>
