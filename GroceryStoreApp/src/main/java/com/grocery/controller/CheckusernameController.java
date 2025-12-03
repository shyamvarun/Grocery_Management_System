package com.grocery.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.grocery.utility.DBConnection;

@WebServlet("/CheckusernameController")
public class CheckusernameController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("checkusername");  // ✅ Fixed
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            boolean available = checkUsernameAvailability(username);
            
            out.print("{\"available\": " + available + "}");
            
            System.out.println("Username check: '" + username + "' → Available: " + available);
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"available\": false}");
        }
        
        out.flush();
    }
    
    private boolean checkUsernameAvailability(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("  Found " + count + " matching username(s) in database");
                return count == 0; // true if available (count = 0)
            }
            
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false; // Default: not available if error
    }
}
