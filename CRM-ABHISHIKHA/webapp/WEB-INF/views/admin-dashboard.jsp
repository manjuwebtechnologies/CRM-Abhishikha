<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBUtil" %>
<%
    // Check if the user is logged in and has admin role
    if (session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/page/index");
        return;
    }

    // Set response headers to prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
<head>
    <title>AbhishikhaTrust - Admin Dashboard</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    
    <!-- Chat Bot CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/chatbot.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/nvb.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/style.css">
    <link rel="stylesheet" href="/CRM_ABHISHIKHA/static/nvb.css">

    <!-- Google Fonts Link For Icons -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@48,400,1,0">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0">
    
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    
    <!-- Cloud Flare CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    <meta charset="UTF-8">


    <script>
        // Function to show the selected section
        function showSection(sectionId) {
            var sections = document.getElementsByClassName('section');
            for (var i = 0; i < sections.length; i++) {
                sections[i].classList.remove('active'); // Hide all sections
            }
            document.getElementById(sectionId).classList.add ('active'); // Show the selected section
        }
    </script>
</head>
<body>

    <!-- HEADER -->
    <div class="header">
    	<div class= "inner-header">
    		<img src="${pageContext.request.contextPath}/images/logo2.png" alt="Abhishikha Trust">
        	<h1>Abhishikha Trust</h1>
    	</div>
        <div class=" user-name">
        	<span class="user-icon nav-icon material-symbols-rounded">account_circle</span>
        	<span class= "user-content"><strong>Admin</strong> <br> <%= session.getAttribute("username") %></span>
        </div>
    </div>

    <div class="main">
        <aside class="sidebar">
            <!-- Sidebar header -->
            <header class="sidebar-header">
                <button class="toggler sidebar-toggler">
                    <span class="material-symbols-rounded">chevron_left</span>
                </button>
                <button class="toggler menu-toggler">
                    <span class="material-symbols-rounded">menu</span>
                </button>
            </header>
            <nav class="sidebar-nav">
                <!-- Primary top nav -->
                <ul class="nav-list primary-nav">
                    <li class="nav-item">
                        <a onclick="showSection('reports')" class="nav-link">
                            <span class="nav-icon material-symbols-rounded">dashboard</span>
                            <span class="nav-label">Dashboard</span>
                        </a>
                        <span class="nav-tooltip">Dashboard</span>
                    </li>
                    <li class="nav-item">
                        <a onclick="showSection('agents')" class="nav-link">
                        	<span class="material-symbols-outlined">support_agent</span>
                            <span class="nav-label">Agents</span>
                        </a>
                        <span class="nav-tooltip">Agents</span>
                                            </li>
                    <li class="nav-item">
                        <a onclick="showSection('donors')" class="nav-link">
                            <span class="nav-icon material-symbols-rounded">group</span>
                            <span class="nav-label">Donors</span>
                        </a>
                        <span class="nav-tooltip">Donors</span>
                    </li>
                    <li class="nav-item">
                        <a onclick="showSection('donations')" class="nav-link">
                            <span class="nav-icon material-symbols-rounded">card_giftcard</span>
                            <span class="nav-label">Donations</span>
                        </a>
                        <span class="nav-tooltip">Donations</span>
                    </li>
                </ul>
                <!-- Secondary bottom nav -->
                <ul class="nav-list secondary-nav">
<!--                     <li class="nav-item"> -->
<!--                         <a href="#" class="nav-link"> -->
<!--                             <span class="nav-icon material-symbols-rounded">account_circle</span> -->
<!--                             <span class="nav-label">Profile</span> -->
<!--                         </a> -->
<!--                         <span class="nav-tooltip">Profile</span> -->
<!--                     </li> -->
                    <li class="nav-item">
                        <!-- Hidden form for logout -->
                        <form id="logoutForm" action="${pageContext.request.contextPath}/LogoutS" method="POST" style="display:none;"></form>
                        <!-- Logout link -->
                        <a href="#" onclick="document.getElementById('logoutForm').submit();" class="nav-link">
                            <span class="nav-icon material-symbols-rounded">logout</span>
                            <span class="nav-label">Logout</span>
                        </a>
                        <span class="nav-tooltip">Logout</span>
                    </li>
                </ul>
            </nav>
        </aside>

        <div class="content">
            <!-- Include different sections of the admin dashboard -->
            <%@ include file="agent-section.jsp" %>
            <%@ include file="donors-section.jsp" %>
            <%@ include file="donations-section.jsp" %>
            <%@ include file="reports-section.jsp" %>
        </div>
        
        
        
        <!-- Chatbot button -->
        <button class="chatbot-toggler">
            <span class="material-symbols-rounded">mode_comment</span>
            <span class="material-symbols-outlined">close</span>
        </button>
        
        <!-- Chatbot UI -->
        <div class="chatbot">
            <header>
                <h2>Chatbot</h2>
                <span class="close-btn material-symbols-outlined">close</span>
            </header>
            <ul class="chatbox">
                <!-- Chat messages will be appended here -->
            </ul>
            <div class="chat-input">
                <textarea placeholder="Enter a message..." spellcheck="false" required></textarea>
                <span id="send-btn" class="material-symbols-rounded">send</span>
            </div>
        </div>
    </div> 

    <!-- FOOTER -->
    <div class="footer">
        © 2025 Abhishikha Trust | All Rights Reserved
    </div>



    <script>
        // Show the reports section by default on page load
        window.onload = function() {
            showSection('reports'); // Set the reports section as active
        }
    </script>

    <%
        // Check if there is an alert message to display
        String alertMsg = request.getParameter("alert");
        if (alertMsg != null) {
            // Retrieve alert message from session
            String alertMessage = (String) session.getAttribute("alertMessage");
            if (alertMessage != null) {
    %>
                <script>
                    alert("<%= alertMessage %>"); // Show the alert with the message
                </script>
    <%
                // Remove the alert message from session so it doesn't show after refresh
                session.removeAttribute("alertMessage");
            }
        }
    %>
    
        <!-- Include JavaScript files -->
    <script src="${pageContext.request.contextPath}/static/chatbot.js"></script>
    <script src="${pageContext.request.contextPath}/static/nvb.js"></script>
    
        <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script>
    $(document).ready(function () {
        $('#donorsTable').DataTable();
    });
    $(document).ready(function () {
        $('#donationsTable').DataTable();
    });
    $(document).ready(function () {
        $('#agentsTable').DataTable();
    });
</script>
</body>
</html>