package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import utils.DBUtil;

@WebServlet("/UpdateDonorS")
public class UpdateDonorS extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String pan = request.getParameter("pan");
        String address = request.getParameter("address");

        try (Connection con = DBUtil.getConnection()) {
            String updateQuery = "UPDATE donors SET name = ?, phone = ?, email = ?, pan = ?, address = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(updateQuery);
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, pan);
            ps.setString(5, address);
            ps.setInt(6, id);

            ps.executeUpdate();

            // Set success message in session
            request.getSession().setAttribute("alertMessage", "Donor updated successfully.");

            response.sendRedirect(request.getContextPath() + "/page/admin-dashboard");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating donor.");
        }
    }
}
