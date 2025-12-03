package com.grocery.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.grocery.dao.CartDAO;
import com.grocery.dao.ProductDAO;
import com.grocery.dto.Product;

@WebServlet("/AddToCartController")
public class AddToCartController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartDAO cartDAO = new CartDAO();
    private ProductDAO productDAO = new ProductDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Check if user is logged in
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String method = request.getParameter("method"); // "barcode" or "manual"
        Product product = null;
        
        try {
            if ("barcode".equals(method)) {
                // METHOD 1: BARCODE SCANNING
                String barcode = request.getParameter("barcode");
                
                if (barcode != null && !barcode.trim().isEmpty()) {
                    product = productDAO.getProductByBarcode(barcode.trim());
                    
                    if (product != null) {
                        // Check stock availability
                        if (product.getStockQuantity() > 0) {
                            cartDAO.addToCart(userId, product.getProductId(), 1);
                            session.setAttribute("successMsg", "✅ Added: " + product.getProductName());
                        } else {
                            session.setAttribute("errorMsg", "❌ Out of Stock: " + product.getProductName());
                        }
                    } else {
                        session.setAttribute("errorMsg", "❌ Product not found! Barcode: " + barcode);
                    }
                }
                
            } else if ("manual".equals(method)) {
                // METHOD 2: MANUAL SELECTION
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                
                product = productDAO.getProductById(productId);
                
                if (product != null) {
                    // Check stock availability
                    if (product.getStockQuantity() >= quantity) {
                        cartDAO.addToCart(userId, productId, quantity);
                        session.setAttribute("successMsg", "✅ Added " + quantity + "x " + product.getProductName());
                    } else {
                        session.setAttribute("errorMsg", "❌ Only " + product.getStockQuantity() + " items available");
                    }
                } else {
                    session.setAttribute("errorMsg", "❌ Product not found!");
                }
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "❌ Invalid input!");
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("errorMsg", "❌ Error adding to cart!");
            e.printStackTrace();
        }
        
        // Redirect back to billing page
        response.sendRedirect("billing.jsp");
    }
}
