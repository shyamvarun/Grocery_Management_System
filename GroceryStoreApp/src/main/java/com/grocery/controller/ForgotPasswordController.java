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
import com.grocery.utility.EmailUtility;

@WebServlet("/ForgotPasswordController")
public class ForgotPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Handle resend OTP
        String resend = request.getParameter("resend");
        if ("true".equals(resend)) {
            resendOTP(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        HttpSession session = request.getSession();
        
        try {
            // Check if email exists in database
            String sql = "SELECT user_id, full_name FROM users WHERE email = ?";
            
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                
                stmt.setString(1, email);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    int userId = rs.getInt("user_id");
                    String fullName = rs.getString("full_name");
                    
                    // Generate OTP
                    String otp = EmailUtility.generateOTP();
                    
                    // Store OTP and expiry time in session
                    session.setAttribute("resetOTP", otp);
                    session.setAttribute("resetEmail", email);
                    session.setAttribute("resetUserId", userId);
                    session.setAttribute("otpExpiry", System.currentTimeMillis() + (10 * 60 * 1000)); // 10 minutes
                    
                    // Send OTP email
                    boolean emailSent = EmailUtility.sendOTPEmail(email, otp, fullName);
                    
                    if (emailSent) {
                        System.out.println("✅ OTP sent to: " + email + " | OTP: " + otp);
                        session.setAttribute("successMsg", "OTP sent to your email successfully!");
                        response.sendRedirect("verifyOTP.jsp");
                    } else {
                        session.setAttribute("errorMsg", "Failed to send OTP. Please try again.");
                        response.sendRedirect("forgotPassword.jsp");
                    }
                    
                } else {
                    // Email not found
                    session.setAttribute("errorMsg", "Email not registered!");
                    response.sendRedirect("forgotPassword.jsp");
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Database error. Please try again.");
            response.sendRedirect("forgotPassword.jsp");
        }
    }
    
    /**
     * Resend OTP
     */
    private void resendOTP(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");
        
        if (email == null) {
            response.sendRedirect("forgotPassword.jsp");
            return;
        }
        
        try {
            String sql = "SELECT full_name FROM users WHERE email = ?";
            
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                
                stmt.setString(1, email);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    String fullName = rs.getString("full_name");
                    
                    // Generate new OTP
                    String otp = EmailUtility.generateOTP();
                    
                    // Update session
                    session.setAttribute("resetOTP", otp);
                    session.setAttribute("otpExpiry", System.currentTimeMillis() + (10 * 60 * 1000));
                    
                    // Send email
                    boolean emailSent = EmailUtility.sendOTPEmail(email, otp, fullName);
                    
                    if (emailSent) {
                        System.out.println("✅ OTP resent to: " + email + " | OTP: " + otp);
                        session.setAttribute("successMsg", "OTP resent successfully!");
                    } else {
                        session.setAttribute("errorMsg", "Failed to resend OTP.");
                    }
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Error resending OTP.");
        }
        
        response.sendRedirect("verifyOTP.jsp");
    }
}
