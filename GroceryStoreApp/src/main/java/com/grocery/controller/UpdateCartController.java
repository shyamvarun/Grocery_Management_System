package com.grocery.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.grocery.dao.CartDAO;

@WebServlet("/UpdateCartController")
public class UpdateCartController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartDAO cartDAO = new CartDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String action = request.getParameter("action");
            
            if ("increment".equals(action)) {
                boolean success = cartDAO.incrementQuantity(userId, productId);
                if (success) {
                    session.setAttribute("successMsg", "✅ Quantity increased!");
                } else {
                    session.setAttribute("errorMsg", "❌ Failed to increase quantity!");
                }
            } else if ("decrement".equals(action)) {
                boolean success = cartDAO.decrementQuantity(userId, productId);
                if (success) {
                    session.setAttribute("successMsg", "✅ Quantity decreased!");
                } else {
                    session.setAttribute("errorMsg", "❌ Failed to decrease quantity!");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "❌ Error updating cart!");
        }
        
        response.sendRedirect("billing.jsp");
    }
}
