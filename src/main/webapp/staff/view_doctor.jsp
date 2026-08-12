<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.db.DBConnect, com.dao.DoctorDao, java.util.List, com.entity.Doctor" %>


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

        .table-container {
            background: #f9f9f9;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border-radius: 8px;
        }

        .table-container h3 {
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

        .actions {
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
    <table>
        <thead>
            <tr>
                <th>Full Name</th>
                <th>DOB</th>
                <th>Qualification</th>
                <th>Specialization</th>
                <th>Mobile</th>
                <th>Email</th>
            </tr>
        </thead>
        <tbody>
            <% 
                DoctorDao doctorDao = new DoctorDao(DBConnect.getConn());
                List<Doctor> doctorList = doctorDao.getAllDoctors();
                if (doctorList != null && !doctorList.isEmpty()) {
                    for (Doctor d : doctorList) { 
            %>
            <tr>
                <td><%= d.getFullName() %></td>
                <td><%= d.getDob() %></td>
                <td><%= d.getQualification() %></td>
                <td><%= d.getSpecialist() %></td>
                <td><%= d.getMobNo() %></td>
                <td><%= d.getEmail() %></td>
            </tr>
            <% 
                    } 
                } else { 
            %>
            <tr>
                <td colspan="6" style="text-align: center;">No doctors found.</td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>

<!-- Success or Error Messages -->
<%
    String successMessage = (String) session.getAttribute("sucMsg");
    String errorMessage = (String) session.getAttribute("errorMsg");

    if (successMessage != null) {
%>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script>
    swal("Success", "<%= successMessage %>", "success");
</script>
<%
        session.removeAttribute("sucMsg");
    }

    if (errorMessage != null) {
%>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script>
    swal("Error", "<%= errorMessage %>", "error");
</script>
<%
        session.removeAttribute("errorMsg");
    }
%>

</body>
</html>
