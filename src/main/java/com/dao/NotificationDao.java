package com.dao;

import com.entity.Notification;
import java.sql.*;
import java.util.*;

public class NotificationDao {
    private Connection conn;

    public NotificationDao(Connection conn) {
        this.conn = conn;
    }

    /** Create a new notification */
    public boolean createNotification(Notification n) {
        try {
            String sql = "INSERT INTO notification (target_role, target_id, message, link) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, n.getTargetRole());
            ps.setInt(2, n.getTargetId());
            ps.setString(3, n.getMessage());
            ps.setString(4, n.getLink() != null ? n.getLink() : "#");
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Shortcut to broadcast to all users of a role (target_id = 0 means broadcast) */
    public boolean broadcast(String role, String message, String link) {
        return createNotification(new Notification(role, 0, message, link));
    }

    /** Get unread notifications for a specific role+id */
    public List<Notification> getUnread(String role, int targetId) {
        List<Notification> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM notification WHERE target_role=? AND (target_id=? OR target_id=0) " +
                         "AND is_read=FALSE ORDER BY created_at DESC LIMIT 20";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, role);
            ps.setInt(2, targetId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapNotif(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Get all notifications for a role+id (for full notifications page) */
    public List<Notification> getAll(String role, int targetId) {
        List<Notification> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM notification WHERE target_role=? AND (target_id=? OR target_id=0) " +
                         "ORDER BY created_at DESC LIMIT 50";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, role);
            ps.setInt(2, targetId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapNotif(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Count unread notifications */
    public int countUnread(String role, int targetId) {
        try {
            String sql = "SELECT COUNT(*) FROM notification WHERE target_role=? AND (target_id=? OR target_id=0) AND is_read=FALSE";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, role);
            ps.setInt(2, targetId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Mark all as read for a role+id */
    public void markAllRead(String role, int targetId) {
        try {
            String sql = "UPDATE notification SET is_read=TRUE WHERE target_role=? AND (target_id=? OR target_id=0)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, role);
            ps.setInt(2, targetId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** Mark single notification as read */
    public void markRead(int id) {
        try {
            PreparedStatement ps = conn.prepareStatement("UPDATE notification SET is_read=TRUE WHERE id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Notification mapNotif(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setId(rs.getInt("id"));
        n.setTargetRole(rs.getString("target_role"));
        n.setTargetId(rs.getInt("target_id"));
        n.setMessage(rs.getString("message"));
        n.setLink(rs.getString("link"));
        n.setRead(rs.getBoolean("is_read"));
        n.setCreatedAt(rs.getString("created_at"));
        return n;
    }
}
