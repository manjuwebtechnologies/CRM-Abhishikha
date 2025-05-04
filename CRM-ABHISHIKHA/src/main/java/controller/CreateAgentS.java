package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

import utils.DBUtil;

@WebServlet("/CreateAgentS")
public class CreateAgentS extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("Received agent creation request: " + username);

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBUtil.getConnection();
            ps = con.prepareStatement("INSERT INTO users (username, password, role) VALUES (?, ?, 'agent')");
            ps.setString(1, username);
            ps.setString(2, password);
            ps.executeUpdate();

            System.out.println("Agent created successfully: " + username);
            response.sendRedirect(request.getContextPath() + "/page/admin-dashboard?agent=created");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/page/admin-dashboard?agent=error");
        } finally {
            DBUtil.close(con, ps);
        }
    }
}
