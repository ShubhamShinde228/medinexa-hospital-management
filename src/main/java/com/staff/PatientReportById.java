package com.staff;

import java.io.IOException;
import com.dao.AdmitPatientDAO;
import com.db.DBConnect;
import com.entity.AdmitPatient;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Paragraph;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/generatePatientReportbyid")
public class PatientReportById extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String patientIdStr = request.getParameter("id");
        if (patientIdStr == null || patientIdStr.isEmpty()) {
            response.getWriter().println("Invalid patient ID");
            return;
        }

        int patientId;
        try {
            patientId = Integer.parseInt(patientIdStr);
        } catch (NumberFormatException e) {
            response.getWriter().println("Invalid patient ID format");
            return;
        }

        AdmitPatientDAO patientDAO = new AdmitPatientDAO(DBConnect.getConn());
        AdmitPatient patient = patientDAO.getPatientById(patientId);

        if (patient == null) {
            response.getWriter().println("Patient not found");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Patient_Report_" + patientId + ".pdf");

        try (ServletOutputStream out = response.getOutputStream()) {
            PdfWriter writer = new PdfWriter(out);
            PdfDocument pdfDoc = new PdfDocument(writer);
            Document document = new Document(pdfDoc);

            document.add(new Paragraph("Patient Report").setFontSize(16));

      
            float[] columnWidths = {150f, 250f};
            Table table = new Table(columnWidths);

            table.addCell("Patient ID");
            table.addCell(String.valueOf(patient.getId()));

            table.addCell("Full Name");
            table.addCell(patient.getName());

            table.addCell("Disease");
            table.addCell(patient.getDisease());

            table.addCell("Address");
            table.addCell(patient.getAddress());

            table.addCell("Admitted Date");
            table.addCell(patient.getAdmittedDate());

            table.addCell("Discharge Date");
            table.addCell((patient.getDischargeDate() != null) ? patient.getDischargeDate() : "Not Discharged");

            table.addCell("Payment");
            table.addCell((patient.getPayment() > 0) ? String.valueOf(patient.getPayment()) : "Pending");

            document.add(table);
            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
