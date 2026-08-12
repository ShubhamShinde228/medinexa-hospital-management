<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Smart Diagnostic Lab Results Auto-Analyzer — Medical Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f5f3ff; }
        .card-lab { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
        .abnormal-highlight { background: #fee2e2; color: #991b1b; font-weight: 700; border-left: 4px solid #dc3545; }
        .normal-highlight { background: #f0fdf4; color: #166534; border-left: 4px solid #16a34a; }
    </style>
</head>
<body>
<%@include file="navbar.jsp" %><br>

<div class="container mt-4 mb-5">
    <div class="card-lab">
        <h4 class="fw-bold text-indigo mb-3" style="color:#4338ca"><i class="fas fa-vial me-2"></i>Smart Diagnostic Lab Results Auto-Analyzer</h4>
        <p class="text-muted small mb-4">Input patient pathology lab values to automatically detect out-of-range clinical anomalies</p>

        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <label class="form-label fw-semibold">Hemoglobin (g/dL)</label>
                <input type="number" step="0.1" id="hbInput" class="form-control" value="8.5" placeholder="Normal: 12-16">
            </div>
            <div class="col-md-3">
                <label class="form-label fw-semibold">WBC Count (/mcL)</label>
                <input type="number" id="wbcInput" class="form-control" value="14500" placeholder="Normal: 4500-11000">
            </div>
            <div class="col-md-3">
                <label class="form-label fw-semibold">Blood Glucose (mg/dL)</label>
                <input type="number" id="glucoseInput" class="form-control" value="240" placeholder="Normal: 70-140">
            </div>
            <div class="col-md-3">
                <label class="form-label fw-semibold">Serum Creatinine (mg/dL)</label>
                <input type="number" step="0.1" id="creatInput" class="form-control" value="2.1" placeholder="Normal: 0.7-1.3">
            </div>
        </div>

        <div class="text-center mb-4">
            <button type="button" onclick="analyzeLabReport()" class="btn btn-indigo btn-lg rounded-pill fw-bold text-white px-5 shadow" style="background:#4338ca">
                <i class="fas fa-microscope me-2"></i>Analyze Report & Detect Abnormalities
            </button>
        </div>

        <div id="labResultBox" style="display:none;">
            <h5 class="fw-bold text-dark mb-3"><i class="fas fa-clipboard-check me-2 text-indigo" style="color:#4338ca"></i>Diagnostic Anomaly Report:</h5>
            <div id="reportList" class="d-flex flex-column gap-2 mb-4"></div>
            
            <button type="button" onclick="window.print()" class="btn btn-outline-dark rounded-pill fw-bold px-4">
                <i class="fas fa-print me-1"></i> Print Diagnostic Summary
            </button>
        </div>
    </div>
</div>

<script>
    function analyzeLabReport() {
        const hb = parseFloat(document.getElementById('hbInput').value);
        const wbc = parseInt(document.getElementById('wbcInput').value);
        const gluc = parseInt(document.getElementById('glucoseInput').value);
        const creat = parseFloat(document.getElementById('creatInput').value);

        const listDiv = document.getElementById('reportList');
        listDiv.innerHTML = '';

        // 1. Hemoglobin Audit
        if (hb < 11.5) {
            listDiv.innerHTML += `<div class="p-3 rounded abnormal-highlight">
                🚨 ABNORMAL CRITICAL LOW: Hemoglobin level ${hb} g/dL (Normal Range: 12.0 - 16.0 g/dL). Indicates Severe Anemia. Recommend Iron Transfusion / Hematology Review.
            </div>`;
        } else {
            listDiv.innerHTML += `<div class="p-3 rounded normal-highlight">
                🟢 NORMAL: Hemoglobin level ${hb} g/dL is within healthy parameters.
            </div>`;
        }

        // 2. WBC Count Audit
        if (wbc > 11000) {
            listDiv.innerHTML += `<div class="p-3 rounded abnormal-highlight">
                🚨 ABNORMAL ELEVATED: WBC Count ${wbc} /mcL (Normal Range: 4,500 - 11,000 /mcL). Indicates Acute Bacterial Infection / Leukocytosis SIRS alert.
            </div>`;
        } else {
            listDiv.innerHTML += `<div class="p-3 rounded normal-highlight">
                🟢 NORMAL: WBC Count ${wbc} /mcL is within normal range.
            </div>`;
        }

        // 3. Blood Glucose Audit
        if (gluc > 180) {
            listDiv.innerHTML += `<div class="p-3 rounded abnormal-highlight">
                🚨 ABNORMAL HYPERGLYCEMIA: Blood Glucose ${gluc} mg/dL (Normal Fasting: 70 - 140 mg/dL). Uncontrolled Diabetes Alert.
            </div>`;
        } else {
            listDiv.innerHTML += `<div class="p-3 rounded normal-highlight">
                🟢 NORMAL: Blood Glucose ${gluc} mg/dL is within target glycemic range.
            </div>`;
        }

        // 4. Creatinine Audit
        if (creat > 1.4) {
            listDiv.innerHTML += `<div class="p-3 rounded abnormal-highlight">
                🚨 ABNORMAL RENAL ELEVATION: Serum Creatinine ${creat} mg/dL (Normal Range: 0.7 - 1.3 mg/dL). Indicates Impaired Renal Clearance / Acute Kidney Injury risk.
            </div>`;
        } else {
            listDiv.innerHTML += `<div class="p-3 rounded normal-highlight">
                🟢 NORMAL: Serum Creatinine ${creat} mg/dL indicates healthy kidney function.
            </div>`;
        }

        document.getElementById('labResultBox').style.display = 'block';
    }
</script>
</body>
</html>
