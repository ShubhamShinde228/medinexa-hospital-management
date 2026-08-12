package com.feature.servlet;

import com.dao.DoctorSlotDao;
import com.dao.NotificationDao;
import com.db.DBConnect;
import com.entity.DoctorSlot;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;

/**
 * Handles adding and deleting doctor appointment slots (Admin).
 * POST /addDoctorSlot  — add single or batch slots
 * POST /deleteDoctorSlot — delete a slot
 */
@WebServlet(urlPatterns = {"/addDoctorSlot", "/deleteDoctorSlot"})
public class DoctorSlotServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();
        DoctorSlotDao dao  = new DoctorSlotDao(DBConnect.getConn());

        if ("/addDoctorSlot".equals(servletPath)) {
            String doctorIdStr = request.getParameter("doctorId");
            String date        = request.getParameter("slotDate");
            String[] times     = request.getParameterValues("slotTime");

            if (doctorIdStr == null || doctorIdStr.isBlank() || date == null || date.isBlank()) {
                request.getSession().setAttribute("errorMsg", "Please select both a Doctor and a Date.");
                response.sendRedirect(request.getContextPath() + "/admin/manage_slots.jsp");
                return;
            }

            int doctorId = Integer.parseInt(doctorIdStr);
            int added = 0;
            if (times != null) {
                for (String t : times) {
                    if (t != null && !t.isBlank()) {
                        DoctorSlot slot = new DoctorSlot(doctorId, date, t.trim());
                        if (dao.addSlot(slot)) added++;
                    }
                }
            }

            if (added > 0) {
                request.getSession().setAttribute("sucMsg", added + " slot(s) added successfully for Dr. #" + doctorId);
                try {
                    NotificationDao nDao = new NotificationDao(DBConnect.getConn());
                    nDao.createNotification(new com.entity.Notification("DOCTOR", doctorId,
                        added + " new appointment slot(s) added on " + date, "prescriptions.jsp"));
                } catch (Exception ignored) {}
            } else {
                request.getSession().setAttribute("errorMsg", "No new slots added. Please select time checkboxes or verify slots do not already exist.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/manage_slots.jsp?doctorId=" + doctorId);

        } else if ("/deleteDoctorSlot".equals(servletPath)) {
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            String redirectPage = request.getParameter("redirect") != null
                ? request.getParameter("redirect") : "/admin/manage_slots.jsp";
            if (dao.deleteSlot(slotId)) {
                request.getSession().setAttribute("sucMsg", "Slot deleted.");
            } else {
                request.getSession().setAttribute("errorMsg", "Could not delete slot.");
            }
            response.sendRedirect(request.getContextPath() + redirectPage);
        }
    }
}
