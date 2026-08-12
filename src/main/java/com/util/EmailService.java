package com.util;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;


/**
 * EmailService — sends HTML emails via Gmail SMTP.
 * Configure your Gmail App Password in src/main/resources/application.properties:
 *   email.host=smtp.gmail.com
 *   email.port=587
 *   email.username=your_gmail@gmail.com
 *   email.password=your_app_password   (NOT your Gmail login password)
 *
 * To get an App Password: Google Account → Security → 2-Step Verification → App passwords
 */
public class EmailService {

    private static final String HOST;
    private static final String PORT;
    private static final String USERNAME;
    private static final String PASSWORD;
    private static final String FROM_NAME = "HospitalCare";

    static {
        java.util.Properties config = new java.util.Properties();
        try (java.io.InputStream in = EmailService.class.getClassLoader()
                .getResourceAsStream("application.properties")) {
            if (in != null) config.load(in);
        } catch (Exception ignored) {}

        HOST     = config.getProperty("email.host",     "smtp.gmail.com");
        PORT     = config.getProperty("email.port",     "587");
        USERNAME = config.getProperty("email.username", "");
        PASSWORD = config.getProperty("email.password", "");
    }

    /**
     * Send a plain HTML email.
     * Returns true if sent, false if credentials not configured or sending fails.
     */
    public static boolean sendHtml(String toEmail, String subject, String htmlBody) {
        if (USERNAME == null || USERNAME.isBlank() || PASSWORD == null || PASSWORD.isBlank()) {
            System.out.println("[EmailService] Email not configured — skipping send to: " + toEmail);
            return false;
        }
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", HOST);
            props.put("mail.smtp.port", PORT);
            props.put("mail.smtp.ssl.trust", HOST);

            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(USERNAME, PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USERNAME, FROM_NAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html; charset=utf-8");
            Transport.send(message);
            System.out.println("[EmailService] Email sent to: " + toEmail);
            return true;
        } catch (Exception e) {
            System.err.println("[EmailService] Failed to send email to " + toEmail + ": " + e.getMessage());
            return false;
        }
    }

    // ── Pre-built templates ──────────────────────────────────────────────────

    public static boolean sendAppointmentConfirmation(String toEmail, String patientName,
                                                       String doctorName, String date, String status) {
        String emoji   = "CONFIRMED".equalsIgnoreCase(status) ? "✅" : "❌";
        String color   = "CONFIRMED".equalsIgnoreCase(status) ? "#198754" : "#dc3545";
        String subject = emoji + " Appointment " + status + " — HospitalCare";
        String html    = "<div style='font-family:Arial,sans-serif;max-width:600px;margin:auto;border:1px solid #ddd;border-radius:8px;overflow:hidden'>"
            + "<div style='background:" + color + ";padding:24px;text-align:center'>"
            + "<h1 style='color:#fff;margin:0'>🏥 HospitalCare</h1></div>"
            + "<div style='padding:28px'>"
            + "<p style='font-size:16px'>Dear <strong>" + patientName + "</strong>,</p>"
            + "<p>Your appointment status has been updated:</p>"
            + "<table style='width:100%;border-collapse:collapse;margin:16px 0'>"
            + "<tr><td style='padding:10px;background:#f8f9fa;border:1px solid #dee2e6'><strong>Doctor</strong></td>"
            + "<td style='padding:10px;border:1px solid #dee2e6'>" + doctorName + "</td></tr>"
            + "<tr><td style='padding:10px;background:#f8f9fa;border:1px solid #dee2e6'><strong>Date</strong></td>"
            + "<td style='padding:10px;border:1px solid #dee2e6'>" + date + "</td></tr>"
            + "<tr><td style='padding:10px;background:#f8f9fa;border:1px solid #dee2e6'><strong>Status</strong></td>"
            + "<td style='padding:10px;border:1px solid #dee2e6;color:" + color + ";font-weight:bold'>" + status + "</td></tr>"
            + "</table>"
            + "<p style='color:#555;font-size:14px'>If you have any questions, please contact the hospital reception.</p>"
            + "</div>"
            + "<div style='background:#f8f9fa;padding:14px;text-align:center;font-size:12px;color:#777'>"
            + "© 2024 HospitalCare. All rights reserved.</div></div>";
        return sendHtml(toEmail, subject, html);
    }

    public static boolean sendPrescriptionReady(String toEmail, String patientName, int prescriptionId) {
        String subject = "💊 Your Prescription is Ready — HospitalCare";
        String html    = "<div style='font-family:Arial,sans-serif;max-width:600px;margin:auto;border:1px solid #ddd;border-radius:8px;overflow:hidden'>"
            + "<div style='background:#198754;padding:24px;text-align:center'>"
            + "<h1 style='color:#fff;margin:0'>🏥 HospitalCare</h1></div>"
            + "<div style='padding:28px'>"
            + "<p>Dear <strong>" + patientName + "</strong>,</p>"
            + "<p>Your doctor has written a new prescription for you.</p>"
            + "<p>Log in to the patient portal to view and download your prescription (PDF).</p>"
            + "<div style='text-align:center;margin-top:24px'>"
            + "<a href='#' style='background:#198754;color:#fff;padding:12px 28px;border-radius:6px;text-decoration:none;font-weight:bold'>View Prescription</a>"
            + "</div></div>"
            + "<div style='background:#f8f9fa;padding:14px;text-align:center;font-size:12px;color:#777'>"
            + "© 2024 HospitalCare.</div></div>";
        return sendHtml(toEmail, subject, html);
    }
}
