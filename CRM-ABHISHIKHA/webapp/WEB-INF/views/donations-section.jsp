<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBUtil" %>

<%
    String role1 = (String) session.getAttribute("role");
    Integer agentId1 = (Integer) session.getAttribute("agent_id");

    Connection con1 = null;
    PreparedStatement ps1 = null;
    ResultSet rs1 = null;
    int serialNumber1 = 1; // Start counter from 1
%>

<div id="donations" class="section">
    <%@ include file="donation-form.jsp" %>

    <h2>View Donations</h2>
    <table id="donationsTable" class="display" border="1" cellpadding="10" cellspacing="0"
           style="width:100%; border-collapse: collapse;">
        <thead>
            <tr style="background-color: #0d5a45; color: white;">
                <th>S.No.</th> <!-- Changed from ID to Serial No -->
                <th>Donor Name</th>
                <th>Amount</th>
                <th>Receipt No</th>
                <th>Date</th>
                <th>Agent ID</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                con1 = DBUtil.getConnection();

                if ("agent".equals(role1) && agentId1 != null) {
                    ps1 = con1.prepareStatement(
                        "SELECT d.name, dn.* FROM donations dn JOIN donors d ON dn.donor_id = d.id WHERE dn.agent_id = ?"
                    );
                    ps1.setInt(1, agentId1);
                } else {
                    ps1 = con1.prepareStatement(
                        "SELECT d.name, dn.* FROM donations dn JOIN donors d ON dn.donor_id = d.id"
                    );
                }

                rs1 = ps1.executeQuery();
                while (rs1.next()) {
        %>
            <tr>
                <td><%= serialNumber1++ %></td> <!-- Serial number here -->
                <td><%= rs1.getString("name") %></td>
                <td>₹<%= rs1.getDouble("amount") %></td>
                <td><%= rs1.getString("receipt_no") %></td>
                <td><%= rs1.getDate("donation_date") %></td>
                <td><%= rs1.getInt("agent_id") %></td>
                <td class="edit">
                    <a href="<%= request.getContextPath() %>/page/editDonation?id=<%= rs1.getInt("id") %>">Edit</a>
                    <a href="<%= request.getContextPath() %>/deleteDonation?id=<%= rs1.getInt("id") %>"
                       onclick="return confirm('Are you sure you want to delete this donation?')">Delete</a>
                </td>
            </tr>
        <%
                }
            } catch (Exception e) {
        %>
            <tr>
                <td colspan="7" style="color: red;">Error: <%= e.getMessage() %></td>
            </tr>
        <%
            } finally {
                DBUtil.close(con1, ps1, rs1);
            }
        %>
        </tbody>
    </table>
</div>
