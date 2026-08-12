<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cost Predictor & Insurance Auto-Verifier — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0fdf4; }
        .hero-claim { background: linear-gradient(135deg, #0f766e 0%, #115e59 100%); color: white; padding: 40px 0; border-radius: 0 0 20px 20px; margin-bottom: 30px; text-align: center; }
        .card-claim { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %>

<div class="hero-claim">
    <div class="container">
        <h1 class="fw-bold mb-2"><i class="fas fa-file-invoice-dollar me-2"></i> Treatment Cost Predictor & Insurance Auto-Verifier</h1>
        <p class="fs-5 opacity-75 mb-0">Upfront procedure cost estimation & automated insurance claim pre-authorization</p>
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
        <!-- Upfront Cost Estimator Calculator -->
        <div class="col-lg-6">
            <div class="card-claim">
                <h4 class="fw-bold text-teal mb-3" style="color:#0f766e"><i class="fas fa-calculator me-2"></i>Upfront Treatment Cost Estimator</h4>
                
                <div class="mb-3">
                    <label class="form-label fw-semibold">Select Medical Procedure / Speciality</label>
                    <select id="procedureSelect" class="form-select form-select-lg" onchange="calculateEstimatedCost()">
                        <option value="15000">General OPD Consultation & Diagnostics (₹15,000)</option>
                        <option value="45000">General Ward Inpatient Stay (3 Days) (₹45,000)</option>
                        <option value="85000">Laparoscopic Surgery & Recovery (₹85,000)</option>
                        <option value="150000">Coronary Angioplasty / Stenting (₹1,50,000)</option>
                        <option value="220000">Total Knee / Hip Replacement (₹2,20,000)</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Ward Category</label>
                    <select id="wardMultiplier" class="form-select" onchange="calculateEstimatedCost()">
                        <option value="1.0">General Ward (Standard Rate)</option>
                        <option value="1.25">Semi-Private Room (+25%)</option>
                        <option value="1.5">Private Deluxe Room (+50%)</option>
                        <option value="2.0">ICU / CCU Suite (+100%)</option>
                    </select>
                </div>

                <div class="p-3 border rounded-3 bg-light text-center">
                    <small class="text-muted d-block">Estimated Total Treatment Cost</small>
                    <div class="fs-2 fw-bold text-teal" id="totalCostDisplay" style="color:#0f766e">₹15,000.00</div>
                </div>
            </div>
        </div>

        <!-- Insurance Pre-Authorization Verifier -->
        <div class="col-lg-6">
            <div class="card-claim">
                <h4 class="fw-bold text-teal mb-3" style="color:#0f766e"><i class="fas fa-shield-alt me-2"></i>Insurance Auto-Pre-Authorization</h4>
                <form action="claimVerifier" method="post">
                    <input type="hidden" name="estimatedCost" id="formCost" value="15000">
                    
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Select Insurance TPA / Provider</label>
                        <select name="provider" class="form-select" required>
                            <option value="Ayushman Bharat PM-JAY (Government Cashless Scheme)">Ayushman Bharat PM-JAY (100% Cashless)</option>
                            <option value="Star Health & Allied Insurance">Star Health & Allied Insurance</option>
                            <option value="HDFC ERGO Health Insurance">HDFC ERGO Health Insurance</option>
                            <option value="Niva Bupa Health Insurance">Niva Bupa Health Insurance</option>
                            <option value="ICICI Lombard General Insurance">ICICI Lombard General Insurance</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Policy / Health Card ID Number</label>
                        <input type="text" name="policyNo" class="form-control" placeholder="e.g. POL-9876543210" required>
                    </div>

                    <button type="submit" class="btn btn-teal btn-lg w-100 fw-bold rounded-pill text-white shadow" style="background:#0f766e">
                        <i class="fas fa-check-circle me-2"></i>Run Automated Pre-Authorization Verification
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function calculateEstimatedCost() {
        const baseCost = parseFloat(document.getElementById('procedureSelect').value);
        const mult = parseFloat(document.getElementById('wardMultiplier').value);
        const finalCost = baseCost * mult;

        document.getElementById('totalCostDisplay').innerText = '₹' + finalCost.toLocaleString('en-IN', { minimumFractionDigits: 2 });
        document.getElementById('formCost').value = finalCost;
    }
</script>
</body>
</html>
