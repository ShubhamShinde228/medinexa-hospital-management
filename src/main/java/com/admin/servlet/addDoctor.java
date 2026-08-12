package com.admin.servlet;

import java.io.IOException;
import java.util.regex.Pattern;

import com.dao.DoctorDao;
import com.db.DBConnect;
import com.entity.Doctor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/addDoctor")
public class addDoctor extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        try {
            // Fetch form data
            String fullName = req.getParameter("fullName");
            String dob = req.getParameter("dob");
            String qualification = req.getParameter("qualification");
            String specialist = req.getParameter("specialist");
            String mobNo = req.getParameter("mobNo");
            String email = req.getParameter("email");
            String password = req.getParameter("password");

            // Validation
            if (fullName == null || fullName.trim().isEmpty()) {
                session.setAttribute("errorMsg", "Full Name is required.");
                resp.sendRedirect("admin/doctor.jsp");
                return;
            }

            if (dob == null || dob.trim().isEmpty()) {
                session.setAttribute("errorMsg", "Date of Birth is required.");
                resp.sendRedirect("admin/doctor.jsp");
                return;
            }

            if (qualification == null || qualification.trim().isEmpty()) {
                session.setAttribute("errorMsg", "Qualification is required.");
                resp.sendRedirect("admin/doctor.jsp");
                return;
            }

            if (specialist == null || specialist.trim().isEmpty()) {
                session.setAttribute("errorMsg", "Specialization is required.");
                resp.sendRedirect("admin/doctor.jsp");
                return;
            }

            if (mobNo == null || !Pattern.matches("\\d{10}", mobNo)) {
                session.setAttribute("errorMsg", "Invalid Mobile Number. It must be 10 digits.");
                resp.sendRedirect("admin/doctor.jsp");
                return;
            }

            if (email == null || !Pattern.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$", email)) {
                session.setAttribute("errorMsg", "Invalid Email Format.");
                resp.sendRedirect("admin/doctor.jsp");
                return;
            }

            if (password == null || password.length() < 6) {
                session.setAttribute("errorMsg", "Password must be at least 6 characters long.");
                resp.sendRedirect("admin/doctor.jsp");
                return;
            }

          
            Doctor d = new Doctor(fullName, dob, qualification, specialist, mobNo, email, password);
            DoctorDao dao = new DoctorDao(DBConnect.getConn());

            
            if (dao.registerDoctor(d)) {
                session.setAttribute("sucMsg", "Doctor Added Successfully!");
                resp.sendRedirect("admin/view_doctor.jsp");
            } else {
                session.setAttribute("errorMsg", "Something went wrong on the server!");
                resp.sendRedirect("admin/doctor.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "An error occurred. Please try again.");
            resp.sendRedirect("admin/doctor.jsp");
        }
    }
}
