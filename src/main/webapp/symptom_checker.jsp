<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.entity.Doctor" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Smart Symptom Checker — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f4f7f6; }
        .hero-banner { background: linear-gradient(135deg, #198754 0%, #0a4729 100%); color: white; padding: 40px 20px; border-radius: 16px; margin-bottom: 30px; text-align: center; }
        .card-symptom { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 30px; margin-bottom: 30px; }
        .symptom-chip { display: inline-flex; align-items: center; gap: 8px; background: #e8f5e9; color: #1b5e20; border: 2px solid #a5d6a7; border-radius: 25px; padding: 8px 18px; margin: 6px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .symptom-chip:hover { background: #c8e6c9; transform: translateY(-2px); }
        .symptom-chip input[type=checkbox] { accent-color: #198754; width: 18px; height: 18px; cursor: pointer; }
        .doc-card { border: 1px solid #e0e0e0; border-radius: 12px; transition: all 0.3s; background: white; }
        .doc-card:hover { transform: translateY(-5px); box-shadow: 0 8px 25px rgba(25, 135, 84, 0.15); border-color: #198754; }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %><br>

<div class="container mt-4">
    <div class="hero-banner">
        <h1 class="fw-bold mb-2"><i class="fas fa-user-md-chat me-2"></i> Smart Symptom Checker</h1>
        <p class="fs-5 opacity-75 mb-0">Select your current symptoms to get instant specialist recommendations & book doctors.</p>
    </div>

    <div class="card-symptom">
        <h4 class="fw-bold text-success mb-3"><i class="fas fa-list-check me-2"></i> Select What You Are Experiencing:</h4>
        
        <form action="symptomChecker" method="post">
            <div class="d-flex flex-wrap mb-4">
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="chest_pain"> ❤️ Chest Pain / Pressure</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="shortness_of_breath"> 🫁 Shortness of Breath</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="high_bp"> 🩸 High Blood Pressure</label>

                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="fever"> 🌡️ Fever / Chills</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="cough"> 😷 Cough / Sore Throat</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="fatigue"> 😴 Constant Fatigue</label>

                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="headache"> 🧠 Severe Headache</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="dizziness"> 🌀 Dizziness / Fainting</label>

                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="joint_pain"> 🦴 Joint / Back Pain</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="bone_fracture"> 🩹 Suspected Fracture</label>

                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="skin_rash"> 🧴 Skin Rash / Allergy</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="acne"> ✨ Severe Acne</label>

                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="stomach_pain"> 🤢 Severe Stomach Pain</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="acid_reflux"> 🔥 Acid Reflux / Indigestion</label>

                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="eye_redness"> 👁️ Eye Redness / Pain</label>
                <label class="symptom-chip"><input type="checkbox" name="symptoms" value="toothache"> 🦷 Severe Toothache</label>
            </div>

            <div class="text-center">
                <button type="submit" class="btn btn-success btn-lg px-5 rounded-pill shadow">
                    <i class="fas fa-stethoscope me-2"></i> Get Doctor Recommendations
                </button>
            </div>
        </form>
    </div>

    <%
        Set<String> recSpecs = (Set<String>) request.getAttribute("recommendedSpecialties");
        List<Doctor> recDocs = (List<Doctor>) request.getAttribute("recommendedDoctors");
        if (recSpecs != null) {
    %>
    <div class="card-symptom">
        <h4 class="fw-bold text-success mb-3"><i class="fas fa-star me-2"></i> Recommended Specialties:</h4>
        <div class="mb-4">
            <% for (String spec : recSpecs) { %>
                <span class="badge bg-success fs-6 p-2 me-2 mb-2"><i class="fas fa-stethoscope me-1"></i> <%= spec %></span>
            <% } %>
        </div>

        <h4 class="fw-bold text-success mb-3"><i class="fas fa-user-md me-2"></i> Recommended Doctors:</h4>
        <% if (recDocs != null && !recDocs.isEmpty()) { %>
            <div class="row g-4">
                <% for (Doctor doc : recDocs) { %>
                <div class="col-md-4">
                    <div class="card doc-card p-3 text-center">
                        <div class="card-body">
                            <i class="fas fa-user-md fa-3x text-success mb-3"></i>
                            <h5 class="fw-bold mb-1"><%= doc.getFullName() %></h5>
                            <p class="text-muted mb-2"><span class="badge bg-success-subtle text-success border border-success"><%= doc.getSpecialist() %></span></p>
                            <p class="small text-muted mb-3"><i class="fas fa-graduation-cap me-1"></i> <%= doc.getQualification() %></p>
                            <a href="slot_booking.jsp" class="btn btn-outline-success rounded-pill w-100 fw-bold">
                                <i class="fas fa-calendar-check me-1"></i> Book Appointment
                            </a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="alert alert-info text-center">
                <i class="fas fa-info-circle me-2"></i> No specific doctor found registered under this specialty yet. You can book an appointment with our General Physicians.
                <br><br>
                <a href="slot_booking.jsp" class="btn btn-success rounded-pill px-4">Book General Appointment</a>
            </div>
        <% } %>
    </div>
    <% } %>
</div>
<br>
</body>
</html>
