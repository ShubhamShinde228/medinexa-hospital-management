package com.feature.servlet;

import com.dao.AppointmentDao;
import com.dao.DoctorSlotDao;
import com.dao.MedicalHistoryDao;
import com.dao.NotificationDao;
import com.db.DBConnect;
import com.entity.Appointment;
import com.entity.User;
import com.util.EmailService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.sql.Connection;

/**
 * Books a slot for the logged-in user.
 * POST /bookSlot
 */
@WebServlet("/bookSlot")
public class BookSlotServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("userObj") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user_login.jsp");
            return;
        }

        try {
            String slotIdStr   = request.getParameter("slotId");
            String doctorIdStr = request.getParameter("doctorId");
            String fullname    = request.getParameter("fullname");
            String gender      = request.getParameter("gender");
            String age         = request.getParameter("age");
            String date        = request.getParameter("appointDate");
            String email       = request.getParameter("email");
            String phone       = request.getParameter("phone");
            String disease     = request.getParameter("disease");
            String address     = request.getParameter("address");

            if (slotIdStr == null || slotIdStr.trim().isEmpty()) {
                session.setAttribute("errorMsg", "Please select an available time slot before submitting.");
                response.sendRedirect(request.getContextPath() + "/slot_booking.jsp?doctorId=" + doctorIdStr + "&slotDate=" + date);
                return;
            }

            int slotId   = Integer.parseInt(slotIdStr);
            int doctorId = Integer.parseInt(doctorIdStr);

            Connection conn = DBConnect.getConn();
            AppointmentDao apDao = new AppointmentDao(conn);

            Appointment ap = new Appointment(user.getId(), fullname, gender, age, date,
                                              email, phone, disease, doctorId, address, "Pending");
            int apId = apDao.addAppointmentReturnId(ap);

            if (apId > 0) {
                DoctorSlotDao slotDao = new DoctorSlotDao(conn);
                slotDao.bookSlot(slotId, apId);

                // Medical history event
                try {
                    MedicalHistoryDao mhDao = new MedicalHistoryDao(conn);
                    mhDao.addEvent(user.getId(), fullname, apId, 0, "APPOINTMENT",
                        "Appointment booked with Doctor ID #" + doctorId + " on " + date);
                } catch (Exception ignored) {}

                // Notification to admin
                try {
                    NotificationDao nDao = new NotificationDao(conn);
                    nDao.broadcast("ADMIN", "New slot appointment booked by " + fullname, "admin/patient.jsp");
                } catch (Exception ignored) {}

                // Email confirmation (async/safe)
                try {
                    EmailService.sendAppointmentConfirmation(email, fullname, "Doctor #" + doctorId, date, "PENDING");
                } catch (Exception ignored) {}

                session.setAttribute("sucMsg", "Appointment booked successfully! Redirecting to payment checkout...");
                response.sendRedirect(request.getContextPath() + "/payment_checkout.jsp?type=APPOINTMENT_FEE&appointmentId=" + apId + "&amount=500");
                return;
            } else {
                session.setAttribute("errorMsg", "Failed to create appointment record. Please verify details and try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Error processing appointment booking: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/slot_booking.jsp");
    }
}
