package com.admin.servlet;

import java.io.IOException;
import java.util.List;

import com.dao.DoctorDao;
import com.entity.Doctor;
import com.db.DBConnect;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;

@WebServlet("/DoctorReportServlet")
public class DoctorReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Doctor_Report.pdf");

        try {
           
            PdfWriter writer = new PdfWriter(response.getOutputStream());
            PdfDocument pdfDoc = new PdfDocument(writer);
            Document document = new Document(pdfDoc);

         
            document.add(new Paragraph("Doctor Report").setFontSize(18));
            document.add(new Paragraph("\n"));

           
            float[] columnWidths = {50, 150, 120, 180, 100}; 
            Table table = new Table(columnWidths);
            table.addCell("Doctor ID");
            table.addCell("Full Name");
            table.addCell("Specialist");
            table.addCell("Email");
            table.addCell("Qualification");

         
            DoctorDao doctorDao = new DoctorDao(DBConnect.getConn());
            List<Doctor> doctorList = doctorDao.getAllDoctorsReport();

            
            for (Doctor doc : doctorList) {
                table.addCell(String.valueOf(doc.getId()));
                table.addCell(doc.getFullName());
                table.addCell(doc.getSpecialist());
                table.addCell(doc.getEmail());
                table.addCell(doc.getQualification());
            }

            
            document.add(table);
            document.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
