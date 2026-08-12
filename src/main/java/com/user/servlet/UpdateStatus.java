package com.user.servlet;

import java.io.IOException;

import com.dao.AppointmentDao;
import com.dao.MedicalHistoryDao;
import com.dao.NotificationDao;
import com.db.DBConnect;
import com.entity.Appointment;
import com.entity.Notification;
import com.util.EmailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/updateStatus")
public class UpdateStatus extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int id   = Integer.parseInt(req.getParameter("id"));
            int did  = Integer.parseInt(req.getParameter("did"));
            String comm = req.getParameter("status");

            AppointmentDao dao = new AppointmentDao(DBConnect.getConn());
            HttpSession session = req.getSession();

            if (dao.updateCommentStatus(id, did, comm)) {
                session.setAttribute("sucMsg", "Status Updated!");

                // ── New: fetch appointment and send email + notification ──
                try {
                    Appointment ap = dao.getAppointmentById(id);
                    if (ap != null) {
                        // Email the patient
                        com.dao.DoctorDao dDao = new com.dao.DoctorDao(DBConnect.getConn());
                        com.entity.Doctor doc  = dDao.getDoctorById(did);
                        String doctorName = (doc != null) ? doc.getFullName() : "Doctor";
                        EmailService.sendAppointmentConfirmation(
                            ap.getEmail(), ap.getFullname(), doctorName, ap.getAppoinDate(), comm);

                        // In-app notification to user
                        NotificationDao nDao = new NotificationDao(DBConnect.getConn());
                        nDao.createNotification(new Notification("USER", ap.getUserId(),
                            "Your appointment with Dr. " + doctorName + " has been " + comm + ".",
                            "../view_appointment.jsp"));

                        // Medical history event
                        MedicalHistoryDao mhDao = new MedicalHistoryDao(DBConnect.getConn());
                        mhDao.addEvent(ap.getUserId(), ap.getFullname(), id, 0, "APPOINTMENT",
                            "Appointment status changed to: " + comm + " by Dr. " + doctorName);
                    }
                } catch (Exception notifEx) {
                    // Don't fail the main update if notifications fail
                    notifEx.printStackTrace();
                }
                // ── end new ──

                resp.sendRedirect("doctor/patient.jsp");
            } else {
                session.setAttribute("errorMsg", "Something Wrong on Server!");
                resp.sendRedirect("doctor/patient.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

