<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBUtil" %>

<%
    double totalDonations = 0;
    double adminDonations = 0;
    double agentDonations = 0;
    double todayDonations = 0;
    double currentMonthDonations = 0;
    double lastMonthDonations = 0;
    double currentYearDonations = 0;
    int totalDonors = 0;
    int totalAgents = 0;

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBUtil.getConnection();

        // Total, Admin, Agent Donations
        ps = con.prepareStatement(
            "SELECT " +
            "IFNULL(SUM(d.amount), 0) AS total, " +
            "IFNULL(SUM(CASE WHEN u.role = 'admin' THEN d.amount ELSE 0 END), 0) AS adminTotal, " +
            "IFNULL(SUM(CASE WHEN u.role != 'admin' OR u.role IS NULL THEN d.amount ELSE 0 END), 0) AS agentTotal " +
            "FROM donations d " +
            "LEFT JOIN users u ON d.agent_id = u.id"
        );
        rs = ps.executeQuery();
        if (rs.next()) {
            totalDonations = rs.getDouble("total");
            adminDonations = rs.getDouble("adminTotal");
            agentDonations = rs.getDouble("agentTotal");
        }
        rs.close(); ps.close();

        // Total Donors (distinct donors)
        ps = con.prepareStatement("SELECT COUNT(DISTINCT id) AS totalDonors FROM donors");
        rs = ps.executeQuery();
        if (rs.next()) {
            totalDonors = rs.getInt("totalDonors");
        }
        rs.close(); ps.close();

        // Today Donation
        ps = con.prepareStatement("SELECT IFNULL(SUM(amount), 0) AS todayTotal FROM donations WHERE DATE(created_at) = CURDATE()");
        rs = ps.executeQuery();
        if (rs.next()) {
            todayDonations = rs.getDouble("todayTotal");
        }
        rs.close(); ps.close();

        // Current Month Donation
        ps = con.prepareStatement(
            "SELECT IFNULL(SUM(amount), 0) AS currentMonthTotal " +
            "FROM donations WHERE MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE())"
        );
        rs = ps.executeQuery();
        if (rs.next()) {
            currentMonthDonations = rs.getDouble("currentMonthTotal");
        }
        rs.close(); ps.close();

        // Last Month Donation
        ps = con.prepareStatement(
            "SELECT IFNULL(SUM(amount), 0) AS lastMonthTotal " +
            "FROM donations WHERE MONTH(created_at) = MONTH(CURDATE() - INTERVAL 1 MONTH) " +
            "AND YEAR(created_at) = YEAR(CURDATE() - INTERVAL 1 MONTH)"
        );
        rs = ps.executeQuery();
        if (rs.next()) {
            lastMonthDonations = rs.getDouble("lastMonthTotal");
        }
        rs.close(); ps.close();

        // Current Year Donation
        ps = con.prepareStatement("SELECT IFNULL(SUM(amount), 0) AS yearTotal FROM donations WHERE YEAR(created_at) = YEAR(CURDATE())");
        rs = ps.executeQuery();
        if (rs.next()) {
            currentYearDonations = rs.getDouble("yearTotal");
        }
        rs.close(); ps.close();

        // Total Agents
        ps = con.prepareStatement("SELECT COUNT(*) AS totalAgents FROM users WHERE role = 'agent'");
        rs = ps.executeQuery();
        if (rs.next()) {
            totalAgents = rs.getInt("totalAgents");
        }
        rs.close(); ps.close();
%>

<div class="section active" id="reports">
<div style="display: flex; flex-wrap: wrap; gap: 20px; justify-content: center; padding: 40px;">
    <div class="card">
        <i class="fa-solid fa-user-tie" style="background-color: #654891;"></i>
        <div>
            <div>Total Donor</div>
            <div><%= totalDonors %></div>
        </div>
    </div>
    <div class="card">
        <i style="background-color: #447085;" class="fa-solid fa-calendar-day"></i>
        <div>
            <div>Today Donation</div>
            <div>₹<%= todayDonations %></div>
        </div>
    </div>
    <div class="card">
        <i style="background-color: #438548;" class="fa-solid fa-coins"></i>
        <div>
            <div>Total Donation</div>
            <div>₹<%= totalDonations %></div>
        </div>
    </div>
    <div class="card">
        <i style="background-color: #86784b;" class="fa-solid fa-user-tie"></i>
        <div>
            <div>Total Agent</div>
            <div><%= totalAgents %></div>
        </div>
    </div>
    <div class="card">
        <i class="fa-solid fa-calendar-alt" style="background-color: #c28c34;"></i>
        <div>
            <div>Current Month Donation</div>
            <div>₹<%= currentMonthDonations %></div>
        </div>
    </div>
    <div class="card">
        <i class="fa-solid fa-calendar-minus" style="background-color: #a047ad;"></i>
        <div>
            <div>Last Month Donation</div>
            <div>₹<%= lastMonthDonations %></div>
        </div>
    </div>
    <div class="card">
        <i class="fa-solid fa-calendar-check" style="background-color: #3f8884;"></i>
        <div>
            <div>Current Year Donation</div>
            <div>₹<%= currentYearDonations %></div>
        </div>
    </div>
</div>
</div>

<% 
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBUtil.close(con, ps, rs);
    }
%>
