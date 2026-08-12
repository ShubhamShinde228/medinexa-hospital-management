-- ============================================================
-- Hospital Management System — Payment Schema Migration
-- Run this script against the `hms_2` database
-- ============================================================

-- 1. ALTER appointment table: add payment_status
ALTER TABLE appointment ADD COLUMN IF NOT EXISTS payment_status VARCHAR(30) DEFAULT 'PENDING_PAYMENT';

-- 2. ALTER admitted_patients table: add doctor/room/status columns
ALTER TABLE admitted_patients ADD COLUMN IF NOT EXISTS doctor_id INT NULL;
ALTER TABLE admitted_patients ADD COLUMN IF NOT EXISTS room_number VARCHAR(20) NULL;
ALTER TABLE admitted_patients ADD COLUMN IF NOT EXISTS patient_status VARCHAR(30) DEFAULT 'ADMITTED';

-- 3. DROP and RECREATE payments table (old one was disconnected)
DROP TABLE IF EXISTS payments;

CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    appointment_id INT NULL,
    admission_id INT NULL,
    bill_id INT NULL,
    payment_type VARCHAR(30) NOT NULL COMMENT 'APPOINTMENT_FEE, ADMISSION_DEPOSIT, DISCHARGE_BILL',
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'INR',
    payment_method VARCHAR(30) NOT NULL COMMENT 'RAZORPAY, CASH, UPI, CARD',
    razorpay_order_id VARCHAR(120) NULL,
    razorpay_payment_id VARCHAR(120) NULL,
    razorpay_signature VARCHAR(255) NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING, CREATED, SUCCESS, FAILED, REFUNDED',
    patient_name VARCHAR(120) NOT NULL,
    patient_email VARCHAR(120) NULL,
    receipt_number VARCHAR(50) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_pay_user (user_id),
    INDEX idx_pay_appointment (appointment_id),
    INDEX idx_pay_admission (admission_id),
    INDEX idx_pay_bill (bill_id),
    INDEX idx_pay_status (status),
    INDEX idx_pay_type (payment_type),
    INDEX idx_pay_date (created_at),
    UNIQUE KEY uk_razorpay_order (razorpay_order_id),
    UNIQUE KEY uk_receipt (receipt_number)
);

-- 4. CREATE billing table
CREATE TABLE IF NOT EXISTS billing (
    id INT AUTO_INCREMENT PRIMARY KEY,
    admission_id INT NOT NULL,
    patient_name VARCHAR(120) NOT NULL,
    doctor_name VARCHAR(120) NULL,
    admission_date VARCHAR(30) NULL,
    discharge_date VARCHAR(30) NULL,
    subtotal DECIMAL(10,2) DEFAULT 0,
    discount DECIMAL(10,2) DEFAULT 0,
    tax DECIMAL(10,2) DEFAULT 0,
    grand_total DECIMAL(10,2) DEFAULT 0,
    payment_status VARCHAR(30) DEFAULT 'PENDING' COMMENT 'PENDING, PAID, PARTIAL',
    invoice_number VARCHAR(50) NULL,
    notes TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_bill_admission (admission_id),
    INDEX idx_bill_status (payment_status),
    UNIQUE KEY uk_invoice (invoice_number)
);

-- 5. CREATE billing_items table
CREATE TABLE IF NOT EXISTS billing_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    item_type VARCHAR(30) NOT NULL COMMENT 'DOCTOR_FEE, ROOM_CHARGE, MEDICINE, LAB_TEST, ADMISSION_CHARGE, OTHER',
    description VARCHAR(200) NOT NULL,
    quantity INT DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES billing(id) ON DELETE CASCADE
);
