package com.feature.servlet;

import com.dao.AppointmentDao;
import com.dao.MedicalHistoryDao;
import com.dao.NotificationDao;
import com.dao.PrescriptionDao;
import com.db.DBConnect;
import com.entity.Appointment;
import com.entity.Doctor;
import com.entity.Prescription;
import com.util.EmailService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.sql.Connection;

/**
 * Saves a prescription written by a doctor.
 * POST /savePrescription
 */
@WebServlet("/savePrescription")
public class PrescriptionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Doctor doctor = null;
        if (session != null) {
            doctor = (Doctor) session.getAttribute("doctObj");
            if (doctor == null) {
                doctor = (Doctor) session.getAttribute("doctorObj");
            }
        }
        if (doctor == null) {
            response.sendRedirect(request.getContextPath() + "/doctor_login.jsp");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String patientName = request.getParameter("patientName");
            String medicine    = request.getParameter("medicine");
            String dosage      = request.getParameter("dosage");
            String frequency   = request.getParameter("frequency");
            int duration       = Integer.parseInt(request.getParameter("duration"));
            String notes       = request.getParameter("notes");
            String patientEmail = request.getParameter("patientEmail");

            Connection conn = DBConnect.getConn();
            PrescriptionDao dao = new PrescriptionDao(conn);

            Prescription p = new Prescription(appointmentId, patientName, doctor.getId(),
                                               medicine, dosage, frequency, duration, notes);
            if (dao.savePrescription(p)) {
                // Medical history event
                MedicalHistoryDao mhDao = new MedicalHistoryDao(conn);
                AppointmentDao apDao = new AppointmentDao(conn);
                Appointment ap = apDao.getAppointmentById(appointmentId);
                int userId = (ap != null) ? ap.getUserId() : 0;
                mhDao.addEvent(userId, patientName, appointmentId, 0, "PRESCRIPTION",
                    "Prescribed: " + medicine + " | " + dosage + " | " + frequency + " for " + duration + " days");

                // Notification to user
                if (userId > 0) {
                    NotificationDao nDao = new NotificationDao(conn);
                    nDao.createNotification(new com.entity.Notification("USER", userId,
                        "Dr. " + doctor.getFullName() + " has written a prescription for you.",
                        "../my_prescriptions.jsp"));
                }

                // Email to patient
                if (patientEmail != null && !patientEmail.isBlank()) {
                    EmailService.sendPrescriptionReady(patientEmail, patientName, 0);
                }

                session.setAttribute("sucMsg", "Prescription saved successfully.");
            } else {
                session.setAttribute("errorMsg", "Failed to save prescription.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Error: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/doctor/prescriptions.jsp");
    }
}
