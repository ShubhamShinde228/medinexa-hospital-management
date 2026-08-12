package com.staff;

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

@WebServlet("/staffLogin")
public class Staff_Login  extends HttpServlet {

	
	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		
         String email = req.getParameter("email");
        
		String password = req.getParameter("password");

         HttpSession session=req.getSession();
         
         StaffDao dao=new StaffDao(DBConnect.getConn());
         
        Staff staff=dao.login(email, password);

   
         if (staff!=null) {   
        	
         	session.setAttribute("staffObj", staff);
         	session.setAttribute("sucMsg","Staff Login Successfully!");
         	
             resp.sendRedirect("staff/index.jsp");
         } 
         else
         {
         	session.setAttribute("errorMsg", "invalid email & password");
         	
         	resp.sendRedirect("staff_login.jsp");
         }

		
	}

	
}
