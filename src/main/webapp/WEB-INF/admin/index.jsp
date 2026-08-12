<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>  
<%@ page isELIgnored="false" %>
<%@page import="com.dao.DoctorDao" %>


<%@ page import="com.db.DBConnect" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entity.Doctor" %>

<%@ page import="com.entity.Appointment" %>
<%@ page import="com.doctor.*" %>
<%@page import="com.user.servlet.AppointmentServlet" %>
<%@page import="com.doctor.servlet.DoctorLogin" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<%@include file="../component/allcss.jsp" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    /* Custom styles for cards */
    .card {
      background-color: #d4edda; /* Success green background */
      border: 1px solid #c3e6cb; /* Slightly darker border */
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .card:hover {
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
      transform: translateY(-5px);
    }

    .card-icons {
      font-size: 2.5rem;
      color: #28a745; /* Success green icon color */
    }

    /* Animation effect */
    .card:active {
      animation: bounce 0.5s ease;
    }

    @keyframes bounce {
      0%, 100% {
        transform: translateY(0);
      }
      50% {
        transform: translateY(-10px);
      }
    }
    </style>
</head>
<body>

<%@include file="navbar.jsp" %><br>

  <c:if test="${empty adminObj}">
    <c:redirect url="../admin_login.jsp"></c:redirect>
</c:if>

 <p class="text-center fs-3">Admin Dashboard</p>
 <div class="container mt-5">
    <div class="row g-4">
    
    <%
    DoctorDao dao=new DoctorDao(DBConnect.getConn());
    
    %>
    
    
      <!-- Doctor Card -->
      <div class="col-md-3">
        <div class="card text-center p-3">
          <div class="card-body">
            <i class="fas fa-user-md card-icons"></i>
            <h5 class="card-title mt-3">Doctor<br><br>
            
            <%=dao.countDoctor() %>
            </h5>
          </div>
        </div>
      </div>
      <!-- User Card -->
      <div class="col-md-3">
        <div class="card text-center p-3">
          <div class="card-body">
            <i class="fas fa-users card-icons"></i>
            <h5 class="card-title mt-3">User<br><br> <%=dao.countUser() %></h5>
          </div>
        </div>
      </div>
      <!-- Total Appointment Card -->
      <div class="col-md-3">
        <div class="card text-center p-3">
          <div class="card-body">
            <i class="fas fa-calendar-check card-icons"></i>
            <h5 class="card-title mt-3">Total Appointment<br><br><%=dao.countAppointment() %></h5>
          </div>
        </div>
      </div>
      <!-- Specialist Card -->
      <div class="col-md-3  ">
      
        <div class="card text-center p-3" data-bs-toggle="modal" data-bs-target="#exampleModal">
          <div class="card-body">
            <i class="fas fa-stethoscope card-icons"></i>
            <h5 class="card-title mt-3">Specialist<br><br><%=dao.countSpecialist() %></h5>
          </div>
           </div>
            </div>
           <!-- Total Ambulance Card -->
     
        </div>
      </div>
   


<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Specialist Registration Form</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button><br>
      </div><br>
      <button type="submit" class="btn btn-primary"></button>
      <div class="modal-body">
      <form action=" ../addSpecialist" method="post">
      <div class="form-group">
      
      
      <label>Enter Specialist Name</label>
      
      <input type="text" name="specName" class="form-control">
      </div>
       <div class="text-center mtn-3" ><br>
       
        <button type="submit" class="btn btn-primary">Add</button>
       </div>
      
     
      
      </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        
      </div>
    </div>
  </div>
</div>

       <%
    String successMessage = (String) session.getAttribute("sucMsg");
    String errorMessage = (String) session.getAttribute("errorMsg");

    if (successMessage != null) {
%>
<script type="text/javascript">
    swal("Success", "<%= successMessage %>", "success");
</script>
<%
        session.removeAttribute("sucMsg"); // Clear the session attribute
    }

    if (errorMessage != null) {
%>
<script type="text/javascript">
    swal("Error", "<%= errorMessage %>", "error");
</script>
<%
        session.removeAttribute("errorMsg"); // Clear the session attribute
    }
%>
	


  <!-- Font Awesome for Icons -->
  <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
  <!-- Bootstrap Bundle with Popper -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
