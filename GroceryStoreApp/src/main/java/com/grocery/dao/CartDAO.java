package com.grocery.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.grocery.dto.CartItem;
import com.grocery.utility.DBConnection;

public class CartDAO {
    
    // Add product to cart (or increase quantity if already exists)
    public boolean addToCart(int userId, int productId, int quantity) {
        // Check if product already in cart
        if (isProductInCart(userId, productId)) {
            return updateCartQuantity(userId, productId, quantity);
        } else {
            return insertNewCartItem(userId, productId, quantity);
        }
    }
    
    // Check if product already exists in cart
    private boolean isProductInCart(int userId, int productId) {
        String sql = "SELECT cart_id FROM cart WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            ResultSet rs = stmt.executeQuery();
            
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Insert new item to cart
    private boolean insertNewCartItem(int userId, int productId, int quantity) {
        String sql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            stmt.setInt(3, quantity);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Update quantity of existing cart item
    private boolean updateCartQuantity(int userId, int productId, int quantityToAdd) {
        String sql = "UPDATE cart SET quantity = quantity + ? WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantityToAdd);
            stmt.setInt(2, userId);
            stmt.setInt(3, productId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Get all cart items for a user
    public List<CartItem> getCartItems(int userId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT c.cart_id, c.user_id, c.product_id, c.quantity, " +
                     "p.product_name, p.price, p.gst_percentage, p.barcode " +
                     "FROM cart c " +
                     "JOIN products p ON c.product_id = p.product_id " +
                     "WHERE c.user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setCartId(rs.getInt("cart_id"));
                item.setUserId(rs.getInt("user_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setQuantity(rs.getInt("quantity"));
                item.setGstPercentage(rs.getBigDecimal("gst_percentage"));
                item.setBarcode(rs.getString("barcode"));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
    
    // Remove item from cart
    public boolean removeFromCart(int userId, int productId) {
        String sql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Clear entire cart
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
 // ADD THIS METHOD - Increment quantity
    public boolean incrementQuantity(int userId, int productId) {
        String sql = "UPDATE cart SET quantity = quantity + 1 WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            
            int rows = stmt.executeUpdate();
            System.out.println("✅ Quantity incremented for product: " + productId);
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Error incrementing quantity: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ADD THIS METHOD - Decrement quantity
    public boolean decrementQuantity(int userId, int productId) {
        // First check current quantity
        String checkSql = "SELECT quantity FROM cart WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            
            checkStmt.setInt(1, userId);
            checkStmt.setInt(2, productId);
            
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                int currentQty = rs.getInt("quantity");
                
                if (currentQty > 1) {
                    // Decrease quantity by 1
                    String updateSql = "UPDATE cart SET quantity = quantity - 1 WHERE user_id = ? AND product_id = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setInt(1, userId);
                    updateStmt.setInt(2, productId);
                    int rows = updateStmt.executeUpdate();
                    System.out.println("✅ Quantity decremented for product: " + productId);
                    return rows > 0;
                } else {
                    // If quantity is 1, remove item from cart
                    String deleteSql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
                    PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                    deleteStmt.setInt(1, userId);
                    deleteStmt.setInt(2, productId);
                    int rows = deleteStmt.executeUpdate();
                    System.out.println("✅ Item removed from cart (quantity was 1): " + productId);
                    return rows > 0;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error decrementing quantity: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    
    // Update specific quantity
    public boolean setQuantity(int userId, int productId, int newQuantity) {
        if (newQuantity <= 0) {
            return removeFromCart(userId, productId);
        }
        
        String sql = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, newQuantity);
            stmt.setInt(2, userId);
            stmt.setInt(3, productId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
