<%@ page import="java.sql.*" %>
<%@ page import="utils.DBUtil" %>
<%

    Connection con2 = null;
    PreparedStatement ps2 = null;
    ResultSet rs2 = null;
    int serialNumber2 = 1; // Start counter from 1
%>

<div id="donors" class="section">
    <%@ include file="donor-form.jsp" %>

    <h2>View Donors</h2>
    <table id="donorsTable" class="display">
        <thead>
            <tr>
                <th>S.No.</th> <!-- Changed from ID to Serial No -->
                <th>Name</th>
                <th>Phone</th>
                <th>Email</th>
                <th>Address</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                try {
                    con2 = DBUtil.getConnection();
                    ps2 = con2.prepareStatement("SELECT * FROM donors");
                    rs2 = ps2.executeQuery();

                    while (rs2.next()) {
            %>
                <tr>
                    <td><%= serialNumber2++ %></td> <!-- Serial number here -->
                    <td><%= rs2.getString("name") %></td>
                    <td><%= rs2.getString("phone") %></td>
                    <td><%= rs2.getString("email") %></td>
                    <td><%= rs2.getString("address") %></td>
                    <td class="edit">
                        <a href="${pageContext.request.contextPath}/page/editDonor?id=<%= rs2.getInt("id") %>">Edit</a>
                        <a href="<%= request.getContextPath() %>/deleteDonor?id=<%= rs2.getInt("id") %>" onclick="return confirm('Are you sure you want to delete this donor?')">Delete</a>
                    </td>
                </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    DBUtil.close(con2, ps2, rs2);
                }
            %>
        </tbody>
    </table>
</div>
