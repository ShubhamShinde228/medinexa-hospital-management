<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="com.dao.*" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entity.Doctor" %>
<%@ page import="com.entity.Specialist" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>  
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor Management</title>
    <%@include file="../component/allcss.jsp" %>
    <style>
        .container {
            display: flex;
            margin-top: 20px;
            gap: 20px;
        }

        .form-container, .table-container {
            background: white;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border-radius: 11px;
        }

        .form-container {
            width: 40%;
        }

        .form-container h3, .table-container h3 {
            margin-bottom: 20px;
            color: #28a745;
            text-align: center;
        }

        .form-container label {
            font-weight: bold;
            margin-top: 10px;
        }

        .form-container input, .form-container select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .button-container {
            text-align: center;
        }

        .form-container button {
            background: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            transition: 0.3s;
        }

        .form-container button:hover {
            background: #218838;
        }

        
    </style>
</head>
<body>

<%@include file="navbar.jsp" %>


    <c:if test="${empty adminObj}">
    <c:redirect url="../admin_login.jsp"></c:redirect>
</c:if>


      <%
    int id = Integer.parseInt(request.getParameter("id"));
    DoctorDao Dao2 = new DoctorDao(DBConnect.getConn()); // Renamed from 'dao' to 'doctorDao'
    Doctor d = Dao2.getDoctorById(id);
    
    
    
    
%>
    <div class="form-container offset-md-4">
        <h3>Edit Doctor Details</h3>
        
        
        
        
        
        <form id="doctorForm" action="../updateDoctor" method="post">
        
        
      
        
        
        
            <label for="fullName">Full Name</label>
            <input type="text"   required name="fullName" value="<%=d.getFullName() %>"  >

            <label for="dob">Date of Birth</label>
            <input type="date"  required name="dob"  value="<%=d.getDob()%>">
            
            <label for="qualification">Qualification</label>
            <input type="text" required name="qualification"  value="<%=d.getQualification()%>">

            <label for="specialist">Specialization</label>
            <select  name="specialist" required>
                <option><%=d.getSpecialist()%></option>
                <% 
                    SpecialistDao dao = new SpecialistDao(DBConnect.getConn());
                    List<Specialist> specialistList = dao.getAllSpecialist();
                    for (Specialist s : specialistList) {
                %>
                    <option><%= s.getSpecialistName()%></option>
                <% } %>
            </select>

            <label for="mobNo">Contact Number</label>
            <input type="tel" required name="mobNo"  value="<%=d.getMobNo()%>">

            <label for="email">Email</label>
            <input type="email" required name="email"   value="<%=d.getEmail()%>">
            
            <label for="password">Password</label>
            <input type="text" required name="password"   value="<%=d.getPassword()%>"><br>
             
             <input type="hidden" name="id" value="<%=d.getId() %>">
             
            <div class="button-container">
                <button type="submit">Update</button>
            </div>
          
        </form>
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

</body>
</html>
