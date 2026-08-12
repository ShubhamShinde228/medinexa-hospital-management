package com.dao;

import com.entity.MedicalStaff;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MedicalStaffDao {
    private Connection conn;

    public MedicalStaffDao(Connection conn) {
        this.conn = conn;
    }

    public MedicalStaff login(String email, String password) {
        MedicalStaff ms = null;
        try {
            String sql = "SELECT * FROM medical_staff WHERE email = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ms = new MedicalStaff();
                ms.setId(rs.getInt("id"));
                ms.setFullName(rs.getString("full_name"));
                ms.setEmail(rs.getString("email"));
                ms.setPassword(rs.getString("password"));
                ms.setLicenseNo(rs.getString("license_no"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ms;
    }

    public boolean register(MedicalStaff ms) {
        boolean f = false;
        try {
            String sql = "INSERT INTO medical_staff (full_name, email, password, license_no) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, ms.getFullName());
            ps.setString(2, ms.getEmail());
            ps.setString(3, ms.getPassword());
            ps.setString(4, ms.getLicenseNo());
            if (ps.executeUpdate() > 0) f = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }
}
