<%@ page import="java.sql.*" %>
<%@ page import="utils.DBUtil" %>

<%
    Connection con4 = null;
    PreparedStatement ps4 = null;
    ResultSet rs4 = null;
    int serialNumber4 = 1; // Start counter from 1
%>


<div id="agents" class="section">

    <!-- Agent Creation Form -->
    <div class="agent-form-container">
        <h2>Create Agent</h2>
        <form action="${pageContext.request.contextPath}/CreateAgentS" method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="text" name="password" placeholder="Password" required>
            <button type="submit">Create Agent</button>
        </form>
    </div>

    <!-- Agent Listing Table -->
    <h2>View Agents</h2>
    <table id="agentsTable" class="display">
        <thead>
            <tr>
                <th>S.No.</th> <!-- Changed from ID to Serial No -->
                <th>Username</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                try {
                    con4 = DBUtil.getConnection();
                    ps4 = con4.prepareStatement("SELECT id, username, role FROM users WHERE role = 'agent'");
                    rs4 = ps4.executeQuery();
                    while (rs4.next()) {
            %>
            <tr>
                <td><%= serialNumber4++ %></td> <!-- Serial number here -->
                <td><%= rs4.getString("username") %></td>
                <td><%= rs4.getString("role") %></td>
                <td class="edit">
                    <a href="${pageContext.request.contextPath}/page/editAgent?id=<%= rs4.getInt("id") %>">Edit</a>
                    <a href="<%= request.getContextPath() %>/deleteAgent?id=<%= rs4.getInt("id") %>" 
                       onclick="return confirm('Are you sure you want to delete this agent?')">Delete</a>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    DBUtil.close(con4, ps4, rs4);
                }
            %>
        </tbody>
    </table>
</div>
