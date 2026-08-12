<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.PaymentDao, com.dao.DoctorDao, com.dao.AppointmentDao" %>
<%@ page import="com.entity.Payment, com.entity.Doctor, com.entity.Appointment" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.util.List, java.util.Map, java.util.LinkedHashMap, java.util.Calendar, java.sql.Connection, java.text.SimpleDateFormat" %>
<%
    Object adminObj = session.getAttribute("adminObj");
    if (adminObj == null) { response.sendRedirect("../admin_login.jsp"); return; }

    Connection conn = DBConnect.getConn();
    PaymentDao paymentDao = new PaymentDao(conn);
    DoctorDao doctorDao = new DoctorDao(conn);
    AppointmentDao apDao = new AppointmentDao(conn);

    List<Payment> allPayments = paymentDao.getAllPayments();
    List<Doctor> allDoctors = doctorDao.getAllDoctors();
    List<Appointment> allAppointments = apDao.getAllAppointment();

    // Revenue last 30 days
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Calendar cal = Calendar.getInstance();
    Map<String, Double> last30Revenue = new LinkedHashMap<>();
    for (int i = 29; i >= 0; i--) {
        Calendar c = Calendar.getInstance();
        c.add(Calendar.DAY_OF_YEAR, -i);
        last30Revenue.put(sdf.format(c.getTime()), 0.0);
    }
    for (Payment p : allPayments) {
        if ("SUCCESS".equalsIgnoreCase(p.getStatus()) && p.getCreatedAt() != null) {
            String day = p.getCreatedAt().substring(0, 10);
            if (last30Revenue.containsKey(day)) {
                last30Revenue.put(day, last30Revenue.get(day) + p.getAmount());
            }
        }
    }

    // Appointment status counts
    int apPending = 0, apApproved = 0, apCancelled = 0;
    for (Appointment ap : allAppointments) {
        String s = ap.getStatus();
        if (s == null) s = "";
        if (s.toLowerCase().contains("pending")) apPending++;
        else if (s.toLowerCase().contains("approved") || s.toLowerCase().contains("confirm")) apApproved++;
        else if (s.toLowerCase().contains("cancel")) apCancelled++;
        else apPending++;
    }

    // Doctor-wise appointment count
    StringBuilder docLabels = new StringBuilder("[");
    StringBuilder docData   = new StringBuilder("[");
    for (int di = 0; di < allDoctors.size(); di++) {
        Doctor d = allDoctors.get(di);
        int cnt = doctorDao.countAppointmentByDoctorId(d.getId());
        if (di > 0) { docLabels.append(","); docData.append(","); }
        docLabels.append("\"Dr. ").append(d.getFullName().replace("\"","")).append("\"");
        docData.append(cnt);
    }
    docLabels.append("]"); docData.append("]");

    // Build revenue chart data
    StringBuilder revLabels = new StringBuilder("[");
    StringBuilder revData   = new StringBuilder("[");
    boolean first = true;
    for (Map.Entry<String, Double> e : last30Revenue.entrySet()) {
        if (!first) { revLabels.append(","); revData.append(","); }
        revLabels.append("\"").append(e.getKey().substring(5)).append("\""); // MM-DD
        revData.append(String.format("%.2f", e.getValue()));
        first = false;
    }
    revLabels.append("]"); revData.append("]");

    // Total revenue
    double totalRev = 0; double monthlyRev = 0; double todayRev = 0;
    String today = sdf.format(new java.util.Date()); String month = today.substring(0, 7);
    for (Payment p : allPayments) {
        if ("SUCCESS".equalsIgnoreCase(p.getStatus())) {
            totalRev += p.getAmount();
            if (p.getCreatedAt() != null) {
                if (p.getCreatedAt().startsWith(today)) todayRev += p.getAmount();
                if (p.getCreatedAt().startsWith(month)) monthlyRev += p.getAmount();
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Analytics Dashboard — Admin</title>
    <%@include file="../component/allcss.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f9f4; }
        .page-header { background: linear-gradient(135deg, #198754 0%, #0d5c38 100%); color: white; padding: 36px; border-radius: 16px; margin-bottom: 28px; }
        .chart-card { background: white; border-radius: 18px; padding: 28px; box-shadow: 0 4px 24px rgba(0,0,0,0.07); margin-bottom: 24px; }
        .chart-card h5 { font-weight: 700; margin-bottom: 20px; color: #1f2937; }
        .metric-card { background: white; border-radius: 14px; padding: 22px; box-shadow: 0 2px 12px rgba(0,0,0,0.05); text-align: center; border-top: 4px solid; }
        .metric-card .num { font-size: 36px; font-weight: 800; line-height: 1.1; }
        .m-green { border-color: #198754; } .m-green .num { color: #198754; }
        .m-blue  { border-color: #3b82f6; } .m-blue  .num { color: #3b82f6; }
        .m-amber { border-color: #f59e0b; } .m-amber .num { color: #f59e0b; }
        .m-rose  { border-color: #f43f5e; } .m-rose  .num { color: #f43f5e; }
        .chart-container { position: relative; min-height: 280px; }
    </style>
</head>
<body>
<%@include file="navbar.jsp" %><br>

<div class="container mt-4">
    <div class="page-header">
        <div class="d-flex align-items-center gap-3">
            <div>
                <h2 class="fw-bold mb-1"><i class="fas fa-chart-line me-3"></i>Analytics Dashboard</h2>
                <p class="opacity-75 mb-0">Live hospital performance metrics and trends</p>
            </div>
            <div class="ms-auto text-end">
                <div class="opacity-75 small">Last updated</div>
                <div class="fw-bold"><%=new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date())%></div>
            </div>
        </div>
    </div>

    <!-- Key Metrics -->
    <div class="row g-4 mb-4">
        <div class="col-6 col-md-3">
            <div class="metric-card m-green">
                <i class="fas fa-rupee-sign fa-lg mb-2" style="color:#198754"></i>
                <div class="num">₹<%=String.format("%.0f", todayRev)%></div>
                <div class="text-muted small mt-1">Today's Revenue</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="metric-card m-blue">
                <i class="fas fa-calendar-check fa-lg mb-2" style="color:#3b82f6"></i>
                <div class="num">₹<%=String.format("%.0f", monthlyRev)%></div>
                <div class="text-muted small mt-1">Monthly Revenue</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="metric-card m-amber">
                <i class="fas fa-chart-bar fa-lg mb-2" style="color:#f59e0b"></i>
                <div class="num">₹<%=String.format("%.0f", totalRev)%></div>
                <div class="text-muted small mt-1">Total Revenue</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="metric-card m-rose">
                <i class="fas fa-calendar-alt fa-lg mb-2" style="color:#f43f5e"></i>
                <div class="num"><%=allAppointments.size()%></div>
                <div class="text-muted small mt-1">Total Appointments</div>
            </div>
        </div>
    </div>

    <!-- Revenue Trend Line Chart -->
    <div class="chart-card">
        <h5><i class="fas fa-chart-line text-success me-2"></i>Revenue Trend — Last 30 Days</h5>
        <div class="chart-container">
            <canvas id="revenueChart"></canvas>
        </div>
    </div>

    <div class="row g-4">
        <!-- Appointment Status Doughnut -->
        <div class="col-md-5">
            <div class="chart-card h-100">
                <h5><i class="fas fa-chart-pie text-primary me-2"></i>Appointment Status</h5>
                <div class="chart-container" style="min-height:260px">
                    <canvas id="statusChart"></canvas>
                </div>
                <div class="d-flex justify-content-center gap-4 mt-3 small">
                    <span><span style="color:#f59e0b">●</span> Pending: <%=apPending%></span>
                    <span><span style="color:#198754">●</span> Approved: <%=apApproved%></span>
                    <span><span style="color:#f43f5e">●</span> Cancelled: <%=apCancelled%></span>
                </div>
            </div>
        </div>

        <!-- Doctor-wise Bar Chart -->
        <div class="col-md-7">
            <div class="chart-card h-100">
                <h5><i class="fas fa-user-md text-success me-2"></i>Appointments by Doctor</h5>
                <div class="chart-container" style="min-height:260px">
                    <canvas id="doctorChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>
<br>

<script>
// ── Revenue Line Chart ──────────────────────────────────────────────────────
const revenueLabels = <%=revLabels%>;
const revenueData   = <%=revData%>;

new Chart(document.getElementById('revenueChart'), {
    type: 'line',
    data: {
        labels: revenueLabels,
        datasets: [{
            label: 'Revenue (INR)',
            data: revenueData,
            borderColor: '#198754',
            backgroundColor: 'rgba(25,135,84,0.12)',
            tension: 0.4,
            fill: true,
            pointBackgroundColor: '#198754',
            pointRadius: 4,
            pointHoverRadius: 7,
        }]
    },
    options: {
        responsive: true, maintainAspectRatio: true,
        plugins: { legend: { display: false }, tooltip: { callbacks: {
            label: ctx => '₹ ' + ctx.parsed.y.toLocaleString('en-IN', {minimumFractionDigits:2})
        }}},
        scales: {
            x: { grid: { display: false }, ticks: { maxTicksLimit: 10 } },
            y: { beginAtZero: true, grid: { color: '#f0f0f0' },
                 ticks: { callback: v => '₹' + v.toLocaleString() } }
        }
    }
});

// ── Status Doughnut ──────────────────────────────────────────────────────────
new Chart(document.getElementById('statusChart'), {
    type: 'doughnut',
    data: {
        labels: ['Pending', 'Approved', 'Cancelled'],
        datasets: [{
            data: [<%=apPending%>, <%=apApproved%>, <%=apCancelled%>],
            backgroundColor: ['#f59e0b', '#198754', '#f43f5e'],
            borderWidth: 0,
            hoverOffset: 8
        }]
    },
    options: {
        responsive: true, maintainAspectRatio: false, cutout: '68%',
        plugins: {
            legend: { position: 'bottom', labels: { padding: 16, usePointStyle: true } }
        }
    }
});

// ── Doctor Bar Chart ──────────────────────────────────────────────────────────
const docLabels = <%=docLabels%>;
const docData   = <%=docData%>;
const docColors = docLabels.map((_, i) => `hsl(${(i * 47 + 150) % 360}, 60%, 55%)`);

new Chart(document.getElementById('doctorChart'), {
    type: 'bar',
    data: {
        labels: docLabels,
        datasets: [{
            label: 'Appointments',
            data: docData,
            backgroundColor: docColors,
            borderRadius: 8,
            borderSkipped: false,
        }]
    },
    options: {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
            x: { grid: { display: false } },
            y: { beginAtZero: true, ticks: { stepSize: 1 }, grid: { color: '#f0f0f0' } }
        }
    }
});
</script>
</body>
</html>
