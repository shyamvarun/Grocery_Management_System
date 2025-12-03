package com.grocery.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.grocery.dao.CartDAO;

@WebServlet("/RemoveFromCartController")
public class RemoveFromCartController extends HttpServlet {
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
            
            if (cartDAO.removeFromCart(userId, productId)) {
                session.setAttribute("successMsg", "✅ Item removed from cart");
            } else {
                session.setAttribute("errorMsg", "❌ Failed to remove item");
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "❌ Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        response.sendRedirect("billing.jsp");
    }
}
