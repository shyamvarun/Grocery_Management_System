<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.grocery.dto.*, java.util.*, java.math.*, com.grocery.dao.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.grocery.utility.DBConnection" %>
<%
    // Check if user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    RegistrationDTO loggedInUser = (RegistrationDTO) session.getAttribute("loggedInUser");
    Integer orderId = (Integer) session.getAttribute("orderId");
    BigDecimal orderTotal = (BigDecimal) session.getAttribute("orderTotal");
    String paymentMethod = (String) session.getAttribute("paymentMethod");
    String customerName = (String) session.getAttribute("customerName");
    String customerPhone = (String) session.getAttribute("customerPhone");
    String customerEmail = (String) session.getAttribute("customerEmail");
    
    if (userId == null || orderId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get order items from database
    List<CartItem> orderItems = new ArrayList<>();
    BigDecimal subtotal = BigDecimal.ZERO;
    BigDecimal totalGst = BigDecimal.ZERO;
    
    String sql = "SELECT oi.*, p.product_name, p.gst_percentage " +
                 "FROM order_items oi " +
                 "JOIN products p ON oi.product_id = p.product_id " +
                 "WHERE oi.order_id = ?";
    
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    try {
        conn = DBConnection.getConnection();
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, orderId);
        rs = stmt.executeQuery();
        
        while (rs.next()) {
            CartItem item = new CartItem();
            item.setProductName(rs.getString("product_name"));
            item.setQuantity(rs.getInt("quantity"));
            item.setPrice(rs.getBigDecimal("price"));
            
            BigDecimal gstPercent = rs.getBigDecimal("gst_percentage");
            BigDecimal itemSubtotal = item.getPrice().multiply(new BigDecimal(item.getQuantity()));
            BigDecimal itemGst = itemSubtotal.multiply(gstPercent).divide(new BigDecimal(100));
            
            subtotal = subtotal.add(itemSubtotal);
            totalGst = totalGst.add(itemGst);
            
            orderItems.add(item);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
    
    BigDecimal grandTotal = subtotal.add(totalGst);
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy hh:mm a");
    String currentDate = dateFormat.format(new java.util.Date());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice #<%= orderId %> - Grocery Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Arial', sans-serif;
            background: #f5f5f5;
            padding: 20px;
        }
        
        .invoice-container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            border: 1px solid #ddd;
        }
        
        .invoice-header {
            text-align: center;
            border-bottom: 3px solid #4CAF50;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        
        .invoice-header h1 {
            color: #4CAF50;
            font-size: 36px;
            margin-bottom: 5px;
        }
        
        .invoice-header p {
            color: #666;
            font-size: 14px;
        }
        
        .success-badge {
            background: #4CAF50;
            color: white;
            padding: 15px 30px;
            border-radius: 50px;
            display: inline-block;
            margin: 20px 0;
            font-size: 18px;
            font-weight: bold;
        }
        
        .invoice-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 8px;
        }
        
        .info-section h3 {
            color: #4CAF50;
            margin-bottom: 10px;
            font-size: 16px;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 5px;
        }
        
        .info-section p {
            margin: 8px 0;
            color: #333;
            font-size: 14px;
        }
        
        .info-section strong {
            color: #666;
            display: inline-block;
            width: 100px;
        }
        
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin: 30px 0;
        }
        
        .items-table thead {
            background: #4CAF50;
            color: white;
        }
        
        .items-table th {
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }
        
        .items-table td {
            padding: 12px;
            border-bottom: 1px solid #eee;
        }
        
        .items-table tbody tr:hover {
            background: #f9f9f9;
        }
        
        .items-table tfoot {
            font-weight: bold;
            background: #f5f5f5;
        }
        
        .totals-section {
            float: right;
            width: 350px;
            margin-top: 20px;
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 15px;
            border-bottom: 1px solid #eee;
            font-size: 15px;
        }
        
        .total-row.grand-total {
            background: #4CAF50;
            color: white;
            font-size: 20px;
            font-weight: bold;
            border-radius: 8px;
            margin-top: 10px;
        }
        
        .thank-you {
            text-align: center;
            margin-top: 50px;
            padding: 30px;
            background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
            border-radius: 8px;
        }
        
        .thank-you h2 {
            color: #4CAF50;
            margin-bottom: 10px;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            justify-content: center;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background: #4CAF50;
            color: white;
        }
        
        .btn-primary:hover {
            background: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
        }
        
        .btn-secondary {
            background: #2196F3;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #0b7dda;
        }
        
        .invoice-footer {
            margin-top: 50px;
            text-align: center;
            padding-top: 20px;
            border-top: 2px solid #eee;
            color: #666;
            font-size: 13px;
        }
        
        @media print {
            .action-buttons {
                display: none;
            }
            
            body {
                background: white;
            }
            
            .invoice-container {
                box-shadow: none;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="invoice-container">
        <!-- Header -->
        <div class="invoice-header">
            <h1><i class="fas fa-shopping-cart"></i> GROCERY STORE</h1>
            <p>Fresh Groceries</p>
            <p style="margin-top: 5px;">📍 123 Main Street, Hyderabad, Telangana 500001</p>
            <p>📞 +91 1234567890 | ✉️ info@grocerystore.com</p>
        </div>
        
        <!-- Success Badge -->
        <div style="text-align: center;">
            <div class="success-badge">
                <i class="fas fa-check-circle"></i> Billing Summary
            </div>
        </div>
        
        <!-- Invoice Info -->
        <div class="invoice-info">
            <div class="info-section">
                <h3><i class="fas fa-user"></i> Customer Details</h3>
                <p><strong>Name:</strong> <%= customerName != null ? customerName : loggedInUser.getFullName() %></p>
                <p><strong>Phone:</strong> <%= customerPhone != null ? customerPhone : (loggedInUser.getPhone() != null ? loggedInUser.getPhone() : "N/A") %></p>
            </div>
            
            <div class="info-section">
                <h3><i class="fas fa-file-invoice"></i> Invoice Details</h3>
                <p><strong>Invoice No:</strong> #<%= orderId %></p>
                <p><strong>Date:</strong> <%= currentDate %></p>
                <p><strong>Payment:</strong> <%= paymentMethod.toUpperCase() %></p>
                <p><strong>Status:</strong> <span style="color: #4CAF50; font-weight: bold;">✓ PAID</span></p>
            </div>
        </div>
        
        <!-- Order Items Table -->
        <h3 style="color: #4CAF50; margin-bottom: 15px; border-bottom: 2px solid #4CAF50; padding-bottom: 10px;">
            <i class="fas fa-shopping-basket"></i> Order Items
        </h3>
        
        <table class="items-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                <% 
                int itemNo = 1;
                for (CartItem item : orderItems) { 
                %>
                    <tr>
                        <td><%= itemNo++ %></td>
                        <td><%= item.getProductName() %></td>
                        <td>₹<%= item.getPrice() %></td>
                        <td><%= item.getQuantity() %></td>
                        <td>₹<%= item.getTotal() %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        
        <!-- Totals Section -->
        <div class="totals-section">
            <div class="total-row">
                <span>Subtotal (<%= orderItems.size() %> items)</span>
                <span>₹<%= subtotal %></span>
            </div>
            
            <div class="total-row">
                <span>GST</span>
                <span>₹<%= totalGst %></span>
            </div>
            
            <div class="total-row grand-total">
                <span>GRAND TOTAL</span>
                <span>₹<%= grandTotal %></span>
            </div>
        </div>
        
        <div style="clear: both;"></div>
        
        <!-- Thank You Message -->
        <div class="thank-you">
            <h2><i class="fas fa-heart"></i> Thank You for Shopping!</h2>
            <p style="color: #666; margin-top: 10px;">
                visit again.
            </p>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <button class="btn btn-primary" onclick="window.print()">
                <i class="fas fa-print"></i> Print Invoice
            </button>
            <button class="btn btn-primary" onclick="downloadPDF()">
                <i class="fas fa-download"></i> Download PDF
            </button>
            <a href="home.jsp" class="btn btn-secondary">
                <i class="fas fa-home"></i> Back to Home
            </a>
        </div>
        
    
    <script>
        // Download as PDF (browser print to PDF)
        function downloadPDF() {
            window.print();
        }
    </script>
</body>
</html>
