<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.grocery.dto.*, java.util.*, java.math.*, com.grocery.dao.*" %>
<%
    // Check if user is logged in
    RegistrationDTO loggedInUser = (RegistrationDTO) session.getAttribute("loggedInUser");
    Integer userId = (Integer) session.getAttribute("userId");
    
    if (loggedInUser == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get cart items
    CartDAO cartDAO = new CartDAO();
    List<CartItem> cartItems = cartDAO.getCartItems(userId);
    
    // Calculate totals
    BigDecimal subtotal = BigDecimal.ZERO;
    BigDecimal totalGst = BigDecimal.ZERO;
    
    for (CartItem item : cartItems) {
        subtotal = subtotal.add(item.getSubtotal());
        totalGst = totalGst.add(item.getGstAmount());
    }
    
    BigDecimal grandTotal = subtotal.add(totalGst);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Grocery Store</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .checkout-container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 20px;
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 30px;
        }
        
        .checkout-section {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .section-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #4CAF50;
            outline: none;
        }
        
        .error-message {
            color: red;
            font-size: 13px;
            margin-top: 5px;
            display: block;
        }
        
        .payment-methods {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .payment-method {
            border: 2px solid #ddd;
            padding: 15px;
            border-radius: 8px;
            cursor: pointer;
            text-align: center;
            transition: all 0.3s;
        }
        
        .payment-method:hover {
            border-color: #4CAF50;
            background: #f0f8f0;
        }
        
        .payment-method.selected {
            border-color: #4CAF50;
            background: #e8f5e9;
        }
        
        .payment-method i {
            font-size: 30px;
            color: #4CAF50;
            margin-bottom: 10px;
        }
        
        .order-summary {
            background: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 15px;
        }
        
        .summary-row.total {
            font-size: 20px;
            font-weight: bold;
            color: #4CAF50;
            border-top: 2px solid #4CAF50;
            padding-top: 12px;
            margin-top: 15px;
        }
        
        .place-order-btn {
            width: 100%;
            padding: 18px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 20px;
            transition: background 0.3s;
        }
        
        .place-order-btn:hover {
            background: #45a049;
        }
        
        .cart-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        
        @media (max-width: 768px) {
            .checkout-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body class="home-page">
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand">
                <i class="fas fa-shopping-cart"></i>
                <span>Grocery Store</span>
            </div>
            
            <ul class="nav-menu">
                <li><a href="home.jsp"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="products.jsp"><i class="fas fa-box"></i> Products</a></li>
                <li><a href="categories.jsp"><i class="fas fa-list"></i> Categories</a></li>
                <li><a href="billing.jsp"><i class="fas fa-shopping-cart"></i> Cart</a></li>
                <li><a href="LogoutController" onclick="return confirm('Logout?')">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a></li>
            </ul>
        </div>
    </nav>
    
    <!-- Main Content -->
    <main class="main-content">
        <!-- Page Header -->
        <section class="welcome-section">
            <div class="container">
                <h1><i class="fas fa-credit-card"></i> Checkout</h1>
                <p>Complete your order and choose payment method</p>
            </div>
        </section>
        
        <!-- Checkout Container -->
        <div class="checkout-container">
            <!-- Left Side - Forms -->
            <div>
                <!-- Details -->
                <div class="checkout-section">
                    <h2 class="section-title"><i class="fas fa-user-edit"></i> Customer Details</h2>
                    
                    <form id="checkoutForm">
                        <div class="form-group">
                            <label>Customer Name *</label>
                            <input type="text" id="fullname" name="fullName" placeholder="Enter customer's full name">
                            <span id="nameError" class="error-message"></span>
                        </div>
                        
                        <div class="form-group">
                            <label>Phone Number *</label>
                            <input type="tel" id="num" name="phone" placeholder="Enter customer's phone number" maxlength="10">
                            <span id="phoneError" class="error-message"></span>
                        </div>
                    </form>
                </div>
                
                <!-- Payment Method -->
                <div class="checkout-section" style="margin-top: 20px;">
                    <h2 class="section-title"><i class="fas fa-wallet"></i> Payment Method</h2>
                    
                    <div class="payment-methods">
                        <div class="payment-method selected" onclick="selectPayment('cash')">
                            <i class="fas fa-money-bill-wave"></i>
                            <div>Cash</div>
                        </div>
                        
                        <div class="payment-method" onclick="selectPayment('upi')">
                            <i class="fas fa-mobile-alt"></i>
                            <div>UPI</div>
                        </div>
                        
                        <div class="payment-method" onclick="selectPayment('card')">
                            <i class="fas fa-credit-card"></i>
                            <div>Credit/Debit Card</div>
                        </div>
                        
                        <div class="payment-method" onclick="selectPayment('netbanking')">
                            <i class="fas fa-university"></i>
                            <div>Net Banking</div>
                        </div>
                    </div>
                    
                    <input type="hidden" id="paymentMethod" value="cash">
                </div>
            </div>
            
            <!-- Right Side - Order Summary -->
            <div>
                <div class="checkout-section">
                    <h2 class="section-title"><i class="fas fa-receipt"></i> Order Summary</h2>
                    
                    <!-- Cart Items -->
                    <div style="max-height: 300px; overflow-y: auto; margin-bottom: 20px;">
                        <% for (CartItem item : cartItems) { %>
                            <div class="cart-item">
                                <div>
                                    <strong><%= item.getProductName() %></strong><br>
                                    <small>Qty: <%= item.getQuantity() %> × ₹<%= item.getPrice() %></small>
                                </div>
                                <div style="text-align: right;">
                                    <strong>₹<%= item.getTotal() %></strong>
                                </div>
                            </div>
                        <% } %>
                    </div>
                    
                    <!-- Price Breakdown -->
                    <div class="order-summary">
                        <div class="summary-row">
                            <span>Subtotal (<%= cartItems.size() %> items)</span>
                            <span>₹<%= subtotal %></span>
                        </div>
                        
                        <div class="summary-row">
                            <span>GST</span>
                            <span>₹<%= totalGst %></span>
                        </div>
                        
                        <div class="summary-row total">
                            <span>Grand Total</span>
                            <span>₹<%= grandTotal %></span>
                        </div>
                    </div>
                    
                    <!-- Place Order Button -->
                    <button class="place-order-btn" onclick="placeOrder()">
                        <i class="fas fa-check-circle"></i> Place Order
                    </button>
                    
                    <div style="text-align: center; margin-top: 15px;">
                        <a href="billing.jsp" style="color: #666; text-decoration: none;">
                            <i class="fas fa-arrow-left"></i> Back to Cart
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-bottom">
                <p>&copy; 2025 Grocery Store. All rights reserved.</p>
            </div>
        </div>
    </footer>
    
    
   
                <!-- Details
                <div class="checkout-section">
                    <h2 class="section-title"><i class="fas fa-user-edit"></i> Customer Details</h2>
                    
                    <form id="checkoutForm">
                        <div class="form-group">
                            <label>Customer Name *</label>
                            <input type="text" id="fullname" name="fullName" placeholder="Enter customer's full name">
                            <span id="nameError" class="error-message"></span>
                        </div>
                        
                        <div class="form-group">
                            <label>Phone Number *</label>
                            <input type="tel" id="num" name="phone" placeholder="Enter customer's phone number" maxlength="10">
                            <span id="phoneError" class="error-message"></span>
                        </div>
                    </form>
                </div>  -->
    
    <script>
        // Character validation for name field
        document.getElementById("fullname").addEventListener("keypress", checkchar);
        document.getElementById("num").addEventListener("keypress", checknum);
        document.getElementById("fullname").addEventListener("blur", checkNameDetails);
        document.getElementById("num").addEventListener("blur", checkPhoneDetails);

        function checkNameDetails() {
            var nameValue = document.getElementById("fullname").value.trim();
            if (nameValue === "") {
                document.getElementById("nameError").innerHTML = "Customer name is required";
            } else {
                document.getElementById("nameError").innerHTML = "";
            }
        }

        function checkPhoneDetails() {
            var phoneValue = document.getElementById("num").value.trim();
            if (phoneValue === "") {
                document.getElementById("phoneError").innerHTML = "Phone number is required";
            } else if (phoneValue.length !== 10) {
                document.getElementById("phoneError").innerHTML = "Phone number must be 10 digits";
            } else {
                document.getElementById("phoneError").innerHTML = "";
            }
        }

        function checknum(event) {
            var ch = event.which;
            if (!(ch >= 48 && ch <= 57)) {
                event.preventDefault();
            }
        }

        function checkchar(event) {
            var ch = event.which;
            if (!((ch >= 65 && ch <= 90) || (ch >= 97 && ch <= 122) || (ch == 32) || (ch == 8))) {
                event.preventDefault();
            }
        }

        // Select payment method
        function selectPayment(method) {
            // Remove selected class from all
            document.querySelectorAll('.payment-method').forEach(el => {
                el.classList.remove('selected');
            });
            
            // Add selected class to clicked
            event.target.closest('.payment-method').classList.add('selected');
            
            // Update hidden input
            document.getElementById('paymentMethod').value = method;
        }
        
        // Place order with validation
        function placeOrder() {
            var nameValue = document.getElementById("fullname").value.trim();
            var phoneValue = document.getElementById("num").value.trim();
            var valid = true;

            // Validate name
            if (nameValue === "") {
                document.getElementById("nameError").innerHTML = "Customer name is required";
                valid = false;
            } else {
                document.getElementById("nameError").innerHTML = "";
            }

            // Validate phone
            if (phoneValue === "") {
                document.getElementById("phoneError").innerHTML = "Phone number is required";
                valid = false;
            } else if (phoneValue.length !== 10) {
                document.getElementById("phoneError").innerHTML = "Phone number must be 10 digits";
                valid = false;
            } else {
                document.getElementById("phoneError").innerHTML = "";
            }

            if (!valid) {
                return;
            }

            const paymentMethod = document.getElementById('paymentMethod').value;
            
            // Display payment method properly
            let paymentText = '';
            switch(paymentMethod) {
                case 'cash':
                    paymentText = 'CASH';
                    break;
                case 'upi':
                    paymentText = 'UPI';
                    break;
                case 'card':
                    paymentText = 'CREDIT/DEBIT CARD';
                    break;
                case 'netbanking':
                    paymentText = 'NET BANKING';
                    break;
                default:
                    paymentText = paymentMethod.toUpperCase();
            }
            
            if (confirm('Confirm order placement with ' + paymentText + ' payment?')) {
                // Create form and submit
                const form = document.getElementById('checkoutForm');
                const orderForm = document.createElement('form');
                orderForm.method = 'POST';
                orderForm.action = 'PlaceOrderController';
                
                // Add all form data
                const formData = new FormData(form);
                formData.append('paymentMethod', paymentMethod);
                formData.append('totalAmount', '<%= grandTotal %>');
                
                for (let [key, value] of formData.entries()) {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = key;
                    input.value = value;
                    orderForm.appendChild(input);
                }
                
                document.body.appendChild(orderForm);
                orderForm.submit();
            }
        }
    </script>
</body>
</html>
