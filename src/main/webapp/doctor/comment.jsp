<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="com.dao.AppointmentDao" %>
<%@ page import="com.entity.Appointment" %>
<%@ page import="com.db.DBConnect" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Comment</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  
   <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

   
    <style>
    
       .navbar {
	padding: 20px;
}

.navbar-brand {
	font-size: 1.5rem;
	color: white !important;
	text-transform: uppercase;
	letter-spacing: 1px;
}

.navbar-nav .nav-link {
	font-size: 1rem;
	color: white !important;
	margin: 0 10px;
	transition: all 0.3s ease;
}

.navbar-nav .nav-link:hover {
	color: #ffe600 !important;
	font-weight: bold;
	text-shadow: 0 2px 2px rgba(0, 0, 0, 0.2);
}


.navbar-toggler {
	border-color: rgba(255, 255, 255, 0.5);
}

.navbar-toggler-icon {
	background-image:
		url('data:image/svg+xml;charset=utf8,%3Csvg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 30"%3E%3Cpath stroke="rgba%28255, 255, 255, 0.8%29" stroke-width="2" d="M4 7h22M4 15h22M4 23h22"/%3E%3C/svg%3E');
}

body {
            font-family: Arial, sans-serif;
            margin: 0;
            
            background-color: #f4f4f9;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        form {
            max-width: 500px;
            margin: 0 auto;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"], textarea {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        input[readonly] {
            background-color: #e9ecef;
        }
        textarea {
            resize: vertical;
            height: 100px;
        }
        button {
            display: block;
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
</style>

</head>
<body>
<%@include file="navbar.jsp" %>



<h2>Patient Comment Form</h2>
    <form action="../updateStatus" method="POST">
    
    
    
    <% int id=Integer.parseInt(request.getParameter("id"));  
       AppointmentDao dao=new AppointmentDao(DBConnect.getConn());
       
       Appointment ap =dao.getAppointmentById(id);
    
    
    %>
        
        <label for="patientName">Patient Name:</label>
        <input type="text" id="patientName" name="patientName" value="<%=ap.getFullname() %>" readonly>
        
       
        <label for="age">Age:</label>
        <input type="text" id="age" name="age" value="<%=ap.getAge() %>" readonly>

       
        <label for="mobNo">Mobile Number:</label>
        <input type="text" id="mobNo" name="mobNo" value="<%=ap.getPhNo() %>" readonly>

        
        <label for="diseases">Diseases:</label>
        <input type="text" id="diseases" name="diseases" value="<%=ap.getDiseases() %>" readonly>
        
        
        <label for="status">Comment:</label>
        <textarea id="status" name="status" placeholder="Enter your comments here..."></textarea><br><br>
        
        
        <input type="hidden" name="id" value="<%=ap.getId()%>">
        <input type="hidden" name="did" value="<%= ap.getDoctorId() %>">
         
        
         
        
        <button type="submit">Submit</button>
    </form>
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
