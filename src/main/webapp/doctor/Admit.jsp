<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="com.dao.AdmitPatientDAO" %>
<%@ page import="com.entity.AdmitPatient" %>
<%@ page import="java.util.List" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admit Patient</title>
   <style >
   
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
}

.admit-container {
    max-width: 600px;
    margin: 30px auto;
    background: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
}

h2, h3 {
    text-align: center;
    color: #333;
}


.admit-form {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.admit-form label {
    font-weight: bold;
}

.admit-form input {
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
}


.submit-btn {
    background: #28a745;
    color: white;
    padding: 10px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 16px;
}

.submit-btn:hover {
    background: #218838;
}


h3 {
    text-align: center;
    color: #555;
    margin-top: 20px;
}


table {
    width: 90%;
    margin: 20px auto;
    border-collapse: collapse;
    background: white;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    overflow: hidden;
}

th, td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid #ddd;
}

th {
    background: #28a745;
    color: white;
}


.actions {
    display: flex;
    align-items: center;
    gap: 5px;
}

.actions a, .actions button {
    text-decoration: none;
    color: white;
    padding: 6px 12px;
    border-radius: 5px;
    font-size: 14px;
    cursor: pointer;
    border: none;
    transition: 0.3s;
}

.edit-btn {
    background: #007bff;
}

.edit-btn:hover {
    background: #0056b3;
}

.delete-btn {
    background: #dc3545;
}

.delete-btn:hover {
    background: #b52a37;
}

.download-btn {
    background: #ffc107;
    color: black;
}

.download-btn:hover {
    background: #e0a800;
}


.no-patients {
    text-align: center;
    font-weight: bold;
    color: #777;
    padding: 10px;
}


@media (max-width: 768px) {
    .admit-container, table {
        width: 95%;
        padding: 15px;
    }

    table {
        font-size: 14px;
    }

    .actions {
        flex-direction: column;
        gap: 3px;
    }
}
   
   </style>
    
  
    
</head>
<body>
<%@include file="navbar.jsp" %>
<br>

   <div class="admit-container">
    <h2>Admit Patient Form</h2>
    <form class="admit-form" action="../AdmitPatient" method="post">
        <label>Name:</label>
        <input type="text" name="name" required>

        <label>Disease:</label>
        <input type="text" name="disease" required>

        <label>Address:</label>
        <input type="text" name="address" required>

        <label>Admitted Date:</label>
        <input type="date" name="admittedDate" required>

        <button type="submit" class="submit-btn">Admit</button>
    </form>
</div><br><br>

    

                 <%
            Date currentDate = new Date();
            SimpleDateFormat formatter = new SimpleDateFormat("EEEE, MMM dd, yyyy HH:mm:ss");
            String formattedDate = formatter.format(currentDate);
        %>


        <h3 align="center"><%= "Current Date and Time: " + formattedDate %></h3>

                        <h3 align="center">Admitted Patients</h3>
        <table align="center" >
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
            if (patientList.isEmpty()) { %>
                <tr>
                    <td colspan="8" style="text-align: center; font-weight: bold; color: #777;">
                        No admitted patients found.
                    </td>
                </tr>
            <% } else {
                for (AdmitPatient p : patientList) { %>
                <tr>
                    <td><%= p.getId() %></td>
                    <td><%= p.getName() %></td>
                    <td><%= p.getDisease() %></td>
                    <td><%= p.getAddress() %></td>
                    <td><%= p.getAdmittedDate() %></td>
                    <td><%= (p.getDischargeDate() != null) ? p.getDischargeDate() : "Not Discharged" %></td>
                    <td><%= (p.getPayment() > 0) ? p.getPayment() : "Pending" %></td>
                    <td class="actions">
                     <a href="EditAdmitPatient.jsp?id=<%= p.getId() %>" class="edit-btn">Edit</a>
                 <form action="../deletePatient" method="post" style="display:inline;">
                   <input type="hidden" name="patientId" value="<%= p.getId() %>">
                    <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this patient?');">Delete</button>
                  </form>
                      <a href="../generatePatientReportbyid?id=<%= p.getId() %>" class="download-btn">Download Report</a>
                </td>

                </tr>
            <% } } %>
        </tbody>
    </table>


    
    
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
