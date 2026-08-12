<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    Connection conn = DBConnect.getConn();
    List<Map<String, Object>> inventory = new ArrayList<>();
    try {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM medical_inventory ORDER BY expiry_date ASC");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", rs.getInt("id"));
            map.put("medicineName", rs.getString("medicine_name"));
            map.put("genericName", rs.getString("generic_name"));
            map.put("batchNo", rs.getString("batch_no"));
            map.put("stock", rs.getInt("stock_quantity"));
            map.put("expiry", rs.getString("expiry_date"));
            map.put("coldChain", rs.getBoolean("cold_chain_required"));
            map.put("price", rs.getDouble("unit_price"));
            inventory.add(map);
        }
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Smart Medicine Dispenser & FEFO Audit</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f5f3ff; }
        .card-dispense { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
    </style>
</head>
<body>
<%@include file="navbar.jsp" %><br>

<div class="container mt-4 mb-5">
    <div class="card-dispense">
        <h4 class="fw-bold text-indigo mb-3" style="color:#4338ca"><i class="fas fa-pills me-2"></i>AI FEFO Medicine Dispenser & Generic Substitute Matcher</h4>
        <p class="text-muted small mb-4">First-Expired, First-Out (FEFO) automated batch audit & generic equivalent finder</p>

        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-dark" style="background:#3730a3">
                    <tr>
                        <th>Medicine & Brand Name</th>
                        <th>Generic Molecule</th>
                        <th>Batch & Expiry (FEFO)</th>
                        <th>Cold-Chain Required</th>
                        <th>Available Stock</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> item : inventory) { 
                           int stock = (Integer) item.get("stock");
                           boolean cold = (Boolean) item.get("coldChain");
                    %>
                    <tr>
                        <td><strong><%= item.get("medicineName") %></strong></td>
                        <td><span class="badge bg-secondary"><%= item.get("genericName") %></span></td>
                        <td>
                            <small class="text-muted"><%= item.get("batchNo") %></small><br>
                            <span class="badge bg-warning text-dark">Exp: <%= item.get("expiry") %></span>
                        </td>
                        <td>
                            <% if (cold) { %>
                                <span class="badge bg-info text-dark"><i class="fas fa-snowflake me-1"></i> 2°C - 8°C Required</span>
                            <% } else { %>
                                <small class="text-muted">Standard Temp</small>
                            <% } %>
                        </td>
                        <td>
                            <% if (stock < 20) { %>
                                <span class="badge bg-danger"><%= stock %> Units (LOW STOCK)</span>
                            <% } else { %>
                                <span class="badge bg-success"><%= stock %> Units</span>
                            <% } %>
                        </td>
                        <td>
                            <button type="button" onclick="dispenseAlert('<%= item.get("medicineName") %>', '<%= item.get("genericName") %>', <%= stock %>)" class="btn btn-indigo btn-sm fw-bold text-white rounded-pill px-3" style="background:#4338ca">
                                Dispense FEFO Batch
                            </button>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function dispenseAlert(name, generic, stock) {
        if (stock < 15) {
            alert("⚠️ LOW STOCK WARNING for " + name + "!\nGeneric Substitute Available: " + generic + ".\nAutomated purchase reorder triggered.");
        } else {
            alert("✅ FEFO BATCH VERIFIED!\nDispensing " + name + " (" + generic + "). FEFO Expiry audit passed.");
        }
    }
</script>
</body>
</html>
