<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.MedicalStaff" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    MedicalStaff ms = (MedicalStaff) session.getAttribute("medicalObj");
    if (ms == null) {
        response.sendRedirect("../medical_login.jsp");
        return;
    }

    Connection conn = DBConnect.getConn();
    List<Map<String, Object>> orders = new ArrayList<>();
    try {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM vendor_orders ORDER BY id DESC");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", rs.getInt("id"));
            map.put("vendor", rs.getString("vendor_name"));
            map.put("medicine", rs.getString("medicine_name"));
            map.put("units", rs.getInt("units_ordered"));
            map.put("cost", rs.getDouble("total_cost"));
            map.put("status", rs.getString("po_status"));
            map.put("createdAt", rs.getString("created_at"));
            orders.add(map);
        }
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Automated Vendor Purchase Orders (PO) — Medical Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f5f3ff; }
        .card-po { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
    </style>
</head>
<body>
<%@include file="navbar.jsp" %><br>

<div class="container mt-4 mb-5">
    <%
        String sucMsg = (String) session.getAttribute("sucMsg");
        String errMsg = (String) session.getAttribute("errorMsg");
        if (sucMsg != null) { session.removeAttribute("sucMsg"); %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-1"></i> <%= sucMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } if (errMsg != null) { session.removeAttribute("errorMsg"); %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-1"></i> <%= errMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

    <div class="row g-4">
        <!-- Generate Purchase Order -->
        <div class="col-lg-5">
            <div class="card-po">
                <h4 class="fw-bold text-indigo mb-3" style="color:#4338ca"><i class="fas fa-truck-loading me-2"></i>Generate Vendor Purchase Order</h4>
                <form action="../vendorOrder" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Select Pharmaceutical Supplier</label>
                        <select name="vendorName" class="form-select" required>
                            <option value="Sun Pharmaceutical Industries Ltd.">Sun Pharmaceutical Industries Ltd.</option>
                            <option value="Cipla Healthcare Ltd.">Cipla Healthcare Ltd.</option>
                            <option value="Dr. Reddy's Laboratories">Dr. Reddy's Laboratories</option>
                            <option value="Torrent Pharmaceuticals">Torrent Pharmaceuticals</option>
                            <option value="Pfizer India Ltd.">Pfizer India Ltd.</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Medicine Item to Reorder</label>
                        <input type="text" name="medicineName" class="form-control" placeholder="e.g. Insulin Glargine 100IU" required>
                    </div>
                    <div class="row g-2 mb-4">
                        <div class="col-6">
                            <label class="form-label fw-semibold">Units Ordered</label>
                            <input type="number" name="unitsOrdered" class="form-control" value="100" min="10" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold">Total PO Cost (₹)</label>
                            <input type="number" step="0.01" name="totalCost" class="form-control" value="45000.00" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-indigo btn-lg w-100 fw-bold text-white rounded-pill shadow" style="background:#4338ca">
                        <i class="fas fa-paper-plane me-2"></i>Dispatch Signed Purchase Order
                    </button>
                </form>
            </div>
        </div>

        <!-- Dispatched PO Log Table -->
        <div class="col-lg-7">
            <div class="card-po">
                <h4 class="fw-bold text-indigo mb-3" style="color:#4338ca"><i class="fas fa-file-contract me-2"></i>Dispatched Purchase Orders</h4>
                
                <% if (orders.isEmpty()) { %>
                    <div class="text-center text-muted py-4">No vendor purchase orders dispatched yet.</div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-dark" style="background:#3730a3">
                                <tr>
                                    <th>PO #</th>
                                    <th>Pharma Vendor</th>
                                    <th>Medicine & Units</th>
                                    <th>Total Cost</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Map<String, Object> o : orders) { %>
                                <tr>
                                    <td>#PO-<%= o.get("id") %></td>
                                    <td><strong><%= o.get("vendor") %></strong></td>
                                    <td><%= o.get("medicine") %><br><small class="text-muted"><%= o.get("units") %> Units</small></td>
                                    <td><strong class="text-success">₹<%= o.get("cost") %></strong></td>
                                    <td><span class="badge bg-success"><%= o.get("status") %></span></td>
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
</body>
</html>
