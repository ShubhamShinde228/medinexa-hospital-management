package com.feature.servlet;

import com.dao.NotificationDao;
import com.db.DBConnect;
import com.entity.Notification;
import com.google.gson.Gson;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.util.*;

/**
 * AJAX endpoint for notification center.
 * GET  /notificationApi?action=count&role=ADMIN&id=1  -> {"count":3}
 * GET  /notificationApi?action=list&role=ADMIN&id=1   -> [{...}, ...]
 * POST /notificationApi?action=markRead&role=ADMIN&id=1 -> {"ok":true}
 */
@WebServlet("/notificationApi")
public class NotificationApiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");

        String action = request.getParameter("action");
        String role   = request.getParameter("role");
        int targetId  = parseId(request.getParameter("id"));

        if (role == null || role.isBlank()) {
            response.getWriter().write("{\"error\":\"Missing role\"}");
            return;
        }

        NotificationDao dao = new NotificationDao(DBConnect.getConn());

        if ("count".equals(action)) {
            int count = dao.countUnread(role.toUpperCase(), targetId);
            response.getWriter().write("{\"count\":" + count + "}");

        } else if ("list".equals(action)) {
            List<Notification> notifs = dao.getAll(role.toUpperCase(), targetId);
            // Simple JSON serialization without Gson dependency
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < notifs.size(); i++) {
                Notification n = notifs.get(i);
                if (i > 0) sb.append(",");
                sb.append("{")
                  .append("\"id\":").append(n.getId()).append(",")
                  .append("\"message\":\"").append(escapeJson(n.getMessage())).append("\",")
                  .append("\"link\":\"").append(escapeJson(n.getLink())).append("\",")
                  .append("\"isRead\":").append(n.isRead()).append(",")
                  .append("\"createdAt\":\"").append(escapeJson(n.getCreatedAt())).append("\"")
                  .append("}");
            }
            sb.append("]");
            response.getWriter().write(sb.toString());

        } else {
            response.getWriter().write("{\"error\":\"Unknown action\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");

        String action = request.getParameter("action");
        String role   = request.getParameter("role");
        int targetId  = parseId(request.getParameter("id"));

        NotificationDao dao = new NotificationDao(DBConnect.getConn());

        if ("markRead".equals(action)) {
            String notifIdStr = request.getParameter("notifId");
            if (notifIdStr != null && !notifIdStr.isBlank()) {
                dao.markRead(Integer.parseInt(notifIdStr));
            } else if (role != null) {
                dao.markAllRead(role.toUpperCase(), targetId);
            }
            response.getWriter().write("{\"ok\":true}");
        } else {
            response.getWriter().write("{\"error\":\"Unknown action\"}");
        }
    }

    private int parseId(String s) {
        try { return Integer.parseInt(s); } catch (Exception e) { return 0; }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
