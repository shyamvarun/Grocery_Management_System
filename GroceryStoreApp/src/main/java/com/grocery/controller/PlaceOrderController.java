package com.grocery.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.grocery.dao.*;
import com.grocery.dto.*;
import com.grocery.utility.DBConnection;

@WebServlet("/PlaceOrderController")
public class PlaceOrderController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        RegistrationDTO loggedInUser = (RegistrationDTO) session.getAttribute("loggedInUser");
        
        if (userId == null || loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get form data
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String paymentMethod = request.getParameter("paymentMethod");
            
            // Get cart items
            CartDAO cartDAO = new CartDAO();
            List<CartItem> cartItems = cartDAO.getCartItems(userId);
            
            if (cartItems.isEmpty()) {
                session.setAttribute("errorMsg", "Cart is empty!");
                response.sendRedirect("billing.jsp");
                return;
            }
            
            // Calculate totals
            BigDecimal subtotal = BigDecimal.ZERO;
            BigDecimal totalGst = BigDecimal.ZERO;
            
            for (CartItem item : cartItems) {
                subtotal = subtotal.add(item.getSubtotal());
                totalGst = totalGst.add(item.getGstAmount());
            }
            
            BigDecimal grandTotal = subtotal.add(totalGst);
            
            // Create order in database
            int orderId = createOrder(userId, grandTotal, paymentMethod);
            
            if (orderId > 0) {
                // Add order items
                addOrderItems(orderId, cartItems);
                
                
             // Update stock and check for low stock
                ProductDAO productDAO = new ProductDAO();
                for (CartItem item : cartItems) {
                    productDAO.updateStock(item.getProductId(), item.getQuantity());
                    
                    // ✅ Check if stock is low and send email alert
                    productDAO.checkLowStock(item.getProductId());
                }

                
                // Clear cart
                cartDAO.clearCart(userId);
                
                // Store order details in session
                session.setAttribute("orderId", orderId);
                session.setAttribute("orderTotal", grandTotal);
                session.setAttribute("paymentMethod", paymentMethod);
                session.setAttribute("customerName", fullName);
                session.setAttribute("customerPhone", phone);
                session.setAttribute("customerEmail", email);
                
                System.out.println("Order created: #" + orderId + " | Payment: " + paymentMethod);
                
                // DECISION: Cash or Other Payment
                if ("cash".equalsIgnoreCase(paymentMethod)) {
                    // CASH PAYMENT → Direct to Bill
                    response.sendRedirect("generate-bill.jsp?orderId=" + orderId);
                } else {
                    // UPI/CARD/NETBANKING → Payment Gateway
                    response.sendRedirect("payment-gateway.jsp?orderId=" + orderId);
                }
            } else {
                session.setAttribute("errorMsg", "Failed to create order!");
                response.sendRedirect("checkout.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Error: " + e.getMessage());
            response.sendRedirect("checkout.jsp");
        }
    }
    
    
    
 // Create order in database
    private int createOrder(int userId, BigDecimal total, String paymentMethod) {
        String sql = "INSERT INTO orders (user_id, total_amount, discount, gst_amount, final_amount, payment_method, payment_status, order_date) " +
                     "VALUES (?, ?, 0, 0, ?, ?, 'Pending', NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, userId);
            stmt.setBigDecimal(2, total);
            stmt.setBigDecimal(3, total);      // final_amount = total_amount
            stmt.setString(4, paymentMethod);
            
            int rows = stmt.executeUpdate();
            
            if (rows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    int orderId = rs.getInt(1);
                    System.out.println("✅ Order created successfully: ID = " + orderId);
                    return orderId;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error creating order: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Add order items
    private void addOrderItems(int orderId, List<CartItem> cartItems) {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, price, total) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            for (CartItem item : cartItems) {
                stmt.setInt(1, orderId);
                stmt.setInt(2, item.getProductId());
                stmt.setInt(3, item.getQuantity());
                stmt.setBigDecimal(4, item.getPrice());
                stmt.setBigDecimal(5, item.getTotal());
                stmt.addBatch();
            }
            
            stmt.executeBatch();
            System.out.println("Order items added successfully for order: " + orderId);
        } catch (SQLException e) {
            System.err.println("Error adding order items: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
