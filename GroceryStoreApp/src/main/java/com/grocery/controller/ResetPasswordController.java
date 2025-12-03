package com.grocery.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.grocery.utility.DBConnection;

@WebServlet("/ResetPasswordController")
public class ResetPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if OTP was verified
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        Integer userId = (Integer) session.getAttribute("resetUserId");
        String email = (String) session.getAttribute("resetEmail");
        
        if (otpVerified == null || !otpVerified || userId == null) {
            session.setAttribute("errorMsg", "Unauthorized access!");
            response.sendRedirect("forgotPassword.jsp");
            return;
        }
        
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate passwords match
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("errorMsg", "Passwords do not match!");
            response.sendRedirect("resetPassword.jsp");
            return;
        }
        
        // Validate password length
        if (newPassword.length() < 4) {
            session.setAttribute("errorMsg", "Password must be at least 6 characters!");
            response.sendRedirect("resetPassword.jsp");
            return;
        }
        
        try {
            // Update password in database
            String sql = "UPDATE users SET password = ? WHERE user_id = ?";
            
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                
                stmt.setString(1, newPassword);
                stmt.setInt(2, userId);
                
                int rowsUpdated = stmt.executeUpdate();
                
                if (rowsUpdated > 0) {
                    System.out.println("✅ Password reset successful for: " + email);
                    
                    // Clear all session attributes
                    session.removeAttribute("otpVerified");
                    session.removeAttribute("resetUserId");
                    session.removeAttribute("resetEmail");
                    
                    // Set success message for login page
                    session.setAttribute("successMsg", "Password reset successful! Please login with your new password.");
                    response.sendRedirect("login.jsp");
                    
                } else {
                    session.setAttribute("errorMsg", "Failed to reset password. Please try again.");
                    response.sendRedirect("resetPassword.jsp");
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Database error. Please try again.");
            response.sendRedirect("resetPassword.jsp");
        }
    }
}
