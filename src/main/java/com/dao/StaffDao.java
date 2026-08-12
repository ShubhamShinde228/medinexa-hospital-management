package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import com.entity.Staff;

public class StaffDao {

    private Connection conn;

    public StaffDao(Connection conn) {
        this.conn = conn;
    }

    
    private boolean isValidStaff(Staff s) {
        if (s == null) return false;
        if (s.getFullName() == null || s.getFullName().trim().isEmpty() ||
            s.getEmail() == null || s.getEmail().trim().isEmpty() ||
            s.getPassword() == null || s.getPassword().trim().isEmpty()) {
            return false;
        }

        String digitsOnly = s.getMobNo() != null ? s.getMobNo().replaceAll("[^0-9]", "") : "";
        if (digitsOnly.length() < 7) {
            return false;
        }

        if (s.getPassword().trim().length() < 3) {
            return false;
        }

        return true;
    }

 
    public boolean registerStaff(Staff s) {
        if (!isValidStaff(s)) {
            return false; 
        }

        boolean isRegistered = false;
        try {
            String sql = "INSERT INTO staff(full_name, dob, qualification, specialist, mobno, email, password) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, s.getFullName());
            ps.setString(2, s.getDob());
            ps.setString(3, s.getQualification());
            ps.setString(4, s.getSpecialist());
            ps.setString(5, s.getMobNo());
            ps.setString(6, s.getEmail());
            ps.setString(7, s.getPassword());

            int rowsAffected = ps.executeUpdate();
            isRegistered = (rowsAffected == 1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isRegistered;
    }

  
    public List<Staff> getAllStaff() {
        List<Staff> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM staff";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Staff s = new Staff();
                s.setId(rs.getInt("id"));
                s.setFullName(rs.getString("full_name"));
                s.setDob(rs.getString("dob"));
                s.setQualification(rs.getString("qualification"));
                s.setSpecialist(rs.getString("specialist"));
                s.setMobNo(rs.getString("mobno"));
                s.setEmail(rs.getString("email"));
                s.setPassword(rs.getString("password"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

  
    public Staff getStaffById(int id) {
        Staff s = null;
        try {
            String sql = "SELECT * FROM staff WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                s = new Staff();
                s.setId(rs.getInt("id"));
                s.setFullName(rs.getString("full_name"));
                s.setDob(rs.getString("dob"));
                s.setQualification(rs.getString("qualification"));
                s.setSpecialist(rs.getString("specialist"));
                s.setMobNo(rs.getString("mobno"));
                s.setEmail(rs.getString("email"));
                s.setPassword(rs.getString("password"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return s;
    }

    
    public boolean deleteStaff(int id) {
        boolean isDeleted = false;
        try {
            String sql = "DELETE FROM staff WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int rowsAffected = ps.executeUpdate();
            isDeleted = (rowsAffected == 1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isDeleted;
    }

    
    public boolean updateStaff(Staff s) {
        if (!isValidStaff(s)) {
            return false; 
        }

        boolean isUpdated = false;
        try {
            String sql = "UPDATE staff SET full_name = ?, dob = ?, qualification = ?, specialist = ?, mobno = ?, email = ?, password = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, s.getFullName());
            ps.setString(2, s.getDob());
            ps.setString(3, s.getQualification());
            ps.setString(4, s.getSpecialist());
            ps.setString(5, s.getMobNo());
            ps.setString(6, s.getEmail());
            ps.setString(7, s.getPassword());
            ps.setInt(8, s.getId());

            int rowsAffected = ps.executeUpdate();
            isUpdated = (rowsAffected == 1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isUpdated;
    }

   
    public Staff login(String email, String password) {
        Staff s = null;
        try {
            if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
                return null; 
            }

            String sql = "SELECT * FROM staff WHERE email = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                s = new Staff();
                s.setId(rs.getInt("id"));
                s.setFullName(rs.getString("full_name"));
                s.setDob(rs.getString("dob"));
                s.setQualification(rs.getString("qualification"));
                s.setSpecialist(rs.getString("specialist"));
                s.setMobNo(rs.getString("mobno"));
                s.setEmail(rs.getString("email"));
                s.setPassword(rs.getString("password"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return s;
    }
}
