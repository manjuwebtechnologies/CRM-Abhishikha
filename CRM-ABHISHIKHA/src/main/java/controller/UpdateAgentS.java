package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import utils.DBUtil;

@WebServlet("/UpdateAgentS")
public class UpdateAgentS extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try (Connection con = DBUtil.getConnection()) {
            String updateQuery;
            PreparedStatement ps;

            if (password != null && !password.trim().isEmpty()) {
                updateQuery = "UPDATE users SET username = ?, password = ?, role = ? WHERE id = ?";
                ps = con.prepareStatement(updateQuery);
                ps.setString(1, username);
                ps.setString(2, password);
                ps.setString(3, role);
                ps.setInt(4, id);
            } else {
                updateQuery = "UPDATE users SET username = ?, role = ? WHERE id = ?";
                ps = con.prepareStatement(updateQuery);
                ps.setString(1, username);
                ps.setString(2, role);
                ps.setInt(3, id);
            }

            ps.executeUpdate();

            // Set the success alert message in the session
            request.getSession().setAttribute("alertMessage", "Agent updated successfully.");

            // Redirect to admin dashboard
            response.sendRedirect(request.getContextPath() + "/page/admin-dashboard");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating agent.");
        }
    }
}
