package com.dao;

import com.entity.DoctorSlot;
import java.sql.*;
import java.util.*;

public class DoctorSlotDao {
    private Connection conn;

    public DoctorSlotDao(Connection conn) {
        this.conn = conn;
    }

    /** Admin/Doctor adds available slots */
    public boolean addSlot(DoctorSlot slot) {
        try {
            String sql = "INSERT IGNORE INTO doctor_slots (doctor_id, slot_date, slot_time) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, slot.getDoctorId());
            ps.setString(2, slot.getSlotDate());
            ps.setString(3, slot.getSlotTime());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Get all available (not booked) slots for a doctor on a date */
    public List<DoctorSlot> getAvailableSlots(int doctorId, String date) {
        List<DoctorSlot> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM doctor_slots WHERE doctor_id=? AND slot_date=? AND is_booked=FALSE ORDER BY slot_time";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ps.setString(2, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapSlot(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Get ALL slots for a doctor (for admin view) */
    public List<DoctorSlot> getAllSlotsForDoctor(int doctorId) {
        List<DoctorSlot> list = new ArrayList<>();
        try {
            String sql = "SELECT ds.*, d.full_name as doctor_name FROM doctor_slots ds " +
                         "JOIN doctor d ON ds.doctor_id=d.id WHERE ds.doctor_id=? ORDER BY ds.slot_date, ds.slot_time";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                DoctorSlot s = mapSlot(rs);
                s.setDoctorName(rs.getString("doctor_name"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Get distinct dates that have available slots for a doctor */
    public List<String> getAvailableDates(int doctorId) {
        List<String> dates = new ArrayList<>();
        try {
            String sql = "SELECT DISTINCT slot_date FROM doctor_slots WHERE doctor_id=? AND is_booked=FALSE ORDER BY slot_date";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                dates.add(rs.getString("slot_date"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dates;
    }

    /** Book a slot — mark it taken */
    public boolean bookSlot(int slotId, int appointmentId) {
        try {
            String sql = "UPDATE doctor_slots SET is_booked=TRUE, appointment_id=? WHERE id=? AND is_booked=FALSE";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, appointmentId);
            ps.setInt(2, slotId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Delete a slot (admin) */
    public boolean deleteSlot(int slotId) {
        try {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM doctor_slots WHERE id=?");
            ps.setInt(1, slotId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Get slot by id */
    public DoctorSlot getSlotById(int id) {
        try {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM doctor_slots WHERE id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapSlot(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private DoctorSlot mapSlot(ResultSet rs) throws SQLException {
        DoctorSlot s = new DoctorSlot();
        s.setId(rs.getInt("id"));
        s.setDoctorId(rs.getInt("doctor_id"));
        s.setSlotDate(rs.getString("slot_date"));
        s.setSlotTime(rs.getString("slot_time"));
        s.setBooked(rs.getBoolean("is_booked"));
        s.setAppointmentId(rs.getInt("appointment_id"));
        s.setCreatedAt(rs.getString("created_at"));
        return s;
    }
}
