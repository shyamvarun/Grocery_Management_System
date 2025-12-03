<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.grocery.dto.*, java.util.*, java.math.*" %>
<%@ page import="com.grocery.dao.*" %>
<%
    // Check if user is logged in
    Integer userId = (Integer) session.getAttribute("userId");
    RegistrationDTO loggedInUser = (RegistrationDTO) session.getAttribute("loggedInUser");
    
    if (userId == null || loggedInUser == null) {
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
    <title>Billing - Grocery Store</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/@ericblade/quagga2@1.7.0/dist/quagga.min.js"></script>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }
        
        .billing-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .scan-section, .cart-section {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .method-tabs {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .tab {
            padding: 15px;
            border: 2px solid #4CAF50;
            background: white;
            cursor: pointer;
            text-align: center;
            border-radius: 8px;
            transition: all 0.3s;
            font-weight: 500;
        }
        
        .tab.active {
            background: #4CAF50;
            color: white;
        }
        
        .tab:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .method-content {
            display: none;
        }
        
        .method-content.active {
            display: block;
        }
        
        .barcode-input {
            width: 100%;
            padding: 15px;
            font-size: 24px;
            border: 2px solid #4CAF50;
            border-radius: 8px;
            text-align: center;
            letter-spacing: 2px;
            font-family: monospace;
        }
        
        .search-box {
            position: relative;
        }
        
        .search-box input {
            width: 100%;
            padding: 15px;
            font-size: 18px;
            border: 2px solid #ddd;
            border-radius: 8px;
        }
        
        .search-results {
            position: absolute;
            width: 100%;
            max-height: 400px;
            overflow-y: auto;
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            margin-top: 5px;
            z-index: 1000;
            display: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .search-result-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .search-result-item:hover {
            background: #f5f5f5;
        }
        
        .cart-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        .cart-table th, .cart-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .cart-table th {
            background: #4CAF50;
            color: white;
            font-weight: 600;
        }
        
        .remove-btn {
            background: #f44336;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
        }
        
        .total-section {
            margin-top: 20px;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 8px;
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            font-size: 16px;
        }
        
        .grand-total {
            font-size: 24px;
            font-weight: bold;
            color: #4CAF50;
            border-top: 2px solid #4CAF50;
            padding-top: 15px;
            margin-top: 10px;
        }
        
        .checkout-btn {
            width: 100%;
            padding: 15px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 15px;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .empty-cart i {
            font-size: 64px;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .billing-container {
                grid-template-columns: 1fr;
            }
            .method-tabs {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
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
                <li><a href="billing.jsp" class="active"><i class="fas fa-shopping-cart"></i> Cart</a></li>
                <li><a href="LogoutController" onclick="return confirm('Logout?')">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a></li>
            </ul>
        </div>
    </nav>

    <div class="billing-container">
        <!-- LEFT SIDE: SCANNING/SEARCH -->
        <div class="scan-section">
            <h2><i class="fas fa-cash-register"></i> Add Items to Cart</h2>
            
            <!-- Messages -->
            <%
                String successMsg = (String) session.getAttribute("successMsg");
                String errorMsg = (String) session.getAttribute("errorMsg");
                
                if (successMsg != null) {
            %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <%= successMsg %>
                </div>
            <%
                    session.removeAttribute("successMsg");
                }
                
                if (errorMsg != null) {
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <%= errorMsg %>
                </div>
            <%
                    session.removeAttribute("errorMsg");
                }
            %>
            
            <!-- Method Tabs with Camera -->
            <div class="method-tabs">
                <div class="tab active" onclick="switchMethod('barcode')">
                    <i class="fas fa-barcode"></i> Barcode
                </div>
                <div class="tab" onclick="switchMethod('manual')">
                    <i class="fas fa-search"></i> Search
                </div>
                <div class="tab" onclick="openScanner()">
                    <i class="fas fa-camera"></i> Camera
                </div>
            </div>
            
            <!-- Barcode Method -->
            <div id="barcode-method" class="method-content active">
                <form action="AddToCartController" method="post" id="barcodeForm">
                    <input type="hidden" name="method" value="barcode">
                    <input 
                        type="text" 
                        name="barcode" 
                        id="barcodeInput" 
                        class="barcode-input" 
                        placeholder="Scan or type barcode"
                        autofocus
                        autocomplete="off"
                    >
                </form>
                <p style="margin-top: 15px; color: #666; font-size: 14px;">
                    <i class="fas fa-info-circle"></i> Scan barcode or type manually and press Enter
                </p>
            </div>
            
            <!-- Manual Search Method -->
            <div id="manual-method" class="method-content">
                <div class="search-box">
                    <input 
                        type="text" 
                        id="searchInput" 
                        placeholder="🔍 Search products..."
                        onkeyup="searchProducts()"
                    >
                    <div id="searchResults" class="search-results"></div>
                </div>
            </div>
        </div>
        
        <!-- RIGHT SIDE: CART -->
        <div class="cart-section">
            <h2><i class="fas fa-shopping-cart"></i> Current Bill</h2>
            
            <% if (cartItems.isEmpty()) { %>
                <div class="empty-cart">
                    <i class="fas fa-shopping-basket"></i>
                    <h3>Cart is empty</h3>
                    <p>Add products to get started</p>
                </div>
            <% } else { %>
                <table class="cart-table">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Price</th>
                            <th>Qty</th>
                            <th>Total</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (CartItem item : cartItems) { %>
                        <tr>
                            <td><%= item.getProductName() %></td>
                            <td>₹<%= item.getPrice() %></td>
                            <td>
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <form action="UpdateCartController" method="post" style="display: inline; margin: 0;">
                                        <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                                        <input type="hidden" name="action" value="decrement">
                                        <button type="submit" style="padding: 5px 10px; background: #f44336; color: white; border: none; border-radius: 4px; cursor: pointer;">
                                            <i class="fas fa-minus"></i>
                                        </button>
                                    </form>
                                    <span style="font-weight: bold; min-width: 30px; text-align: center;">
                                        <%= item.getQuantity() %>
                                    </span>
                                    <form action="UpdateCartController" method="post" style="display: inline; margin: 0;">
                                        <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                                        <input type="hidden" name="action" value="increment">
                                        <button type="submit" style="padding: 5px 10px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer;">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                            <td>₹<%= item.getTotal() %></td>
                            <td>
                                <form action="RemoveFromCartController" method="post" style="display: inline;">
                                    <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                                    <button type="submit" class="remove-btn" title="Remove">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                
                <div class="total-section">
                    <div class="total-row">
                        <span>Subtotal (<%= cartItems.size() %> items):</span>
                        <span>₹<%= subtotal %></span>
                    </div>
                    <div class="total-row">
                        <span>GST:</span>
                        <span>₹<%= totalGst %></span>
                    </div>
                    <div class="total-row grand-total">
                        <span>Grand Total:</span>
                        <span>₹<%= grandTotal %></span>
                    </div>
                </div>
                
                <button class="checkout-btn" onclick="proceedToCheckout()">
                    <i class="fas fa-credit-card"></i> Proceed to Payment
                </button>
            <% } %>
        </div>
    </div>
    
    <!-- Camera Scanner Modal -->
    <div id="scannerModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.9); z-index: 9999; align-items: center; justify-content: center;">
        <div style="background: white; padding: 20px; border-radius: 10px; max-width: 600px; width: 90%;">
            <div style="display: flex; justify-content: space-between; margin-bottom: 15px; align-items: center;">
                <h3 style="margin: 0;"><i class="fas fa-camera"></i> Camera Scanner</h3>
                <button onclick="closeScanner()" style="background: #f44336; color: white; border: none; width: 35px; height: 35px; border-radius: 50%; cursor: pointer; font-size: 20px;">×</button>
            </div>
            <div id="scanner-viewport" style="width: 100%; height: 350px; background: #000; border-radius: 8px; margin-bottom: 15px;"></div>
            <div id="scanner-status" style="background: #e3f2fd; padding: 12px; border-radius: 8px; text-align: center; margin-bottom: 15px;">
                <p style="margin: 0; color: #1976d2;">📷 Point camera at barcode</p>
            </div>
            <div style="display: flex; gap: 10px;">
                <input type="text" id="manualBarcode" placeholder="Or enter barcode..." style="flex: 1; padding: 10px; border: 2px solid #ddd; border-radius: 6px; font-size: 16px;">
                <button onclick="submitManualBarcode()" style="padding: 10px 20px; background: #4CAF50; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold;">Add</button>
            </div>
        </div>
    </div>
    
    <script>
        let scannerActive = false;
        
        // Auto-submit barcode
        document.getElementById('barcodeInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                if (this.value.trim() !== '') {
                    document.getElementById('barcodeForm').submit();
                }
            }
        });
        
        // Keep focus on barcode
        setInterval(function() {
            if (document.getElementById('barcode-method').classList.contains('active')) {
                document.getElementById('barcodeInput').focus();
            }
        }, 500);
        
        // Switch methods
        function switchMethod(method) {
            document.querySelectorAll('.method-content').forEach(content => content.classList.remove('active'));
            document.getElementById(method + '-method').classList.add('active');
            
            if (method === 'barcode') {
                document.getElementById('barcodeInput').value = '';
                document.getElementById('barcodeInput').focus();
            } else {
                document.getElementById('searchInput').value = '';
                document.getElementById('searchInput').focus();
                document.getElementById('searchResults').style.display = 'none';
            }
        }
        
        // Checkout
        function proceedToCheckout() {
            if (confirm('Proceed to checkout?')) {
                window.location.href = 'checkout.jsp';
            }
        }
        
        // Search products
        let searchTimeout;
        function searchProducts() {
            clearTimeout(searchTimeout);
            let keyword = document.getElementById('searchInput').value;
            let resultsDiv = document.getElementById('searchResults');
            
            if (keyword.length < 2) {
                resultsDiv.style.display = 'none';
                return;
            }
            
            searchTimeout = setTimeout(function() {
                fetch('ProductSearchController?keyword=' + encodeURIComponent(keyword))
                    .then(response => response.json())
                    .then(products => {
                        if (products.length > 0) {
                            let html = '';
                            products.forEach(product => {
                                html += `
                                    <div class="search-result-item" onclick="addProduct(${product.productId})">
                                        <div>
                                            <strong>${product.productName}</strong><br>
                                            <small>Stock: ${product.stockQuantity}</small>
                                        </div>
                                        <div>
                                            <strong style="color: #4CAF50;">₹${product.price}</strong>
                                        </div>
                                    </div>
                                `;
                            });
                            resultsDiv.innerHTML = html;
                            resultsDiv.style.display = 'block';
                        } else {
                            resultsDiv.innerHTML = '<div style="padding: 15px; text-align: center; color: #999;">No products found</div>';
                            resultsDiv.style.display = 'block';
                        }
                    });
            }, 300);
        }
        
        // Add product
        function addProduct(productId) {
            let form = document.createElement('form');
            form.method = 'POST';
            form.action = 'AddToCartController';
            form.innerHTML = `
                <input type="hidden" name="method" value="manual">
                <input type="hidden" name="productId" value="${productId}">
                <input type="hidden" name="quantity" value="1">
            `;
            document.body.appendChild(form);
            form.submit();
        }
        
        // Camera Scanner
        function openScanner() {
            document.getElementById('scannerModal').style.display = 'flex';
            Quagga.init({
                inputStream: { 
                    type: "LiveStream", 
                    target: document.querySelector('#scanner-viewport'), 
                    constraints: { facingMode: "environment" }
                },
                decoder: { readers: ["ean_reader", "code_128_reader", "upc_reader", "code_39_reader"] }
            }, function(err) {
                if (!err) { 
                    Quagga.start(); 
                    scannerActive = true;
                    document.getElementById('scanner-status').innerHTML = '<p style="margin: 0; color: #1976d2;">📷 Point at barcode</p>';
                } else {
                    document.getElementById('scanner-status').innerHTML = '<p style="margin: 0; color: #c62828;">❌ Camera error</p>';
                }
            });
            Quagga.onDetected(function(result) {
                const barcode = result.codeResult.code;
                document.getElementById('scanner-status').innerHTML = '<p style="margin: 0; color: #2e7d32;">✅ Found: ' + barcode + '</p>';
                addToCartByBarcode(barcode);
                setTimeout(closeScanner, 1500);
            });
        }
        
        function closeScanner() {
            document.getElementById('scannerModal').style.display = 'none';
            if (scannerActive) { 
                Quagga.stop(); 
                scannerActive = false; 
            }
        }
        
        function addToCartByBarcode(barcode) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'AddToCartController';
            form.innerHTML = '<input type="hidden" name="method" value="barcode"><input type="hidden" name="barcode" value="' + barcode + '">';
            document.body.appendChild(form);
            form.submit();
        }
        
        function submitManualBarcode() {
            const barcode = document.getElementById('manualBarcode').value.trim();
            if (barcode) {
                addToCartByBarcode(barcode);
            } else {
                alert('Enter a barcode!');
            }
        }
        
        document.getElementById('manualBarcode').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') submitManualBarcode();
        });
        
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && scannerActive) closeScanner();
        });
    </script>
</body>
</html>
