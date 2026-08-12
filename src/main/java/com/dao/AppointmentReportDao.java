package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.entity.Appointment;

public class AppointmentReportDao {
    private Connection conn;

    public AppointmentReportDao(Connection conn) {
        this.conn = conn;
    }

  
    public Appointment getAppointmentById(int id) {
        Appointment ap = null;
        try {
            String sql = "SELECT * FROM appointment WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                ap = new Appointment();
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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ap;
    }
}
