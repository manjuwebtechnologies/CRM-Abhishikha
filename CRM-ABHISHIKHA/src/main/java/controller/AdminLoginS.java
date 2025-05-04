package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import utils.DBUtil;

import java.io.IOException;
import java.sql.*;

@WebServlet("/AdminLoginS")
public class AdminLoginS extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.getWriter().println("GET not supported. Please login via form.");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBUtil.getConnection();
            ps = con.prepareStatement("SELECT id, username FROM users WHERE username=? AND password=? AND role='admin'");
            ps.setString(1, username);
            ps.setString(2, password); // 👉 You can hash this using SHA-256 for better security

            rs = ps.executeQuery();

            if (rs.next()) {
                int adminId = rs.getInt("id");

                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", "admin");
                session.setAttribute("admin_id", adminId); // 👉 This helps identify the logged-in admin

                System.out.println("[INFO] Admin login successful: " + username);
                response.sendRedirect(request.getContextPath() + "/page/admin-dashboard");
            } else {
                System.out.println("[WARN] Admin login failed for: " + username);
                response.sendRedirect(request.getContextPath() + "/page/admin-dashboard?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/page/admin-dashboard?error=2");
        } finally {
            DBUtil.close(con, ps, rs);
        }
    }
}
