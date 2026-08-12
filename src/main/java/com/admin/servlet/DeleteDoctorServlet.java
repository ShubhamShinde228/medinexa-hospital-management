package com.admin.servlet;



import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.DoctorDao;
import com.db.DBConnect;

@WebServlet("/deleteDoctor")

public class DeleteDoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int doctorId = Integer.parseInt(request.getParameter("doctorId")); 
        DoctorDao doctorDao = new DoctorDao(DBConnect.getConn());

        boolean isDeleted = doctorDao.deleteDoctor(doctorId);
      
        if (isDeleted) {
           
            request.getSession().setAttribute("sucMsg", "Doctor deleted successfully.");
            response.sendRedirect("admin/doctor.jsp"); 
        } else {
           
            request.getSession().setAttribute("errorMsg", "Failed to delete the doctor.");
            response.sendRedirect("admin/doctor.jsp");
        }
        
    }
}
