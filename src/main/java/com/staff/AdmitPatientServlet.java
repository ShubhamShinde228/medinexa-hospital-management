package com.staff;

import com.dao.AdmitPatientDAO;
import com.entity.AdmitPatient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.db.DBConnect;
import java.io.IOException;
import java.sql.Connection;


@WebServlet("/AdmitPatient")
public class AdmitPatientServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String disease = request.getParameter("disease");
        String address = request.getParameter("address");
        String admittedDate = request.getParameter("admittedDate");
        String doctorIdStr = request.getParameter("doctorId");
        String roomNumber = request.getParameter("roomNumber");

        AdmitPatient patient = new AdmitPatient();
        patient.setName(name);
        patient.setDisease(disease);
        patient.setAddress(address);
        patient.setAdmittedDate(admittedDate);
        
        int doctorId = 0;
        try {
            if (doctorIdStr != null && !doctorIdStr.trim().isEmpty()) {
                doctorId = Integer.parseInt(doctorIdStr.trim());
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        patient.setDoctorId(doctorId);
        patient.setRoomNumber(roomNumber);
        patient.setPatientStatus("ADMITTED");

        Connection conn = DBConnect.getConn();
        AdmitPatientDAO dao = new AdmitPatientDAO(conn);
        
        HttpSession session=request.getSession();
        
        boolean success = dao.admitPatient(patient);
        if (success) {
        	session.setAttribute("sucMsg","Successfully Added !");
            response.sendRedirect("staff/Admit.jsp");
        } else {
        	session.setAttribute("errorMsg","something Wrong !");
            response.sendRedirect("staff/Admit.jsp");
        }
    }
}