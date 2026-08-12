<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <%@ page import="com.entity.User" %>
  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Index Page</title>

<%@include file="component/allcss.jsp" %>
<style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;9000
      padding: 0;
      background-color: #f4f4f9;
    }
    

    .text-center {
      text-align: center;
      font-weight: bold;
      margin: 20px 0;
    }

    .container {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 20px;
      padding: 20px;
    }

    .card {
      background: #ffffff;
      border: 1px solid #ddd;
      border-radius: 8px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      width: 250px;
      padding: 20px;
      text-align: center;
      transition: transform 0.2s;
    }

    .card:hover {
      transform: scale(1.05);
    }

    .card img {
      display: block;
      margin: 0 auto 15px;
      width: 80px;
    }

    .card h3 {
      font-size: 1.2em;
      margin-bottom: 10px;
      color: #333;
    }

    .card p {
      font-size: 0.9em;
      color: #555;
    }
     body {
      font-family: 'Arial', sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f4f4f9;
      color: #333;
    }

    a {
      text-decoration: none;
      color: inherit;
    }

    ul {
      list-style: none;
      padding: 0;
      margin: 0;
    }
     /* Hero Section */
.hero {
    background: linear-gradient(to right, #4CAF50, #8BC34A);
    color: white;
    padding: 80px 20px;
    text-align: center;
    animation: fadeIn 2s ease-out;
}

.hero h2 {
    font-size: 40px;
    margin-bottom: 20px;
    animation: slideIn 1.5```css
s ease-in;
}

.hero p {
    font-size: 24px;
    margin-bottom: 30px;
}

.btn {
    background-color: #FFD700;
    padding: 10px 30px;
    border-radius: 5px;
    font-size: 18px;
    color: #333;
    transition: background-color 0.3s;
}

.btn:hover {
    background-color: #FF9800;
}
    /* Navbar Styles */
    .navbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 20px;
      background-color: #007bff;
      color: white;
    }

    .navbar .logo {
      font-size: 1.5rem;
      font-weight: bold;
    }

    .navbar ul {
      display: flex;
      gap: 20px;
    }

    .navbar ul li {
      font-size: 1rem;
    }

     
    /* Features Section */
    .features {
      padding: 40px 20px;
      text-align: center;
    }

    .features h2 {
      font-size: 2rem;
      margin-bottom: 20px;
    }

    .features .container {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 20px;
    }

    .features .card {
      background: white;
      border: 1px solid #ddd;
      border-radius: 8px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      width: 250px;
      padding: 20px;
      text-align: center;
      transition: transform 0.2s;
    }

    .features .card:hover {
      transform: scale(1.05);
    }

    .features .card img {
      display: block;
      margin: 0 auto 15px;
      width: 80px;
    }

    .features .card h3 {
      font-size: 1.2em;
      margin-bottom: 10px;
      color: #007bff;
    }

    /* Footer Styles */
    .footer {
      background-color: #333;
      color: white;
      padding: 20px;
      text-align: center;
    }

    .footer a {
      color: #00c6ff;
    }
     /* Footer Styles */
    .footer {
      background-color: #32a85a;
      color: white;
      padding: 20px;
      text-align: center;
    }

    .footer a {
      color: #00c6ff;
    }
     body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }

        .header {
            text-align: center;
            padding: 50px 20px;
            
            color: black;
        }

        .header h1 {
            margin: 0;
            font-size: 36px;
        }

        .team-container {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 20px;
            padding: 20px;
        }

        .team-card {
            background-color: white;
              border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 250px;
            padding: 20px;
        }

        .team-card img {
            border-radius: 50%;
            width: 120px;
            height: 120px;
            object-fit: cover;
            margin-bottom: 15px;
        }

        .team-card h3 {
            font-size: 20px;
            margin: 0;
             @keyframes slideIn {
            from {
                transform: translateX(-100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }
    
  </style>
	
</head>
<body>
   <%@include file="component/navbar.jsp" %>
   
    <section id="home" class="hero">
        <div class="hero-content">
            <h2>Welcome to HospitalCare</h2>
            <p>Your health, our priority.</p>
            <a href="#about" class="btn">Learn More</a>
        </div>
    </section> 
	
	<div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel">
  <div class="carousel-indicators">
    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="1" aria-label="Slide 2"></button>
    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="2" aria-label="Slide 3"></button>
    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="3" aria-label="Slide 3"></button>
    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="4" aria-label="Slide 3"></button>
    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="5" aria-label="Slide 3"></button>
    
  </div>
  <div class="carousel-inner">
    <div class="carousel-item active">
      <img src="img/hostfront1.jpg" class="d-block w-100" alt="..."height="500px">
    </div>
    <div class="carousel-item">
      <img src="img/host2.jpg" class="d-block w-100" alt="..."height="500px">
    </div>
    <div class="carousel-item">
      <img src="img/host3.jpg" class="d-block w-100" alt="..."height="500px">
    </div>
    <div class="carousel-item">
      <img src="img/host4.jpg" class="d-block w-100" alt="..."height="500px">
    </div>
    <div class="carousel-item">
      <img src="img/host5.jpg" class="d-block w-100" alt="..."height="500px">
    </div>
    <div class="carousel-item">
      <img src="img/host6.jpg" class="d-block w-100" alt="..."height="500px">
    </div>
  </div>
  <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    <span class="visually-hidden">Previous</span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
    <span class="carousel-control-next-icon" aria-hidden="true"></span>
    <span class="visually-hidden">Next</span>
  </button>
</div>

  <!-- Features Section -->
<div class="container my-5">
    <h2 class="text-center mb-4">Why Choose Us?</h2>
    <div class="row features">
        <div class="col-md-3">
            <div class="card text-center p-4">
                <i class="fa-solid fa-user-md fa-3x mb-3 text-success"></i>
                <h5 class="card-title">Expert Doctors</h5>
                <p class="card-text">Our team of highly qualified doctors ensures you get the best care.</p>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center p-4">
                <i class="fa-solid fa-stethoscope fa-3x mb-3 text-success"></i>
                <h5 class="card-title">Advanced Equipment</h5>
                <p class="card-text">We use the latest medical technology for accurate diagnostics and treatment.</p>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center p-4">
                <i class="fa-solid fa-hospital fa-3x mb-3 text-success"></i>
                <h5 class="card-title">Comprehensive Services</h5>
                <p class="card-text">From general check-ups to complex surgeries, we've got you covered.</p>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card text-center p-4">
                <i class="fa-solid fa-phone-volume fa-3x mb-3 text-success"></i>
                <h5 class="card-title">24/7 Emergency</h5>
                <p class="card-text">Our emergency services are available round the clock for any urgent medical needs.</p>
            </div>
        </div>
    </div>
</div>
      
      
     
    <!-- Font Awesome for Icons -->
   
  <div class="header">
        <h1>Meet Our Team</h1>
    </div>
    <div class="team-container">
        <%-- Card 1 --%>
        <div class="team-card">
            <img src="img/doctor1.jpg" alt="Team Member 1">
            <h3>John Doe</h3>
        </div>

        <%-- Card 2 --%>
        <div class="team-card">
            <img src="img/doctor2.jpg" alt="Team Member 2">
            <h3>Jane Smith</h3>
        </div>

        <%-- Card 3 --%>
        <div class="team-card">
            <img src="img/doctor3.jpg" alt="Team Member 3">
            <h3>Mark Taylor</h3>
        </div>

        <%-- Card 4 --%>
        <div class="team-card">
            <img src="img/doctor4.jpg" alt="Team Member 4">
            <h3>Emily Johnson</h3>
        </div>
    </div>
    
  <!-- Footer -->
  <footer class="footer">
    <p>&copy; 2024 Hospital Care. All rights reserved. | <a href="#">Privacy Policy</a></p>
  </footer>
     
	
</body>
</html>
