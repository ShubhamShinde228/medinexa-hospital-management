<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.db.DBConnect, com.entity.User, com.payment.PaymentConfig, com.payment.PaymentUtils, java.sql.Connection" %>
<%
    /* -------------------------------------------------------
     * DIAGNOSTIC PAGE — visit /Hospital_System/payment_test.jsp
     * Remove this file before production deployment!
     * ------------------------------------------------------- */
    response.setContentType("application/json");
    StringBuilder sb = new StringBuilder();
    sb.append("{\n");

    // 1. Session check
    User userObj = (User) session.getAttribute("userObj");
    User staffObj = (User) session.getAttribute("staffObj");
    sb.append("  \"userObj_in_session\": ").append(userObj != null).append(",\n");
    sb.append("  \"staffObj_in_session\": ").append(staffObj != null).append(",\n");
    if (userObj != null) {
        sb.append("  \"user_fullname\": \"").append(userObj.getFullName()).append("\",\n");
        sb.append("  \"user_id\": ").append(userObj.getId()).append(",\n");
    }

    // 2. DB connection check
    boolean dbOk = false;
    String dbError = null;
    try {
        Connection conn = DBConnect.getConn();
        if (conn != null && conn.isValid(3)) {
            dbOk = true;
        } else {
            dbError = "Connection is null or invalid";
        }
    } catch (Exception e) {
        dbError = e.getClass().getSimpleName() + ": " + e.getMessage();
    }
    sb.append("  \"db_connected\": ").append(dbOk).append(",\n");
    if (dbError != null) sb.append("  \"db_error\": \"").append(dbError.replace("\"","'")).append("\",\n");

    // 3. Payment config check
    String keyId = PaymentConfig.getKeyId();
    String keySecret = PaymentConfig.getKeySecret();
    sb.append("  \"razorpay_configured\": ").append(PaymentConfig.isConfigured()).append(",\n");
    sb.append("  \"key_id_prefix\": \"").append(keyId != null && keyId.length() > 10 ? keyId.substring(0, 10) + "..." : keyId).append("\",\n");
    sb.append("  \"key_secret_set\": ").append(keySecret != null && !keySecret.isBlank()).append(",\n");

    // 4. Razorpay reachability check (simple ping — creates a ₹1 test order)
    boolean razorpayReachable = false;
    String razorpayError = null;
    try {
        String testResp = PaymentUtils.postRazorpayOrder(100, "DIAGNOSTIC-TEST");
        if (testResp != null) {
            String testId = PaymentUtils.extractJsonValue(testResp, "id");
            razorpayReachable = (testId != null && testId.startsWith("order_"));
            if (!razorpayReachable) razorpayError = testResp.replace("\"", "'");
        } else {
            razorpayError = "null response from Razorpay (network/firewall issue?)";
        }
    } catch (Exception e) {
        razorpayError = e.getClass().getSimpleName() + ": " + e.getMessage();
    }
    sb.append("  \"razorpay_reachable\": ").append(razorpayReachable).append(",\n");
    if (razorpayError != null) sb.append("  \"razorpay_error\": \"").append(razorpayError.replace("\"","'")).append("\",\n");

    // 5. Appointment table check
    boolean apptTableOk = false;
    String apptTableError = null;
    try {
        Connection conn = DBConnect.getConn();
        java.sql.PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM appointment");
        java.sql.ResultSet rs = ps.executeQuery();
        if (rs.next()) { apptTableOk = true; }
        rs.close(); ps.close();
    } catch (Exception e) {
        apptTableError = e.getClass().getSimpleName() + ": " + e.getMessage();
    }
    sb.append("  \"appointment_table_accessible\": ").append(apptTableOk).append(",\n");
    if (apptTableError != null) sb.append("  \"appointment_table_error\": \"").append(apptTableError.replace("\"","'")).append("\",\n");

    // 6. Payments table check
    boolean payTableOk = false;
    String payTableError = null;
    try {
        Connection conn = DBConnect.getConn();
        java.sql.PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM payments");
        java.sql.ResultSet rs = ps.executeQuery();
        if (rs.next()) { payTableOk = true; }
        rs.close(); ps.close();
    } catch (Exception e) {
        payTableError = e.getClass().getSimpleName() + ": " + e.getMessage();
    }
    sb.append("  \"payments_table_accessible\": ").append(payTableOk).append(",\n");
    if (payTableError != null) sb.append("  \"payments_table_error\": \"").append(payTableError.replace("\"","'")).append("\",\n");

    sb.append("  \"status\": \"diagnostic complete\"\n}");
    out.print(sb.toString());
%>
