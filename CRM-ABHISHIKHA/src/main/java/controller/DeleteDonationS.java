package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.DBUtil;

@WebServlet("/deleteDonation")
public class DeleteDonationS extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int donationId = Integer.parseInt(request.getParameter("id")); // Get donation ID from request

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBUtil.getConnection();
            String deleteDonationSql = "DELETE FROM donations WHERE id = ?"; // Delete only from donations table
            ps = con.prepareStatement(deleteDonationSql);
            ps.setInt(1, donationId);

            int rowsDeleted = ps.executeUpdate();

            if (rowsDeleted > 0) {
                // Set a session attribute for alert message
                request.getSession().setAttribute("alertMessage", "Donation deleted successfully.");
                String role = (String) request.getSession().getAttribute("role");

                if ("admin".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/page/admin-dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/page/index"); // Fallback redirection
                }
            } else {
                response.getWriter().println("Error deleting donation.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error deleting donation.");
        } finally {
            DBUtil.close(con, ps, null);
        }
    }
}
