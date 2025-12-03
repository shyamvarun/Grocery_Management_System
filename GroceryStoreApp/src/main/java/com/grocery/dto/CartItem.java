package com.grocery.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int cartId;
    private int userId;
    private int productId;
    private String productName;
    private BigDecimal price;
    private int quantity;
    private BigDecimal gstPercentage;
    private String barcode;
    
    public CartItem() {}
    
    public CartItem(int productId, String productName, BigDecimal price, int quantity) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public BigDecimal getGstPercentage() { return gstPercentage; }
    public void setGstPercentage(BigDecimal gstPercentage) { this.gstPercentage = gstPercentage; }
    
    public String getBarcode() { return barcode; }
    public void setBarcode(String barcode) { this.barcode = barcode; }
    
    // Calculate subtotal (price * quantity)
    public BigDecimal getSubtotal() {
        return price.multiply(new BigDecimal(quantity));
    }
    
    // Calculate GST amount
    public BigDecimal getGstAmount() {
        if (gstPercentage != null) {
            return getSubtotal().multiply(gstPercentage).divide(new BigDecimal(100));
        }
        return BigDecimal.ZERO;
    }
    
    // Get total including GST
    public BigDecimal getTotal() {
        return getSubtotal().add(getGstAmount());
    }
}
