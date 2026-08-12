package com.dao;
import com.entity.AdmitPatient;
import java.sql.*;
import java.util.*;

public class AdmitPatientDAO {
    private Connection conn;

    public AdmitPatientDAO(Connection conn) {
        this.conn = conn;
    }

    public boolean admitPatient(AdmitPatient patient) {
        boolean f = false;
        try {
            String query = "INSERT INTO admitted_patients(name, disease, address, admitted_date, doctor_id, room_number, patient_status) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, patient.getName());
            ps.setString(2, patient.getDisease());
            ps.setString(3, patient.getAddress());
            ps.setString(4, patient.getAdmittedDate());
            ps.setInt(5, patient.getDoctorId());
            ps.setString(6, patient.getRoomNumber());
            ps.setString(7, patient.getPatientStatus() != null ? patient.getPatientStatus() : "ADMITTED");
            int rows = ps.executeUpdate();
            if (rows > 0) {
                f = true;
                if (patient.getRoomNumber() != null && !patient.getRoomNumber().trim().isEmpty()) {
                    new WardDao(conn).incrementOccupancyByRoom(patient.getRoomNumber());
                }
                try {
                    new NotificationDao(conn).broadcast("ADMIN", "Patient Admitted: " + patient.getName() + " (Room: " + patient.getRoomNumber() + ")", "admin/ward_occupancy.jsp");
                } catch (Exception ignored) {}
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }
    
    public boolean dischargePatient(int id, String dischargeDate, double payment) {
        boolean f = false;
        try {
            AdmitPatient p = getPatientById(id);

            String query = "UPDATE admitted_patients SET discharge_date = ?, payment = ?, patient_status = 'DISCHARGED' WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, dischargeDate);
            ps.setDouble(2, payment);
            ps.setInt(3, id);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                f = true;
                if (p != null && p.getRoomNumber() != null) {
                    new WardDao(conn).decrementOccupancyByRoom(p.getRoomNumber());
                }
                try {
                    new NotificationDao(conn).broadcast("ADMIN", "Patient Discharged: " + (p != null ? p.getName() : ("ID #" + id)), "admin/ward_occupancy.jsp");
                } catch (Exception ignored) {}
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }

    public List<AdmitPatient> getAdmittedPatients() {
        List<AdmitPatient> list = new ArrayList<>();
        try {
            String query = "SELECT * FROM admitted_patients ORDER BY id DESC";
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AdmitPatient p = new AdmitPatient(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("disease"),
                    rs.getString("address"),
                    rs.getString("admitted_date"),
                    rs.getString("discharge_date"),
                    rs.getDouble("payment")
                );
                p.setDoctorId(rs.getInt("doctor_id"));
                p.setRoomNumber(rs.getString("room_number"));
                p.setPatientStatus(rs.getString("patient_status"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updatePatient(int id, String name, String disease, String address) {
        boolean result = false;
        try {
            String query = "UPDATE admitted_patients SET name=?, disease=?, address=? WHERE id=?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, name);
            pstmt.setString(2, disease);
            pstmt.setString(3, address);
            pstmt.setInt(4, id);

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                result = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public boolean deletePatient(int id) {
        boolean result = false;
        try {
            String query = "DELETE FROM admitted_patients WHERE id=?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, id);

            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                result = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public AdmitPatient getPatientById(int id) {
        AdmitPatient patient = null;
        try {
            String query = "SELECT * FROM admitted_patients WHERE id = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                patient = new AdmitPatient();
                patient.setId(rs.getInt("id"));
                patient.setName(rs.getString("name"));
                patient.setDisease(rs.getString("disease"));
                patient.setAddress(rs.getString("address"));
                patient.setAdmittedDate(rs.getString("admitted_date"));
                patient.setDischargeDate(rs.getString("discharge_date"));
                patient.setPayment(rs.getDouble("payment"));
                patient.setDoctorId(rs.getInt("doctor_id"));
                patient.setRoomNumber(rs.getString("room_number"));
                patient.setPatientStatus(rs.getString("patient_status"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return patient;
    }

    public boolean updatePatientStatus(int id, String status) {
        boolean f = false;
        try {
            String query = "UPDATE admitted_patients SET patient_status=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, status);
            ps.setInt(2, id);
            int i = ps.executeUpdate();
            if (i == 1) {
                f = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return f;
    }

    public List<AdmitPatient> getAdmittedPatientsOnly() {
        List<AdmitPatient> list = new ArrayList<>();
        try {
            String query = "SELECT * FROM admitted_patients WHERE patient_status='ADMITTED' OR patient_status='BILLING_PENDING' ORDER BY id DESC";
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AdmitPatient p = new AdmitPatient(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("disease"),
                    rs.getString("address"),
                    rs.getString("admitted_date"),
                    rs.getString("discharge_date"),
                    rs.getDouble("payment")
                );
                p.setDoctorId(rs.getInt("doctor_id"));
                p.setRoomNumber(rs.getString("room_number"));
                p.setPatientStatus(rs.getString("patient_status"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
