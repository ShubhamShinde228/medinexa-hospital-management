<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
    <%@page import="com.dao.*" %>
    <%@page import="com.db.DBConnect" %>
    <%@page import="com.user.servlet.*" %>
      <%@page import="com.entity.*" %>
      <%@ page import="java.util.List" %>
       
        
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Appointment Form</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Custom CSS -->
    <style>
        body {
            background-color: #f4f4f4;
            font-family: 'Arial', sans-serif;
        }

        .appointment-form {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            max-width: 600px;
            margin: 50px auto;
        }

        .appointment-form h2 {
            text-align: center;
            margin-bottom: 20px;
            font-size: 2rem;
            color: #28a745;
            font-weight: bold;
        }

        .form-label {
            font-weight: bold;
            color: #555;
        }

        .form-control, .form-select {
            border-radius: 20px;
        }

        .form-control:focus, .form-select:focus {
            border-color: #28a745;
            box-shadow: 0 0 5px rgba(40, 167, 69, 0.4);
        }

        .btn-submit {
            background-color: #28a745;
            color: white;
            font-size: 1.2rem;
            border-radius: 20px;
            transition: all 0.3s ease;
            width: 100%;
        }

        .btn-submit:hover {
            background-color: #218838;
            box-shadow: 0 4px 10px rgba(33, 136, 56, 0.4);
        }

        .form-footer {
            text-align: center;
            margin-top: 20px;
            font-size: 0.9rem;
            color: #555;
        }
    </style>
</head>
<body>

   <%@include file="component/navbar.jsp"%>
   
   <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

   
    <div class="appointment-form">
        <h2>Book Your Appointment</h2>
        
        <form action="addAppointment" method="POST">
        
        <%
    User userObjFromSession = (User) session.getAttribute("userObj");
    int userId = userObjFromSession != null ? userObjFromSession.getId() : 0;
%>
<input type="hidden" name="UserId" value="<%= userId %>">
        
            <!-- Full Name -->
            <div class="mb-3">
                <label for="name" class="form-label">Full Name</label>
                <input type="text" class="form-control" id="fullname" name="fullname" placeholder="Enter your full name" required>
            </div>
            <!-- Gender -->
            <div class="mb-3">
                <label for="gender" class="form-label">Gender</label>
                <select class="form-select" id="gender" name="gender" required>
                    <option value="" selected disabled>Select Gender</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
            </div>
            <!-- Age -->
            <div class="mb-3">
                <label for="age" class="form-label">Age</label>
                <input type="number" class="form-control" id="age" name="age" placeholder="Enter your age" required>
            </div>
            <!-- Appointment Date -->
            <div class="mb-3">
                <label for="date" class="form-label">Appointment Date</label>
                <input type="date" class="form-control" id="appoinDate" name="appoinDate" required>
            </div>
            <!-- Email -->
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
            </div>
            <!-- Phone Number -->
            <div class="mb-3">
                <label for="phone" class="form-label">Phone Number</label>
                <input type="tel" class="form-control" id="phNo" name="phNo" placeholder="Enter your phone number" required>
            </div>
            <!-- Disease -->
            <div class="mb-3">
                <label for="disease" class="form-label">Disease</label>
                <input type="text" class="form-control" id="diseases" name="diseases" placeholder="Enter the disease/issue" required>
            </div>
            <!-- Doctor -->
            <div class="mb-3">
                <label for="doctor" class="form-label">Doctor</label>
                <select class="form-select" id="doct" name="doct" required>
                    <option value="" selected disabled>--Select Doctor--</option>
                        <%DoctorDao dao=new DoctorDao(DBConnect.getConn()); 
  List<Doctor> list=dao.getAllDoctors();

  for(Doctor d:list)
  {
  %>
    <option value="<%=d.getId()%>"><%=d.getFullName() %> (<%=d.getSpecialist() %>)</option>
    
<%
  }
%>

                </select>
            </div>
            <!-- Full Address -->
            <div class="mb-3">
                <label for="address" class="form-label">Full Address</label>
                <textarea class="form-control" id="address" name="address" rows="3" placeholder="Enter your full address" required></textarea>
            </div>
            <!-- Submit Button -->
            <button type="submit" class="btn btn-submit">Submit Appointment</button>
        </form>
        <div class="form-footer">
            <p><i class="fas fa-info-circle"></i> Please fill in all the fields carefully.</p>
        </div>
    </div>
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
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
    
