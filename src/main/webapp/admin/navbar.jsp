<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">

<style>
  .admin-header-nav {
      background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%) !important;
      padding: 12px 24px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  }
  .admin-header-nav .navbar-brand {
      font-size: 1.4rem;
      font-weight: 800;
      color: #ffffff !important;
      letter-spacing: 0.5px;
  }
  .admin-header-nav .nav-link {
      font-size: 0.92rem;
      font-weight: 600;
      color: rgba(255, 255, 255, 0.9) !important;
      margin: 0 4px;
      border-radius: 8px;
      padding: 8px 14px !important;
      transition: all 0.25s ease;
  }
  .admin-header-nav .nav-link:hover, .admin-header-nav .nav-link.active {
      color: #ffffff !important;
      background: rgba(255, 255, 255, 0.12);
  }
  .admin-header-nav .dropdown-menu {
      border-radius: 12px;
      border: none;
      box-shadow: 0 10px 30px rgba(0,0,0,0.18);
      padding: 8px;
  }
  .admin-header-nav .dropdown-item {
      font-size: 0.9rem;
      font-weight: 600;
      border-radius: 8px;
      padding: 8px 16px;
      color: #334155;
      transition: all 0.2s;
  }
  .admin-header-nav .dropdown-item:hover {
      background: #f1f5f9;
      color: #0f172a;
  }
</style>

<nav class="navbar navbar-expand-lg navbar-dark admin-header-nav sticky-top">
  <div class="container-fluid">
    <!-- Admin Brand Header -->
    <a class="navbar-brand text-white d-flex align-items-center gap-2" href="index.jsp">
      <i class="fas fa-user-tie text-warning fa-lg"></i>
      <span>ADMIN PORTAL</span>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminHeaderNav" aria-controls="adminHeaderNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="adminHeaderNav">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0 align-items-center">
        <!-- Dashboard Home -->
        <li class="nav-item">
          <a class="nav-link" href="index.jsp"><i class="fas fa-chart-line me-1"></i> DASHBOARD</a>
        </li>

        <!-- Staff & Doctor Roster Dropdown -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
            <i class="fas fa-users-cog me-1"></i> STAFF & DOCTORS
          </a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="doctor.jsp"><i class="fas fa-user-plus text-primary me-2"></i> Add Doctor</a></li>
            <li><a class="dropdown-item" href="view_doctor.jsp"><i class="fas fa-user-md text-success me-2"></i> Doctor Directory</a></li>
            <li><a class="dropdown-item" href="staff.jsp"><i class="fas fa-user-nurse text-warning me-2"></i> Add Staff Member</a></li>
            <li><a class="dropdown-item" href="patient.jsp"><i class="fas fa-users text-info me-2"></i> View Patients</a></li>
          </ul>
        </li>

        <!-- Wards & Operations Dropdown -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
            <i class="fas fa-hospital-alt me-1"></i> WARDS & SLOTS
          </a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="addward.jsp"><i class="fas fa-plus-square text-success me-2"></i> Add Hospital Ward</a></li>
            <li><a class="dropdown-item" href="ward_occupancy.jsp"><i class="fas fa-bed text-danger me-2"></i> Ward Bed Map</a></li>
            <li><a class="dropdown-item" href="manage_slots.jsp"><i class="fas fa-calendar-alt text-primary me-2"></i> Manage Doctor Slots</a></li>
          </ul>
        </li>

        <!-- Analytics & Financial Dropdown -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
            <i class="fas fa-chart-bar me-1"></i> ANALYTICS & REPORTS
          </a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="analytics_dashboard.jsp"><i class="fas fa-chart-line text-success me-2"></i> Chart.js Analytics</a></li>
            <li><a class="dropdown-item" href="outbreak_radar.jsp"><i class="fas fa-virus text-danger me-2"></i> Epidemic Outbreak Radar</a></li>
            <li><a class="dropdown-item" href="payment_dashboard.jsp"><i class="fas fa-rupee-sign text-warning me-2"></i> Revenue & Payments</a></li>
            <li><a class="dropdown-item" href="DoctorReport.jsp"><i class="fas fa-file-pdf text-danger me-2"></i> Doctor PDF Report</a></li>
          </ul>
        </li>

        <!-- Emergency SOS Dispatch Link -->
        <li class="nav-item">
          <a class="nav-link text-warning fw-bold" href="../emergency_dispatch.jsp">
            <i class="fas fa-truck-medical me-1"></i> SOS DISPATCH
          </a>
        </li>
      </ul>

      <!-- Right Side Actions: Notification Bell & Logout -->
      <ul class="navbar-nav align-items-center gap-2">
        <%
          int _adminUnread = 0;
          try {
            com.dao.NotificationDao _aNDao = new com.dao.NotificationDao(com.db.DBConnect.getConn());
            _adminUnread = _aNDao.countUnread("ADMIN", 1);
          } catch (Exception _ae) {}
        %>
        <li class="nav-item">
          <a class="nav-link text-white position-relative" href="../notifications.jsp">
            <i class="fas fa-bell fa-lg"></i>
            <% if (_adminUnread > 0) { %>
            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size:10px">
              <%= _adminUnread > 9 ? "9+" : _adminUnread %>
            </span>
            <% } %>
          </a>
        </li>
        <li class="nav-item">
          <a class="btn btn-light text-dark fw-bold rounded-pill px-3 shadow-sm" href="../AdminLogout">
            <i class="fas fa-sign-out-alt me-1"></i> LOGOUT
          </a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
