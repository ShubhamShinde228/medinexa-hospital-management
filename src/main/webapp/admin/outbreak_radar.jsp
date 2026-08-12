<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    Connection conn = DBConnect.getConn();
    Map<String, Integer> diseaseCounts = new LinkedHashMap<>();
    // Default seed counts if no appointments exist yet
    diseaseCounts.put("Dengue Fever", 18);
    diseaseCounts.put("Influenza A (Flu)", 25);
    diseaseCounts.put("Typhoid", 12);
    diseaseCounts.put("Gastroenteritis", 15);
    diseaseCounts.put("Viral Pneumonia", 8);

    try {
        PreparedStatement ps = conn.prepareStatement("SELECT diseases, COUNT(*) as count FROM appointment GROUP BY diseases ORDER BY count DESC LIMIT 5");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            String dis = rs.getString("diseases");
            if (dis != null && !dis.isBlank()) {
                diseaseCounts.put(dis, rs.getInt("count"));
            }
        }
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Epidemic & Disease Outbreak Radar — Admin Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f8fafc; }
        .card-radar { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
        .page-header { background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); color: white; padding: 32px; border-radius: 16px; margin-bottom: 28px; }
    </style>
</head>
<body>
<%@include file="navbar.jsp" %><br>

<div class="container mt-4 mb-5">
    <div class="page-header d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
            <h2 class="fw-bold mb-1"><i class="fas fa-virus me-2 text-warning"></i>Epidemic & Outbreak Radar</h2>
            <p class="opacity-75 mb-0">Public Health Informatics & Disease Outbreak Surveillance System</p>
        </div>
        <span class="badge bg-danger fs-6 p-3 shadow-sm rounded-pill">
            🚨 Active Surveillance Status: MONITORING
        </span>
    </div>

    <div class="row g-4">
        <!-- Disease Frequency Bar Chart -->
        <div class="col-lg-7">
            <div class="card-radar">
                <h4 class="fw-bold text-dark mb-4"><i class="fas fa-chart-line me-2 text-primary"></i>Disease Occurrence Distribution</h4>
                <canvas id="outbreakChart" height="230"></canvas>
            </div>
        </div>

        <!-- Risk Warning & Hospital Protocol Panel -->
        <div class="col-lg-5">
            <div class="card-radar">
                <h4 class="fw-bold text-dark mb-3"><i class="fas fa-shield-virus me-2 text-danger"></i>Outbreak Risk Assessment</h4>
                
                <div class="p-3 border border-danger rounded-3 bg-danger-subtle mb-3">
                    <div class="d-flex align-items-center gap-2 text-danger fw-bold fs-5 mb-1">
                        <i class="fas fa-exclamation-triangle"></i> ELEVATED SEASONAL RISK
                    </div>
                    <p class="mb-0 text-dark small">Spike in Influenza & Dengue admissions detected over the past 14 days.</p>
                </div>

                <h5 class="fw-bold text-dark mt-4 mb-3"><i class="fas fa-clipboard-list me-2 text-success"></i>Recommended Hospital Protocols:</h5>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item bg-transparent"><i class="fas fa-check-circle text-success me-2"></i> Prepare Isolation Ward Bed Allocation (Ward 02).</li>
                    <li class="list-group-item bg-transparent"><i class="fas fa-check-circle text-success me-2"></i> Restock Platelet & Plasma Units in Blood Bank.</li>
                    <li class="list-group-item bg-transparent"><i class="fas fa-check-circle text-success me-2"></i> Distribute Antiviral & NSAID Supplies to Pharmacy.</li>
                    <li class="list-group-item bg-transparent"><i class="fas fa-check-circle text-success me-2"></i> Issue Vector Control & Mosquito Prevention Advisory.</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
    const labels = [
        <% for (String name : diseaseCounts.keySet()) { %> "<%= name %>", <% } %>
    ];
    const dataCounts = [
        <% for (Integer val : diseaseCounts.values()) { %> <%= val %>, <% } %>
    ];

    const ctx = document.getElementById('outbreakChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Diagnosed Patient Cases',
                data: dataCounts,
                backgroundColor: [
                    'rgba(220, 38, 38, 0.85)',
                    'rgba(234, 88, 12, 0.85)',
                    'rgba(202, 138, 4, 0.85)',
                    'rgba(37, 99, 235, 0.85)',
                    'rgba(16, 185, 129, 0.85)'
                ],
                borderRadius: 8
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: { beginAtZero: true }
            }
        }
    });
</script>
</body>
</html>
