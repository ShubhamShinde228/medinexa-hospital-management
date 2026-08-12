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

@WebServlet("/bloodBank")
public class BloodBankServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        Connection conn = DBConnect.getConn();

        try {
            if ("updateStock".equals(action)) {
                String group = request.getParameter("bloodGroup");
                int units = Integer.parseInt(request.getParameter("units"));

                String sql = "UPDATE blood_bank SET units_available = ? WHERE blood_group = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, units);
                ps.setString(2, group);
                ps.executeUpdate();

                request.getSession().setAttribute("sucMsg", "Blood bank inventory updated for " + group + ": " + units + " units.");
            } else if ("requestBlood".equals(action)) {
                String group = request.getParameter("bloodGroup");
                int units = Integer.parseInt(request.getParameter("unitsNeeded"));
                String patientName = request.getParameter("patientName");

                // Broadcast emergency blood request to staff and admin
                try {
                    NotificationDao nDao = new NotificationDao(conn);
                    nDao.broadcast("STAFF", "🩸 URGENT BLOOD REQUEST: " + units + " unit(s) of " + group + " for Patient: " + patientName, "blood_bank.jsp");
                    nDao.broadcast("ADMIN", "🩸 URGENT BLOOD REQUEST: " + units + " unit(s) of " + group + " for Patient: " + patientName, "blood_bank.jsp");
                } catch (Exception ignored) {}

                request.getSession().setAttribute("sucMsg", "🚨 Emergency Blood Request for " + group + " (" + units + " units) broadcasted to Blood Bank & Staff!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "Server error: " + e.getMessage());
        }
        response.sendRedirect("blood_bank.jsp");
    }
}
