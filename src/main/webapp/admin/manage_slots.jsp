<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.Doctor" %>
<%@ page import="com.dao.DoctorDao, com.dao.DoctorSlotDao" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="com.entity.DoctorSlot" %>
<%@ page import="java.util.List" %>
<%
    Object adminObj = session.getAttribute("adminObj");
    if (adminObj == null) { response.sendRedirect("../admin_login.jsp"); return; }

    DoctorDao doctorDao = new DoctorDao(DBConnect.getConn());
    List<Doctor> doctors = doctorDao.getAllDoctors();

    String selectedDoctorIdStr = request.getParameter("doctorId");
    int selectedDoctorId = 0;
    List<DoctorSlot> slots = null;
    if (selectedDoctorIdStr != null && !selectedDoctorIdStr.isEmpty()) {
        selectedDoctorId = Integer.parseInt(selectedDoctorIdStr);
        DoctorSlotDao slotDao = new DoctorSlotDao(DBConnect.getConn());
        slots = slotDao.getAllSlotsForDoctor(selectedDoctorId);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Doctor Slots — Admin</title>
    <%@include file="../component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f7f0; }
        .page-header { background: linear-gradient(135deg, #198754 0%, #0d5c38 100%); color: white; padding: 32px; border-radius: 16px; margin-bottom: 28px; }
        .card-slot { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; }
        .slot-badge { display: inline-block; padding: 6px 16px; border-radius: 20px; font-size: 13px; font-weight: 600; margin: 4px; }
        .slot-free { background: #d1fae5; color: #065f46; }
        .slot-taken { background: #fee2e2; color: #991b1b; }
        .time-chip { display: inline-flex; align-items: center; gap: 6px; background: #e8f5e9; color: #2e7d32; border-radius: 8px; padding: 4px 12px; margin: 3px; font-size: 13px; cursor: pointer; border: 2px solid transparent; transition: all 0.2s; }
        .time-chip input[type=checkbox] { display: none; }
        .time-chip:has(input:checked) { background: #2e7d32; color: white; border-color: #1b5e20; }
        .time-chip label { cursor: pointer; margin: 0; }
        .table-slots th { background: #198754; color: white; }
    </style>
</head>
<body>
<%@include file="navbar.jsp" %><br>

<div class="container mt-4">
    <div class="page-header">
        <h2><i class="fas fa-calendar-alt me-2"></i> Manage Doctor Appointment Slots</h2>
        <p class="mb-0 opacity-75">Add available time slots for each doctor so patients can book appointments.</p>
    </div>

    <%
    String sucMsg = (String) session.getAttribute("sucMsg");
    String errMsg = (String) session.getAttribute("errorMsg");
    if (sucMsg != null) { session.removeAttribute("sucMsg"); %>
        <script>swal("Success", "<%=sucMsg%>", "success");</script>
    <% } if (errMsg != null) { session.removeAttribute("errorMsg"); %>
        <script>swal("Error", "<%=errMsg%>", "error");</script>
    <% } %>

    <div class="row g-4">
        <!-- Add Slots Form -->
        <div class="col-md-5">
            <div class="card-slot">
                <h5 class="fw-bold mb-4"><i class="fas fa-plus-circle text-success me-2"></i>Add Slots</h5>
                <form action="../addDoctorSlot" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Select Doctor</label>
                        <select name="doctorId" class="form-select" required>
                            <option value="">— Choose Doctor —</option>
                            <% for (Doctor d : doctors) { %>
                            <option value="<%=d.getId()%>" <%=d.getId()==selectedDoctorId?"selected":""%>>
                                Dr. <%=d.getFullName()%> (<%=d.getSpecialist()%>)
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Date</label>
                        <input type="date" name="slotDate" class="form-control" required
                               min="<%=new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>">
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Select Time Slots</label>
                        <div class="d-flex flex-wrap gap-2">
                            <% String[] times = {"09:00","09:30","10:00","10:30","11:00","11:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00"};
                               for (String t : times) { 
                                   String idStr = "t" + t.replace(":", "");
                            %>
                            <div class="form-check form-check-inline bg-light border rounded px-3 py-2">
                                <input class="form-check-input" type="checkbox" name="slotTime" value="<%=t%>" id="<%=idStr%>">
                                <label class="form-check-label fw-semibold" for="<%=idStr%>">⏰ <%=t%></label>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-success w-100">
                        <i class="fas fa-save me-2"></i>Add Selected Slots
                    </button>
                </form>
            </div>
        </div>

        <!-- View Existing Slots -->
        <div class="col-md-7">
            <div class="card-slot">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold mb-0"><i class="fas fa-list-alt text-success me-2"></i>Existing Slots</h5>
                    <form method="get" class="d-flex gap-2">
                        <select name="doctorId" class="form-select form-select-sm" style="width:200px">
                            <option value="">— Filter by Doctor —</option>
                            <% for (Doctor d : doctors) { %>
                            <option value="<%=d.getId()%>" <%=d.getId()==selectedDoctorId?"selected":""%>>
                                Dr. <%=d.getFullName()%>
                            </option>
                            <% } %>
                        </select>
                        <button type="submit" class="btn btn-sm btn-outline-success">View</button>
                    </form>
                </div>
                <% if (slots == null) { %>
                    <div class="text-center text-muted py-5">
                        <i class="fas fa-calendar-alt fa-3x mb-3 opacity-50"></i>
                        <p>Select a doctor above to view their slots.</p>
                    </div>
                <% } else if (slots.isEmpty()) { %>
                    <div class="alert alert-info">No slots found for this doctor.</div>
                <% } else { %>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-slots">
                            <tr><th>Date</th><th>Time</th><th>Status</th><th>Action</th></tr>
                        </thead>
                        <tbody>
                            <% for (DoctorSlot s : slots) { %>
                            <tr>
                                <td><i class="fas fa-calendar-day text-success me-1"></i><%=s.getSlotDate()%></td>
                                <td><i class="fas fa-clock text-primary me-1"></i><%=s.getSlotTime()%></td>
                                <td>
                                    <% if (s.isBooked()) { %>
                                        <span class="slot-badge slot-taken">🔴 Booked</span>
                                    <% } else { %>
                                        <span class="slot-badge slot-free">🟢 Available</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (!s.isBooked()) { %>
                                    <form action="../deleteDoctorSlot" method="post" style="display:inline"
                                          onsubmit="return confirm('Delete this slot?')">
                                        <input type="hidden" name="slotId" value="<%=s.getId()%>">
                                        <input type="hidden" name="redirect" value="/admin/manage_slots.jsp?doctorId=<%=selectedDoctorId%>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                    <% } else { %>
                                    <span class="text-muted small">Locked</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>
<br>
</body>
</html>
