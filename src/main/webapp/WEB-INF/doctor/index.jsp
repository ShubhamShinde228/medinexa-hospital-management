<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>  
    <%@ page isELIgnored="false" %>
    <%@page import="com.dao.DoctorDao" %>
    <%@ page import="com.db.DBConnect" %>
      <%@ page import="com.doctor.servlet.*" %>
        <%@ page import="com.entity.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Doctor Dashboard</title>

<%@include file="navbarcss.jsp" %>

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

<%@include file="navbar.jsp" %>


       

<input type="hidden" id="status" value="<%= request.getAttribute("status") %>">

<p class="text-center fs-3">Doctor Dashboard</p>
<div class="container mt-5">
    <div class="row justify-content-center g-4">
    
    <% 
   Doctor d =(Doctor) session.getAttribute("doctObj");
    DoctorDao dao=new DoctorDao(DBConnect.getConn());
    %>
    
        <!-- Doctor Card -->
        <div class="col-md-3">
            <div class="card text-center p-3">
                <div class="card-body">
                    <i class="fas fa-user-md card-icons"></i>
                    <h5 class="card-title mt-3">Doctor<br><br><%=dao.countDoctor() %></h5>
                </div>
            </div>
        </div>
        <!-- Total Appointment Card -->
        <div class="col-md-3">
            <div class="card text-center p-3">
                <div class="card-body">
                    <i class="fas fa-users card-icons"></i>
                    <h5 class="card-title mt-3">Total Appointment<br><br><%=dao.countAppointmentByDoctorId(d.getId()) %></h5>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

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

</body>
</html>
