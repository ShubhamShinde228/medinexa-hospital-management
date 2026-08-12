<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet">

<style>
  .medical-header-nav {
      background: linear-gradient(135deg, #3730a3 0%, #4338ca 100%) !important;
      padding: 12px 24px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  }
  .medical-header-nav .navbar-brand {
      font-size: 1.4rem;
      font-weight: 800;
      color: #ffffff !important;
      letter-spacing: 0.5px;
  }
  .medical-header-nav .nav-link {
      font-size: 0.92rem;
      font-weight: 600;
      color: rgba(255, 255, 255, 0.9) !important;
      margin: 0 4px;
      border-radius: 8px;
      padding: 8px 14px !important;
      transition: all 0.25s ease;
  }
  .medical-header-nav .nav-link:hover, .medical-header-nav .nav-link.active {
      color: #ffffff !important;
      background: rgba(255, 255, 255, 0.18);
  }
</style>

<nav class="navbar navbar-expand-lg navbar-dark medical-header-nav sticky-top">
  <div class="container-fluid">
    <!-- Medical Brand Header -->
    <a class="navbar-brand text-white d-flex align-items-center gap-2" href="index.jsp">
      <i class="fas fa-capsules fa-lg text-warning"></i>
      <span>MEDICAL PORTAL</span>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#medicalHeaderNav" aria-controls="medicalHeaderNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="medicalHeaderNav">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0 align-items-center">
        <li class="nav-item">
          <a class="nav-link" href="index.jsp"><i class="fas fa-chart-pie me-1"></i> COMMAND CENTER</a>
        </li>
        <li class="nav-item">
          <a class="nav-link text-warning fw-bold" href="dispense_medicine.jsp"><i class="fas fa-pills me-1"></i> AI SMART DISPENSER</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="qr_dispense.jsp"><i class="fas fa-qrcode me-1"></i> QR DISPENSE</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="vendor_orders.jsp"><i class="fas fa-truck-loading me-1"></i> VENDOR POs</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="lab_analyzer.jsp"><i class="fas fa-vial me-1"></i> LAB DIAGNOSTIC ANALYZER</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="../pharmacy_safety.jsp"><i class="fas fa-shield-virus me-1"></i> DRUG CONFLICT CHECKER</a>
        </li>
      </ul>

      <!-- Logout -->
      <ul class="navbar-nav align-items-center gap-2">
        <li class="nav-item">
          <a class="btn btn-light text-indigo fw-bold rounded-pill px-4 shadow-sm" style="color:#4338ca" href="../medicalLogout">
            <i class="fas fa-sign-out-alt me-1"></i> LOGOUT
          </a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
