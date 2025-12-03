package com.grocery.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LogoutController")
public class LogoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;  // ← ADD THIS LINE
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get existing session (don't create new)
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Log session destruction (optional - for debugging)
            System.out.println("Logging out user: " + session.getAttribute("username"));
            System.out.println("Session ID: " + session.getId());
            
            // Destroy session
            session.invalidate();
        }
        
        // Redirect to login page
        response.sendRedirect("login.jsp");
    }
}
