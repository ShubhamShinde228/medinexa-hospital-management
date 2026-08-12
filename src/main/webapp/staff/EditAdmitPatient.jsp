<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.db.DBConnect, com.dao.AdmitPatientDAO, com.entity.AdmitPatient" %>
<%
    int patientId = Integer.parseInt(request.getParameter("id"));
    AdmitPatientDAO patientDAO = new AdmitPatientDAO(DBConnect.getConn());
    AdmitPatient patient = patientDAO.getPatientById(patientId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    
    <title>Edit Patient</title>
    
    <style>
     /* General Page Styles */
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
}

/* Main Edit Container */
.edit-container {
    max-width: 500px;
    margin: 50px auto;
    background: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    text-align: center;
}

/* Page Heading */
h2 {
    color: #333;
    margin-bottom: 20px;
}

/* Form Styles */
.form-group {
    text-align: left;
    margin-bottom: 15px;
}

.form-group label {
    font-weight: bold;
    display: block;
    margin-bottom: 5px;
}

.form-group input {
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
}

/* Update Button */
button {
    background: #007bff;
    color: white;
    padding: 10px 15px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 16px;
}

button:hover {
    background: #0056b3;
}

/* Responsive Design */
@media (max-width: 768px) {
    .edit-container {
        width: 90%;
        padding: 15px;
    }
}
     
    </style>
    
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="edit-container">
    <h2>Edit Patient</h2>
    <form action="../EditPatient" method="post">
        <input type="hidden" name="id" value="<%= patient.getId() %>">

        <div class="form-group">
            <label>Name:</label>
            <input type="text" name="name" value="<%= patient.getName() %>" required>
        </div>

        <div class="form-group">
            <label>Disease:</label>
            <input type="text" name="disease" value="<%= patient.getDisease() %>" required>
        </div>

        <div class="form-group">
            <label>Address:</label>
            <input type="text" name="address" value="<%= patient.getAddress() %>" required>
        </div>

        <button type="submit">Update Patient</button>
    </form>
</div>

</body>
</html>
