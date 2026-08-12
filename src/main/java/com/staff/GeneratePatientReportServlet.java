package com.staff;




import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.dao.AdmitPatientDAO;
import com.db.DBConnect;
import com.entity.AdmitPatient;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;

@WebServlet("/generatePatientReport")
public class GeneratePatientReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Patient_Report.pdf");

        try (OutputStream out = response.getOutputStream()) {
            PdfDocument pdfDoc = new PdfDocument(new PdfWriter(out));
            Document document = new Document(pdfDoc);
            
           
            document.add(new Paragraph("Hospital System - Admitted Patient Report").setFontSize(16));

          
            AdmitPatientDAO patientDAO = new AdmitPatientDAO(DBConnect.getConn());
            List<AdmitPatient> patientList = patientDAO.getAdmittedPatients();

            
            Table table = new Table(6);

          
            table.addCell(new Cell().add(new Paragraph("ID")));
            table.addCell(new Cell().add(new Paragraph("Name")));
            table.addCell(new Cell().add(new Paragraph("Disease")));
            table.addCell(new Cell().add(new Paragraph("Admitted Date")));
            table.addCell(new Cell().add(new Paragraph("Discharge Date")));
            table.addCell(new Cell().add(new Paragraph("Payment")));

         
            for (AdmitPatient p : patientList) {
                table.addCell(new Cell().add(new Paragraph(String.valueOf(p.getId()))));
                table.addCell(new Cell().add(new Paragraph(p.getName())));
                table.addCell(new Cell().add(new Paragraph(p.getDisease())));
                table.addCell(new Cell().add(new Paragraph(p.getAdmittedDate())));
                table.addCell(new Cell().add(new Paragraph(p.getDischargeDate() != null ? p.getDischargeDate() : "N/A")));
                table.addCell(new Cell().add(new Paragraph(String.valueOf(p.getPayment()))));
            }

           
            document.add(table);
            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
