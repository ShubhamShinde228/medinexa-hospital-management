package com.dao;

import com.entity.MedicalHistory;
import java.sql.*;
import java.util.*;

public class MedicalHistoryDao {
    private Connection conn;

    public MedicalHistoryDao(Connection conn) {
        this.conn = conn;
    }

    /** Add a new timeline event */
    public boolean addEvent(MedicalHistory mh) {
        try {
            String sql = "INSERT INTO medical_history (user_id, patient_name, appointment_id, admission_id, event_type, description) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, mh.getUserId());
            ps.setString(2, mh.getPatientName());
            ps.setInt(3, mh.getAppointmentId());
            ps.setInt(4, mh.getAdmissionId());
            ps.setString(5, mh.getEventType());
            ps.setString(6, mh.getDescription());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Convenience helper */
    public boolean addEvent(int userId, String patientName, int appointmentId, int admissionId,
                             String eventType, String description) {
        return addEvent(new MedicalHistory(userId, patientName, appointmentId, admissionId, eventType, description));
    }

    /** Get all events for a user ordered by most recent first */
    public List<MedicalHistory> getHistoryByUserId(int userId) {
        List<MedicalHistory> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM medical_history WHERE user_id=? ORDER BY event_date DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapHistory(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Get events for a specific appointment */
    public List<MedicalHistory> getHistoryByAppointmentId(int appointmentId) {
        List<MedicalHistory> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM medical_history WHERE appointment_id=? ORDER BY event_date DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapHistory(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Get events for a patient name (for staff/doctor view of non-registered patients) */
    public List<MedicalHistory> getHistoryByPatientName(String name) {
        List<MedicalHistory> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM medical_history WHERE patient_name LIKE ? ORDER BY event_date DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapHistory(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private MedicalHistory mapHistory(ResultSet rs) throws SQLException {
        MedicalHistory mh = new MedicalHistory();
        mh.setId(rs.getInt("id"));
        mh.setUserId(rs.getInt("user_id"));
        mh.setPatientName(rs.getString("patient_name"));
        mh.setAppointmentId(rs.getInt("appointment_id"));
        mh.setAdmissionId(rs.getInt("admission_id"));
        mh.setEventType(rs.getString("event_type"));
        mh.setDescription(rs.getString("description"));
        mh.setEventDate(rs.getString("event_date"));
        return mh;
    }
}
