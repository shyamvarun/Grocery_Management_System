package com.grocery.controller;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.grocery.dao.UserDAO;
import com.grocery.dto.LoginDTO;
import com.grocery.dto.RegistrationDTO;

@WebServlet("/LoginController")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    public LoginController() {
        super();
        this.userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");
        
        // Validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Username and password are required!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Create LoginDTO object
        LoginDTO loginDTO = new LoginDTO();
        loginDTO.setUsername(username);
        loginDTO.setPassword(password);
        loginDTO.setRememberMe(rememberMe != null);
        
        // Validate credentials and get user in one call
        RegistrationDTO user = userDAO.authenticateUser(loginDTO);
        
        if (user != null) {
            // Login successful - Create session
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("userId", user.getUserId()); // ← CRITICAL for billing
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            
            System.out.println("User logged in: " + username + " (ID: " + user.getUserId() + ")");
            
            // Redirect to home page
            response.sendRedirect("home.jsp");
        } else {
            // Login failed
            request.setAttribute("errorMessage", "Invalid username or password!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }
}
