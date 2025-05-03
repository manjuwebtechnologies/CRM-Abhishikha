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

@WebServlet("/deleteDonor")
public class DeleteDonorS extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int donorId = Integer.parseInt(request.getParameter("id"));

        try (Connection con = DBUtil.getConnection()) {
            String deleteSql = "DELETE FROM donors WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(deleteSql);
            ps.setInt(1, donorId);

            int rowsDeleted = ps.executeUpdate();

            if (rowsDeleted > 0) {
                // Set success message in session
                request.getSession().setAttribute("alertMessage", "Donor deleted successfully.");
                response.sendRedirect(request.getContextPath() + "/page/admin-dashboard");
            } else {
                response.getWriter().println("Error deleting donor.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Exception occurred while deleting donor.");
        }
    }
}
