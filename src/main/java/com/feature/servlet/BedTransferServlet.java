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

@WebServlet("/bedTransfer")
public class BedTransferServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int admissionId = Integer.parseInt(request.getParameter("admissionId"));
            String patientName = request.getParameter("patientName");
            String currentWard = request.getParameter("currentWard");
            String targetWard = request.getParameter("targetWard");
            String reason = request.getParameter("reason");

            Connection conn = DBConnect.getConn();
            String sql = "INSERT INTO bed_transfers (admission_id, patient_name, current_ward, target_ward, transfer_reason, status) VALUES (?, ?, ?, ?, ?, 'ICU_BED_RESERVED')";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, admissionId);
            ps.setString(2, patientName);
            ps.setString(3, currentWard != null ? currentWard : "General Ward");
            ps.setString(4, targetWard != null ? targetWard : "ICU - Critical Care Unit");
            ps.setString(5, reason);

            if (ps.executeUpdate() > 0) {
                // Broadcast emergency ICU transfer alert
                try {
                    NotificationDao nDao = new NotificationDao(conn);
                    nDao.broadcast("STAFF", "🚨 ICU BED RESERVED: Transferring " + patientName + " to " + targetWard + " (Reason: " + reason + ")", "smart_bed_transfer.jsp");
                    nDao.broadcast("ADMIN", "🚨 ICU BED RESERVED: Transferring " + patientName, "smart_bed_transfer.jsp");
                } catch (Exception ignored) {}

                request.getSession().setAttribute("sucMsg", "🚨 EMERGENCY ICU BED AUTO-RESERVED! Transfer request dispatched for " + patientName);
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to process bed transfer.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "Server error: " + e.getMessage());
        }
        response.sendRedirect("smart_bed_transfer.jsp");
    }
}
