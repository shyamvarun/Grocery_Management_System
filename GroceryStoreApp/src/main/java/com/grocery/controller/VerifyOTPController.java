package com.grocery.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/VerifyOTPController")
public class VerifyOTPController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Get stored OTP and expiry
        String storedOTP = (String) session.getAttribute("resetOTP");
        Long otpExpiry = (Long) session.getAttribute("otpExpiry");
        String email = (String) session.getAttribute("resetEmail");
        
        if (storedOTP == null || otpExpiry == null || email == null) {
            session.setAttribute("errorMsg", "Session expired. Please start again.");
            response.sendRedirect("forgotPassword.jsp");
            return;
        }
        
        // Check if OTP expired
        if (System.currentTimeMillis() > otpExpiry) {
            session.setAttribute("errorMsg", "OTP expired! Please request a new one.");
            response.sendRedirect("verifyOTP.jsp");
            return;
        }
        
        // Get entered OTP
        String otp1 = request.getParameter("otp1");
        String otp2 = request.getParameter("otp2");
        String otp3 = request.getParameter("otp3");
        String otp4 = request.getParameter("otp4");
        String otp5 = request.getParameter("otp5");
        String otp6 = request.getParameter("otp6");
        
        String enteredOTP = otp1 + otp2 + otp3 + otp4 + otp5 + otp6;
        
        // Verify OTP
        if (storedOTP.equals(enteredOTP)) {
            // OTP verified successfully
            session.setAttribute("otpVerified", true);
            session.removeAttribute("resetOTP"); // Clear OTP from session
            session.removeAttribute("otpExpiry");
            
            System.out.println("✅ OTP verified for: " + email);
            response.sendRedirect("resetPassword.jsp");
            
        } else {
            // Wrong OTP
            session.setAttribute("errorMsg", "Invalid OTP! Please try again.");
            response.sendRedirect("verifyOTP.jsp");
        }
    }
}
