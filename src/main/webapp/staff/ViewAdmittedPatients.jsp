<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.db.DBConnect" %>
<%@ page import="com.dao.AdmitPatientDAO" %>
<%@ page import="com.entity.AdmitPatient" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admitted Patients</title>
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

<!-- Admitted Patient List Table -->
<div class="table-container">
    <h3>Admitted Patients</h3>
    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Disease</th>
                <th>Address</th>
                <th>Admitted Date</th>
                <th>Discharge Date</th>
                <th>Payment</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% 
                AdmitPatientDAO patientDAO = new AdmitPatientDAO(DBConnect.getConn());
                List<AdmitPatient> patientList = patientDAO.getAdmittedPatients();

                for (AdmitPatient p : patientList) { 
            %>
            <tr>
                <td><%= p.getId() %></td>
                <td><%= p.getName() %></td>
                <td><%= p.getDisease() %></td>
                <td><%= p.getAddress() %></td>
                <td><%= p.getAdmittedDate() %></td>
                <td><%= (p.getDischargeDate() != null) ? p.getDischargeDate() : "Not Discharged" %></td>
                <td><%= p.getPayment() %></td>
                <td class="actions">
                     <a href="EditAdmitPatient.jsp?id=<%= p.getId() %>" class="edit-btn">Edit</a>
                 <form action="../deletePatient" method="post" style="display:inline;">
                   <input type="hidden" name="patientId" value="<%= p.getId() %>">
                    <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this patient?');">Delete</button>
                  </form>
                      <a href="../generatePatientReportbyid?id=<%= p.getId() %>" class="download-btn">Download Report</a>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>

</body>
</html>
