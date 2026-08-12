package com.payment;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.BillingDao;
import com.db.DBConnect;
import com.entity.Billing;
import com.entity.BillingItem;

import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.properties.UnitValue;

@WebServlet("/generateInvoice")
public class InvoiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String billIdStr = req.getParameter("billId");
        if (billIdStr == null || billIdStr.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing billId parameter");
            return;
        }

        int billId;
        try {
            billId = Integer.parseInt(billIdStr);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid billId");
            return;
        }

        Connection conn = DBConnect.getConn();
        BillingDao billingDao = new BillingDao(conn);
        Billing bill = billingDao.getBillById(billId);
        if (bill == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Invoice not found");
            return;
        }

        List<BillingItem> items = billingDao.getBillingItems(billId);

        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "attachment; filename=Invoice_" + bill.getInvoiceNumber() + ".pdf");

        try (PdfWriter writer = new PdfWriter(resp.getOutputStream());
             PdfDocument pdf = new PdfDocument(writer);
             Document document = new Document(pdf)) {

            // Title
            document.add(new Paragraph("MEDI HOME - Hospital Invoice")
                .setFontSize(20)
                .setMarginBottom(15));

            // Invoice details
            document.add(new Paragraph("Invoice Number: " + bill.getInvoiceNumber()));
            document.add(new Paragraph("Date: " + (bill.getCreatedAt() != null ? bill.getCreatedAt() : "")));
            document.add(new Paragraph("Patient Name: " + bill.getPatientName()));
            document.add(new Paragraph("Doctor: " + (bill.getDoctorName() != null ? bill.getDoctorName() : "")));
            document.add(new Paragraph("Admission Date: " + (bill.getAdmissionDate() != null ? bill.getAdmissionDate() : "")));
            document.add(new Paragraph("Discharge Date: " + (bill.getDischargeDate() != null ? bill.getDischargeDate() : "")));
            document.add(new Paragraph("----------------------------------------------------------------------------------------------------"));

            // Table of items
            float[] columnWidths = {2, 4, 1, 2, 2};
            Table table = new Table(UnitValue.createPointArray(columnWidths));
            table.setWidth(UnitValue.createPercentValue(100));

            table.addHeaderCell(new Cell().add(new Paragraph("Type")));
            table.addHeaderCell(new Cell().add(new Paragraph("Description")));
            table.addHeaderCell(new Cell().add(new Paragraph("Qty")));
            table.addHeaderCell(new Cell().add(new Paragraph("Unit Price")));
            table.addHeaderCell(new Cell().add(new Paragraph("Total")));

            if (items != null) {
                for (BillingItem item : items) {
                    table.addCell(new Cell().add(new Paragraph(item.getItemType() != null ? item.getItemType() : "")));
                    table.addCell(new Cell().add(new Paragraph(item.getDescription() != null ? item.getDescription() : "")));
                    table.addCell(new Cell().add(new Paragraph(String.valueOf(item.getQuantity()))));
                    table.addCell(new Cell().add(new Paragraph(String.format("INR %.2f", item.getUnitPrice()))));
                    table.addCell(new Cell().add(new Paragraph(String.format("INR %.2f", item.getTotalPrice()))));
                }
            }

            document.add(table);

            document.add(new Paragraph("----------------------------------------------------------------------------------------------------"));
            document.add(new Paragraph(String.format("Subtotal: INR %.2f", bill.getSubtotal())));
            document.add(new Paragraph(String.format("Discount: INR %.2f", bill.getDiscount())));
            document.add(new Paragraph(String.format("Tax: INR %.2f", bill.getTax())));
            document.add(new Paragraph(String.format("Grand Total: INR %.2f", bill.getGrandTotal())));
            document.add(new Paragraph("Payment Status: " + bill.getPaymentStatus()));
            
            if (bill.getNotes() != null && !bill.getNotes().isBlank()) {
                document.add(new Paragraph("Notes: " + bill.getNotes()));
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF: " + e.getMessage());
        }
    }
}
