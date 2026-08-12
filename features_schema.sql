-- ============================================================
-- Hospital Management System — 7 New Features Schema
-- Run this script against the `hms_2` database
-- ============================================================

-- 1. Doctor Slot-Based Calendar Booking
CREATE TABLE IF NOT EXISTS doctor_slots (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    slot_date DATE NOT NULL,
    slot_time VARCHAR(10) NOT NULL,
    is_booked BOOLEAN DEFAULT FALSE,
    appointment_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_slot_doctor (doctor_id),
    INDEX idx_slot_date (slot_date),
    UNIQUE KEY uk_doctor_slot (doctor_id, slot_date, slot_time)
);

-- 2. Digital Prescriptions
CREATE TABLE IF NOT EXISTS prescription (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    patient_name VARCHAR(255),
    doctor_id INT,
    medicine_name VARCHAR(255) NOT NULL,
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    duration_days INT DEFAULT 1,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_presc_appointment (appointment_id),
    INDEX idx_presc_doctor (doctor_id)
);

-- 3. In-App Notification Center
CREATE TABLE IF NOT EXISTS notification (
    id INT AUTO_INCREMENT PRIMARY KEY,
    target_role ENUM('ADMIN','DOCTOR','STAFF','USER') NOT NULL,
    target_id INT DEFAULT NULL,
    message TEXT NOT NULL,
    link VARCHAR(500) DEFAULT '#',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_notif_role (target_role, target_id),
    INDEX idx_notif_read (is_read)
);

-- 4. Patient Medical History / Timeline
CREATE TABLE IF NOT EXISTS medical_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT DEFAULT NULL,
    patient_name VARCHAR(255),
    appointment_id INT DEFAULT NULL,
    admission_id INT DEFAULT NULL,
    event_type ENUM('APPOINTMENT','ADMISSION','PRESCRIPTION','LAB','DISCHARGE','PAYMENT','NOTE') NOT NULL,
    description TEXT NOT NULL,
    event_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_mh_user (user_id),
    INDEX idx_mh_appointment (appointment_id),
    INDEX idx_mh_date (event_date)
);

-- 5. Email notification config (optional log table)
CREATE TABLE IF NOT EXISTS email_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipient_email VARCHAR(255) NOT NULL,
    subject VARCHAR(500),
    status ENUM('SENT','FAILED') DEFAULT 'SENT',
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
