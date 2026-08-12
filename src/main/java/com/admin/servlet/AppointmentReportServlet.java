package com.admin.servlet;

import java.io.IOException;
import java.io.OutputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.dao.AppointmentDao;
import com.db.DBConnect;
import com.entity.Appointment;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;

@WebServlet("/generateAppointmentReport")
public class AppointmentReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Appointment_Report.pdf");
        
        int appointmentId = Integer.parseInt(request.getParameter("id"));
        AppointmentDao appointmentDao = new AppointmentDao(DBConnect.getConn());
        Appointment appointment = appointmentDao.getAppointmentById(appointmentId);
        
        if (appointment == null) {
            response.getWriter().write("No appointment found for the given ID");
            return;
        }

        try (OutputStream out = response.getOutputStream()) {
            PdfDocument pdfDoc = new PdfDocument(new PdfWriter(out));
            Document document = new Document(pdfDoc);
            
            document.add(new Paragraph("Hospital System - Appointment Report").setFontSize(16));
            
            Table table = new Table(2);
            table.addCell(new Cell().add(new Paragraph("Field")));
            table.addCell(new Cell().add(new Paragraph("Details")));
            
            table.addCell(new Cell().add(new Paragraph("ID")));
            table.addCell(new Cell().add(new Paragraph(String.valueOf(appointment.getId()))));
            
            table.addCell(new Cell().add(new Paragraph("Full Name")));
            table.addCell(new Cell().add(new Paragraph(appointment.getFullname())));
            
            table.addCell(new Cell().add(new Paragraph("Email")));
            table.addCell(new Cell().add(new Paragraph(appointment.getEmail())));
            
            table.addCell(new Cell().add(new Paragraph("Phone Number")));
            table.addCell(new Cell().add(new Paragraph(appointment.getPhNo())));
            
            table.addCell(new Cell().add(new Paragraph("Age")));
            table.addCell(new Cell().add(new Paragraph(appointment.getAge())));
            
            table.addCell(new Cell().add(new Paragraph("Appointment Date")));
            table.addCell(new Cell().add(new Paragraph(appointment.getAppoinDate())));
            
            table.addCell(new Cell().add(new Paragraph("Disease")));
            table.addCell(new Cell().add(new Paragraph(appointment.getDiseases())));
            
            table.addCell(new Cell().add(new Paragraph("Address")));
            table.addCell(new Cell().add(new Paragraph(appointment.getAddress())));
            
            table.addCell(new Cell().add(new Paragraph("Status")));
            table.addCell(new Cell().add(new Paragraph(appointment.getStatus())));
            
            document.add(table);
            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
