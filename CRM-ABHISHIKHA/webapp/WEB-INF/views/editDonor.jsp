<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBUtil" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/static/formStyle.css">

<%
    int donorId = Integer.parseInt(request.getParameter("id"));
    String name = "";
    String phone = "";
    String email = "";
    String pan = "";
    String address = "";

    try {
        Connection con = DBUtil.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT name, phone, email, pan, address FROM donors WHERE id = ?");
        ps.setInt(1, donorId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");       // ✅ corrected
            phone = rs.getString("phone");     // ✅ corrected
            email = rs.getString("email");
            pan = rs.getString("pan");
            address = rs.getString("address");
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<div class="edit-form donor-form-container">
    <h2>Edit Donor</h2>
    <form action="${pageContext.request.contextPath}/UpdateDonorS" method="post">
        <input type="hidden" name="id" value="<%= donorId %>">
        <input type="text" name="name" value="<%= name %>" placeholder="Full Name" required>
        <input type="text" name="phone" value="<%= phone %>" placeholder="Phone Number" required>
        <input type="email" name="email" value="<%= email %>" placeholder="Email Address">
        <input type="text" name="pan" value="<%= pan %>" placeholder="PAN Number">
        <textarea name="address" placeholder="Address" rows="3"><%= address %></textarea>
        <button type="submit">Save Donor</button>
    </form>
</div>
