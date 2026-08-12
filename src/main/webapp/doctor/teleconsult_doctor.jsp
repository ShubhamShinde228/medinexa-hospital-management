<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.Doctor" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    Object doctObj = session.getAttribute("doctObj");
    if (doctObj == null) doctObj = session.getAttribute("doctorObj");
    if (doctObj == null) {
        response.sendRedirect("../doctor_login.jsp");
        return;
    }

    Doctor doctor = (Doctor) doctObj;
    Connection conn = DBConnect.getConn();

    List<Map<String, Object>> pendingCalls = new ArrayList<>();
    try {
        String sql = "SELECT * FROM virtual_queue WHERE doctor_id=? ORDER BY id DESC";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, doctor.getId());
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", rs.getInt("id"));
            map.put("queueNo", rs.getInt("queue_number"));
            map.put("patientName", rs.getString("patient_name"));
            map.put("status", rs.getString("status"));
            map.put("createdAt", rs.getString("created_at"));
            pendingCalls.add(map);
        }
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor Teleconsultation Call Reception — HospitalCare</title>
    <%@include file="../component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0fdf4; }
        .page-header { background: linear-gradient(135deg, #0369a1 0%, #0284c7 100%); color: white; padding: 32px; border-radius: 16px; margin-bottom: 28px; }
        .card-custom { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
        .video-box { background: #0f172a; color: white; border-radius: 18px; padding: 24px; text-align: center; }
        .video-stream-container { position: relative; background: #000; border-radius: 14px; overflow: hidden; height: 320px; border: 2px solid #0284c7; }
        video { width: 100%; height: 100%; object-fit: cover; }
        .video-overlay-badge { position: absolute; top: 12px; left: 12px; background: rgba(0,0,0,0.7); color: #38bdf8; font-size: 12px; font-weight: 700; padding: 4px 12px; border-radius: 20px; }
        .call-ring { animation: pulseRing 1.5s infinite; }
        @keyframes pulseRing { 0% { box-shadow: 0 0 0 0 rgba(14, 165, 233, 0.7); } 70% { box-shadow: 0 0 0 12px rgba(14, 165, 233, 0); } 100% { box-shadow: 0 0 0 0 rgba(14, 165, 233, 0); } }
    </style>
</head>
<body>
<%@include file="navbar.jsp" %><br>

<div class="container mt-4 mb-5">
    <!-- Header -->
    <div class="page-header d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
            <h2 class="fw-bold mb-1"><i class="fas fa-headset me-2 text-warning"></i>Doctor Teleconsult Reception</h2>
            <p class="opacity-75 mb-0">Accept incoming patient video calls & manage online OPD camera feed</p>
        </div>
        <span class="badge bg-success fs-6 p-3 shadow-sm rounded-pill">
            🟢 Online & Available for Calls
        </span>
    </div>

    <%
        String sucMsg = (String) session.getAttribute("sucMsg");
        String errMsg = (String) session.getAttribute("errorMsg");
        if (sucMsg != null) { session.removeAttribute("sucMsg"); %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i> <%= sucMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } if (errMsg != null) { session.removeAttribute("errorMsg"); %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> <%= errMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

    <div class="row g-4">
        <!-- List of Patient Call Requests -->
        <div class="col-lg-5">
            <div class="card-custom">
                <h4 class="fw-bold text-primary mb-4"><i class="fas fa-phone-alt me-2"></i>Incoming Patient Call Queue</h4>
                
                <% if (pendingCalls.isEmpty()) { %>
                    <div class="text-center text-muted py-5">
                        <i class="fas fa-phone-slash fa-3x mb-3 opacity-50"></i>
                        <p class="mb-0">No active patient video call requests in queue.</p>
                    </div>
                <% } else { %>
                    <% for (Map<String, Object> c : pendingCalls) { 
                           String status = (String) c.get("status");
                           boolean isWaiting = "WAITING".equals(status);
                           boolean isInCall  = "IN_CONSULTATION".equals(status);
                    %>
                    <div class="border rounded-3 p-3 mb-3 bg-light d-flex justify-content-between align-items-center flex-wrap gap-2">
                        <div>
                            <span class="badge bg-primary me-2">Ticket #<%= c.get("queueNo") %></span>
                            <strong class="fs-5"><%= c.get("patientName") %></strong><br>
                            <small class="text-muted"><i class="fas fa-clock me-1"></i><%= c.get("createdAt") != null ? c.get("createdAt").toString().substring(0, 16) : "" %></small>
                        </div>
                        <div class="d-flex gap-2 align-items-center">
                            <% if (isWaiting) { %>
                                <button type="button" onclick="startDoctorWebcam(<%= c.get("id") %>, '<%= c.get("patientName") %>')"
                                        class="btn btn-success rounded-pill fw-bold call-ring">
                                    <i class="fas fa-video me-1"></i> Accept Video Call
                                </button>
                            <% } else if (isInCall) { %>
                                <span class="badge bg-warning text-dark p-2 me-2">In Call 🟢</span>
                                <form action="../virtualQueue" method="post" style="display:inline">
                                    <input type="hidden" name="action" value="endCall">
                                    <input type="hidden" name="ticketId" value="<%= c.get("id") %>">
                                    <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill fw-bold">End Call</button>
                                </form>
                            <% } else { %>
                                <span class="badge bg-secondary p-2">Completed</span>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                <% } %>
            </div>
        </div>

        <!-- Real HTML5 Doctor Camera Video Stream Container -->
        <div class="col-lg-7">
            <div class="video-box" id="doctorVideoRoom" style="display:none;">
                <h4 class="fw-bold mb-2 text-info" id="docCallTitle"><i class="fas fa-video me-2"></i>Live Doctor Teleconsultation Feed</h4>
                <p class="text-slate-300 small mb-3">HTML5 MediaDevices Camera & Microphone Live Video Feed</p>
                
                <div class="video-stream-container mb-3">
                    <span class="video-overlay-badge"><i class="fas fa-circle text-success me-1"></i> DOCTOR LIVE CAMERA</span>
                    <video id="doctorCamera" autoplay playsinline muted></video>
                </div>

                <div class="d-flex justify-content-center gap-3">
                    <form action="../virtualQueue" method="post" id="acceptForm">
                        <input type="hidden" name="action" value="acceptCall">
                        <input type="hidden" name="ticketId" id="acceptTicketId">
                        <button type="submit" class="btn btn-success rounded-pill px-4 fw-bold">
                            <i class="fas fa-check me-1"></i> Confirm Consultation
                        </button>
                    </form>
                    <button type="button" onclick="stopDoctorWebcam()" class="btn btn-danger rounded-pill px-4 fw-bold">
                        <i class="fas fa-phone-slash me-1"></i> Close Camera
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let doctorStream = null;

    async function startDoctorWebcam(ticketId, patientName) {
        const room = document.getElementById('doctorVideoRoom');
        room.style.display = 'block';
        document.getElementById('docCallTitle').innerHTML = '<i class="fas fa-video me-2 text-success"></i>Live Call with Patient: ' + patientName;
        document.getElementById('acceptTicketId').value = ticketId;

        try {
            doctorStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
            const videoElem = document.getElementById('doctorCamera');
            videoElem.srcObject = doctorStream;
            videoElem.play();
        } catch (err) {
            console.error("Doctor camera access error:", err);
            alert("Unable to access doctor webcam/microphone: " + err.message + "\nPlease allow camera permissions in your browser.");
        }
    }

    function stopDoctorWebcam() {
        if (doctorStream) {
            doctorStream.getTracks().forEach(track => track.stop());
            doctorStream = null;
        }
        document.getElementById('doctorVideoRoom').style.display = 'none';
    }
</script>
</body>
</html>
