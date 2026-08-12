<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<%@ page import="jakarta.servlet.http.HttpSession" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<%@include file="component/allcss.jsp" %>

<!-- Main css -->
<link rel="stylesheet" href="component/style.css">
</head>
<body>
<%@include file="component/navbar.jsp" %>
         
         <div class="main">

		<!-- Sing in  Form -->
		<section class="sign-in">
			<div class="container">
				<div class="signin-content">
					<div class="signin-image">
						<figure>
							<img src="img/signin-image.jpg" alt="sing up image">
						</figure>
						<a href="sign_up.jsp" class="signup-image-link">Create an
							account</a> 
					</div>
					
					<br>
							
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
        session.removeAttribute("errorMsg"); // Clear the session attribute
    }
%>

					<div class="signin-form">
						<h2 class="form-title">Sign up</h2>
						<form method="Post" action="ForgotPasswordServlet" class="register-form"
							id="login-form">
							<div class="form-group">
								<label for="username"><i
									class="zmdi zmdi-account material-icons-name"></i></label> <input
									type="text" name="email" id="email"
									placeholder="Enter Your Email" />
							</div>
							
							
							<div class="form-group form-button">
								<input type="submit" name="signin" id="signin"
									class="form-submit" value="Log in" />
									<br>
							<br>
							<br>
							<br>
							<br>
							<br>
							<br>
							<br>
							<br>
							<br>
							<br>
							<a href="user_login.jsp" class="signup-image-link">I am Already Exist..</a>
							</div>
						</form>
						
					</div>
				</div>
			</div>
		</section>

	</div>

</body>
</html>
