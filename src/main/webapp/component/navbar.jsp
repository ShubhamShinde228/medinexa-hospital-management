<%@ page import="jakarta.servlet.http.HttpSession"%>
<%@ page import="com.entity.User"%>

<style>
.exec-navbar {
    background: linear-gradient(135deg, #0d5c38 0%, #198754 100%) !important;
    padding: 12px 24px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
}
.exec-navbar .navbar-brand {
    font-size: 1.45rem;
    font-weight: 800;
    color: #ffffff !important;
    letter-spacing: 0.5px;
    display: flex;
    align-items: center;
    gap: 10px;
}
.exec-navbar .brand-icon {
    width: 42px;
    height: 42px;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    color: #ffe600;
}
/* Module Nav Pill Buttons */
.nav-pill-btn {
    font-size: 0.88rem;
    font-weight: 700;
    padding: 8px 18px !important;
    border-radius: 25px;
    margin: 0 4px;
    transition: all 0.25s ease;
    display: inline-flex;
    align-items: center;
    gap: 7px;
    text-transform: uppercase;
    letter-spacing: 0.3px;
    border: 1px solid transparent;
}
.nav-pill-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
}
.pill-admin { background: #1e293b; color: #f8fafc !important; border-color: #334155; }
.pill-admin:hover { background: #0f172a; color: #ffffff !important; }

.pill-doctor { background: #0284c7; color: #ffffff !important; border-color: #38bdf8; }
.pill-doctor:hover { background: #0369a1; color: #ffffff !important; }

.pill-staff { background: #059669; color: #ffffff !important; border-color: #34d399; }
.pill-staff:hover { background: #047857; color: #ffffff !important; }

.pill-user { background: #d97706; color: #ffffff !important; border-color: #fbbf24; }
.pill-user:hover { background: #b45309; color: #ffffff !important; }

.pill-sos { background: #dc3545; color: #ffffff !important; border-color: #fca5a5; animation: sosPulse 2s infinite; }
@keyframes sosPulse { 0% { box-shadow: 0 0 0 0 rgba(220,53,69,0.7); } 70% { box-shadow: 0 0 0 10px rgba(220,53,69,0); } 100% { box-shadow: 0 0 0 0 rgba(220,53,69,0); } }

/* Dropdown Menu Styling */
.exec-navbar .dropdown-menu {
    border-radius: 14px;
    border: none;
    box-shadow: 0 10px 30px rgba(0,0,0,0.15);
    padding: 8px;
}
.exec-navbar .dropdown-item {
    font-size: 0.9rem;
    font-weight: 600;
    border-radius: 8px;
    padding: 8px 16px;
    color: #334155;
    transition: all 0.2s;
}
.exec-navbar .dropdown-item:hover {
    background: #f0fdf4;
    color: #198754;
}
</style>

<nav class="navbar navbar-expand-lg navbar-dark exec-navbar sticky-top">
	<div class="container-fluid">
		<!-- Executive Brand Logo -->
		<a class="navbar-brand text-white" href="index.jsp">
			<div class="brand-icon"><i class="fa-solid fa-hospital"></i></div>
			<div>
				<div>MEDI HOME</div>
				<small style="font-size: 10px; font-weight: 500; opacity: 0.8; display: block; margin-top: -4px;">ENTERPRISE HEALTHCARE</small>
			</div>
		</a>

		<button class="navbar-toggler" type="button" data-bs-toggle="collapse"
			data-bs-target="#navbarNav" aria-controls="navbarNav"
			aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse" id="navbarNav">
			<ul class="navbar-nav ms-auto align-items-center">
				<%
				Object userObj = session.getAttribute("userObj");
				if (userObj == null) {
				%>
				<!-- Clean Executive Guest Nav: 5 Core Modules -->
				<li class="nav-item">
					<a class="nav-link nav-pill-btn pill-admin shadow-sm" href="admin_login.jsp">
						<i class="fa-solid fa-user-tie"></i> ADMIN PORTAL
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link nav-pill-btn pill-doctor shadow-sm" href="doctor_login.jsp">
						<i class="fa-solid fa-user-md"></i> DOCTOR PORTAL
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link nav-pill-btn pill-staff shadow-sm" href="staff_login.jsp">
						<i class="fa-solid fa-user-nurse"></i> STAFF PORTAL
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link nav-pill-btn shadow-sm text-white" style="background:#4338ca; border-color:#818cf8" href="medical_login.jsp">
						<i class="fa-solid fa-capsules"></i> MEDICAL PORTAL
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link nav-pill-btn pill-user shadow-sm" href="user_login.jsp">
						<i class="fa-solid fa-user"></i> PATIENT PORTAL
					</a>
				</li>
				<% } else { %>
				<!-- Logged-in Patient Module Organized Navigation -->
				
				<!-- Appointments Dropdown -->
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle text-white fw-semibold" href="#" role="button" data-bs-toggle="dropdown">
						<i class="fa-solid fa-calendar-check me-1"></i> APPOINTMENTS
					</a>
					<ul class="dropdown-menu">
						<li><a class="dropdown-item" href="slot_booking.jsp"><i class="fa-solid fa-calendar-plus text-success me-2"></i> Book Doctor Slot</a></li>
						<li><a class="dropdown-item" href="user_appointment.jsp"><i class="fa-solid fa-calendar-day text-primary me-2"></i> Request Appointment</a></li>
						<li><a class="dropdown-item" href="view_appointment.jsp"><i class="fa-solid fa-list-check text-warning me-2"></i> View My Appointments</a></li>
					</ul>
				</li>

				<!-- Smart Health Tools Dropdown -->
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle text-white fw-semibold" href="#" role="button" data-bs-toggle="dropdown">
						<i class="fa-solid fa-kit-medical me-1"></i> HEALTH SERVICES
					</a>
					<ul class="dropdown-menu">
						<li><a class="dropdown-item" href="symptom_checker.jsp"><i class="fa-solid fa-stethoscope text-success me-2"></i> AI Symptom Checker</a></li>
						<li><a class="dropdown-item" href="ai_diagnostic_matrix.jsp"><i class="fa-solid fa-brain text-warning me-2"></i> AI Differential Diagnosis Matrix</a></li>
						<li><a class="dropdown-item" href="genomic_profiler.jsp"><i class="fa-solid fa-dna text-purple me-2"></i> Genomic & Allergen Profiler</a></li>
						<li><a class="dropdown-item" href="blood_bank.jsp"><i class="fa-solid fa-droplet text-danger me-2"></i> Smart Blood Bank & Donor Match</a></li>
						<li><a class="dropdown-item" href="diet_planner.jsp"><i class="fa-solid fa-carrot text-success me-2"></i> AI Clinical Recovery Diet Planner</a></li>
						<li><a class="dropdown-item" href="smart_bed_transfer.jsp"><i class="fa-solid fa-bed-pulse text-danger me-2"></i> Auto ICU Bed Transfer</a></li>
						<li><a class="dropdown-item" href="claim_verifier.jsp"><i class="fa-solid fa-file-invoice-dollar text-info me-2"></i> Cost & Insurance Verifier</a></li>
						<li><a class="dropdown-item" href="teleconsult.jsp"><i class="fa-solid fa-video text-primary me-2"></i> Virtual Queue & Teleconsult</a></li>
						<li><a class="dropdown-item" href="patient_qr.jsp"><i class="fa-solid fa-qrcode text-dark me-2"></i> QR Health Passport</a></li>
						<li><a class="dropdown-item" href="my_prescriptions.jsp"><i class="fas fa-prescription-bottle-alt text-info me-2"></i> My Prescriptions</a></li>
						<li><a class="dropdown-item" href="my_timeline.jsp"><i class="fas fa-notes-medical text-secondary me-2"></i> Medical Timeline</a></li>
						<li><a class="dropdown-item" href="payment_history.jsp"><i class="fa-solid fa-clock-rotate-left text-success me-2"></i> Payment History</a></li>
					</ul>
				</li>

				<!-- Emergency SOS Pill Button -->
				<li class="nav-item">
					<a class="nav-link nav-pill-btn pill-sos shadow-sm" href="emergency_dispatch.jsp">
						<i class="fa-solid fa-truck-medical"></i> SOS EMERGENCY
					</a>
				</li>

				<!-- Live notification bell -->
				<li class="nav-item">
					<%
					int _userId = 0;
					try { _userId = ((com.entity.User) userObj).getId(); } catch (Exception ignored) {}
					int _unread = 0;
					try {
						com.dao.NotificationDao _nDao = new com.dao.NotificationDao(com.db.DBConnect.getConn());
						_unread = _nDao.countUnread("USER", _userId);
					} catch (Exception _ex) {}
					%>
					<a class="nav-link position-relative text-white ms-2" href="notifications.jsp">
						<i class="fas fa-bell fa-lg"></i>
						<% if (_unread > 0) { %>
						<span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size:10px">
							<%= _unread > 9 ? "9+" : _unread %>
						</span>
						<% } %>
					</a>
				</li>

				<li class="nav-item ms-2">
					<a class="btn btn-light text-success fw-bold rounded-pill px-4 shadow-sm" href="UserLogout">
						<i class="fas fa-sign-out-alt me-1"></i> Logout
					</a>
				</li>
				<% } %>
			</ul>
		</div>
	</div>
</nav>
