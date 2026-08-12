<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.admin.servlet.AddWard" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="com.dao.WardDao" %>
<%@ page import="com.entity.Ward" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Add Ward Information</title>
    
    <!-- Include external CSS and Bootstrap -->
    <%@ include file="../component/allcss.jsp" %>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        /* General Reset */
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }

        /* Center the form */
        .container {
            width: 50%;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* Form heading */
        .container h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #007bff;
        }

        /* Label styling */
        label {
            font-weight: bold;
            margin-bottom: 8px;
            color: #555;
        }

        /* Input field styling */
        input[type="text"],
        input[type="number"],
        select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }

        /* Input field focus */
        input[type="text"]:focus,
        input[type="number"]:focus,
        select:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
        }

        /* Submit button styling */
        button {
            width: 30%;
            padding: 10px;
            background-color: #007bff;
            border: none;
            border-radius: 4px;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #0056b3;
        }

        /* Link Styling */
        a {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #007bff;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>
   
    <%@ include file="navbar.jsp" %>
    
  <%
    
    if (session.getAttribute("adminObj") == null) {
        response.sendRedirect("../admin_login.jsp"); 
    }
%>
    

    <div class="container">
        <h2>Add Ward Information</h2>
        <form action="../AddWard" method="POST">

          \
            <div class="mb-3">
                <label for="wardName" class="form-label">Ward Name:</label>
                <input type="text" id="wardName" name="ward_name" class="form-control" required>
            </div>
            
            
            <div class="mb-3">
                <label for="wardType" class="form-label">Ward Type:</label>
                <select id="wardType" name="ward_type" class="form-select" required>
                    <option value="General">General</option>
                    <option value="ICU">ICU</option>
                    <option value="Private">Private</option>
                </select>
            </div>
            
           
            <div class="mb-3">
                <label for="capacity" class="form-label">Capacity:</label>
                <input type="number" id="capacity" name="capacity" class="form-control" min="1" required>
            </div>
            
          
            <div class="mb-3">
                <label for="currentOccupancy" class="form-label">Current Occupancy:</label>
                <input type="number" id="currentOccupancy" name="current_occupancy" class="form-control" min="0" required>
            </div>
            
          
            <div class="text-center">
                <button type="submit" class="btn btn-primary">Add Ward</button>
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
    <script >setTimeout(function() {
        alert("Session expired. Redirecting to login...");
        window.location.href = 'admin_login.jsp';
    }, 300000);</script>
</body>
</html>
