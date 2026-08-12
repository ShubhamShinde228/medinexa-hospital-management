package com.feature.servlet;

import com.dao.PrescriptionDao;
import com.db.DBConnect;
import com.entity.Prescription;
import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.SolidBorder;
import com.itextpdf.layout.element.*;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.*;
import java.util.List;

/**
 * Generates a PDF prescription for download.
 * GET /prescriptionPdf?appointmentId=X
 */
@WebServlet("/prescriptionPdf")
public class PrescriptionPdfServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        } catch (Exception e) {
            response.sendError(400, "Invalid appointment ID");
            return;
        }

        PrescriptionDao dao = new PrescriptionDao(DBConnect.getConn());
        List<Prescription> prescriptions = dao.getPrescriptionsByAppointmentId(appointmentId);

        if (prescriptions.isEmpty()) {
            response.sendError(404, "No prescriptions found for this appointment.");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=prescription_" + appointmentId + ".pdf");

        try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
            PdfWriter writer  = new PdfWriter(baos);
            PdfDocument pdf   = new PdfDocument(writer);
            Document document = new Document(pdf);

            // Fonts
            PdfFont boldFont   = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);
            PdfFont normalFont = PdfFontFactory.createFont(StandardFonts.HELVETICA);
            PdfFont italicFont = PdfFontFactory.createFont(StandardFonts.HELVETICA_OBLIQUE);

            DeviceRgb green = new DeviceRgb(25, 135, 84);

            // Header
            document.add(new Paragraph("HOSPITALCARE")
                .setFont(boldFont).setFontSize(22)
                .setTextAlignment(TextAlignment.CENTER)
                .setFontColor(green));

            document.add(new Paragraph("PRESCRIPTION")
                .setFont(boldFont).setFontSize(16)
                .setTextAlignment(TextAlignment.CENTER)
                .setFontColor(ColorConstants.DARK_GRAY));

            // Divider line using a styled paragraph border
            document.add(new Paragraph(" ")
                .setBorderBottom(new SolidBorder(green, 2))
                .setMarginBottom(10));

            Prescription first = prescriptions.get(0);
            document.add(new Paragraph("Patient: " + (first.getPatientName() != null ? first.getPatientName() : "N/A"))
                .setFont(boldFont).setFontSize(13));
            if (first.getDoctorName() != null) {
                document.add(new Paragraph("Prescribed by: Dr. " + first.getDoctorName())
                    .setFont(normalFont).setFontSize(12));
            }
            document.add(new Paragraph("Appointment ID: #" + appointmentId)
                .setFont(normalFont).setFontSize(11).setFontColor(ColorConstants.GRAY));
            document.add(new Paragraph("Date: " + (first.getCreatedAt() != null
                    ? first.getCreatedAt().substring(0, 10) : ""))
                .setFont(normalFont).setFontSize(11));
            document.add(new Paragraph(" "));

            // Table of medicines
            Table table = new Table(UnitValue.createPercentArray(new float[]{2f, 1.5f, 2f, 1.2f, 3f}))
                    .setWidth(UnitValue.createPercentValue(100));

            String[] headers = {"Medicine", "Dosage", "Frequency", "Duration", "Notes"};
            for (String h : headers) {
                Cell cell = new Cell().add(new Paragraph(h).setFont(boldFont))
                    .setBackgroundColor(green).setFontColor(ColorConstants.WHITE)
                    .setPadding(8);
                table.addHeaderCell(cell);
            }

            boolean alt = false;
            for (Prescription p : prescriptions) {
                DeviceRgb rowColor = alt ? new DeviceRgb(240, 248, 244) : new DeviceRgb(255, 255, 255);
                String[] vals = {
                    p.getMedicineName(),
                    p.getDosage() != null ? p.getDosage() : "",
                    p.getFrequency() != null ? p.getFrequency() : "",
                    p.getDurationDays() + " days",
                    p.getNotes() != null ? p.getNotes() : ""
                };
                for (String v : vals) {
                    table.addCell(new Cell()
                        .add(new Paragraph(v).setFont(normalFont))
                        .setBackgroundColor(rowColor)
                        .setPadding(7));
                }
                alt = !alt;
            }
            document.add(table);

            document.add(new Paragraph("\n\nNote: Take medicines as prescribed. Contact your doctor if you experience any side effects.")
                .setFont(italicFont).setFontSize(10).setFontColor(ColorConstants.GRAY));

            document.add(new Paragraph("\n\n________________________________\nDoctor's Signature")
                .setFont(normalFont).setTextAlignment(TextAlignment.RIGHT).setFontSize(11));

            document.close();

            byte[] pdfBytes = baos.toByteArray();
            response.setContentLength(pdfBytes.length);
            try (OutputStream out = response.getOutputStream()) {
                out.write(pdfBytes);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error generating PDF: " + e.getMessage());
        }
    }
}
