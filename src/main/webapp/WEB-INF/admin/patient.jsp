<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>  
<%@ page isELIgnored="false" %>


<%@ page import="com.db.DBConnect" %>
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entity.Doctor" %>

<%@ page import="com.entity.Appointment" %>
<%@ page import="com.doctor.*" %>
<%@page import="com.user.servlet.AppointmentServlet" %>
<%@page import="com.doctor.servlet.DoctorLogin" %>
<%@page import="com.dao.DoctorDao" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Patient Module</title>
<%@include file="../component/allcss.jsp" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style >
  .table-container {
    background: #f9f9f9; /* Subtle background for better contrast */
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
<%@include file="navbar.jsp" %><br>

  <c:if test="${empty adminObj}">
    <c:redirect url="../admin_login.jsp"></c:redirect>
</c:if>

 <!-- Doctor List Table -->
    <div class="table-container">
        <h3>Patient Details</h3>
        <table border="2" cellpadding1="12" cellspacing1="0">
            <thead>
                <tr>
                    
                    <th>Full Name</th>
                    <th>Gender</th>
                    <th>Age</th>
                    <th>Appointment</th>
                    <th>Email</th>
                    <th>Mob No</th>
                    <th>Diseases</th>
                    <th>Doctor Name</th>
                    <th>Address</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
            
            <%
            
            AppointmentDao dao=new AppointmentDao(DBConnect.getConn());
            DoctorDao dao2=new DoctorDao(DBConnect.getConn());
            List<Appointment> list=dao.getAllAppointment();
            for (Appointment ap : list) { 
            
            	 Doctor d= dao2.getDoctorById(ap.getDoctorId());
            %>
            
          

            <tr>
                <td><%= ap.getFullname() %></td>
                <td><%= ap.getGender() %></td>
                <td><%= ap.getAge() %></td>
                <td><%= ap.getAppoinDate() %></td>
                <td><%= ap.getEmail() %></td>
                <td><%= ap.getPhNo() %></td>
                <td><%= ap.getDiseases() %></td>
                <td><%= d.getFullName() %></td>
                <td><%= ap.getAddress() %></td>
                <td><%= ap.getStatus() %></td>
           
             </tr>
                
           <% } %>
                
            
           
            
            
      
   
    
         </tbody>
        </table>
    </div>   
            
            

</body>
</html>
