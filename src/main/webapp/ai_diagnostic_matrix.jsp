<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.AIDiagnosticEngine, com.util.AIDiagnosticEngine.DiagnosisProbability" %>
<%@ page import="java.util.*" %>
<%
    String[] selectedSymptoms = request.getParameterValues("symptoms");
    String tempStr = request.getParameter("temp");
    String spo2Str = request.getParameter("spo2");
    String pulseStr = request.getParameter("pulse");
    String ageStr = request.getParameter("age");

    List<DiagnosisProbability> ddxResults = null;
    if (selectedSymptoms != null && selectedSymptoms.length > 0) {
        double temp = (tempStr != null && !tempStr.isBlank()) ? Double.parseDouble(tempStr) : 98.6;
        int spo2 = (spo2Str != null && !spo2Str.isBlank()) ? Integer.parseInt(spo2Str) : 98;
        int pulse = (pulseStr != null && !pulseStr.isBlank()) ? Integer.parseInt(pulseStr) : 75;
        int age = (ageStr != null && !ageStr.isBlank()) ? Integer.parseInt(ageStr) : 40;

        List<String> sList = Arrays.asList(selectedSymptoms);
        ddxResults = AIDiagnosticEngine.evaluateDifferentialDiagnosis(sList, temp, spo2, pulse, age);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Differential Diagnosis Risk Heatmap — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #0f172a; color: white; }
        .hero-ddx { background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%); padding: 40px 0; border-radius: 0 0 20px 20px; margin-bottom: 30px; text-align: center; border-bottom: 2px solid #6366f1; }
        .card-ddx { background: #1e293b; border-radius: 16px; border: 1px solid #334155; padding: 28px; margin-bottom: 24px; }
        .symptom-chip { display: inline-flex; align-items: center; gap: 8px; background: #334155; color: #f8fafc; border: 1px solid #475569; border-radius: 25px; padding: 8px 18px; margin: 6px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .symptom-chip:hover { background: #475569; }
        .symptom-chip input[type=checkbox] { accent-color: #6366f1; width: 18px; height: 18px; }
        .progress-heatmap { height: 24px; border-radius: 12px; background: #334155; overflow: hidden; }
        .risk-CRITICAL { background: #dc3545; color: white; }
        .risk-HIGH { background: #fd7e14; color: white; }
        .risk-MODERATE { background: #ffc107; color: black; }
        .risk-LOW { background: #198754; color: white; }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %>

<div class="hero-ddx">
    <div class="container">
        <h1 class="fw-bold mb-2"><i class="fas fa-brain me-2 text-warning"></i> AI Clinical Differential Diagnosis Engine</h1>
        <p class="fs-5 opacity-75 mb-0">Multi-factorial probability matrix correlating symptoms, vital signs & physiological risk factors</p>
    </div>
</div>

<div class="container mb-5">
    <div class="card-ddx">
        <h4 class="fw-bold text-warning mb-4"><i class="fas fa-sliders-h me-2"></i> Clinical Input Matrix</h4>
        
        <form action="ai_diagnostic_matrix.jsp" method="get">
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <label class="form-label text-slate-300 fw-semibold">Patient Age</label>
                    <input type="number" name="age" class="form-control bg-dark text-white border-secondary" value="<%= ageStr != null ? ageStr : "45" %>" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-slate-300 fw-semibold">Temperature (°F)</label>
                    <input type="number" step="0.1" name="temp" class="form-control bg-dark text-white border-secondary" value="<%= tempStr != null ? tempStr : "101.5" %>" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-slate-300 fw-semibold">SpO2 Oxygen (%)</label>
                    <input type="number" name="spo2" class="form-control bg-dark text-white border-secondary" value="<%= spo2Str != null ? spo2Str : "91" %>" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-slate-300 fw-semibold">Pulse Rate (BPM)</label>
                    <input type="number" name="pulse" class="form-control bg-dark text-white border-secondary" value="<%= pulseStr != null ? pulseStr : "108" %>" required>
                </div>
            </div>

            <label class="form-label text-slate-300 fw-semibold mb-2">Select Active Symptoms:</label>
            <div class="d-flex flex-wrap mb-4">
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="Shortness of Breath"> 🫁 Shortness of Breath</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="Chest Pain"> 🫀 Chest Pain</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="Fever"> 🌡️ High Fever</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="Cough"> 🗣️ Cough</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="Joint Pain"> 🦴 Joint / Body Pain</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="Sweating"> 💦 Sweating & Chills</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="Dizziness"> 🌀 Dizziness</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="Headache"> 🤕 Severe Headache</label>
            </div>

            <div class="text-center">
                <button type="submit" class="btn btn-warning btn-lg px-5 rounded-pill fw-bold shadow">
                    <i class="fas fa-microchip me-2"></i> Compute Probability Heatmap
                </button>
            </div>
        </form>
    </div>

    <% if (ddxResults != null) { %>
    <div class="card-ddx">
        <h4 class="fw-bold text-warning mb-4"><i class="fas fa-chart-pie me-2"></i> Clinical Probability Heatmap & Escalation Plan</h4>
        
        <div class="row g-4">
            <% for (DiagnosisProbability diag : ddxResults) { 
                   int pct = diag.getProbabilityPercentage();
                   String risk = diag.getRiskLevel();
                   String barColor = "CRITICAL".equals(risk) ? "bg-danger" : ("HIGH".equals(risk) ? "bg-warning" : "bg-info");
            %>
            <div class="col-12">
                <div class="p-3 rounded-3 bg-dark border border-secondary">
                    <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap gap-2">
                        <div>
                            <h5 class="fw-bold text-white mb-0"><%= diag.getDiseaseName() %></h5>
                            <small class="text-slate-400"><%= diag.getClinicalRationale() %></small>
                        </div>
                        <div class="text-end">
                            <span class="badge risk-<%= risk %> px-3 py-2 fw-bold me-2"><%= risk %> RISK</span>
                            <span class="fs-4 fw-bold text-warning"><%= pct %>%</span>
                        </div>
                    </div>

                    <!-- Heatmap Progress Bar -->
                    <div class="progress progress-heatmap mb-3">
                        <div class="progress-bar <%= barColor %>" style="width: <%= pct %>%;"></div>
                    </div>

                    <div class="p-2 rounded bg-secondary-subtle text-dark font-monospace small fw-bold">
                        <i class="fas fa-user-md me-1 text-primary"></i> Recommended Clinical Protocol: <%= diag.getRecommendedAction() %>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>
</div>
</body>
</html>
