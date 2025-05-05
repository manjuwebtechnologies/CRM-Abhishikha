//package utils;
//
//import java.io.IOException;
//
//import com.itextpdf.kernel.pdf.*;
//import com.itextpdf.kernel.font.PdfFontFactory;
//import com.itextpdf.kernel.geom.PageSize;
//import com.itextpdf.kernel.geom.Rectangle;
//import com.itextpdf.layout.Document;
//import com.itextpdf.layout.element.Paragraph;
//import com.itextpdf.kernel.pdf.canvas.PdfCanvas;
//
//import jakarta.servlet.ServletContext;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
///**
// * Servlet implementation class MakePDF
// */
//@WebServlet("/MakePDF")
//
//public class MakePDF extends HttpServlet {
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // Sample data (replace with DB lookup or form input)
//        String donorName = request.getParameter("name");
//        String receiptNo = request.getParameter("receipt_no");
//        String amount = request.getParameter("amount");
//        String date = request.getParameter("date");
//        String pan = request.getParameter("pan");
//        String address = request.getParameter("address");
//        String contact = request.getParameter("contact");
//        String email = request.getParameter("email");
//        String mode = request.getParameter("mode");
//        String amountWords = request.getParameter("amount_words");
//
//        // Load the receipt template from resources
//        ServletContext context = getServletContext();
//        String templatePath = context.getRealPath("/images/receipt # 2410AT304.pdf");
//
//        PdfDocument pdfDoc = new PdfDocument(
//            new PdfReader(templatePath),
//            new PdfWriter(response.getOutputStream())
//        );
//        response.setContentType("application/pdf");
//        response.setHeader("Content-Disposition", "inline; filename=receipt.pdf");
//
//        PdfPage page = pdfDoc.getFirstPage();
//        PdfCanvas canvas = new PdfCanvas(page);
//        canvas.beginText();
//        canvas.setFontAndSize(PdfFontFactory.createFont(), 12);
//
//        // Draw text (x, y in points from bottom-left)
//        canvas.setTextMatrix(400, 730);  // adjust these coordinates
//        canvas.showText("Date: " + date);
//
//        canvas.setTextMatrix(400, 700);
//        canvas.showText("Receipt #: " + receiptNo);
//
//        canvas.setTextMatrix(100, 670);
//        canvas.showText("Donor Name: " + donorName);
//
//        canvas.setTextMatrix(100, 650);
//        canvas.showText("Contact: " + contact);
//
//        canvas.setTextMatrix(100, 630);
//        canvas.showText("Email: " + email);
//
//        canvas.setTextMatrix(100, 610);
//        canvas.showText("Amount: ₹" + amount);
//
//        canvas.setTextMatrix(100, 590);
//        canvas.showText("Amount in Words: " + amountWords);
//
//        canvas.setTextMatrix(100, 570);
//        canvas.showText("Mode of Payment: " + mode);
//
//        canvas.setTextMatrix(100, 550);
//        canvas.showText("PAN: " + pan);
//
//        canvas.setTextMatrix(100, 530);
//        canvas.showText("Address: " + address);
//
//
//        canvas.endText();
//        pdfDoc.close();
//    }
//}
//
//
