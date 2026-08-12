
<%@ page import="jakarta.servlet.http.HttpSession"%>
<%@ page import="com.entity.User"%>

<nav class="navbar navbar-expand-lg navbar-dark bg-success shadow">
	<div class="container-fluid">
		<!-- Navbar Brand -->
		<a class="navbar-brand fw-bold" href="index.jsp"> <i
			class="fa-solid fa-house-medical-flag"></i> MEDI HOME
		</a>
		<!-- Navbar Toggler -->
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse"
			data-bs-target="#navbarNav" aria-controls="navbarNav"
			aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<!-- Navbar Links -->
		<div class="collapse navbar-collapse" id="navbarNav">
			<ul class="navbar-nav ms-auto">
				<%
				
				Object userObj = session.getAttribute("userObj");
				%>

				<%
				if (userObj == null) {
				%>
				<!-- Links for guests -->
				<li class="nav-item"><a class="nav-link active"
					href="admin_login.jsp"> <i class="fa-solid fa-user-tie"></i>
						ADMIN
				</a></li>
				<li class="nav-item"><a class="nav-link"
					href="doctor_login.jsp"> <i class="fa-solid fa-user-md"></i>
						DOCTOR
				</a></li>
				<li class="nav-item"><a class="nav-link" href="user_appointment.jsp"> <i
						class="fa-solid fa-calendar-check"></i> APPOINTMENT
				</a></li>
				<li class="nav-item"><a class="nav-link" href="user_login.jsp">
						<i class="fa-solid fa-user"></i> USER
				</a></li>
				<%
				} else {
				%>
				<!-- Links for logged-in users -->
				<li class="nav-item"><a class="nav-link" href="user_appointment.jsp"> <i
						class="fa-solid fa-calendar-check"></i> APPOINTMENT
				</a></li>
				<li class="nav-item"><a class="nav-link" href="view_appointment.jsp"> <i
						class="fa-solid fa-calendar-check"></i> VIEW APPOINTMENT
				</a></li></ul>
				         
				       <ul class="navbar-nav">
          <!-- Logout Button with Icon -->
          <li class="nav-item">
            <a class="btn btn-light text-success" href="UserLogout"><i class="fas fa-sign-out-alt"></i>Logout</a>
          </li>
        </ul>
    </div>
</div>
				         
			
		
		
	
	<%
						}
						%>
						
					
</nav>

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
	background-image:
		url('data:image/svg+xml;charset=utf8,%3Csvg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 30"%3E%3Cpath stroke="rgba%28255, 255, 255, 0.8%29" stroke-width="2" d="M4 7h22M4 15h22M4 23h22"/%3E%3C/svg%3E');
}

/* Shadow effect */
.shadow {
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}




</style>
