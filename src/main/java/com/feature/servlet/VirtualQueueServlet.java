package com.feature.servlet;

import com.db.DBConnect;
import com.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/virtualQueue")
public class VirtualQueueServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        Connection conn = DBConnect.getConn();

        // Doctor actions: accept or end call
        if ("acceptCall".equals(action) || "endCall".equals(action)) {
            try {
                int ticketId = Integer.parseInt(request.getParameter("ticketId"));
                String newStatus = "acceptCall".equals(action) ? "IN_CONSULTATION" : "COMPLETED";

                String sql = "UPDATE virtual_queue SET status=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, newStatus);
                ps.setInt(2, ticketId);
                ps.executeUpdate();

                request.getSession().setAttribute("sucMsg", "Call status updated: " + newStatus);
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("errorMsg", "Error updating call status: " + e.getMessage());
            }
            response.sendRedirect("doctor/teleconsult_doctor.jsp");
            return;
        }

        // Patient action: Join queue
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("userObj") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user_login.jsp");
            return;
        }

        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String patientName = request.getParameter("patientName");
            if (patientName == null || patientName.isBlank()) patientName = user.getFullName();

            // Find current highest queue number for doctor
            int nextQueueNo = 1;
            PreparedStatement psCount = conn.prepareStatement("SELECT COUNT(*) FROM virtual_queue WHERE doctor_id=? AND DATE(created_at)=CURRENT_DATE");
            psCount.setInt(1, doctorId);
            ResultSet rs = psCount.executeQuery();
            if (rs.next()) {
                nextQueueNo = rs.getInt(1) + 1;
            }

            int estimatedWaitMins = (nextQueueNo - 1) * 10;

            String sql = "INSERT INTO virtual_queue (doctor_id, user_id, patient_name, queue_number, status, estimated_wait_mins) VALUES (?, ?, ?, ?, 'WAITING', ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ps.setInt(2, user.getId());
            ps.setString(3, patientName);
            ps.setInt(4, nextQueueNo);
            ps.setInt(5, estimatedWaitMins);

            if (ps.executeUpdate() > 0) {
                session.setAttribute("sucMsg", "Joined Teleconsultation Queue! Your Queue Ticket: #" + nextQueueNo + " (Est. Wait: " + estimatedWaitMins + " mins).");
            } else {
                session.setAttribute("errorMsg", "Could not join queue. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Server error: " + e.getMessage());
        }
        response.sendRedirect("teleconsult.jsp");
    }
}
