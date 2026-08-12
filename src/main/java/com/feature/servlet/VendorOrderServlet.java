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

@WebServlet("/vendorOrder")
public class VendorOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String vendorName = request.getParameter("vendorName");
            String medicineName = request.getParameter("medicineName");
            int units = Integer.parseInt(request.getParameter("unitsOrdered"));
            double cost = Double.parseDouble(request.getParameter("totalCost"));

            Connection conn = DBConnect.getConn();
            String sql = "INSERT INTO vendor_orders (vendor_name, medicine_name, units_ordered, total_cost, po_status) VALUES (?, ?, ?, ?, 'PO_DISPATCHED')";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, vendorName);
            ps.setString(2, medicineName);
            ps.setInt(3, units);
            ps.setDouble(4, cost);

            if (ps.executeUpdate() > 0) {
                // Broadcast PO dispatch alert
                try {
                    NotificationDao nDao = new NotificationDao(conn);
                    nDao.broadcast("ADMIN", "🚚 PURCHASE ORDER DISPATCHED: " + units + " units of " + medicineName + " to " + vendorName + " (Total: ₹" + cost + ")", "medical/vendor_orders.jsp");
                } catch (Exception ignored) {}

                request.getSession().setAttribute("sucMsg", "🚚 PURCHASE ORDER DISPATCHED! PO issued to " + vendorName + " for " + medicineName + " (" + units + " units).");
            } else {
                request.getSession().setAttribute("errorMsg", "Failed to dispatch Purchase Order.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "Server error: " + e.getMessage());
        }
        response.sendRedirect("medical/vendor_orders.jsp");
    }
}
