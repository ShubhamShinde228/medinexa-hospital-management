<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    Connection conn = DBConnect.getConn();
    List<Map<String, Object>> activeDispatches = new ArrayList<>();
    try {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM ambulance_dispatch ORDER BY id DESC LIMIT 10");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", rs.getInt("id"));
            map.put("callerName", rs.getString("caller_name"));
            map.put("callerPhone", rs.getString("caller_phone"));
            map.put("location", rs.getString("pickup_location"));
            map.put("unit", rs.getString("ambulance_unit"));
            map.put("driver", rs.getString("driver_name"));
            map.put("status", rs.getString("status"));
            map.put("eta", rs.getInt("eta_minutes"));
            map.put("createdAt", rs.getString("created_at"));
            activeDispatches.add(map);
        }
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Emergency SOS & Ambulance Dispatch — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <!-- Leaflet.js CSS for OpenStreetMap -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #fff5f5; }
        .hero-sos { background: linear-gradient(135deg, #dc3545 0%, #991b1b 100%); color: white; padding: 40px 0; border-radius: 0 0 20px 20px; margin-bottom: 30px; text-align: center; }
        .card-sos { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(220, 53, 69, 0.1); padding: 28px; margin-bottom: 24px; border: 2px solid #fee2e2; }
        #map { height: 320px; border-radius: 12px; border: 2px solid #fca5a5; }
        .sos-btn { background: #dc3545; color: white; font-weight: 800; font-size: 18px; padding: 14px; border-radius: 30px; transition: all 0.3s; }
        .sos-btn:hover { background: #b91c1c; transform: scale(1.02); box-shadow: 0 6px 20px rgba(220,53,69,0.4); }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %>

<div class="hero-sos">
    <div class="container">
        <h1 class="fw-bold mb-2"><i class="fas fa-ambulance me-2"></i> Emergency SOS Ambulance Dispatch</h1>
        <p class="fs-5 opacity-75 mb-0">Request immediate emergency paramedic & ambulance pickup with live GPS ETA</p>
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
        <!-- Emergency SOS Dispatch Form -->
        <div class="col-lg-5">
            <div class="card-sos">
                <h4 class="fw-bold text-danger mb-3"><i class="fas fa-phone-volume me-2"></i>Request Emergency Pickup</h4>
                <form action="ambulanceDispatch" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Caller Full Name</label>
                        <input type="text" name="callerName" class="form-control form-control-lg" placeholder="Enter name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Phone Number</label>
                        <input type="tel" name="callerPhone" class="form-control form-control-lg" placeholder="10-digit mobile number" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Pickup Address / Location Landmark</label>
                        <textarea name="pickupLocation" class="form-control" rows="3" placeholder="e.g. Sector 18, Near Central Mall, Main Road" required></textarea>
                    </div>
                    <button type="submit" class="btn sos-btn w-100 shadow">
                        <i class="fas fa-ambulance me-2"></i>DISPATCH AMBULANCE NOW
                    </button>
                </form>
            </div>
        </div>

        <!-- Live GPS Map Simulator & Dispatches -->
        <div class="col-lg-7">
            <div class="card-sos">
                <h4 class="fw-bold text-danger mb-3"><i class="fas fa-map-marked-alt me-2"></i>Live Dispatch Map & ETA</h4>
                <div id="map" class="mb-4"></div>

                <h5 class="fw-bold text-dark mb-3"><i class="fas fa-list-ul me-2 text-danger"></i>Active Ambulance Dispatches</h5>
                <% if (activeDispatches.isEmpty()) { %>
                    <div class="text-center text-muted py-3">No active ambulance dispatches right now.</div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-danger">
                                <tr>
                                    <th>Unit & Driver</th>
                                    <th>Location</th>
                                    <th>ETA</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Map<String, Object> d : activeDispatches) { %>
                                <tr>
                                    <td>
                                        <strong><%= d.get("unit") %></strong><br>
                                        <small class="text-muted"><%= d.get("driver") %></small>
                                    </td>
                                    <td><small><strong><%= d.get("callerName") %></strong><br><%= d.get("location") %></small></td>
                                    <td><span class="badge bg-warning text-dark fs-6">⏱️ <%= d.get("eta") %> mins</span></td>
                                    <td><span class="badge bg-danger"><%= d.get("status") %></span></td>
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

<!-- Leaflet.js Script for Live OpenStreetMap -->
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    // Initialize Map centered on Hospital Location (Default: Delhi/NCR region coords)
    const map = L.map('map').setView([28.6139, 77.2090], 12);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors'
    }).addTo(map);

    // Hospital Location Marker
    L.marker([28.6139, 77.2090]).addTo(map)
        .bindPopup('<b>🏥 HospitalCare Central Command</b><br>Base Station')
        .openPopup();

    // Simulated Ambulance 01 Location Marker
    L.marker([28.6300, 77.2200]).addTo(map)
        .bindPopup('<b>🚑 ALS-Unit 01</b><br>Status: En route (ETA: 10 mins)');
</script>
</body>
</html>
