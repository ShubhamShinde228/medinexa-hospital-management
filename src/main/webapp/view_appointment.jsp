<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="com.dao.*" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entity.Doctor" %>
<%@ page import="com.entity.Appointment" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  
   <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <style>
    
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


.shadow {
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

         .table-container {
    background: #f9f9f9;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    padding: 20px;
    border-radius: 8px;
}

.table-container h3, .form-container h3 {
    text-align: center;
    margin-bottom: 20px;
    color: #28a745;
    font-weight: bold;
}

.table-container table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
}

.table-container th, .table-container td {
    text-align: left;
    padding: 10px;
    border: 1px solid #ddd;
}

.table-container th {
    background-color: #28a745;
    color: white;
}

.table-container td {
    position: relative;
}

.table-container .actions {
    text-align: right;
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}
    </style>

</head>
<body>

<%@ include file="component/navbar.jsp" %>

   
   <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
   
   
<%
    User user = (User) session.getAttribute("userObj");
    if (user == null) {
        session.setAttribute("errorMsg", "Please login to view appointments.");
        response.sendRedirect("user_login.jsp");
        return;
    }
%>
<div class="table-container">
    <h2 class="text-center text-success mb-4">Appointment List</h2>
    <div class="table-responsive">
        <table class="table align-middle">
            <thead>
                <tr>
                    <th>Full Name</th>
                    <th>Gender</th>
                    <th>Age</th>
                    <th>Appointment Date</th>
                    <th>Diseases</th>
                    <th>Doctor Name</th>
                    <th>Status</th>
                    <th>Action / Payment</th>
                </tr>
            </thead>
            <tbody>
                <%
                AppointmentDao dao = new AppointmentDao(DBConnect.getConn());
                DoctorDao dao2 = new DoctorDao(DBConnect.getConn());
                List<Appointment> list = dao.getAllAppointmentByLoginUser(user.getId());

                for (Appointment ap : list) {
                    Doctor d = dao2.getDoctorById(ap.getDoctorId());
                    String doctorName = (d != null) ? d.getFullName() : "N/A";
                %>
                <tr>
                    <td><%= ap.getFullname() %></td>
                    <td><%= ap.getGender() %></td>
                    <td><%= ap.getAge() %></td>
                    <td><%= ap.getAppoinDate() %></td>
                    <td><%= ap.getDiseases() %></td>
                    <td><%= doctorName %></td>
                    <td>
                        <%
                        if ("Pending".equals(ap.getStatus())) {
                        %>
                            <span class="badge bg-warning text-dark">Pending</span>
                        <%
                        } else {
                        %>
                            <span class="badge bg-secondary"><%= ap.getStatus() %></span>
                        <%
                        }
                        %>
                    </td>
                    <td>
                        <%
                        String payStatus = ap.getPaymentStatus();
                        if ("Pending".equals(ap.getStatus())) {
                            if ("PENDING_PAYMENT".equals(payStatus) || payStatus == null) {
                        %>
                                <a href="payment_checkout.jsp?type=APPOINTMENT_FEE&appointmentId=<%= ap.getId() %>&amount=500" class="btn btn-sm btn-success fw-semibold">
                                    <i class="fa-solid fa-credit-card me-1"></i> Pay Now
                                </a>
                        <%
                            } else if ("PAID".equals(payStatus)) {
                        %>
                                <span class="badge bg-success"><i class="fa-solid fa-circle-check me-1"></i> Paid (Pending Doctor Comment)</span>
                        <%
                            } else {
                        %>
                                <span class="badge bg-secondary"><%= payStatus %></span>
                        <%
                            }
                        } else {
                        %>
                            <span class="text-muted small">Completed</span>
                        <%
                        }
                        %>
                    </td>
                </tr>
                <%
                }
                %>
            </tbody>
        </table>
    </div>
</div>

    



<!-- Success or Error Message -->
<%
    String successMessage = (String) session.getAttribute("sucMsg");
    String errorMessage = (String) session.getAttribute("errorMsg");

    if (successMessage != null) {
%>
<script type="text/javascript">
    swal("Success", "<%= successMessage %>", "success");
</script>
<%
        session.removeAttribute("sucMsg");
    }

    if (errorMessage != null) {
%>
<script type="text/javascript">
    swal("Error", "<%= errorMessage %>", "error");
</script>
<%
        session.removeAttribute("errorMsg");
    }
%>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>


</body>
</html>
