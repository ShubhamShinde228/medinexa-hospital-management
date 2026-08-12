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

@WebServlet("/deletePatient")
public class DeletePatientServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int patientId = Integer.parseInt(request.getParameter("patientId"));

        AdmitPatientDAO patientDAO = new AdmitPatientDAO(DBConnect.getConn());
        boolean deleted = patientDAO.deletePatient(patientId);
        
        HttpSession session=request.getSession();
        if (deleted) {
        	session.setAttribute("sucMsg","Successfully Deleted !");
            try {
				response.sendRedirect("staff/Admit.jsp");
			} catch (IOException e) {
				
				e.printStackTrace();
			}
        } else {
        	session.setAttribute("errorMsg","something Wrong !");
            response.sendRedirect("staff/Admit.jsp");
        }
    }
}
