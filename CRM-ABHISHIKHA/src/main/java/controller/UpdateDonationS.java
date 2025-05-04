package controller;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.DBUtil;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;


@WebServlet("/UpdateDonationS")
public class UpdateDonationS extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
    	// Inside your doPost method
    	String dateString = request.getParameter("donation_date");  // e.g. "2025-05-03"
    	LocalDate localDate = LocalDate.parse(dateString);
    	LocalDateTime startOfDay = localDate.atStartOfDay();   // midnight local date-time
    	Timestamp donationTimestamp = Timestamp.valueOf(startOfDay);
        
        int donationId = Integer.parseInt(request.getParameter("id"));
        int agentId = Integer.parseInt(request.getParameter("agent_id"));
        String receiptNo = request.getParameter("receipt_no");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String pan = request.getParameter("pan");
        String pmode = request.getParameter("pmode");
        double amount = Double.parseDouble(request.getParameter("amount"));
        
//        java.sql.Date donationDate = java.sql.Date.valueOf(request.getParameter("donation_date"));
        
		/*
		 * System.out.println("Updating donation with ID: " + donationId); //
		 * System.out.println("New donation_date: " + donationDate);
		 * System.out.println("New Donation Date: " + donationTimestamp);
		 * System.out.println("New amount: " + amount); System.out.println("New pmode: "
		 * + pmode); System.out.println("New receipt_no: " + receiptNo);
		 * System.out.println("New agent_id: " + agentId);
		 */

        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBUtil.getConnection();
            con.setAutoCommit(false);  // Start transaction

            // Update donor information in donors table
            String updateDonorQuery = "UPDATE donors SET name = ?, phone = ?, email = ?, address = ?, pan = ? WHERE phone = ?";
            ps = con.prepareStatement(updateDonorQuery);
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, address);
            ps.setString(5, pan);
            ps.setString(6, phone);  // Assuming phone is unique for donors (used as primary key)
            int donorRowsUpdated = ps.executeUpdate();

            if (donorRowsUpdated == 0) {
                throw new SQLException("Error updating donor details.");
            }

            ps.close();
            
            // Update donation information in donations table
            String updateDonationQuery = "UPDATE donations SET amount = ?, pmode = ?, donation_date = ?, " +
                                         "receipt_no = ?, agent_id = ? WHERE id = ?";
            ps = con.prepareStatement(updateDonationQuery);
            ps.setDouble(1, amount);
            ps.setString(2, pmode);
            ps.setTimestamp(3, donationTimestamp);  // Use Timestamp here
//            ps.setDate(3, donationDate);
            ps.setString(4, receiptNo);
            ps.setInt(5, agentId);
            ps.setInt(6, donationId);


            int donationRowsUpdated = ps.executeUpdate();
            
            System.out.println("Rows updated in donations table: " + donationRowsUpdated);
            System.out.println("Default Timezone: " + java.util.TimeZone.getDefault().getID());

            if (donationRowsUpdated > 0) {
                con.commit();  // Commit the transaction if both updates are successful
                
				/*
				 * // After commit String verifyQuery =
				 * "SELECT donation_date FROM donations WHERE id = ?"; try (PreparedStatement
				 * verifyPs = con.prepareStatement(verifyQuery)) { verifyPs.setInt(1,
				 * donationId); try (ResultSet rs = verifyPs.executeQuery()) { if (rs.next()) {
				 * java.sql.Date verifiedDate = rs.getDate("donation_date");
				 * System.out.println("Verified donation_date after update: " + verifiedDate); }
				 * else { System.out.println("No record found with id=" + donationId +
				 * " for verification."); } } }
				 */
                
                // Set the success alert message in the session
                request.getSession().setAttribute("alertMessage", "Donation updated successfully.");
                response.sendRedirect(request.getContextPath() + "/page/admin-dashboard");
            } else {
                throw new SQLException("Error updating donation.");
            }
            
            ps.close();
            
            
        } catch (SQLException e) {
            try {
                if (con != null) {
                    con.rollback();  // Rollback transaction in case of error
                }
            } catch (SQLException rollbackException) {
                rollbackException.printStackTrace();
            }
            e.printStackTrace();
            response.getWriter().println("Error updating donation.");
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
