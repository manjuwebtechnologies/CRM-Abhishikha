package utils;

import java.sql.*;

public class DBUtil {
    // Disable SSL, avoid SSLException, and ensure reliable timezone handling
	private static final String URL = "jdbc:mysql://localhost:3306/crm3?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Calcutta";
    private static final String USER = "root";
    private static final String PASSWORD = "7303424711";
    

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found:");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // Generic close method (safe closing of resources)
    public static void close(Connection con, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
        try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
        try { if (con != null) con.close(); } catch (SQLException ignored) {}
    }

    public static void close(Connection con, PreparedStatement ps) {
        close(con, ps, null);
    }
}
