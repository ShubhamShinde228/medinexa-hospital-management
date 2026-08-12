package com.staff;


import java.io.IOException;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.dao.AppointmentDao;
import com.db.DBConnect;
import com.entity.*;

@WebServlet("/staff/addAppointment")
public class Addappointment extends HttpServlet {

	
	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		

		 int userId = Integer.parseInt(req.getParameter("UserId"));
		 String fullname=req.getParameter("fullname");
		 String gender=req.getParameter("gender");
		 String age=req.getParameter("age");
		 String appoinDate=req.getParameter("appoinDate");
		 String email=req.getParameter("email");
		 String phNo=req.getParameter("phNo");
		 String diseases=req.getParameter("diseases");
		 int doctorId = Integer.parseInt(req.getParameter("doct"));
		 String address=req.getParameter("address");
		
		 
		 System.out.println("AddAppointmentServlet Called");
		 
		 Appointment ap=new Appointment(userId,fullname,gender,age,appoinDate,email,phNo,diseases,doctorId,address,"Pending");
			
		 AppointmentDao dao=new AppointmentDao(DBConnect.getConn());
		 
		 HttpSession session =req.getSession();
		 
		

		 
		 int appointmentId = dao.addAppointmentReturnId(ap);
		 if (appointmentId > 0) {
			    resp.sendRedirect("../payment_checkout.jsp?type=APPOINTMENT_FEE&appointmentId=" + appointmentId + "&amount=500");
			} else {
			    session.setAttribute("errorMsg", "Something Went Wrong on the Server");
			    resp.sendRedirect("user_appointment.jsp");
			}
		 
	}

}

     
