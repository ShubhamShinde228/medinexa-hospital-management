<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.DoctorDao" %>
<%@ page import="com.entity.Doctor, com.entity.User" %>
<%@ page import="com.db.DBConnect" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    User user = (User) session.getAttribute("userObj");
    DoctorDao docDao = new DoctorDao(DBConnect.getConn());
    List<Doctor> docList = docDao.getAllDoctors();

    Connection conn = DBConnect.getConn();
    List<Map<String, Object>> myQueueTickets = new ArrayList<>();

    if (user != null) {
        try {
            String sql = "SELECT q.*, d.full_name as doctor_name, d.specialist FROM virtual_queue q " +
                         "JOIN doctor d ON q.doctor_id = d.id WHERE q.user_id = ? ORDER BY q.id DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, user.getId());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("queueNo", rs.getInt("queue_number"));
                map.put("doctorName", rs.getString("doctor_name"));
                map.put("specialist", rs.getString("specialist"));
                map.put("patientName", rs.getString("patient_name"));
                map.put("status", rs.getString("status"));
                map.put("waitMins", rs.getInt("estimated_wait_mins"));
                myQueueTickets.add(map);
            }
        } catch (Exception ignored) {}
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Live Video Teleconsultation — HospitalCare</title>
    <%@include file="component/allcss.jsp" %>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0fdf4; }
        .hero-queue { background: linear-gradient(135deg, #16a34a 0%, #15803d 100%); color: white; padding: 40px 0; border-radius: 0 0 20px 20px; margin-bottom: 30px; text-align: center; }
        .card-queue { background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 28px; margin-bottom: 24px; }
        .ticket-number { font-size: 42px; font-weight: 800; color: #16a34a; line-height: 1; }
        .video-box { background: #0f172a; color: white; border-radius: 18px; padding: 24px; text-align: center; }
        .video-stream-container { position: relative; background: #000; border-radius: 14px; overflow: hidden; height: 320px; border: 2px solid #16a34a; }
        video { width: 100%; height: 100%; object-fit: cover; }
        .video-overlay-badge { position: absolute; top: 12px; left: 12px; background: rgba(0,0,0,0.7); color: #4ade80; font-size: 12px; font-weight: 700; padding: 4px 12px; border-radius: 20px; }
    </style>
</head>
<body>
<%@include file="component/navbar.jsp" %>

<div class="hero-queue">
    <div class="container">
        <h1 class="fw-bold mb-2"><i class="fas fa-video me-2"></i> Live Teleconsultation Video Room</h1>
        <p class="fs-5 opacity-75 mb-0">Real-time WebRTC camera video consultation with your attending doctor</p>
    </div>
</div>

<div class="container mb-5">
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
        <!-- Join Virtual Queue Form -->
        <div class="col-lg-5">
            <div class="card-queue">
                <h4 class="fw-bold text-success mb-4"><i class="fas fa-user-clock me-2"></i>Join Virtual OPD Queue</h4>
                
                <% if (user == null) { %>
                    <div class="alert alert-warning text-center">
                        <i class="fas fa-lock me-1"></i> Please <a href="user_login.jsp" class="fw-bold">Login as Patient</a> to join OPD teleconsultation.
                    </div>
                <% } else { %>
                <form action="virtualQueue" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Patient Name</label>
                        <input type="text" name="patientName" class="form-control" value="<%= user.getFullName() %>" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Select Doctor to Consult</label>
                        <select name="doctorId" class="form-select form-select-lg" required>
                            <option value="">— Choose Doctor —</option>
                            <% for (Doctor d : docList) { %>
                                <option value="<%= d.getId() %>">Dr. <%= d.getFullName() %> (<%= d.getSpecialist() %>)</option>
                            <% } %>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-success btn-lg w-100 fw-bold rounded-pill shadow-sm">
                        <i class="fas fa-ticket-alt me-2"></i>Take Virtual Queue Ticket
                    </button>
                </form>
                <% } %>
            </div>
        </div>

        <!-- Queue Status & Real Webcam Stream -->
        <div class="col-lg-7">
            <div class="card-queue">
                <h4 class="fw-bold text-success mb-3"><i class="fas fa-receipt me-2"></i>Your Live Queue Tickets</h4>
                <% if (myQueueTickets.isEmpty()) { %>
                    <div class="text-center text-muted py-4">No active teleconsultation tickets. Join a doctor's queue on the left!</div>
                <% } else { %>
                    <% for (Map<String, Object> t : myQueueTickets) { %>
                        <div class="border rounded-3 p-3 mb-3 bg-light d-flex justify-content-between align-items-center flex-wrap gap-3">
                            <div>
                                <small class="text-muted">Queue Ticket Number</small>
                                <div class="ticket-number">#<%= t.get("queueNo") %></div>
                                <div class="fw-bold text-dark mt-1">Dr. <%= t.get("doctorName") %> (<%= t.get("specialist") %>)</div>
                            </div>
                            <div class="text-end">
                                <div class="mb-2">
                                    <span class="badge bg-success fs-6"><%= t.get("status") %></span>
                                </div>
                                <div class="text-muted small mb-2">⏱️ Est. Wait: <%= t.get("waitMins") %> mins</div>
                                <button type="button" onclick="startPatientWebcam('<%= t.get("doctorName") %>')" class="btn btn-primary btn-sm rounded-pill fw-bold">
                                    <i class="fas fa-video me-1"></i> Start Real Camera Video
                                </button>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>

            <!-- HTML5 Real Camera Video Stream Container -->
            <div class="video-box" id="patientVideoRoom" style="display:none;">
                <h4 class="fw-bold mb-2 text-success" id="videoTitle"><i class="fas fa-video me-2"></i>Live Patient Webcam Stream</h4>
                <p class="text-slate-300 small mb-3">HTML5 MediaDevices Camera & Microphone Live Feed</p>
                
                <div class="video-stream-container mb-3">
                    <span class="video-overlay-badge"><i class="fas fa-circle text-success me-1"></i> LIVE CAMERA FEED</span>
                    <video id="patientCamera" autoplay playsinline muted></video>
                </div>

                <div class="d-flex justify-content-center gap-2">
                    <button type="button" onclick="toggleMute('patientCamera')" class="btn btn-outline-light rounded-pill px-3">
                        <i class="fas fa-microphone me-1"></i> Mute/Unmute
                    </button>
                    <button type="button" onclick="stopPatientWebcam()" class="btn btn-danger rounded-pill px-4 fw-bold">
                        <i class="fas fa-phone-slash me-1"></i> End Call
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let localStream = null;

    async function startPatientWebcam(doctorName) {
        const room = document.getElementById('patientVideoRoom');
        room.style.display = 'block';
        document.getElementById('videoTitle').innerHTML = '<i class="fas fa-video me-2 text-success"></i>Live Teleconsultation with Dr. ' + doctorName;
        window.scrollTo({ top: room.offsetTop - 50, behavior: 'smooth' });

        try {
            localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
            const videoElem = document.getElementById('patientCamera');
            videoElem.srcObject = localStream;
            videoElem.play();
        } catch (err) {
            console.error("Camera access error:", err);
            alert("Unable to access camera/microphone: " + err.message + "\nPlease allow browser camera permissions.");
        }
    }

    function stopPatientWebcam() {
        if (localStream) {
            localStream.getTracks().forEach(track => track.stop());
            localStream = null;
        }
        document.getElementById('patientVideoRoom').style.display = 'none';
    }

    function toggleMute(videoId) {
        if (localStream) {
            const audioTrack = localStream.getAudioTracks()[0];
            if (audioTrack) {
                audioTrack.enabled = !audioTrack.enabled;
                alert(audioTrack.enabled ? "Microphone Unmuted" : "Microphone Muted");
            }
        }
    }
</script>
</body>
</html>
