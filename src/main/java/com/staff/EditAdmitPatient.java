package com.staff;



import java.io.IOException;


import com.dao.AdmitPatientDAO;
import com.db.DBConnect;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/EditPatient")
public class EditAdmitPatient extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String disease = request.getParameter("disease");
        String address = request.getParameter("address");

        AdmitPatientDAO patientDAO = new AdmitPatientDAO(DBConnect.getConn());
        boolean updated = patientDAO.updatePatient(id, name, disease, address);
         
        HttpSession session =request.getSession();
        if (updated) {
        	session.setAttribute("sucMsg", "Edited Sucessfully !");
            response.sendRedirect("staff/Admit.jsp");
        } else {
        	session.setAttribute("errorMsg", "Edited Sucessfully !");
            response.sendRedirect("staff/EditAdmitPatient.jsp");
           
        }
    }
}
