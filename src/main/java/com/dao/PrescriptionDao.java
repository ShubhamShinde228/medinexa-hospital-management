package com.dao;

import com.entity.Prescription;
import java.sql.*;
import java.util.*;

public class PrescriptionDao {
    private Connection conn;

    public PrescriptionDao(Connection conn) {
        this.conn = conn;
    }

    /** Save a prescription */
    public boolean savePrescription(Prescription p) {
        try {
            String sql = "INSERT INTO prescription (appointment_id, patient_name, doctor_id, medicine_name, dosage, frequency, duration_days, notes) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, p.getAppointmentId());
            ps.setString(2, p.getPatientName());
            ps.setInt(3, p.getDoctorId());
            ps.setString(4, p.getMedicineName());
            ps.setString(5, p.getDosage());
            ps.setString(6, p.getFrequency());
            ps.setInt(7, p.getDurationDays());
            ps.setString(8, p.getNotes());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Get all prescriptions for an appointment */
    public List<Prescription> getPrescriptionsByAppointmentId(int appointmentId) {
        List<Prescription> list = new ArrayList<>();
        try {
            String sql = "SELECT pr.*, d.full_name as doctor_name FROM prescription pr " +
                         "LEFT JOIN doctor d ON pr.doctor_id=d.id WHERE pr.appointment_id=? ORDER BY pr.created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapPrescription(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Get all prescriptions written by a doctor */
    public List<Prescription> getPrescriptionsByDoctorId(int doctorId) {
        List<Prescription> list = new ArrayList<>();
        try {
            String sql = "SELECT pr.*, d.full_name as doctor_name FROM prescription pr " +
                         "LEFT JOIN doctor d ON pr.doctor_id=d.id WHERE pr.doctor_id=? ORDER BY pr.created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapPrescription(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Get all prescriptions for a user (via appointment join) */
    public List<Prescription> getPrescriptionsByUserId(int userId) {
        List<Prescription> list = new ArrayList<>();
        try {
            String sql = "SELECT pr.*, d.full_name as doctor_name FROM prescription pr " +
                         "LEFT JOIN doctor d ON pr.doctor_id=d.id " +
                         "INNER JOIN appointment a ON pr.appointment_id=a.id " +
                         "WHERE a.user_id=? ORDER BY pr.created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapPrescription(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Get single prescription by id */
    public Prescription getPrescriptionById(int id) {
        try {
            String sql = "SELECT pr.*, d.full_name as doctor_name FROM prescription pr " +
                         "LEFT JOIN doctor d ON pr.doctor_id=d.id WHERE pr.id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapPrescription(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Delete prescription */
    public boolean deletePrescription(int id) {
        try {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM prescription WHERE id=?");
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Prescription mapPrescription(ResultSet rs) throws SQLException {
        Prescription p = new Prescription();
        p.setId(rs.getInt("id"));
        p.setAppointmentId(rs.getInt("appointment_id"));
        p.setPatientName(rs.getString("patient_name"));
        p.setDoctorId(rs.getInt("doctor_id"));
        p.setMedicineName(rs.getString("medicine_name"));
        p.setDosage(rs.getString("dosage"));
        p.setFrequency(rs.getString("frequency"));
        p.setDurationDays(rs.getInt("duration_days"));
        p.setNotes(rs.getString("notes"));
        p.setCreatedAt(rs.getString("created_at"));
        try { p.setDoctorName(rs.getString("doctor_name")); } catch (Exception ignored) {}
        return p;
    }
}
