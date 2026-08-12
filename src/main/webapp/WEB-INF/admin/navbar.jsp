  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome Icons -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
  <style>
    /* Navbar styles */
    .navbar {
        padding: 15px;
    }

    .navbar-brand {
        font-size: 1.5rem;
        color: white !important;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .navbar-nav .nav-link {
        font-size: 1rem;
        color: white !important;
        margin: 0 10px;
        transition: all 0.3s ease;
    }

    .navbar-nav .nav-link:hover {
        color: #ffe600 !important;
        font-weight: bold;
        text-shadow: 0 2px 2px rgba(0, 0, 0, 0.2);
    }

    /* Navbar toggle button */
    .navbar-toggler {
        border-color: rgba(255, 255, 255, 0.5);
    }

    .navbar-toggler-icon {
        background-image: url('data:image/svg+xml;charset=utf8,%3Csvg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 30"%3E%3Cpath stroke="rgba%28255, 255, 255, 0.8%29" stroke-width="2" d="M4 7h22M4 15h22M4 23h22"/%3E%3C/svg%3E');
    }

    /* Shadow effect */
    .shadow {
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }
  </style>
  <nav class="navbar navbar-expand-lg navbar-success bg-success shadow">
    <div class="container-fluid">
      <!-- Admin Dashboard Icon -->
      <a class="navbar-brand text-white" href="#">
        <i class="fas fa-tachometer-alt"></i> Admin Dashboard
      </a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button><br>

      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav me-auto">
          <!-- Home Link with Icon -->
          <li class="nav-item">
            <a class="nav-link text-white" href="index.jsp"><i class="fas fa-home"></i> HOME</a>
          </li>
          <!-- Doctor Link with Icon -->
          <li class="nav-item">
            <a class="nav-link text-white" href="doctor.jsp"><i class="fas fa-user-md"></i> DOCTOR</a>
          </li>
           <li class="nav-item">
            <a class="nav-link text-white" href="view_doctor.jsp"><i class="fas fa-user-md"></i> View Doctor</a>
          </li>
          <!-- Patients Link with Icon -->
          <li class="nav-item">
            <a class="nav-link text-white" href="patient.jsp"><i class="fas fa-users"></i> PATIENTS</a>
          </li>
        </ul>
        <ul class="navbar-nav">
          <!-- Logout Button with Icon -->
          <li class="nav-item">
            <a class="btn btn-light text-success" href="../AdminLogout"><i class="fas fa-sign-out-alt"></i> LOGOUT</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>

  <!-- Bootstrap Bundle with Popper -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
