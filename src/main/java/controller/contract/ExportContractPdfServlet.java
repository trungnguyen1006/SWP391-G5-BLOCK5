package controller.contract;

import com.itextpdf.io.font.PdfEncodings;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import dal.ContractDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Contract;
import model.ContractItem;
import model.Users;

import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;

@WebServlet(name = "ExportContractPdfServlet", urlPatterns = {"/employee/export-contract-pdf"})
public class ExportContractPdfServlet extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String contractIdStr = request.getParameter("contractId");
        if (contractIdStr == null || contractIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Contract ID is required");
            return;
        }

        try {
            int contractId = Integer.parseInt(contractIdStr);
            Contract contract = contractDAO.getContractById(contractId);

            if (contract == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Contract not found");
                return;
            }

            // Set response headers for PDF download
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", 
                "attachment; filename=\"Contract_" + contract.getContractCode() + ".pdf\"");

            // Generate PDF
            OutputStream out = response.getOutputStream();
            generatePdf(contract, out);
            out.flush();
            out.close();

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid contract ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF");
        }
    }

    private void generatePdf(Contract contract, OutputStream out) throws Exception {
        PdfWriter writer = new PdfWriter(out);
        PdfDocument pdfDoc = new PdfDocument(writer);
        Document document = new Document(pdfDoc);

        // Set font with Vietnamese support
        PdfFont font = PdfFontFactory.createFont("Helvetica");
        PdfFont boldFont = PdfFontFactory.createFont("Helvetica-Bold");

        // Title
        Paragraph title = new Paragraph("MACHINE RENTAL CONTRACT")
                .setFont(boldFont)
                .setFontSize(18)
                .setTextAlignment(TextAlignment.CENTER)
                .setMarginBottom(20);
        document.add(title);

        // Contract Code
        Paragraph code = new Paragraph("Contract Code: " + contract.getContractCode())
                .setFont(font)
                .setFontSize(11)
                .setMarginBottom(15);
        document.add(code);

        // Contract Information Section
        Paragraph infoTitle = new Paragraph("CONTRACT INFORMATION")
                .setFont(boldFont)
                .setFontSize(12)
                .setMarginBottom(10);
        document.add(infoTitle);

        Table infoTable = new Table(new float[]{1, 1, 1, 1});
        infoTable.setWidth(UnitValue.createPercentValue(100));
        infoTable.setMarginBottom(15);

        addCell(infoTable, "Customer:", contract.getCustomerName(), font, boldFont);
        addCell(infoTable, "Location:", contract.getSiteName() != null ? contract.getSiteName() : "N/A", font, boldFont);
        addCell(infoTable, "Start Date:", contract.getStartDate().toString(), font, boldFont);
        addCell(infoTable, "End Date:", contract.getEndDate().toString(), font, boldFont);
        addCell(infoTable, "Status:", contract.getStatus(), font, boldFont);
        addCell(infoTable, "Signed Date:", contract.getSignedDate() != null ? contract.getSignedDate().toString() : "N/A", font, boldFont);

        document.add(infoTable);

        // Machines Section
        Paragraph machineTitle = new Paragraph("MACHINE LIST")
                .setFont(boldFont)
                .setFontSize(12)
                .setMarginBottom(10);
        document.add(machineTitle);

        if (contract.getContractItems() != null && !contract.getContractItems().isEmpty()) {
            Table machineTable = new Table(new float[]{1.5f, 1.5f, 1.2f, 1.2f, 1.2f, 1.2f, 1.2f});
            machineTable.setWidth(UnitValue.createPercentValue(100));
            machineTable.setMarginBottom(15);

            // Header
            addHeaderCell(machineTable, "Serial Number", boldFont);
            addHeaderCell(machineTable, "Model", boldFont);
            addHeaderCell(machineTable, "Brand", boldFont);
            addHeaderCell(machineTable, "Delivery Date", boldFont);
            addHeaderCell(machineTable, "Return Date", boldFont);
            addHeaderCell(machineTable, "Rental Price", boldFont);
            addHeaderCell(machineTable, "Deposit", boldFont);

            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

            BigDecimal totalPrice = BigDecimal.ZERO;
            BigDecimal totalDeposit = BigDecimal.ZERO;

            for (ContractItem item : contract.getContractItems()) {
                addDataCell(machineTable, item.getSerialNumber(), font);
                addDataCell(machineTable, item.getModelName(), font);
                addDataCell(machineTable, item.getBrand(), font);
                addDataCell(machineTable, item.getDeliveryDate().toString(), font);
                addDataCell(machineTable, item.getReturnDueDate().toString(), font);
                addDataCell(machineTable, formatCurrency(item.getPrice()), font);
                addDataCell(machineTable, formatCurrency(item.getDeposit()), font);

                totalPrice = totalPrice.add(item.getPrice());
                totalDeposit = totalDeposit.add(item.getDeposit());
            }

            // Total row
            Cell totalCell = new Cell(1, 5)
                    .add(new Paragraph("TOTAL").setFont(boldFont))
                    .setTextAlignment(TextAlignment.RIGHT);
            machineTable.addCell(totalCell);
            machineTable.addCell(new Cell().add(new Paragraph(formatCurrency(totalPrice)).setFont(boldFont)));
            machineTable.addCell(new Cell().add(new Paragraph(formatCurrency(totalDeposit)).setFont(boldFont)));

            document.add(machineTable);
        } else {
            Paragraph noMachines = new Paragraph("No machines in this contract")
                    .setFont(font)
                    .setMarginBottom(15);
            document.add(noMachines);
        }

        // Note Section
        if (contract.getNote() != null && !contract.getNote().isEmpty()) {
            Paragraph noteTitle = new Paragraph("NOTES")
                    .setFont(boldFont)
                    .setFontSize(12)
                    .setMarginBottom(10);
            document.add(noteTitle);

            Paragraph note = new Paragraph(contract.getNote())
                    .setFont(font)
                    .setMarginBottom(15);
            document.add(note);
        }

        // Signature Section
        document.add(new Paragraph("\n\n").setMarginTop(30));
        
        Paragraph signatureTitle = new Paragraph("AUTHORIZED SIGNATURES")
                .setFont(boldFont)
                .setFontSize(12)
                .setMarginBottom(20);
        document.add(signatureTitle);

        Table signatureTable = new Table(new float[]{1, 1, 1});
        signatureTable.setWidth(UnitValue.createPercentValue(100));
        signatureTable.setMarginBottom(15);

        // Signature cells
        Cell companyCell = new Cell()
                .add(new Paragraph("COMPANY REPRESENTATIVE").setFont(boldFont).setTextAlignment(TextAlignment.CENTER))
                .add(new Paragraph("\n\n\n").setFont(font))
                .add(new Paragraph("_____________________").setFont(font).setTextAlignment(TextAlignment.CENTER))
                .add(new Paragraph("Name & Signature").setFont(font).setTextAlignment(TextAlignment.CENTER).setFontSize(9));
        signatureTable.addCell(companyCell);

        Cell customerCell = new Cell()
                .add(new Paragraph("CUSTOMER REPRESENTATIVE").setFont(boldFont).setTextAlignment(TextAlignment.CENTER))
                .add(new Paragraph("\n\n\n").setFont(font))
                .add(new Paragraph("_____________________").setFont(font).setTextAlignment(TextAlignment.CENTER))
                .add(new Paragraph("Name & Signature").setFont(font).setTextAlignment(TextAlignment.CENTER).setFontSize(9));
        signatureTable.addCell(customerCell);

        Cell dateCell = new Cell()
                .add(new Paragraph("DATE").setFont(boldFont).setTextAlignment(TextAlignment.CENTER))
                .add(new Paragraph("\n\n\n").setFont(font))
                .add(new Paragraph("_____________________").setFont(font).setTextAlignment(TextAlignment.CENTER))
                .add(new Paragraph("Date").setFont(font).setTextAlignment(TextAlignment.CENTER).setFontSize(9));
        signatureTable.addCell(dateCell);

        document.add(signatureTable);

        // Footer
        document.add(new Paragraph("\n"));
        Paragraph footer = new Paragraph("This document is automatically generated. Please contact the company for confirmation.")
                .setFont(font)
                .setFontSize(9)
                .setTextAlignment(TextAlignment.CENTER)
                .setMarginTop(20);
        document.add(footer);

        document.close();
    }

    private void addCell(Table table, String label, String value, PdfFont font, PdfFont boldFont) {
        Cell labelCell = new Cell().add(new Paragraph(label).setFont(boldFont));
        Cell valueCell = new Cell().add(new Paragraph(value).setFont(font));
        table.addCell(labelCell);
        table.addCell(valueCell);
    }

    private void addHeaderCell(Table table, String text, PdfFont font) {
        Cell cell = new Cell()
                .add(new Paragraph(text).setFont(font))
                .setBackgroundColor(com.itextpdf.kernel.colors.ColorConstants.LIGHT_GRAY);
        table.addCell(cell);
    }

    private void addDataCell(Table table, String text, PdfFont font) {
        Cell cell = new Cell().add(new Paragraph(text).setFont(font));
        table.addCell(cell);
    }

    private String formatCurrency(BigDecimal amount) {
        if (amount == null) {
            return "$0.00";
        }
        NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("en", "US"));
        return nf.format(amount);
    }
}
