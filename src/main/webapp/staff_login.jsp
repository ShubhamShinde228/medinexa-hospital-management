<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ page import="com.entity.User" %>
   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Staff Login Page</title>

<%@include file="component/allcss.jsp" %>
<style type="text/css">
.paint-card{
           box-shadow: 0 0 10px 0 rgba(0, 0, 0, 0.3);
}
 
</style>

</head>
<body>

 <%@include file="component/navbar.jsp" %>
 
 <input type ="hidden" id="status" value=<%= request.getAttribute("status") %>>
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
 
 
 
 <div class="container p-5">
	<div class="row">
		<div class="col-md-4 offset-md-4">
			<div class="card paint-card">
				<div class="card-body">
					<p class="fs-4 text-center">Staff Login</p>
					
			<form action="staffLogin" method="post">
					
							<div class="mb-3">
        <label class="form-label">Email address</label> <input required name="email" type="email"class="form-control">
        </div>
        
        <div class="mb-3">
        <label class="form-label">Password</label> 
        <input required name="password"type="password"class="form-control">
        </div>
         <button type="submit" class="btn bg-success text-white col-md-12">Login</button>
         </form>
         
         </div>
         </div>
         </div>
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
</body>
</html>
