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

        .form-container {
            background: white;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border-radius: 18px;
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

.edit-btn {
    background: #007bff;
    color: white;
    border: none;
    padding: 5px 10px;
    border-radius: 4px;
    cursor: pointer;
    transition: 0.3s;
}

.edit-btn:hover {
    background: #0056b3;
}

.delete-btn {
    background: #dc3545;
    color: white;
    border: none;
    padding: 5px 10px;
    border-radius: 4px;
    cursor: pointer;
    transition: 0.3s;
}

.delete-btn:hover {
    background: #c82333;
}
    </style>
</head>
<body>

<%@include file="navbar.jsp" %>

    

    <!-- Doctor List Table -->
    <div class="table-container">
        <h3>Doctor List</h3>
        <table border="2" cellpadding1="12" cellspacing1="0">
            <thead>
                <tr>
                    
                    <th>Full Name</th>
                    <th>DOB</th>
                    <th>Qualification</th>
                    <th>Specialization</th>
                    <th>Mobile</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    DoctorDao doctorDao = new DoctorDao(DBConnect.getConn());
                    List<Doctor> doctorList = doctorDao.getAllDoctors();
                    for (Doctor d : doctorList) { 
                %>
                <tr>
   
    <td><%= d.getFullName() %></td>
    <td><%= d.getDob() %></td>
    <td><%= d.getQualification() %></td>
    <td><%= d.getSpecialist() %></td>
    <td><%= d.getMobNo() %></td>
    <td><%= d.getEmail() %></td>
    <td>
        <div class="actions">
            <!-- Edit Button -->
            
            <a href="edit_doctor.jsp?id=<%= d.getId() %>" class="btn btn-primary">Edit</a>
            
           
            <!-- Delete Button -->
            <form action="../deleteDoctor" method="post" style="display:inline;">
                <input type="hidden" name="doctorId" value="<%= d.getId() %>">
                <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this doctor?');">Delete</button>
            </form>
        </div>
    </td>
</tr>
                <% } %>
            </tbody>
        </table>
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
