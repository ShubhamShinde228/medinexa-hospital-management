package com.dao;

import com.entity.PatientVitals;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientVitalsDao {
    private Connection conn;

    public PatientVitalsDao(Connection conn) {
        this.conn = conn;
    }

    public boolean recordVitals(PatientVitals v) {
        try {
            String sql = "INSERT INTO patient_vitals (admission_id, patient_name, pulse_rate, blood_pressure, temperature_f, spo2_percentage, triage_status) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, v.getAdmissionId());
            ps.setString(2, v.getPatientName());
            ps.setInt(3, v.getPulseRate());
            ps.setString(4, v.getBloodPressure());
            ps.setDouble(5, v.getTemperatureF());
            ps.setInt(6, v.getSpo2Percentage());
            ps.setString(7, v.getTriageStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<PatientVitals> getAllRecentVitals() {
        List<PatientVitals> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM patient_vitals ORDER BY id DESC LIMIT 50";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PatientVitals v = new PatientVitals();
                v.setId(rs.getInt("id"));
                v.setAdmissionId(rs.getInt("admission_id"));
                v.setPatientName(rs.getString("patient_name"));
                v.setPulseRate(rs.getInt("pulse_rate"));
                v.setBloodPressure(rs.getString("blood_pressure"));
                v.setTemperatureF(rs.getDouble("temperature_f"));
                v.setSpo2Percentage(rs.getInt("spo2_percentage"));
                v.setTriageStatus(rs.getString("triage_status"));
                v.setRecordedAt(rs.getString("recorded_at"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PatientVitals> getVitalsByAdmissionId(int admissionId) {
        List<PatientVitals> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM patient_vitals WHERE admission_id=? ORDER BY id DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, admissionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PatientVitals v = new PatientVitals();
                v.setId(rs.getInt("id"));
                v.setAdmissionId(rs.getInt("admission_id"));
                v.setPatientName(rs.getString("patient_name"));
                v.setPulseRate(rs.getInt("pulse_rate"));
                v.setBloodPressure(rs.getString("blood_pressure"));
                v.setTemperatureF(rs.getDouble("temperature_f"));
                v.setSpo2Percentage(rs.getInt("spo2_percentage"));
                v.setTriageStatus(rs.getString("triage_status"));
                v.setRecordedAt(rs.getString("recorded_at"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countCriticalPatients() {
        try {
            String sql = "SELECT COUNT(DISTINCT admission_id) FROM patient_vitals WHERE triage_status='CRITICAL'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
