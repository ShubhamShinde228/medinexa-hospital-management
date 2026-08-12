<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">
<style>
  .staff-nav {
      background: linear-gradient(135deg, #0d5c38 0%, #198754 100%) !important;
      padding: 12px 20px;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
  }
  .staff-nav .navbar-brand {
      font-size: 1.4rem;
      font-weight: 800;
      color: #ffffff !important;
      letter-spacing: 0.5px;
  }
  .staff-nav .nav-link {
      font-size: 0.92rem;
      font-weight: 600;
      color: rgba(255, 255, 255, 0.9) !important;
      margin: 0 4px;
      border-radius: 8px;
      padding: 8px 12px !important;
      transition: all 0.25s ease;
  }
  .staff-nav .nav-link:hover, .staff-nav .nav-link.active {
      color: #ffffff !important;
      background: rgba(255, 255, 255, 0.18);
      transform: translateY(-1px);
  }
  .staff-nav .navbar-toggler {
      border: 1px solid rgba(255,255,255,0.4);
  }
</style>

<nav class="navbar navbar-expand-lg navbar-dark staff-nav shadow-sm sticky-top">
  <div class="container-fluid">
    <a class="navbar-brand text-white d-flex align-items-center gap-2" href="index.jsp">
      <i class="fas fa-user-nurse fa-lg text-warning"></i>
      <span>STAFF PORTAL</span>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#staffNav" aria-controls="staffNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="staffNav">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link" href="index.jsp"><i class="fas fa-chart-pie me-1"></i> DASHBOARD</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="ViewAdmittedPatients.jsp"><i class="fas fa-procedures me-1"></i> PATIENTS</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="Admit.jsp"><i class="fas fa-user-plus me-1"></i> ADMIT</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="Discharge.jsp"><i class="fas fa-user-check me-1"></i> DISCHARGE</a>
        </li>
        <li class="nav-item">
          <a class="nav-link text-warning fw-bold" href="vitals_tracker.jsp"><i class="fas fa-heartbeat me-1"></i> VITALS & TRIAGE</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="../admin/ward_occupancy.jsp"><i class="fas fa-hospital-alt me-1"></i> WARD MAP</a>
        </li>
      </ul>
      <ul class="navbar-nav align-items-center gap-2">
        <!-- Notification Bell -->
        <%
          int _staffUnread = 0;
          try {
            Object _sObj = session.getAttribute("staffObj");
            int _sId = 0;
            if (_sObj != null) _sId = ((com.entity.Staff)_sObj).getId();
            com.dao.NotificationDao _sNDao = new com.dao.NotificationDao(com.db.DBConnect.getConn());
            _staffUnread = _sNDao.countUnread("STAFF", _sId);
          } catch (Exception _se) { /* table may not exist yet */ }
        %>
        <li class="nav-item">
          <a class="nav-link text-white position-relative" href="../notifications.jsp">
            <i class="fas fa-bell fa-lg"></i>
            <% if (_staffUnread > 0) { %>
            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size:10px">
              <%= _staffUnread > 9 ? "9+" : _staffUnread %>
            </span>
            <% } %>
          </a>
        </li>
        <li class="nav-item">
          <a class="btn btn-light text-success fw-bold rounded-pill px-3 shadow-sm" href="../staffLogout">
            <i class="fas fa-sign-out-alt me-1"></i> LOGOUT
          </a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
