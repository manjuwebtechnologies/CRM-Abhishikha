package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

import utils.DBUtil;

@WebServlet("/AgentLoginS")
public class AgentLoginS extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().println("GET not supported. Please login via form.");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("AgentLoginS servlet called.");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBUtil.getConnection();
            ps = con.prepareStatement("SELECT * FROM users WHERE username=? AND password=? AND role='agent'");
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                int agentId = rs.getInt("id"); // Ensure your table has this column
                session.setAttribute("username", username);
                session.setAttribute("role", "agent");
                session.setAttribute("agent_id", agentId); // ✅ now agent_id is stored properly

                System.out.println("Agent login successful: " + username + ", ID: " + agentId);
                response.sendRedirect(request.getContextPath() + "/page/agent-dashboard");
            } else {
                System.out.println("Login failed for: " + username);
                response.sendRedirect(request.getContextPath() + "/page/agent-dashboard?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/page/agent-dashboard?error=2");
        } finally {
            DBUtil.close(con, ps, rs);
        }
    }
}
