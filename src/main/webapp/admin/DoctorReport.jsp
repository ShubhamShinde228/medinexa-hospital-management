<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.dao.DoctorDao"%>
<%@page import="com.entity.Doctor"%>
<%@page import="com.db.DBConnect"%>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Registration Report</title>
    <link rel="stylesheet" href="styles.css"> <!-- Add CSS file for styling -->
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }
        .container {
            width: 80%;
            margin: auto;
            background: white;
            padding: 20px;
            box-shadow: 0px 0px 10px gray;
            border-radius: 8px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }
        th {
            background: #007bff;
            color: white;
        }
        .download-btn {
            display: block;
            width: 250px;
            margin: 20px auto;
            text-align: center;
            background: #28a745;
            color: white;
            padding: 10px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
        }
        .download-btn:hover {
            background: #218838;
        }
    </style>
</head>
<body>
   <%@ include file="navbar.jsp" %>
    <div class="container">
        <h2>Doctor Registration Report</h2>
        
        <%
    // Start session if it doesn't exist
    if (session.getAttribute("adminObj") == null) {
        response.sendRedirect("../admin_login.jsp"); // Redirect to login page if not logged in
    }
%>

        <!-- Fetch doctor list from the database -->
        <%
            DoctorDao doctorDao = new DoctorDao(DBConnect.getConn());
            List<Doctor> doctorList = doctorDao.getAllDoctorsReport();
        %>

        <!-- Table to Display Doctor Data -->
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Specialization</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Qualification</th>
                </tr>
            </thead>
            <tbody>
                <% for (Doctor doc : doctorList) { %>
                    <tr>
                        <td><%= doc.getId() %></td>
                        <td><%= doc.getFullName() %></td>
                        <td><%= doc.getSpecialist() %></td>
                        <td><%= doc.getEmail() %></td>
                        <td><%= doc.getMobNo() %></td>
                        <td><%= doc.getQualification() %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>

        <!-- Download CSV Button -->
        <a href="../DoctorReportServlet" class="download-btn">Download Pdf Report</a>
    </div>

</body>
</html>
