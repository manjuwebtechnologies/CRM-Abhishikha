package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import utils.DBUtil;

@WebServlet("/DonationFormS")
public class DonationFormS extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer agentId = (Integer) session.getAttribute("agent_id");
        String role = (String) session.getAttribute("role"); // Track if it's admin or agent

        if (agentId == null) {
            agentId = 1; // Default for admin
        }

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String pan = request.getParameter("pan");
        String address = request.getParameter("address");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String pmode = request.getParameter("pmode");
        String donationDate = request.getParameter("donation_date");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBUtil.getConnection();

            // 1. Check if donor exists
            ps = con.prepareStatement("SELECT id FROM donors WHERE phone = ?");
            ps.setString(1, phone);
            rs = ps.executeQuery();

            int donorId;
            if (rs.next()) {
                donorId = rs.getInt("id");
            } else {
                // 2. Insert donor
                ps = con.prepareStatement("INSERT INTO donors (name, phone, email, pan, address, agent_id) VALUES (?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, name);
                ps.setString(2, phone);
                ps.setString(3, email);
                ps.setString(4, pan);
                ps.setString(5, address);
                ps.setInt(6, agentId);
                ps.executeUpdate();
                ResultSet generatedKeys = ps.getGeneratedKeys();
                generatedKeys.next();
                donorId = generatedKeys.getInt(1);
            }

            // 3. Generate receipt number
            Calendar cal = Calendar.getInstance();
            int year = cal.get(Calendar.YEAR);
            int month = cal.get(Calendar.MONTH) + 1;
            String fy = (month >= 4) ? (year % 100) + "-" + ((year + 1) % 100) : ((year - 1) % 100) + "-" + (year % 100);
            String prefix = fy + "AT";

            ps = con.prepareStatement("SELECT COUNT(*) FROM donations WHERE receipt_no LIKE ?");
            ps.setString(1, prefix + "%");
            rs = ps.executeQuery();
            rs.next();
            int nextSerial = rs.getInt(1) + 1;
            String receiptNo = prefix + String.format("%04d", nextSerial);

            // 4. Insert donation
            ps = con.prepareStatement("INSERT INTO donations (donor_id, donation_date, amount, pmode, agent_id, receipt_no) VALUES (?, ?, ?, ?, ?, ?)");
            ps.setInt(1, donorId);
            ps.setString(2, donationDate);
            ps.setDouble(3, amount);
            ps.setString(4, pmode);
            ps.setInt(5, agentId);
            ps.setString(6, receiptNo);
            ps.executeUpdate();

            // ✅ Redirect based on role
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
            DBUtil.close(con, ps, rs);
        }
    }
}

