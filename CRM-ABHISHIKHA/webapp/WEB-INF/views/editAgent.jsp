<%@ page import="java.sql.*" %>
<%@ page import="utils.DBUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Agent</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/static/formStyle.css">
</head>
<body>

<%
    int agentId = Integer.parseInt(request.getParameter("id"));
    String username = "";
    String role = "";

    // Fetch agent data
    try {
        Connection con = DBUtil.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT username, role FROM users WHERE id = ?");
        ps.setInt(1, agentId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            username = rs.getString("username");
            role = rs.getString("role");
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<div class="edit-form agent-form-container">
    <h2>Edit Agent</h2>
    <form action="${pageContext.request.contextPath}/UpdateAgentS" method="post">
        <input type="hidden" name="id" value="<%= agentId %>">
        <input type="text" name="username" placeholder="Username" value="<%= username %>" required>
        <input type="text" name="password" placeholder="New Password (Leave empty if not changing)">
        <select name="role" required>
            <option value="agent" <%= "agent".equals(role) ? "selected" : "" %>>Agent</option>
            <option value="admin" <%= "admin".equals(role) ? "selected" : "" %>>Admin</option>
        </select>
        <button type="submit">Update Agent</button>
    </form>
</div>

</body>
</html>
