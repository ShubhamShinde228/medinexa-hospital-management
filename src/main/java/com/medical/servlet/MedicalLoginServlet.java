package com.medical.servlet;

import com.dao.MedicalStaffDao;
import com.db.DBConnect;
import com.entity.MedicalStaff;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/medicalLogin")
public class MedicalLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            HttpSession session = request.getSession();

            // Default demo account auto-create
            if ("medical@hospital.com".equals(email) && "123456".equals(password)) {
                MedicalStaff defaultMs = new MedicalStaff(1, "Chief Pharmacist Rajesh", email, password, "PHARM-98765");
                session.setAttribute("medicalObj", defaultMs);
                response.sendRedirect("medical/index.jsp");
                return;
            }

            MedicalStaffDao dao = new MedicalStaffDao(DBConnect.getConn());
            MedicalStaff ms = dao.login(email, password);

            if (ms != null) {
                session.setAttribute("medicalObj", ms);
                response.sendRedirect("medical/index.jsp");
            } else {
                session.setAttribute("errorMsg", "Invalid Medical Staff Email & Password");
                response.sendRedirect("medical_login.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "Server error: " + e.getMessage());
            response.sendRedirect("medical_login.jsp");
        }
    }
}
