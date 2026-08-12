<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Login Page</title>

<%@include file="component/allcss.jsp" %>

 <link rel="stylesheet" href="component/style.css">


</head>
<body>

 <%@include file="component/navbar.jsp" %>
  
  
 
 <input type ="hidden" id="status" value=<%= request.getAttribute("status") %>>
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
 
 
 
  <div class="main">

		
		<section class="sign-in">
			<div class="container">
				<div class="signin-content">
					<div class="signin-image">
						<figure>
							<img src="img/signin-image.jpg" alt="sing up image">
						</figure>
						
						<a href="#" class="signup-image-link">Admin Registration Form</a>
					</div>
					
					
					
					<div class="signin-form">
						<h2 class="form-title">Admin Login</h2>
						<form method="Post" action="AdninLogin1" class="register-form"
							id="login-form">
							<div class="form-group">
								<label for="username"><i
									class="zmdi zmdi-account material-icons-name"></i></label> <input
									type="text" name="email" id="email"
									placeholder="Enter Your Email" />
							</div>
							<div class="form-group">
								<label for="password"><i class="zmdi zmdi-lock"></i></label> <input
									type="password" name="password" id="password"
									placeholder="Password" />
							</div>
							
							<div class="form-group form-button">
								<input type="submit" name="signin" id="signin"
									class="form-submit" value="Log in" />
							</div>
						</form>
						
					</div>
				</div>
			</div>
		</section>

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
