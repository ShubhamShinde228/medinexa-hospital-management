<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.User, com.entity.DoctorSlot, com.entity.Doctor" %>
<%@ page import="com.dao.DoctorDao, com.dao.DoctorSlotDao, com.dao.AppointmentDao" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("userObj");
    if (user == null) { response.sendRedirect("user_login.jsp"); return; }

    DoctorDao doctorDao = new DoctorDao(DBConnect.getConn());
    List<Doctor> doctors = doctorDao.getAllDoctors();

    String selectedDoctorIdStr = request.getParameter("doctorId");
    String selectedDate = request.getParameter("slotDate");
    int selectedDoctorId = 0;
    List<DoctorSlot> availableSlots = null;
    Doctor selectedDoctor = null;

    if (selectedDoctorIdStr != null && selectedDate != null && !selectedDoctorIdStr.isEmpty()) {
        selectedDoctorId = Integer.parseInt(selectedDoctorIdStr);
        DoctorSlotDao slotDao = new DoctorSlotDao(DBConnect.getConn());
        availableSlots = slotDao.getAvailableSlots(selectedDoctorId, selectedDate);
        selectedDoctor = doctorDao.getDoctorById(selectedDoctorId);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Appointment — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f9f4; }
        .hero-book { background: linear-gradient(135deg, #198754 0%, #0d5c38 100%); color: white; padding: 48px 0; }
        .step-card { background: white; border-radius: 20px; box-shadow: 0 8px 32px rgba(0,0,0,0.08); padding: 32px; }
        .slot-card { display: flex; align-items: center; gap: 12px; background: #f0fdf4; border: 2px solid #bbf7d0; border-radius: 12px; padding: 16px; margin: 8px 0; cursor: pointer; transition: all 0.25s; }
        .slot-card:hover, .slot-card.selected { background: #198754; border-color: #198754; color: white; }
        .slot-card input[type=radio] { display: none; }
        .slot-time-display { font-size: 20px; font-weight: 700; }
        .doctor-avatar { width: 56px; height: 56px; background: linear-gradient(135deg, #198754, #10b981); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 22px; flex-shrink: 0; }
        .step-indicator { display: flex; gap: 0; margin-bottom: 32px; }
        .step-item { flex: 1; text-align: center; padding: 12px; font-size: 13px; font-weight: 600; background: #e5e7eb; color: #6b7280; position: relative; }
        .step-item.active { background: #198754; color: white; }
        .step-item:not(:last-child)::after { content: ''; position: absolute; right: -12px; top: 0; border: 22px solid transparent; border-left-color: inherit; z-index: 1; }
        .no-slots-msg { text-align: center; padding: 40px; color: #6b7280; }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %>

<div class="hero-book">
    <div class="container text-center">
        <h1 class="fw-bold mb-2"><i class="fas fa-calendar-check me-3"></i>Book an Appointment</h1>
        <p class="opacity-75 mb-0">Choose your doctor, pick a date and select an available time slot</p>
    </div>
</div>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-9">

            <!-- Step 1: Choose Doctor & Date -->
            <div class="step-card mb-4">
                <h5 class="fw-bold mb-4"><span class="badge bg-success me-2">1</span> Select Doctor & Date</h5>
                <form method="get">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Doctor</label>
                            <select name="doctorId" class="form-select form-select-lg" required>
                                <option value="">— Choose a Doctor —</option>
                                <% for (Doctor d : doctors) { %>
                                <option value="<%=d.getId()%>" <%=d.getId()==selectedDoctorId?"selected":""%>>
                                    Dr. <%=d.getFullName()%> — <%=d.getSpecialist()%>
                                </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Appointment Date</label>
                            <input type="date" name="slotDate" class="form-control form-control-lg"
                                   value="<%=selectedDate!=null?selectedDate:""%>"
                                   min="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>" required>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-success btn-lg w-100">
                                <i class="fas fa-search"></i> Find
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <% if (availableSlots != null) { %>
            <!-- Step 2: Pick a Slot & Fill Details -->
            <form action="bookSlot" method="post">
                <input type="hidden" name="doctorId" value="<%=selectedDoctorId%>">
                <input type="hidden" name="appointDate" value="<%=selectedDate%>">
                <input type="hidden" name="email" value="<%=user.getEmail()%>">

                <!-- Doctor Info -->
                <% if (selectedDoctor != null) { %>
                <div class="step-card mb-4 d-flex align-items-center gap-4">
                    <div class="doctor-avatar"><i class="fas fa-user-md"></i></div>
                    <div>
                        <h5 class="fw-bold mb-1">Dr. <%=selectedDoctor.getFullName()%></h5>
                        <p class="text-muted mb-0"><%=selectedDoctor.getSpecialist()%> | <%=selectedDoctor.getQualification()%></p>
                        <small class="text-success"><i class="fas fa-calendar-day me-1"></i>Date: <%=selectedDate%></small>
                    </div>
                </div>
                <% } %>

                <div class="row g-4">
                    <!-- Slot Selection -->
                    <div class="col-md-5">
                        <div class="step-card h-100">
                            <h6 class="fw-bold mb-3"><span class="badge bg-success me-2">2</span> Pick a Time Slot</h6>
                            <% if (availableSlots.isEmpty()) { %>
                            <div class="no-slots-msg">
                                <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                <p>No available slots for this date.<br>
                                <small class="text-muted">Try a different date or contact the hospital.</small></p>
                            </div>
                            <% } else { %>
                                <% for (DoctorSlot slot : availableSlots) { %>
                                <label class="slot-card w-100" id="slotLabel<%=slot.getId()%>">
                                    <input type="radio" name="slotId" value="<%=slot.getId()%>" required
                                           onchange="document.querySelectorAll('.slot-card').forEach(c=>c.classList.remove('selected'));
                                                     document.getElementById('slotLabel<%=slot.getId()%>').classList.add('selected')">
                                    <i class="fas fa-clock fa-lg"></i>
                                    <span class="slot-time-display"><%=slot.getSlotTime()%></span>
                                    <span class="badge bg-success ms-auto">Available</span>
                                </label>
                                <% } %>
                            <% } %>
                        </div>
                    </div>

                    <!-- Patient Details -->
                    <div class="col-md-7">
                        <div class="step-card">
                            <h6 class="fw-bold mb-3"><span class="badge bg-success me-2">3</span> Patient Details</h6>
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label">Full Name</label>
                                    <input type="text" name="fullname" class="form-control" required
                                           value="<%=user.getFullName()%>">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Gender</label>
                                    <select name="gender" class="form-select" required>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Age</label>
                                    <input type="number" name="age" class="form-control" min="1" max="120" required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Phone Number</label>
                                    <input type="tel" name="phone" class="form-control" pattern="[0-9]{10,}" required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Symptoms / Disease</label>
                                    <input type="text" name="disease" class="form-control" required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Address</label>
                                    <textarea name="address" class="form-control" rows="2" required></textarea>
                                </div>
                                <div class="col-12">
                                    <% if (!availableSlots.isEmpty()) { %>
                                    <button type="submit" class="btn btn-success btn-lg w-100 mt-2">
                                        <i class="fas fa-check-circle me-2"></i>Confirm Appointment
                                    </button>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
            <% } %>

        </div>
    </div>
</div>

<%
String sucMsg = (String) session.getAttribute("sucMsg");
String errMsg = (String) session.getAttribute("errorMsg");
if (sucMsg != null) { session.removeAttribute("sucMsg"); %>
    <script>swal("Booked!", "<%=sucMsg%>", "success");</script>
<% } if (errMsg != null) { session.removeAttribute("errorMsg"); %>
    <script>swal("Error", "<%=errMsg%>", "error");</script>
<% } %>
</body>
</html>
