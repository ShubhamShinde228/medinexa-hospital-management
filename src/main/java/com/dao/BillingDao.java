package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.entity.Billing;
import com.entity.BillingItem;

public class BillingDao {
    private Connection conn;

    public BillingDao(Connection conn) {
        this.conn = conn;
    }

    public int createBill(Billing bill) {
        int billId = -1;
        String sql = "INSERT INTO billing (admission_id, patient_name, doctor_name, admission_date, discharge_date, subtotal, discount, tax, grand_total, payment_status, invoice_number, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, bill.getAdmissionId());
            ps.setString(2, bill.getPatientName());
            ps.setString(3, bill.getDoctorName());
            ps.setString(4, bill.getAdmissionDate());
            ps.setString(5, bill.getDischargeDate());
            ps.setDouble(6, bill.getSubtotal());
            ps.setDouble(7, bill.getDiscount());
            ps.setDouble(8, bill.getTax());
            ps.setDouble(9, bill.getGrandTotal());
            ps.setString(10, bill.getPaymentStatus() != null ? bill.getPaymentStatus() : "PENDING");
            ps.setString(11, bill.getInvoiceNumber());
            ps.setString(12, bill.getNotes());

            int affected = ps.executeUpdate();
            if (affected == 1) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        billId = rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return billId;
    }

    public boolean addBillingItem(BillingItem item) {
        String sql = "INSERT INTO billing_items (bill_id, item_type, description, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, item.getBillId());
            ps.setString(2, item.getItemType());
            ps.setString(3, item.getDescription());
            ps.setInt(4, item.getQuantity());
            ps.setDouble(5, item.getUnitPrice());
            ps.setDouble(6, item.getTotalPrice());
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Billing getBillById(int id) {
        Billing bill = null;
        String sql = "SELECT * FROM billing WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    bill = mapBilling(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bill;
    }

    public List<BillingItem> getBillingItems(int billId) {
        List<BillingItem> list = new ArrayList<>();
        String sql = "SELECT * FROM billing_items WHERE bill_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, billId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BillingItem item = new BillingItem();
                    item.setId(rs.getInt("id"));
                    item.setBillId(rs.getInt("bill_id"));
                    item.setItemType(rs.getString("item_type"));
                    item.setDescription(rs.getString("description"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getDouble("unit_price"));
                    item.setTotalPrice(rs.getDouble("total_price"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateBillPaymentStatus(int billId, String status) {
        String sql = "UPDATE billing SET payment_status = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, billId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public String generateInvoiceNumber() {
        return "INV-" + new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) + "-" + (int)(Math.random() * 90000 + 10000);
    }

    // --- Alias methods for backward/subagent compatibility ---
    public int createBilling(Billing bill, List<BillingItem> items) {
        int billId = createBill(bill);
        if (billId > 0 && items != null) {
            for (BillingItem item : items) {
                item.setBillId(billId);
                addBillingItem(item);
            }
        }
        return billId;
    }

    public Billing getBillingById(int id) {
        return getBillById(id);
    }

    public Billing getBillingByAdmissionId(int admissionId) {
        Billing bill = null;
        String sql = "SELECT * FROM billing WHERE admission_id = ? ORDER BY id DESC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, admissionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    bill = mapBilling(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bill;
    }

    public List<BillingItem> getBillingItemsByBillId(int billId) {
        return getBillingItems(billId);
    }

    public boolean updatePaymentStatus(int billId, String status) {
        return updateBillPaymentStatus(billId, status);
    }

    private Billing mapBilling(ResultSet rs) throws Exception {
        Billing bill = new Billing();
        bill.setId(rs.getInt("id"));
        bill.setAdmissionId(rs.getInt("admission_id"));
        bill.setPatientName(rs.getString("patient_name"));
        bill.setDoctorName(rs.getString("doctor_name"));
        bill.setAdmissionDate(rs.getString("admission_date"));
        bill.setDischargeDate(rs.getString("discharge_date"));
        bill.setSubtotal(rs.getDouble("subtotal"));
        bill.setDiscount(rs.getDouble("discount"));
        bill.setTax(rs.getDouble("tax"));
        bill.setGrandTotal(rs.getDouble("grand_total"));
        bill.setPaymentStatus(rs.getString("payment_status"));
        bill.setInvoiceNumber(rs.getString("invoice_number"));
        bill.setNotes(rs.getString("notes"));
        bill.setCreatedAt(rs.getString("created_at"));
        return bill;
    }
}
