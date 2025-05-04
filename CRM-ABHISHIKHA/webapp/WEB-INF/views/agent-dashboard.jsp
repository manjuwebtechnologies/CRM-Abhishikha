<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBUtil" %>
<%
    if (session.getAttribute("username") == null || !"agent".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/page/index");
        return;
    }

    int agentId = (Integer) session.getAttribute("agent_id");

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    int serialNumber = 1; // Start counter from 1
    int serialNumber1 = 1; // Start counter from 1
%>
<!DOCTYPE html>
<html>
<head>
    <title>Abhishikha Trust - Agent Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/chatbot.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/nvb.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <meta charset="UTF-8">
    <style>
        .section {
            display: none;
        }
        .section.active {
            display: block;
        }
    </style>
    <script>
        function showSection(sectionId) {
            document.querySelectorAll('.section').forEach(sec => sec.classList.remove('active'));
            document.getElementById(sectionId).classList.add('active');
        }
        window.onload = function () {
            showSection('donors');
        };
    </script>
</head>
<body>

    <div class="header">
        <img src="${pageContext.request.contextPath}/images/logo.png" alt="Abhishikha Trust">
        <h1>Abhishikha Trust - Agent Dashboard</h1>
        <h4>Welcome, <%= session.getAttribute("username") %></h4>
    </div>

    <div class="main">
        <aside class="sidebar">
            <header class="sidebar-header">
                <button class="toggler sidebar-toggler">
                    <span class="material-symbols-rounded">chevron_left</span>
                </button>
                <button class="toggler menu-toggler">
                    <span class="material-symbols-rounded">menu</span>
                </button>
            </header>
            <nav class="sidebar-nav">
                <ul class="nav-list primary-nav">
                    <li class="nav-item">
                        <a onclick="showSection('donors')" class="nav-link">
                            <span class="nav-icon material-symbols-rounded">group</span>
                            <span class="nav-label">Donors</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a onclick="showSection('donations')" class="nav-link">
                            <span class="nav-icon material-symbols-rounded">card_giftcard</span>
                            <span class="nav-label">Donations</span>
                        </a>
                    </li>
                </ul>
                <ul class="nav-list secondary-nav">
                    <li class="nav-item">
                        <form id="logoutForm" action="${pageContext.request.contextPath}/LogoutS" method="POST" style="display:none;"></form>
                        <a href="#" onclick="document.getElementById('logoutForm').submit();" class="nav-link">
                            <span class="nav-icon material-symbols-rounded">logout</span>
                            <span class="nav-label">Logout</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <div class="content">
            <!-- Donors Section -->
            <div class="section" id="donors">
                <%@ include file="donor-form.jsp" %>
                <h3>My Donors</h3>
                <table id="donorsTable" class="display">
                    <thead>
                        <tr><th>ID</th><th>Name</th><th>Phone</th><th>Email</th><th>PAN</th><th>Address</th></tr>
                    </thead>
                    <tbody>
                    <%
                        try (Connection con = DBUtil.getConnection()) {
                            PreparedStatement ps = con.prepareStatement("SELECT * FROM donors WHERE agent_id = ?");
                            ps.setInt(1, agentId);
                            ResultSet rs = ps.executeQuery();
                            while (rs.next()) {
                    %>
                        <tr>
                            <td><%= serialNumber++ %></td> <!-- Serial number here -->
                            <td><%= rs.getString("name") %></td>
                            <td><%= rs.getString("phone") %></td>
                            <td><%= rs.getString("email") %></td>
                            <td><%= rs.getString("pan") %></td>
                            <td><%= rs.getString("address") %></td>
                        </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("Error: " + e.getMessage());
                        }
                    %>
                    </tbody>
                </table>
            </div>

            <!-- Donations Section -->
            <div class="section" id="donations">
                <%@ include file="donation-form.jsp" %>
                <h3>My Donations</h3>
                <table id="donationsTable" class="display">
                    <thead>
                        <tr><th>ID</th><th>Donor</th><th>Amount</th><th>Receipt</th><th>Date</th></tr>
                    </thead>
                    <tbody>
                    <%
                        try (Connection con = DBUtil.getConnection()) {
                            PreparedStatement ps = con.prepareStatement(
                                "SELECT dn.id, d.name, dn.amount, dn.receipt_no, dn.donation_date FROM donations dn JOIN donors d ON dn.donor_id = d.id WHERE dn.agent_id = ?"
                            );
                            ps.setInt(1, agentId);
                            ResultSet rs = ps.executeQuery();
                            while (rs.next()) {
                    %>
                        <tr>
                            <td><%= serialNumber1++ %></td> <!-- Serial number here -->
                            <td><%= rs.getString("name") %></td>
                            <td><%= rs.getDouble("amount") %></td>
                            <td><%= rs.getString("receipt_no") %></td>
                            <td><%= rs.getDate("donation_date") %></td>
                        </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("Error: " + e.getMessage());
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Chatbot and toggler -->
        <button class="chatbot-toggler">
            <span class="material-symbols-rounded">mode_comment</span>
            <span class="material-symbols-outlined">close</span>
        </button>
        <div class="chatbot">
            <header><h2>Chatbot</h2><span class="close-btn material-symbols-outlined">close</span></header>
            <ul class="chatbox"></ul>
            <div class="chat-input">
                <textarea placeholder="Enter a message..." spellcheck="false" required></textarea>
                <span id="send-btn" class="material-symbols-rounded">send</span>
            </div>
        </div>
    </div>

    <div class="footer">© 2025 Abhishikha Trust | All Rights Reserved</div>

    <% String alert = (String) session.getAttribute("alertMessage");
       if (alert != null) {
    %>
        <script>alert("<%= alert %>");</script>
    <%
           session.removeAttribute("alertMessage");
       }
    %>

    <script src="${pageContext.request.contextPath}/static/chatbot.js"></script>
    <script src="${pageContext.request.contextPath}/static/nvb.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script>
        $(document).ready(function () {
            $('#donorsTable').DataTable();
            $('#donationsTable').DataTable();
        });
    </script>
</body>
</html>
