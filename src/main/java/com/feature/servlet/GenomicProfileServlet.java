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

@WebServlet("/genomicProfile")
public class GenomicProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("userObj") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user_login.jsp");
            return;
        }

        try {
            String markers = request.getParameter("geneticMarkers");
            String allergies = request.getParameter("severeAllergies");

            Connection conn = DBConnect.getConn();
            String sql = "INSERT INTO genomic_profile (user_id, patient_name, genetic_markers, severe_allergies) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, user.getId());
            ps.setString(2, user.getFullName());
            ps.setString(3, markers != null ? markers : "CYP2C9 Wildtype");
            ps.setString(4, allergies != null ? allergies : "None Reported");

            if (ps.executeUpdate() > 0) {
                session.setAttribute("sucMsg", "🧬 Pharmacogenomic & Allergen Risk Profile Saved Successfully!");
            } else {
                session.setAttribute("errorMsg", "Failed to save profile.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Server error: " + e.getMessage());
        }
        response.sendRedirect("genomic_profiler.jsp");
    }
}
