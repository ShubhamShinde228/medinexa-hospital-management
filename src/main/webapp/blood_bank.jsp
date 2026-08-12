<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    Connection conn = DBConnect.getConn();
    List<Map<String, Object>> bloodList = new ArrayList<>();
    try {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM blood_bank ORDER BY blood_group");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("group", rs.getString("blood_group"));
            map.put("units", rs.getInt("units_available"));
            bloodList.add(map);
        }
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Smart Blood Bank & Donor Match — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #fff5f5; }
        .hero-blood { background: linear-gradient(135deg, #b91c1c 0%, #7f1d1d 100%); color: white; padding: 40px 0; border-radius: 0 0 20px 20px; margin-bottom: 30px; text-align: center; }
        .card-blood { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(185, 28, 28, 0.08); padding: 28px; margin-bottom: 24px; border: 1px solid #fee2e2; }
        .blood-card-item { background: #fef2f2; border: 2px solid #fca5a5; border-radius: 14px; padding: 18px; text-align: center; transition: all 0.2s; }
        .blood-card-item:hover { transform: translateY(-4px); box-shadow: 0 6px 15px rgba(239, 68, 68, 0.2); }
        .blood-group-badge { font-size: 26px; font-weight: 800; color: #b91c1c; }
        .units-count { font-size: 20px; font-weight: 700; color: #1e293b; }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %>

<div class="hero-blood">
    <div class="container">
        <h1 class="fw-bold mb-2"><i class="fas fa-droplet me-2"></i> Smart Blood Bank & Compatibility Engine</h1>
        <p class="fs-5 opacity-75 mb-0">Live inventory tracking, universal donor algorithms & emergency SOS requests</p>
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

    <!-- Live Inventory Grid -->
    <div class="card-blood">
        <h4 class="fw-bold text-danger mb-4"><i class="fas fa-warehouse me-2"></i>Live Blood Stock Inventory</h4>
        <div class="row g-3">
            <% for (Map<String, Object> b : bloodList) { 
                   int units = (Integer) b.get("units");
                   String statusClass = units < 6 ? "bg-danger text-white" : "bg-success text-white";
            %>
            <div class="col-md-3 col-6">
                <div class="blood-card-item">
                    <div class="blood-group-badge"><%= b.get("group") %></div>
                    <div class="units-count my-1"><%= units %> Unit(s)</div>
                    <span class="badge <%= statusClass %> rounded-pill px-3"><%= units < 6 ? "CRITICAL LOW" : "ADEQUATE" %></span>
                </div>
            </div>
            <% } %>
        </div>
    </div>

    <div class="row g-4">
        <!-- Algorithmic Donor Compatibility Matcher -->
        <div class="col-lg-6">
            <div class="card-blood">
                <h4 class="fw-bold text-danger mb-3"><i class="fas fa-microscope me-2"></i>Donor Compatibility Match Calculator</h4>
                <p class="text-muted small">Select recipient blood group to compute safe matching donor types:</p>
                
                <div class="mb-3">
                    <label class="form-label fw-semibold">Patient / Recipient Blood Group</label>
                    <select id="recipientGroup" onchange="calculateCompatibility()" class="form-select form-select-lg">
                        <option value="">— Select Recipient Blood Group —</option>
                        <option value="A+">A+</option>
                        <option value="A-">A-</option>
                        <option value="B+">B+</option>
                        <option value="B-">B-</option>
                        <option value="O+">O+</option>
                        <option value="O-">O- (Universal Donor)</option>
                        <option value="AB+">AB+ (Universal Recipient)</option>
                        <option value="AB-">AB-</option>
                    </select>
                </div>

                <div id="compatResult" class="p-3 border rounded-3 bg-light" style="display:none;">
                    <h5 class="fw-bold text-dark mb-2" id="compatTitle">Compatible Donor Groups:</h5>
                    <div id="compatBadges" class="d-flex flex-wrap gap-2 mb-2"></div>
                    <small class="text-muted" id="compatNote"></small>
                </div>
            </div>
        </div>

        <!-- Emergency Blood Request Form -->
        <div class="col-lg-6">
            <div class="card-blood">
                <h4 class="fw-bold text-danger mb-3"><i class="fas fa-hand-holding-medical me-2"></i>Emergency Blood Request</h4>
                <form action="bloodBank" method="post">
                    <input type="hidden" name="action" value="requestBlood">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Patient Name</label>
                        <input type="text" name="patientName" class="form-control" placeholder="Patient Full Name" required>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label fw-semibold">Required Blood Group</label>
                            <select name="bloodGroup" class="form-select" required>
                                <option value="A+">A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold">Units Required</label>
                            <input type="number" name="unitsNeeded" min="1" max="10" value="2" class="form-control" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-danger btn-lg w-100 fw-bold rounded-pill shadow">
                        <i class="fas fa-bullhorn me-2"></i>Broadcast Emergency Blood Request
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    const compatibilityMap = {
        'A+': { donors: ['A+', 'A-', 'O+', 'O-'], note: 'A+ patients can receive blood from A+, A-, O+, and O-.' },
        'A-': { donors: ['A-', 'O-'], note: 'A- patients can receive blood from A- and O-.' },
        'B+': { donors: ['B+', 'B-', 'O+', 'O-'], note: 'B+ patients can receive blood from B+, B-, O+, and O-.' },
        'B-': { donors: ['B-', 'O-'], note: 'B- patients can receive blood from B- and O-.' },
        'O+': { donors: ['O+', 'O-'], note: 'O+ patients can receive blood from O+ and O-.' },
        'O-': { donors: ['O-'], note: 'O- is the Universal Donor, but O- patients can ONLY receive O-.' },
        'AB+': { donors: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'], note: 'AB+ is the Universal Recipient! Can safely receive blood from ALL blood groups.' },
        'AB-': { donors: ['AB-', 'A-', 'B-', 'O-'], note: 'AB- patients can receive blood from AB-, A-, B-, and O-.' }
    };

    function calculateCompatibility() {
        const group = document.getElementById('recipientGroup').value;
        const resDiv = document.getElementById('compatResult');
        const badgeDiv = document.getElementById('compatBadges');
        const noteElem = document.getElementById('compatNote');

        if (!group || !compatibilityMap[group]) {
            resDiv.style.display = 'none';
            return;
        }

        const data = compatibilityMap[group];
        badgeDiv.innerHTML = '';
        data.donors.forEach(d => {
            badgeDiv.innerHTML += `<span class="badge bg-danger fs-6 p-2">${d}</span>`;
        });
        noteElem.innerText = data.note;
        resDiv.style.display = 'block';
    }
</script>
</body>
</html>
