package com.admin.servlet;

	import java.io.IOException;

	import com.dao.WardDao;
import com.db.DBConnect;
	import com.entity.Ward;

import jakarta.servlet.ServletException;
	import jakarta.servlet.annotation.WebServlet;
	import jakarta.servlet.http.HttpServlet;
	import jakarta.servlet.http.HttpServletRequest;
	import jakarta.servlet.http.HttpServletResponse;
	import jakarta.servlet.http.HttpSession;

	@WebServlet("/AddWard")
	public class AddWard extends HttpServlet{

		private static final long serialVersionUID = 1L;

		@Override
		protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
			
			try {
				
				String wardName=req.getParameter("ward_name");
				String wardType=req.getParameter("ward_type");
				 int capacity = Integer.parseInt(req.getParameter("capacity"));
				 int currentOccupancy = Integer.parseInt(req.getParameter("current_occupancy"));
				
				Ward w=new Ward( wardName,wardType,capacity,currentOccupancy);
				
				WardDao dao=new WardDao(DBConnect.getConn());
				
				HttpSession session=req.getSession();
				
				if(dao.registerWard(w))
				{
					session.setAttribute("sucMsg", "Ward Added Successfully !");
					resp.sendRedirect("admin/addward.jsp");
				}else
				{
					session.setAttribute("errorMsg", "Something Wrong on Server !");
					resp.sendRedirect("admin/index.jsp");
				}
				
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}

		
		
		
	}

	

