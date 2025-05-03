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

@WebServlet("/deleteAgent")
public class DeleteAgentS extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int agentId = Integer.parseInt(request.getParameter("id"));

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBUtil.getConnection();
            String deleteSql = "DELETE FROM users WHERE id = ?";
            ps = con.prepareStatement(deleteSql);
            ps.setInt(1, agentId);

            int rowsDeleted = ps.executeUpdate();

            if (rowsDeleted > 0) {
                // Set success message in session
                request.getSession().setAttribute("alertMessage", "Agent deleted successfully.");

                String role = (String) request.getSession().getAttribute("role");

                if ("admin".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/page/admin-dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/page/index"); // fallback
                }
            } else {
                response.getWriter().println("Error deleting agent.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(con, ps, null);
        }
    }
}
