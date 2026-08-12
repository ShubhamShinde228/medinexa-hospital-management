package com.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.dao.AdmitPatientDAO;
import com.db.DBConnect;
import java.io.IOException;
import java.sql.Connection;


@WebServlet("/DischargePatient")
public class DischargePatientServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String dischargeDate = request.getParameter("discharge_date");

        Connection conn = DBConnect.getConn();
        AdmitPatientDAO dao = new AdmitPatientDAO(conn);
        
        com.entity.AdmitPatient patient = dao.getPatientById(id);
        if (patient != null) {
            dao.updatePatientStatus(id, "BILLING_PENDING");
            dao.dischargePatient(id, dischargeDate, 0.0);
            response.sendRedirect("staff/billing.jsp?admissionId=" + id + "&dischargeDate=" + dischargeDate);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("errorMsg", "Patient not found!");
            response.sendRedirect("staff/Discharge.jsp");
        }
    }
}
