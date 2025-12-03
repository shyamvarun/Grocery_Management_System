<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.grocery.dto.*, java.util.*, com.grocery.dao.*" %>
<%
    // Check if user is logged in
    RegistrationDTO loggedInUser = (RegistrationDTO) session.getAttribute("loggedInUser");
    String username = (String) session.getAttribute("username");
    
    if (loggedInUser == null || username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get all products
    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getAllProducts();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - Grocery Store</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="home-page">
    <!-- Responsive Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand">
                <i class="fas fa-shopping-cart"></i>
                <span>Grocery Store</span>
            </div>
            
            <button class="nav-toggle" id="navToggle">
                <i class="fas fa-bars"></i>
            </button>
            
            <ul class="nav-menu" id="navMenu">
                <li><a href="home.jsp"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="products.jsp" class="active"><i class="fas fa-box"></i> Products</a></li>
                <li><a href="categories.jsp"><i class="fas fa-list"></i> Categories</a></li>
                <li><a href="billing.jsp"><i class="fas fa-shopping-cart"></i> Cart</a></li>
                <li><a href="LogoutController" onclick="return confirm('Are you sure you want to logout?')">
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
                <h1><i class="fas fa-box"></i> All Products</h1>
                <p>Browse our complete range of fresh groceries</p>
            </div>
        </section>
        
        <!-- Search and Filter Section -->
        <section class="categories-section">
            <div class="container">
                <div style="margin-bottom: 30px;">
                    <input type="text" id="searchInput" placeholder="🔍 Search products..." 
                           style="width: 100%; padding: 15px; font-size: 16px; border: 2px solid #ddd; border-radius: 8px;"
                           onkeyup="filterProducts()">
                </div>
                
                <div style="display: flex; gap: 10px; margin-bottom: 30px; flex-wrap: wrap;">
                    <button class="btn btn-primary active" onclick="filterByCategory('all')">All Products</button>
                    <button class="btn btn-secondary" onclick="filterByCategory('1')">Fruits & Vegetables</button>
                    <button class="btn btn-secondary" onclick="filterByCategory('2')">Dairy & Bakery</button>
                    <button class="btn btn-secondary" onclick="filterByCategory('3')">Pantry Essentials</button>
                    <button class="btn btn-secondary" onclick="filterByCategory('4')">Beverages</button>
                    <button class="btn btn-secondary" onclick="filterByCategory('5')">Snacks</button>
                </div>
            </div>
        </section>
        
        <!-- Products Grid -->
        <section class="products-section">
            <div class="container">
                <div class="grid-4-columns" id="productsGrid">
                    <% if (products == null || products.isEmpty()) { %>
                        <p style="grid-column: 1/-1; text-align: center; padding: 50px;">No products available</p>
                    <% } else {
                        for (Product product : products) {
                            boolean inStock = product.getStockQuantity() > 0;
                            boolean lowStock = product.getStockQuantity() < product.getMinStock();
                    %>
                        <div class="product-card" data-category="<%= product.getCategoryId() %>" data-name="<%= product.getProductName().toLowerCase() %>">
                            <% if (lowStock && inStock) { %>
                                <div class="product-badge" style="background: #ff9800;">Low Stock</div>
                            <% } else if (!inStock) { %>
                                <div class="product-badge" style="background: #f44336;">Out of Stock</div>
                            <% } %>
                            
                            <div class="product-image">
                                <i class="fas fa-box-open"></i>
                            </div>
                            
                            <h4><%= product.getProductName() %></h4>
                            
                            <p style="font-size: 13px; color: #666; margin: 5px 0;">
                                <i class="fas fa-tag"></i> <%= product.getCategoryName() %>
                            </p>
                            
                            <p style="font-size: 12px; color: #999; margin: 5px 0;">
                                Stock: <%= product.getStockQuantity() %> units
                            </p>
                            
                            <% if (product.getBarcode() != null) { %>
                                <p style="font-size: 11px; color: #999;">Barcode: <%= product.getBarcode() %></p>
                            <% } %>
                            
                            <p class="product-price">₹<%= product.getPrice() %></p>
                            
                            <form action="AddToCartController" method="post">
                                <input type="hidden" name="method" value="manual">
                                <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn btn-add-cart" <%= !inStock ? "disabled style='background: #ccc; cursor: not-allowed;'" : "" %>>
                                    <i class="fas fa-cart-plus"></i> <%= inStock ? "Add to Cart" : "Out of Stock" %>
                                </button>
                            </form>
                        </div>
                    <% 
                        }
                    } 
                    %>
                </div>
            </div>
        </section>
    </main>
    
    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="grid-4-columns">
                <div class="footer-column">
                    <h4>About Us</h4>
                    <p>Your trusted online grocery store delivering fresh products.</p>
                </div>
                
                <div class="footer-column">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="#">About</a></li>
                        <li><a href="#">Contact</a></li>
                        <li><a href="#">FAQs</a></li>
                    </ul>
                </div>
                
                <div class="footer-column">
                    <h4>Customer Service</h4>
                    <ul>
                        <li><a href="#">Shipping Info</a></li>
                        <li><a href="#">Returns</a></li>
                        <li><a href="#">Track Order</a></li>
                    </ul>
                </div>
                
                <div class="footer-column">
                    <h4>Contact</h4>
                    <p><i class="fas fa-phone"></i> +91 1234567890</p>
                    <p><i class="fas fa-envelope"></i> info@grocerystore.com</p>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>&copy; 2025 Grocery Store. All rights reserved.</p>
            </div>
        </div>
    </footer>
    
    <script>
        // Search filter
        function filterProducts() {
            let input = document.getElementById('searchInput').value.toLowerCase();
            let cards = document.querySelectorAll('.product-card');
            
            cards.forEach(card => {
                let name = card.dataset.name;
                card.style.display = name.includes(input) ? 'block' : 'none';
            });
        }
        
        // Category filter
        function filterByCategory(categoryId) {
            let cards = document.querySelectorAll('.product-card');
            let buttons = document.querySelectorAll('.btn');
            
            // Update active button
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            
            // Filter cards
            cards.forEach(card => {
                if (categoryId === 'all' || card.dataset.category === categoryId) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
        
        // Mobile navigation toggle
        const navToggle = document.getElementById('navToggle');
        const navMenu = document.getElementById('navMenu');
        
        if (navToggle && navMenu) {
            navToggle.addEventListener('click', function() {
                navMenu.classList.toggle('active');
            });
        }
    </script>
</body>
</html>
