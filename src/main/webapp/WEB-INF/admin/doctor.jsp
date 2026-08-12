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
        
body {
    margin: 0;
    background-color: #f8f9fa;
    display: flex;
    flex-direction: column; /* Stack elements vertically */
    align-items: center; /* Center horizontally */
}

.navbar {
    width: 100%;
    background-color: #343a40; /* Dark navbar color */
    color: white;
    padding: 10px 20px;
    position: fixed; /* Keep navbar fixed at the top */
    top: 0;
    left: 0;
    z-index: 1000;
    text-align: center; /* Center navbar content */
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

.content-container {
    margin-top: 80px; /* Add space below navbar (adjust to navbar height) */
    display: flex;
    justify-content: center;
    align-items: center;
    height: calc(100vh - 80px); /* Subtract navbar height from full height */
    width: 100%;
}

.form-container {
    background: white;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    padding: 20px;
    border-radius: 17px;
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

       

.delete-btn:hover {
    background: #c82333;
}
    </style>
</head>
<body>

<%@include file="navbar.jsp" %>
<br>
<br>

 <c:if test="${empty adminObj}">
    <c:redirect url="../admin_login.jsp"></c:redirect>
</c:if>



    <!-- Doctor Details Form -->
    <div class="form-container">
        <h3>Doctor Details Form</h3>
        <form id="doctorForm" action="../addDoctor" method="post">
        
            <label for="fullName">Full Name</label>
            <input type="text" id="fullName" name="fullName" placeholder="Enter full name" required>

            <label for="dob">Date of Birth</label>
            <input type="date" id="dob" name="dob" required>
            
            <label for="qualification">Qualification</label>
            <input type="text" id="qualification" name="qualification" placeholder="Enter Qualification" required>

            <label for="specialist">Specialization</label>
            <select id="specialist" name="specialist" required>
                <option value="">Select Specialization</option>
                <% 
                    SpecialistDao dao = new SpecialistDao(DBConnect.getConn());
                    List<Specialist> specialistList = dao.getAllSpecialist();
                    for (Specialist s : specialistList) {
                %>
                    <option value="<%= s.getSpecialistName() %>"><%= s.getSpecialistName() %></option>
                <% } %>
            </select>

            <label for="mobNo">Contact Number</label>
            <input type="tel" id="mobNo" name="mobNo" placeholder="Enter contact number" required>

            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="Enter email" required>
            
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter Password" required><br>

            <div class="button-container">
                <button type="submit">Submit</button>
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
