package com.admin.servlet;

import java.io.IOException;

import com.dao.SpecialistDao;
import com.db.DBConnect;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/addSpecialist")
public class AddSpecialist extends HttpServlet{

	
	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String specName=req.getParameter("specName");
		
		SpecialistDao dao=new SpecialistDao(DBConnect.getConn());
		boolean f=dao.addSpecialist(specName);
		
		HttpSession session=req.getSession();
		
        if(f) {   
           
        	session.setAttribute("sucMsg","Specialist Added Sucessfully!");
        	
            resp.sendRedirect("admin/index.jsp");
        } 
        else
        {
        	session.setAttribute("errorMsg", "Something Wrong on Server!");
        	
        	resp.sendRedirect("admin/index.jsp");
        }
	}

	
	
	
}
