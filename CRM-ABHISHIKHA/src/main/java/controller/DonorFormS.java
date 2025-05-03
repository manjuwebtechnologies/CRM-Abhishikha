package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

import utils.DBUtil;

@WebServlet("/DonorFormS")
public class DonorFormS extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String pan = request.getParameter("pan");  // <-- Added this line

        HttpSession session = request.getSession();
        Integer agentId = (Integer) session.getAttribute("agent_id");
        String role = (String) session.getAttribute("role");

        if (agentId == null) {
            agentId = 1; // Default for admin
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBUtil.getConnection();
            ps = con.prepareStatement("INSERT INTO donors (name, phone, email, address, pan, agent_id) VALUES (?, ?, ?, ?, ?, ?)"); // <-- Added 'pan'
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, address);
            ps.setString(5, pan); // <-- Set PAN
            ps.setInt(6, agentId);
            ps.executeUpdate();

            if ("admin".equals(role)) {
                response.sendRedirect("page/admin-dashboard?status=success");
            } else {
                response.sendRedirect("page/agent-dashboard?status=success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            if ("admin".equals(role)) {
                response.sendRedirect("page/admin-dashboard?status=fail");
            } else {
                response.sendRedirect("page/agent-dashboard?status=fail");
            }
        } finally {
            DBUtil.close(con, ps, null);
        }
    }
}
