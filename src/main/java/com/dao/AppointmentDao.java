package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import com.entity.Appointment;



public class AppointmentDao {

    private Connection conn;

    public AppointmentDao(Connection conn) {
        this.conn = conn;
    }

   
    private boolean isValidAppointment(Appointment ap) {
        if (ap == null) return false;
        if (ap.getFullname() == null || ap.getFullname().trim().isEmpty() ||
            ap.getEmail() == null || ap.getEmail().trim().isEmpty() ||
            ap.getPhNo() == null || ap.getPhNo().trim().isEmpty() ||
            ap.getAppoinDate() == null || ap.getAppoinDate().trim().isEmpty()) {
            return false;
        }

        String digitsOnly = ap.getPhNo().replaceAll("[^0-9]", "");
        if (digitsOnly.length() < 7) {
            return false;
        }

        if (ap.getDoctorId() <= 0) {
            return false;
        }

        return true;
    }

   
    public boolean addAppointment(Appointment ap) {
        if (!isValidAppointment(ap)) {
            return false; 
        }

        boolean success = false;
        try {
            String sql = "INSERT INTO appointment (user_id, fullname, gender, age, appoint_date, email, phNo, disease, doctor_id, address, status, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, ap.getUserId());
            ps.setString(2, ap.getFullname());
            ps.setString(3, ap.getGender());
            ps.setString(4, ap.getAge());
            ps.setString(5, ap.getAppoinDate());
            ps.setString(6, ap.getEmail());
            ps.setString(7, ap.getPhNo());
            ps.setString(8, ap.getDiseases());
            ps.setInt(9, ap.getDoctorId());
            ps.setString(10, ap.getAddress());
            ps.setString(11, ap.getStatus());
            ps.setString(12, ap.getPaymentStatus() != null ? ap.getPaymentStatus() : "PENDING_PAYMENT");

            int i = ps.executeUpdate();
            success = (i == 1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }


    public List<Appointment> getAllAppointmentByLoginUser(int userId) {
        List<Appointment> list = new ArrayList<>();
        Appointment ap = null;

        if (userId <= 0) return list; 

        try {
            String sql = "SELECT * FROM appointment WHERE user_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ap = extractAppointmentFromResultSet(rs);
                list.add(ap);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

   
    public List<Appointment> getAllAppointmentByDoctorLogin(int doctorId) {
        List<Appointment> list = new ArrayList<>();

        if (doctorId <= 0) return list; 

        try {
            String sql = "SELECT * FROM appointment WHERE doctor_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractAppointmentFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

   
    public Appointment getAppointmentById(int id) {
        if (id <= 0) return null;

        Appointment ap = null;
        try {
            String sql = "SELECT * FROM appointment WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                ap = extractAppointmentFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ap;
    }

   
    public boolean updateCommentStatus(int id, int doctorId, String status) {
        if (id <= 0 || doctorId <= 0 || status == null || status.trim().isEmpty()) {
            return false; 
        }

        boolean success = false;
        try {
            String sql = "UPDATE appointment SET status = ? WHERE id = ? AND doctor_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.setInt(3, doctorId);

            int i = ps.executeUpdate();
            success = (i == 1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

   
    public List<Appointment> getAllAppointment() {
        List<Appointment> list = new ArrayList<>();

        try {
            String sql = "SELECT * FROM appointment ORDER BY id DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractAppointmentFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

   
    private Appointment extractAppointmentFromResultSet(ResultSet rs) throws Exception {
        Appointment ap = new Appointment();
        ap.setId(rs.getInt("id"));
        ap.setUserId(rs.getInt("user_id"));
        ap.setFullname(rs.getString("fullname"));
        ap.setGender(rs.getString("gender"));
        ap.setAge(rs.getString("age"));
        ap.setAppoinDate(rs.getString("appoint_date"));
        ap.setEmail(rs.getString("email"));
        ap.setPhNo(rs.getString("phNo"));
        ap.setDiseases(rs.getString("disease"));
        ap.setDoctorId(rs.getInt("doctor_id"));
        ap.setAddress(rs.getString("address"));
        ap.setStatus(rs.getString("status"));
        ap.setPaymentStatus(rs.getString("payment_status"));
        return ap;
    }

    public int addAppointmentReturnId(Appointment ap) {
        if (!isValidAppointment(ap)) {
            return -1; 
        }

        try {
            String sql = "INSERT INTO appointment (user_id, fullname, gender, age, appoint_date, email, phNo, disease, doctor_id, address, status, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, ap.getUserId());
            ps.setString(2, ap.getFullname());
            ps.setString(3, ap.getGender());
            ps.setString(4, ap.getAge());
            ps.setString(5, ap.getAppoinDate());
            ps.setString(6, ap.getEmail());
            ps.setString(7, ap.getPhNo());
            ps.setString(8, ap.getDiseases());
            ps.setInt(9, ap.getDoctorId());
            ps.setString(10, ap.getAddress());
            ps.setString(11, ap.getStatus());
            ps.setString(12, ap.getPaymentStatus() != null ? ap.getPaymentStatus() : "PENDING_PAYMENT");

            int affected = ps.executeUpdate();
            if (affected == 1) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updatePaymentStatus(int id, String paymentStatus) {
        if (id <= 0 || paymentStatus == null) {
            return false;
        }
        try {
            String sql = "UPDATE appointment SET payment_status = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, paymentStatus);
            ps.setInt(2, id);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
