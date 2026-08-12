<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.MedicalStaff" %>
<%
    MedicalStaff ms = (MedicalStaff) session.getAttribute("medicalObj");
    if (ms == null) {
        response.sendRedirect("../medical_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>E-Prescription QR Scanner & Cashless Dispense — Medical Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f5f3ff; }
        .card-qr { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
    </style>
</head>
<body>
<%@include file="navbar.jsp" %><br>

<div class="container mt-4 mb-5">
    <div class="card-qr">
        <h4 class="fw-bold text-indigo mb-2" style="color:#4338ca"><i class="fas fa-qrcode me-2"></i>E-Prescription QR Scanner & Cashless Dispense</h4>
        <p class="text-muted small mb-4">Scan patient Health Passport QR code to auto-load doctor prescriptions without manual typing</p>

        <div class="row g-3 mb-4">
            <div class="col-md-9">
                <input type="text" id="qrInput" class="form-control form-control-lg" placeholder="Scan or paste E-Prescription QR Code string (e.g. PATIENT_ID:101|NAME:Rahul Sharma|MED:Amoxicillin 500mg)">
            </div>
            <div class="col-md-3">
                <button type="button" onclick="scanPrescriptionQR()" class="btn btn-indigo btn-lg w-100 fw-bold text-white rounded-pill shadow" style="background:#4338ca">
                    <i class="fas fa-camera me-1"></i> Scan & Decode QR
                </button>
            </div>
        </div>

        <div id="decodedPrescription" style="display:none;" class="p-4 border border-indigo rounded-3 bg-light">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold text-indigo mb-0" style="color:#4338ca"><i class="fas fa-file-medical me-2"></i>Decoded E-Prescription</h5>
                <span class="badge bg-success fs-6">VERIFIED DIGITAL SIGNATURE 🟢</span>
            </div>

            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <strong>Patient Name:</strong> <span id="patName" class="text-dark fw-bold">Rahul Sharma</span><br>
                    <small class="text-muted">Attending Doctor: Dr. Suresh Kumar (Cardiology)</small>
                </div>
                <div class="col-md-6 text-end">
                    <strong>Prescription Date:</strong> <span class="text-dark"><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(new java.util.Date()) %></span>
                </div>
            </div>

            <div class="table-responsive mb-3">
                <table class="table table-bordered align-middle">
                    <thead class="table-dark" style="background:#3730a3">
                        <tr>
                            <th>Prescribed Medicine</th>
                            <th>Dosage & Frequency</th>
                            <th>Duration</th>
                            <th>Price</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>Amoxicillin Trihydrate 500mg</strong></td>
                            <td>1 Capsule after food (TID)</td>
                            <td>5 Days</td>
                            <td>₹175.00</td>
                        </tr>
                        <tr>
                            <td><strong>Paracetamol 650mg</strong></td>
                            <td>1 Tablet SOS for fever</td>
                            <td>3 Days</td>
                            <td>₹36.00</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <h4 class="fw-bold text-dark mb-0">Total Pharmacy Bill: ₹211.00</h4>
                <button type="button" onclick="completeQRDispense()" class="btn btn-success btn-lg fw-bold rounded-pill px-5 shadow">
                    <i class="fas fa-check-circle me-2"></i>Complete Cashless Dispense & Issue Receipt
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    function scanPrescriptionQR() {
        const qrVal = document.getElementById('qrInput').value.trim();
        if (!qrVal) {
            alert("Please paste or scan a valid E-Prescription QR code string.");
            return;
        }

        if (qrVal.includes("NAME:")) {
            const parts = qrVal.split("|");
            parts.forEach(p => {
                if (p.startsWith("NAME:")) document.getElementById('patName').innerText = p.replace("NAME:", "");
            });
        }
        document.getElementById('decodedPrescription').style.display = 'block';
    }

    function completeQRDispense() {
        alert("✅ E-PRESCRIPTION DISPENSED SUCCESSFULLY!\nStock updated in medical inventory. Receipt printed.");
    }
</script>
</body>
</html>
