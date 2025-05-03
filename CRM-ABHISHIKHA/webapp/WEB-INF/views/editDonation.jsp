<%@ page import="utils.DBUtil" %>
<%@ page import="java.sql.*, java.util.*" %>

<%
    int donationId = Integer.parseInt(request.getParameter("id"));
    String name = "", phone = "", email = "", address = "", pan = "", pmode = "";
    double amount = 0;
    java.sql.Date donationDate = null; // Use fully qualified class name
    String receiptNo = "";
    int agentId = 0;

    try {
        Connection con = DBUtil.getConnection();
        PreparedStatement ps = con.prepareStatement(
            "SELECT dn.*, d.name, d.phone, d.email, d.address, d.pan " +
            "FROM donations dn JOIN donors d ON dn.donor_id = d.id WHERE dn.id = ?"
        );
        ps.setInt(1, donationId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            phone = rs.getString("phone");
            email = rs.getString("email");
            address = rs.getString("address");
            pan = rs.getString("pan");
            pmode = rs.getString("pmode");
            amount = rs.getDouble("amount");
            donationDate = rs.getDate("donation_date"); // No ambiguity now
            receiptNo = rs.getString("receipt_no");
            agentId = rs.getInt("agent_id");
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/static/formStyle.css">

<div class="edit-form donor-form-container">
    <h2>Edit Donation</h2>
    <form action="${pageContext.request.contextPath}/UpdateDonationS" method="post">
        <input type="hidden" name="id" value="<%= donationId %>">
        <input type="hidden" name="agent_id" value="<%= agentId %>">
        <input type="hidden" name="receipt_no" value="<%= receiptNo %>">

        <input type="date" name="donation_date" value="<%= donationDate != null ? donationDate.toString() : "" %>" required>
        <input type="text" name="name" value="<%= name %>" placeholder="Donor Full Name" required>
        <input type="text" name="phone" value="<%= phone %>" placeholder="Phone Number" required>
        <input type="email" name="email" value="<%= email %>" placeholder="Email Address">
        <input type="number" name="amount" step="0.01" value="<%= amount %>" placeholder="Donation Amount" required>
        <input type="text" name="pmode" value="<%= pmode %>" placeholder="Payment Mode (e.g. UPI, Cash)">
        <input type="text" name="pan" value="<%= pan %>" placeholder="PAN Number">
        <textarea name="address" placeholder="Address" rows="3"><%= address %></textarea>

        <button type="submit">Update Donation</button>
    </form>
</div>
