package com.feature.servlet;

import com.dao.NotificationDao;
import com.db.DBConnect;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Random;

@WebServlet("/ambulanceDispatch")
public class AmbulanceServlet extends HttpServlet {

    private static final String[] AMBULANCE_UNITS = {
        "ALS-Unit 01 (Advanced Life Support)",
        "BLS-Unit 04 (Basic Life Support)",
        "ICU-Unit 02 (Mobile ICU)",
        "Cardiac-Unit 05 (Emergency Cardiac)"
    };

    private static final String[] DRIVERS = {
        "Paramedic Suresh Kumar (9876543210)",
        "Paramedic Vikram Singh (9876543211)",
        "Paramedic Rahul Sharma (9876543212)"
    };

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String name     = request.getParameter("callerName");
            String phone    = request.getParameter("callerPhone");
            String location = request.getParameter("pickupLocation");

            if (name == null || name.isBlank() || phone == null || phone.isBlank() || location == null || location.isBlank()) {
                request.getSession().setAttribute("errorMsg", "Please fill in all emergency pickup details.");
                response.sendRedirect("emergency_dispatch.jsp");
                return;
            }

            Random rand = new Random();
            String unit   = AMBULANCE_UNITS[rand.nextInt(AMBULANCE_UNITS.length)];
            String driver = DRIVERS[rand.nextInt(DRIVERS.length)];
            int etaMins   = 8 + rand.nextInt(10); // 8-18 minutes random ETA

            Connection conn = DBConnect.getConn();
            String sql = "INSERT INTO ambulance_dispatch (caller_name, caller_phone, pickup_location, ambulance_unit, driver_name, status, eta_minutes) VALUES (?, ?, ?, ?, ?, 'DISPATCHED', ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, location);
            ps.setString(4, unit);
            ps.setString(5, driver);
            ps.setInt(6, etaMins);

            if (ps.executeUpdate() > 0) {
                // Broadcast emergency notification to staff and admin
                try {
                    NotificationDao nDao = new NotificationDao(conn);
                    nDao.broadcast("STAFF", "🚨 EMERGENCY SOS: Ambulance Dispatched to " + location + " (Caller: " + name + ")", "staff/index.jsp");
                    nDao.broadcast("ADMIN", "🚨 EMERGENCY SOS: Ambulance Dispatched to " + location, "admin/patient.jsp");
                } catch (Exception ignored) {}

                request.getSession().setAttribute("sucMsg", "🚨 EMERGENCY AMBULANCE DISPATCHED! Unit: " + unit + " | Driver: " + driver + " | Estimated Arrival: " + etaMins + " mins.");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to dispatch ambulance. Please call emergency line directly.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "Server error: " + e.getMessage());
        }
        response.sendRedirect("emergency_dispatch.jsp");
    }
}
