package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.entity.Payment;

public class PaymentDao {
    private final Connection conn;

    public PaymentDao(Connection conn) {
        this.conn = conn;
    }

    public int savePayment(Payment p) {
        String sql = "INSERT INTO payments (user_id, appointment_id, admission_id, bill_id, payment_type, amount, currency, payment_method, razorpay_order_id, razorpay_payment_id, razorpay_signature, status, patient_name, patient_email, receipt_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (p.getUserId() == null) {
                ps.setNull(1, java.sql.Types.INTEGER);
            } else {
                ps.setInt(1, p.getUserId());
            }
            if (p.getAppointmentId() == null) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, p.getAppointmentId());
            }
            if (p.getAdmissionId() == null) {
                ps.setNull(3, java.sql.Types.INTEGER);
            } else {
                ps.setInt(3, p.getAdmissionId());
            }
            if (p.getBillId() == null) {
                ps.setNull(4, java.sql.Types.INTEGER);
            } else {
                ps.setInt(4, p.getBillId());
            }
            ps.setString(5, p.getPaymentType());
            ps.setDouble(6, p.getAmount());
            ps.setString(7, p.getCurrency());
            ps.setString(8, p.getPaymentMethod());
            ps.setString(9, p.getRazorpayOrderId());
            ps.setString(10, p.getRazorpayPaymentId());
            ps.setString(11, p.getRazorpaySignature());
            ps.setString(12, p.getStatus());
            ps.setString(13, p.getPatientName());
            ps.setString(14, p.getPatientEmail());
            ps.setString(15, p.getReceiptNumber());

            int affected = ps.executeUpdate();
            if (affected > 0) {
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

    public boolean updatePaymentVerification(String orderId, String paymentId, String signature, String status) {
        String sql = "UPDATE payments SET razorpay_payment_id = ?, razorpay_signature = ?, status = ? WHERE razorpay_order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentId);
            ps.setString(2, signature);
            ps.setString(3, status);
            ps.setString(4, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Payment getPaymentByOrderId(String orderId) {
        String sql = "SELECT * FROM payments WHERE razorpay_order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapPayment(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Payment> getPaymentsByUser(int userId) {
        String sql = "SELECT * FROM payments WHERE user_id = ? ORDER BY id DESC";
        List<Payment> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPayment(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Payment> getPaymentsByAppointment(int appointmentId) {
        String sql = "SELECT * FROM payments WHERE appointment_id = ? AND status = 'SUCCESS'";
        List<Payment> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPayment(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Payment> getPaymentsByAdmission(int admissionId) {
        String sql = "SELECT * FROM payments WHERE admission_id = ? ORDER BY id DESC";
        List<Payment> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, admissionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPayment(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Payment> getAllPayments() {
        String sql = "SELECT * FROM payments ORDER BY id DESC";
        List<Payment> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapPayment(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM payments WHERE status = 'SUCCESS'";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getTodayRevenue() {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM payments WHERE status = 'SUCCESS' AND DATE(created_at) = CURDATE()";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getMonthlyRevenue() {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM payments WHERE status = 'SUCCESS' AND MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM payments WHERE status = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Payment> getPaymentsByDateRange(String from, String to) {
        String sql = "SELECT * FROM payments WHERE DATE(created_at) BETWEEN ? AND ? ORDER BY id DESC";
        List<Payment> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, from);
            ps.setString(2, to);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapPayment(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Payment mapPayment(ResultSet rs) throws Exception {
        Payment p = new Payment();
        p.setId(rs.getInt("id"));
        
        int userId = rs.getInt("user_id");
        p.setUserId(rs.wasNull() ? null : userId);
        
        int appointmentId = rs.getInt("appointment_id");
        p.setAppointmentId(rs.wasNull() ? null : appointmentId);
        
        int admissionId = rs.getInt("admission_id");
        p.setAdmissionId(rs.wasNull() ? null : admissionId);
        
        int billId = rs.getInt("bill_id");
        p.setBillId(rs.wasNull() ? null : billId);
        
        p.setPaymentType(rs.getString("payment_type"));
        p.setAmount(rs.getDouble("amount"));
        p.setCurrency(rs.getString("currency"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setRazorpayOrderId(rs.getString("razorpay_order_id"));
        p.setRazorpayPaymentId(rs.getString("razorpay_payment_id"));
        p.setRazorpaySignature(rs.getString("razorpay_signature"));
        p.setStatus(rs.getString("status"));
        p.setPatientName(rs.getString("patient_name"));
        p.setPatientEmail(rs.getString("patient_email"));
        p.setReceiptNumber(rs.getString("receipt_number"));
        p.setCreatedAt(rs.getString("created_at"));
        p.setUpdatedAt(rs.getString("updated_at"));
        return p;
    }
}
