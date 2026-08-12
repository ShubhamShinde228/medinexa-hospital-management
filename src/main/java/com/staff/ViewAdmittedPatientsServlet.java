package com.staff;

import com.dao.AdmitPatientDAO;
import com.db.DBConnect;
import com.entity.AdmitPatient;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ViewAdmittedPatients")
public class ViewAdmittedPatientsServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = DBConnect.getConn();
        AdmitPatientDAO dao = new AdmitPatientDAO(conn);
        List<AdmitPatient> patients = dao.getAdmittedPatients();
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("viewAdmittedPatients.jsp").forward(request, response);
    }
}
