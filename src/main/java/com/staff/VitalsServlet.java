package com.staff;

import com.dao.AdmitPatientDAO;
import com.dao.NotificationDao;
import com.dao.PatientVitalsDao;
import com.db.DBConnect;
import com.entity.AdmitPatient;
import com.entity.PatientVitals;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/staff/recordVitals")
public class VitalsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        try {
            int admissionId = Integer.parseInt(req.getParameter("admissionId"));
            int pulseRate = Integer.parseInt(req.getParameter("pulseRate"));
            String bloodPressure = req.getParameter("bloodPressure");
            double tempF = Double.parseDouble(req.getParameter("temperatureF"));
            int spo2 = Integer.parseInt(req.getParameter("spo2Percentage"));

            Connection conn = DBConnect.getConn();
            AdmitPatientDAO admitDao = new AdmitPatientDAO(conn);
            AdmitPatient patient = admitDao.getPatientById(admissionId);
            String patientName = (patient != null) ? patient.getName() : "Patient #" + admissionId;

            // Auto Triage Classification
            String triageStatus = "STABLE";
            if (spo2 < 90 || tempF >= 103.0 || pulseRate > 130 || pulseRate < 45) {
                triageStatus = "CRITICAL";
            } else if (spo2 <= 94 || tempF >= 100.5 || pulseRate > 100) {
                triageStatus = "WARNING";
            }

            PatientVitals vitals = new PatientVitals(admissionId, patientName, pulseRate, bloodPressure, tempF, spo2, triageStatus);
            PatientVitalsDao dao = new PatientVitalsDao(conn);

            if (dao.recordVitals(vitals)) {
                if ("CRITICAL".equals(triageStatus)) {
                    try {
                        NotificationDao nDao = new NotificationDao(conn);
                        nDao.broadcast("DOCTOR", "🚨 CRITICAL VITALS ALERT: Patient " + patientName + " (SpO2: " + spo2 + "%, Temp: " + tempF + "°F)", "../doctor/index.jsp");
                        nDao.broadcast("ADMIN", "🚨 CRITICAL VITALS ALERT: Patient " + patientName + " (SpO2: " + spo2 + "%)", "../admin/patient.jsp");
                    } catch (Exception ignored) {}
                    session.setAttribute("sucMsg", "Vitals Recorded! 🚨 CRITICAL ALERT SENT TO DOCTORS & ADMIN.");
                } else {
                    session.setAttribute("sucMsg", "Patient Vitals Recorded Successfully! Status: " + triageStatus);
                }
            } else {
                session.setAttribute("errorMsg", "Failed to record patient vitals.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Error recording vitals: " + e.getMessage());
        }
        resp.sendRedirect("vitals_tracker.jsp");
    }
}
