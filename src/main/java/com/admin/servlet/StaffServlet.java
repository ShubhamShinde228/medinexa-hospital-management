package com.admin.servlet;

import java.io.IOException;

import com.dao.StaffDao;
import com.db.DBConnect;
import com.entity.Staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/addStaff")
public class StaffServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        try {
            String fullName = req.getParameter("fullName");
            String dob = req.getParameter("dob");
            String qualification = req.getParameter("qualification");
            String specialist = req.getParameter("specialist");
            String mobNo = req.getParameter("mobNo");
            String email = req.getParameter("email");
            String password = req.getParameter("password");

            Staff staff = new Staff(fullName, dob, qualification, specialist, mobNo, email, password);
            StaffDao dao = new StaffDao(DBConnect.getConn());

            if (dao.registerStaff(staff)) {
                session.setAttribute("sucMsg", "Staff Member Added Successfully!");
                resp.sendRedirect("admin/staff.jsp");
            } else {
                session.setAttribute("errorMsg", "Failed to add staff. Check details or email may already be registered.");
                resp.sendRedirect("admin/staff.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Server error: " + e.getMessage());
            resp.sendRedirect("admin/staff.jsp");
        }
    }
}
