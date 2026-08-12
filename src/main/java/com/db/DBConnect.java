package com.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DBConnect {
    private static final String URL = "jdbc:mysql://localhost:3306/hms_2?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Kolkata";
    private static final String USER = "root";
    private static final String PASS = "shubham@1234";

    private static Connection conn;

    public static synchronized Connection getConn() {
        try {
            if (conn == null || conn.isClosed() || !conn.isValid(3)) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(URL, USER, PASS);
                initTables(conn);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }

    private static void initTables(Connection connection) {
        try (Statement st = connection.createStatement()) {
            st.execute("CREATE TABLE IF NOT EXISTS doctor_slots (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "doctor_id INT NOT NULL, " +
                       "slot_date DATE NOT NULL, " +
                       "slot_time VARCHAR(10) NOT NULL, " +
                       "is_booked BOOLEAN DEFAULT FALSE, " +
                       "appointment_id INT DEFAULT NULL, " +
                       "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                       "UNIQUE KEY uk_doctor_slot (doctor_id, slot_date, slot_time))");

            st.execute("CREATE TABLE IF NOT EXISTS wards (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "ward_name VARCHAR(255) NOT NULL, " +
                       "ward_type VARCHAR(100), " +
                       "capacity INT DEFAULT 10, " +
                       "current_occupancy INT DEFAULT 0)");

            st.execute("CREATE TABLE IF NOT EXISTS notification (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "target_role VARCHAR(50) NOT NULL, " +
                       "target_id INT DEFAULT 0, " +
                       "message TEXT NOT NULL, " +
                       "link VARCHAR(500) DEFAULT '#', " +
                       "is_read BOOLEAN DEFAULT FALSE, " +
                       "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            st.execute("CREATE TABLE IF NOT EXISTS prescription (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "appointment_id INT NOT NULL, " +
                       "patient_name VARCHAR(255), " +
                       "doctor_id INT, " +
                       "medicine_name VARCHAR(255) NOT NULL, " +
                       "dosage VARCHAR(100), " +
                       "frequency VARCHAR(100), " +
                       "duration_days INT DEFAULT 1, " +
                       "notes TEXT, " +
                       "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            st.execute("CREATE TABLE IF NOT EXISTS medical_history (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "user_id INT DEFAULT NULL, " +
                       "patient_name VARCHAR(255), " +
                       "appointment_id INT DEFAULT NULL, " +
                       "admission_id INT DEFAULT NULL, " +
                       "event_type VARCHAR(50) NOT NULL, " +
                       "description TEXT NOT NULL, " +
                       "event_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            st.execute("CREATE TABLE IF NOT EXISTS staff (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "full_name VARCHAR(255) NOT NULL, " +
                       "dob VARCHAR(100), " +
                       "qualification VARCHAR(255), " +
                       "specialist VARCHAR(255), " +
                       "mobno VARCHAR(100), " +
                       "email VARCHAR(255) NOT NULL, " +
                       "password VARCHAR(255) NOT NULL)");

            st.execute("CREATE TABLE IF NOT EXISTS patient_vitals (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "admission_id INT NOT NULL, " +
                       "patient_name VARCHAR(255), " +
                       "pulse_rate INT, " +
                       "blood_pressure VARCHAR(50), " +
                       "temperature_f DOUBLE, " +
                       "spo2_percentage INT, " +
                       "triage_status VARCHAR(50) DEFAULT 'STABLE', " +
                       "recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            st.execute("CREATE TABLE IF NOT EXISTS ambulance_dispatch (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "caller_name VARCHAR(255) NOT NULL, " +
                       "caller_phone VARCHAR(50) NOT NULL, " +
                       "pickup_location VARCHAR(500) NOT NULL, " +
                       "ambulance_unit VARCHAR(100) DEFAULT 'ALS-Unit 01', " +
                       "driver_name VARCHAR(100) DEFAULT 'Paramedic Ramesh', " +
                       "status VARCHAR(50) DEFAULT 'DISPATCHED', " +
                       "eta_minutes INT DEFAULT 12, " +
                       "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            st.execute("CREATE TABLE IF NOT EXISTS virtual_queue (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "doctor_id INT NOT NULL, " +
                       "user_id INT NOT NULL, " +
                       "patient_name VARCHAR(255) NOT NULL, " +
                       "queue_number INT NOT NULL, " +
                       "status VARCHAR(50) DEFAULT 'WAITING', " +
                       "estimated_wait_mins INT DEFAULT 15, " +
                       "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            st.execute("CREATE TABLE IF NOT EXISTS blood_bank (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "blood_group VARCHAR(10) UNIQUE NOT NULL, " +
                       "units_available INT DEFAULT 10, " +
                       "last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)");

            // Auto-seed default blood groups if empty
            st.execute("INSERT IGNORE INTO blood_bank (blood_group, units_available) VALUES " +
                       "('A+', 15), ('A-', 8), ('B+', 20), ('B-', 5), ('O+', 25), ('O-', 12), ('AB+', 10), ('AB-', 4)");

            st.execute("CREATE TABLE IF NOT EXISTS genomic_profile (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "user_id INT NOT NULL, " +
                       "patient_name VARCHAR(255) NOT NULL, " +
                       "genetic_markers VARCHAR(500), " +
                       "severe_allergies VARCHAR(500), " +
                       "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            st.execute("CREATE TABLE IF NOT EXISTS bed_transfers (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "admission_id INT NOT NULL, " +
                       "patient_name VARCHAR(255) NOT NULL, " +
                       "current_ward VARCHAR(100), " +
                       "target_ward VARCHAR(100) DEFAULT 'ICU - Critical Care Unit', " +
                       "transfer_reason VARCHAR(500), " +
                       "status VARCHAR(50) DEFAULT 'PENDING_TRANSFER', " +
                       "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            st.execute("CREATE TABLE IF NOT EXISTS medical_staff (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "full_name VARCHAR(255) NOT NULL, " +
                       "email VARCHAR(255) UNIQUE NOT NULL, " +
                       "password VARCHAR(255) NOT NULL, " +
                       "license_no VARCHAR(100), " +
                       "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            st.execute("CREATE TABLE IF NOT EXISTS medical_inventory (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "medicine_name VARCHAR(255) NOT NULL, " +
                       "generic_name VARCHAR(255), " +
                       "batch_no VARCHAR(100), " +
                       "stock_quantity INT DEFAULT 50, " +
                       "expiry_date VARCHAR(50), " +
                       "cold_chain_required BOOLEAN DEFAULT FALSE, " +
                       "unit_price DOUBLE DEFAULT 15.0)");

            // Auto-seed default medical inventory items
            st.execute("INSERT IGNORE INTO medical_inventory (id, medicine_name, generic_name, batch_no, stock_quantity, expiry_date, cold_chain_required, unit_price) VALUES " +
                       "(1, 'Paracetamol 500mg', 'Acetaminophen', 'BATCH-2026A', 120, '2027-12-31', FALSE, 12.0), " +
                       "(2, 'Amoxicillin 250mg', 'Amoxicillin Trihydrate', 'BATCH-2026B', 45, '2027-08-15', FALSE, 35.0), " +
                       "(3, 'Insulin Glargine 100IU', 'Recombinant Human Insulin', 'BATCH-2026C', 18, '2026-11-20', TRUE, 450.0), " +
                       "(4, 'Azithromycin 500mg', 'Azithromycin Dihydrate', 'BATCH-2026D', 8, '2027-05-10', FALSE, 65.0)");

            st.execute("CREATE TABLE IF NOT EXISTS vendor_orders (" +
                       "id INT AUTO_INCREMENT PRIMARY KEY, " +
                       "vendor_name VARCHAR(255) NOT NULL, " +
                       "medicine_name VARCHAR(255) NOT NULL, " +
                       "units_ordered INT DEFAULT 100, " +
                       "total_cost DOUBLE DEFAULT 1500.0, " +
                       "po_status VARCHAR(50) DEFAULT 'PO_DISPATCHED', " +
                       "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
        } catch (Exception ignored) {
            // Silently ignore if user has insufficient table creation privileges
        }
    }
}
