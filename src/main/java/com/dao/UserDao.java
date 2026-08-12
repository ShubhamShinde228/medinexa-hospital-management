package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Random;
import java.util.regex.Pattern;
import com.entity.User;

public class UserDao {

    private Connection conn;

    public UserDao(Connection conn) {
        this.conn = conn;
    }

    
    private boolean isValidUser(User u) {
        if (u.getFullName() == null || u.getEmail() == null || u.getPassword() == null ||
            u.getFullName().trim().isEmpty() || u.getEmail().trim().isEmpty() || u.getPassword().trim().isEmpty()) {
            return false; 
        }

     
        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
        if (!Pattern.matches(emailRegex, u.getEmail())) {
            return false;
        }

       
        String passwordRegex = "^(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{6,}$";
        if (!Pattern.matches(passwordRegex, u.getPassword())) {
            return false;
        }

        return true;
    }

  
    public boolean register(User u) {
        if (!isValidUser(u)) {
            return false; 
        }

        boolean f = false;
        try {
            String sql = "INSERT INTO users(full_name, email, password) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());

            int i = ps.executeUpdate();
            f = (i == 1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }

    
    public User login(String em, String psw) {
        User u = null;
        try {
            if (em == null || psw == null || em.trim().isEmpty() || psw.trim().isEmpty()) {
                return null; 
            }

            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, em);
            ps.setString(2, psw);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                u = new User();
                u.setId(rs.getInt(1));
                u.setFullName(rs.getString(2));
                u.setEmail(rs.getString(3));
                u.setPassword(rs.getString(4));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return u;
    }
    public User getUserByEmail(String email) {
        try {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE email = ?");
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String resetPassword(String email) {
        String newPassword = generateRandomPassword();
        try {
            PreparedStatement stmt = conn.prepareStatement("UPDATE users SET password = ? WHERE email = ?");
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return newPassword;
    }

    private String generateRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        Random random = new Random();
        
        for (int i = 0; i < 8; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
}
