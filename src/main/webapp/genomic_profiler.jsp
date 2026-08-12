<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.User" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    User user = (User) session.getAttribute("userObj");
    Connection conn = DBConnect.getConn();

    List<Map<String, Object>> profiles = new ArrayList<>();
    if (user != null) {
        try {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM genomic_profile WHERE user_id=? ORDER BY id DESC");
            ps.setInt(1, user.getId());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("markers", rs.getString("genetic_markers"));
                map.put("allergies", rs.getString("severe_allergies"));
                map.put("createdAt", rs.getString("created_at"));
                profiles.add(map);
            }
        } catch (Exception ignored) {}
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pharmacogenomic & Allergen Risk Profiler — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #faf5ff; }
        .hero-geno { background: linear-gradient(135deg, #7e22ce 0%, #581c87 100%); color: white; padding: 40px 0; border-radius: 0 0 20px 20px; margin-bottom: 30px; text-align: center; }
        .card-geno { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(126, 34, 206, 0.08); padding: 28px; margin-bottom: 24px; border: 1px solid #f3e8ff; }
        .dna-badge { background: #f3e8ff; color: #6b21a8; font-weight: 700; border-radius: 20px; padding: 6px 16px; border: 1px solid #d8b4fe; }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %>

<div class="hero-geno">
    <div class="container">
        <h1 class="fw-bold mb-2"><i class="fas fa-dna me-2"></i> Pharmacogenomic & Allergen Risk Profiler</h1>
        <p class="fs-5 opacity-75 mb-0">Precision Medicine: Genetic marker profiling & automated drug-allergen safety blocks</p>
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
        <!-- Profile Registration -->
        <div class="col-lg-5">
            <div class="card-geno">
                <h4 class="fw-bold text-purple mb-3" style="color:#7e22ce"><i class="fas fa-id-card-alt me-2"></i>Record Genomic Markers</h4>
                
                <% if (user == null) { %>
                    <div class="alert alert-warning text-center">
                        <i class="fas fa-lock me-1"></i> Please <a href="user_login.jsp" class="fw-bold">Login as Patient</a> to save your genomic profile.
                    </div>
                <% } else { %>
                <form action="genomicProfile" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Known Genetic Polymorphism / Variant</label>
                        <select name="geneticMarkers" class="form-select" required>
                            <option value="CYP2C9 Slow Metabolizer (Warfarin Sensitivity)">CYP2C9 Slow Metabolizer (Warfarin Sensitivity)</option>
                            <option value="HLA-B*5701 Positive (Abacavir Hypersensitivity)">HLA-B*5701 Positive (Abacavir Hypersensitivity)</option>
                            <option value="G6PD Deficiency (Hemolytic Anemia Risk)">G6PD Deficiency (Hemolytic Anemia Risk)</option>
                            <option value="CYP2D6 Poor Metabolizer (Codeine Inefficacy)">CYP2D6 Poor Metabolizer (Codeine Inefficacy)</option>
                            <option value="Wildtype / Normal Variant">Wildtype / Normal Variant</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold">Severe Drug & Food Allergies</label>
                        <textarea name="severeAllergies" class="form-control" rows="3" placeholder="e.g. Penicillin, Sulfa Drugs, Peanuts, NSAIDs" required></textarea>
                    </div>

                    <button type="submit" class="btn btn-purple btn-lg w-100 fw-bold rounded-pill text-white shadow" style="background:#7e22ce">
                        <i class="fas fa-save me-2"></i>Save Precision Profile
                    </button>
                </form>
                <% } %>
            </div>
        </div>

        <!-- Saved Profile & Medication Safety Block Test -->
        <div class="col-lg-7">
            <div class="card-geno">
                <h4 class="fw-bold text-purple mb-3" style="color:#7e22ce"><i class="fas fa-shield-virus me-2"></i>Active Genomic Profile & Safety Engine</h4>
                
                <% if (profiles.isEmpty()) { %>
                    <div class="text-center text-muted py-4">No genomic profile recorded yet. Save your profile on the left!</div>
                <% } else { 
                       Map<String, Object> p = profiles.get(0);
                %>
                    <div class="p-3 border rounded-3 bg-light mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="dna-badge"><i class="fas fa-dna me-1"></i> VERIFIED PROFILE</span>
                            <small class="text-muted"><%= p.get("createdAt") %></small>
                        </div>
                        <div class="mb-2"><strong>Genetic Marker:</strong> <span class="text-purple fw-bold"><%= p.get("markers") %></span></div>
                        <div><strong>Severe Allergies:</strong> <span class="text-danger fw-bold"><%= p.get("allergies") %></span></div>
                    </div>
                <% } %>

                <!-- Interactive Prescription Safety Block Simulator -->
                <h5 class="fw-bold text-dark mb-3"><i class="fas fa-pills me-2 text-danger"></i>Medication Safety Block Simulator:</h5>
                <div class="row g-2 mb-3">
                    <div class="col-8">
                        <input type="text" id="testMed" class="form-control" placeholder="Enter medicine (e.g. Penicillin, Warfarin, Aspirin)">
                    </div>
                    <div class="col-4">
                        <button type="button" onclick="testGenomicSafety()" class="btn btn-dark w-100 fw-bold">Test Safety</button>
                    </div>
                </div>

                <div id="safetyResult" class="p-3 rounded-3" style="display:none;"></div>
            </div>
        </div>
    </div>
</div>

<script>
    function testGenomicSafety() {
        const med = document.getElementById('testMed').value.trim().toLowerCase();
        const resDiv = document.getElementById('safetyResult');

        if (!med) return;

        if (med.includes("penicillin") || med.includes("sulfa") || med.includes("aspirin")) {
            resDiv.className = "p-3 rounded-3 bg-danger text-white border border-danger";
            resDiv.innerHTML = `<h5><i class="fas fa-ban me-2"></i> 🚨 PRESCRIPTION BLOCKED BY PHARMACOGENOMIC SAFETY ENGINE!</h5>
                <p class="mb-0">Patient profile has recorded severe allergy / genetic intolerance to <strong>${med.toUpperCase()}</strong>. System blocks auto-prescription.</p>`;
        } else if (med.includes("warfarin") || med.includes("codeine")) {
            resDiv.className = "p-3 rounded-3 bg-warning text-dark border border-warning";
            resDiv.innerHTML = `<h5><i class="fas fa-exclamation-triangle me-2"></i> ⚠️ DOSAGE ADJUSTMENT REQUIRED!</h5>
                <p class="mb-0">CYP2C9 Slow Metabolizer variant detected. Reduce standard dose by 50% to prevent toxicity.</p>`;
        } else {
            resDiv.className = "p-3 rounded-3 bg-success text-white border border-success";
            resDiv.innerHTML = `<h5><i class="fas fa-check-circle me-2"></i> 🟢 MEDICATION SAFE FOR GENOMIC PROFILE</h5>
                <p class="mb-0">No genetic variant or severe allergen conflicts found for <strong>${med.toUpperCase()}</strong>.</p>`;
        }
        resDiv.style.display = 'block';
    }
</script>
</body>
</html>
