<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">

<style>
  .doctor-header-nav {
      background: linear-gradient(135deg, #0369a1 0%, #0284c7 100%) !important;
      padding: 12px 24px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  }
  .doctor-header-nav .navbar-brand {
      font-size: 1.4rem;
      font-weight: 800;
      color: #ffffff !important;
      letter-spacing: 0.5px;
  }
  .doctor-header-nav .nav-link {
      font-size: 0.92rem;
      font-weight: 600;
      color: rgba(255, 255, 255, 0.9) !important;
      margin: 0 4px;
      border-radius: 8px;
      padding: 8px 14px !important;
      transition: all 0.25s ease;
  }
  .doctor-header-nav .nav-link:hover, .doctor-header-nav .nav-link.active {
      color: #ffffff !important;
      background: rgba(255, 255, 255, 0.18);
  }
</style>

<nav class="navbar navbar-expand-lg navbar-dark doctor-header-nav sticky-top">
  <div class="container-fluid">
    <!-- Doctor Brand Header -->
    <a class="navbar-brand text-white d-flex align-items-center gap-2" href="index.jsp">
      <i class="fas fa-user-md fa-lg text-warning"></i>
      <span>DOCTOR PORTAL</span>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#doctorHeaderNav" aria-controls="doctorHeaderNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="doctorHeaderNav">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0 align-items-center">
        <li class="nav-item">
          <a class="nav-link" href="index.jsp"><i class="fas fa-chart-pie me-1"></i> DASHBOARD</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="patient.jsp"><i class="fas fa-user-clock me-1"></i> APPOINTMENTS & PATIENTS</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="prescriptions.jsp"><i class="fas fa-prescription-bottle-alt me-1"></i> PRESCRIPTIONS</a>
        </li>
        <li class="nav-item">
          <a class="nav-link text-warning fw-bold" href="teleconsult_doctor.jsp"><i class="fas fa-video me-1"></i> TELECONSULT CALLS</a>
        </li>
        <li class="nav-item">
          <a class="nav-link text-white" href="voice_dictation.jsp"><i class="fas fa-microphone-alt me-1"></i> VOICE DICTATION</a>
        </li>
        <li class="nav-item">
          <a class="nav-link text-white" href="../pharmacy_safety.jsp"><i class="fas fa-pills me-1"></i> DRUG SAFETY CHECKER</a>
        </li>
      </ul>

      <!-- Notification Bell & Logout -->
      <ul class="navbar-nav align-items-center gap-2">
        <%
          int _docUnread = 0;
          try {
            Object _dObj = session.getAttribute("doctObj");
            if (_dObj == null) _dObj = session.getAttribute("doctorObj");
            int _dId = 0;
            if (_dObj != null) _dId = ((com.entity.Doctor)_dObj).getId();
            com.dao.NotificationDao _dNDao = new com.dao.NotificationDao(com.db.DBConnect.getConn());
            _docUnread = _dNDao.countUnread("DOCTOR", _dId);
          } catch (Exception _de) {}
        %>
        <li class="nav-item">
          <a class="nav-link text-white position-relative" href="../notifications.jsp">
            <i class="fas fa-bell fa-lg"></i>
            <% if (_docUnread > 0) { %>
            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size:10px">
              <%= _docUnread > 9 ? "9+" : _docUnread %>
            </span>
            <% } %>
          </a>
        </li>
        <li class="nav-item">
          <a class="btn btn-light text-primary fw-bold rounded-pill px-3 shadow-sm" href="../doctLogout">
            <i class="fas fa-sign-out-alt me-1"></i> LOGOUT
          </a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
