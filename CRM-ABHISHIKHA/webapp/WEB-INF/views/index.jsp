<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String role = (String) session.getAttribute("role");
    if (role != null) {
        if ("admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/page/admin-dashboard");
        } else if ("agent".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/page/agent-dashboard");
        }
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Abhishikha Trust</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 0;
            background: #000;
            color: white;
        }
        
        body *{
        	font-family: 'Segoe UI', sans-serif;
        }

        .container {
            width: 100%;
            height: 100vh;
            background-image: url("/CRM_ABHISHIKHA/images/bg.png");
            background-repeat: no-repeat;
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .card {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 40px 30px;
            backdrop-filter: blur(10px);
            max-width: 400px;
            width: 100%;
            overflow: hidden;
            text-align: center;
            position: relative;
        }

        .card h1 {
            font-size: 28px;
            margin-bottom: 10px;
            color: #fff;
        }

        .card h4 {
            font-size: 13px;
            margin-bottom: 20px;
            color: #ccc;
        }

        .form-buttons {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .form-buttons button {
            flex: 1;
            margin: 0 5px;
            padding: 10px;
            border: none;
            border-radius: 6px;
            background-color: #0d5a45;
            color: white;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .form-buttons button:hover {
            background-color: #0b4a39;
        }

        .inner-container {
            display: flex;
            width: 220%;
            transition: transform 0.5s ease-in-out;
           
        }

        .inner-container form {
            width: 100%;
            padding: 0 10px;
             margin-right: 35px;
        }

        .form-group {
            margin-bottom: 15px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
        }

        .form-group input {
            width: 100%;
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #ccc;
            outline: none;
        }

        .submit-btn {
            width: 100%;
            background-color: #0d5a45;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .submit-btn:hover {
            background-color: #0b4a39;
        }

        @media (max-width: 480px) {
            .card {
                padding: 30px 20px;
            }

            .form-buttons {
                flex-direction: column;
                gap: 10px;
            }

            .form-buttons button {
                margin: 0;
            }

            .inner-container {
                flex-direction: column;
                width: 100%;
            }

            .inner-container form {
                width: 100%;
                transform: translateX(0) !important;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="card">
        <h1>Welcome to Abhishikha Trust</h1>
        <h4>NGO Darpan ID - DL/2021/0295775<br>Donations exempt under 80G(5)(VI)</h4>

        <div class="form-buttons">
            <button onclick="slideTo('admin')">Admin</button>
            <button onclick="slideTo('agent')">Agent</button>
        </div>

        <h3 id="loginTitle">Admin Login</h3>

        <div class="inner-container" id="inner-container">
            <!-- Admin Form -->
            <form id="adminForm" action="<%= request.getContextPath() %>/AdminLoginS" method="post">
                <input type="hidden" id="roleInput" name="role" value="admin" />
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" name="username" required />
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" name="password" required />
                </div>
                <button class="submit-btn" type="submit">Login</button>
            </form>

            <!-- Agent Form -->
            <form id="agentForm" action="<%= request.getContextPath() %>/AgentLoginS" method="post">
                <input type="hidden" id="roleInput" name="role" value="agent" />
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" name="username" required />
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" name="password" required />
                </div>
                <button class="submit-btn" type="submit">Login</button>
            </form>
        </div>
    </div>
</div>

<script>
    function slideTo(role) {
        const container = document.getElementById("inner-container");
        const title = document.getElementById("loginTitle");
        const roleInput = document.querySelectorAll("#roleInput");

        if (role === "admin") {
            container.style.transform = "translateX(0%)";
            title.innerText = "Admin Login";
            roleInput.forEach(input => input.value = "admin");
        } else {
            container.style.transform = "translateX(-50%)";
            title.innerText = "Agent Login";
            roleInput.forEach(input => input.value = "agent");
        }
    }
</script>
</body>
</html>
