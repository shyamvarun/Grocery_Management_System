<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.grocery.dto.RegistrationDTO" %>
<%
    // Check if user is logged in
    RegistrationDTO loggedInUser = (RegistrationDTO) session.getAttribute("loggedInUser");
    String username = (String) session.getAttribute("username");
    
    if (loggedInUser == null || username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Grocery Store</title>
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
                <li><a href="home.jsp" class="active"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="products.jsp"><i class="fas fa-box"></i> Products</a></li>
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
        <!-- Welcome Section -->
        <section class="welcome-section">
            <div class="container">
                <h1>Welcome, <%= loggedInUser.getFullName() %>!</h1>
                <p>Start shopping for fresh groceries delivered to your doorstep</p>
            </div>
        </section>
        
        <!-- Featured Categories - 3 Columns -->
        <section class="categories-section">
            <div class="container">
                <h2 class="section-title">Shop by Category</h2>
                
                <div class="grid-3-columns">
                    <div class="category-card">
                        <div class="card-icon">
                            <i class="fas fa-apple-alt"></i>
                        </div>
                        <h3>Fruits & Vegetables</h3>
                        <p>Fresh organic produce delivered daily</p>
                        <a href="products.jsp" class="btn btn-secondary">Shop Now</a>
                    </div>
                    
                    <div class="category-card">
                        <div class="card-icon">
                            <i class="fas fa-bread-slice"></i>
                        </div>
                        <h3>Bakery & Dairy</h3>
                        <p>Freshly baked bread and dairy products</p>
                        <a href="products.jsp" class="btn btn-secondary">Shop Now</a>
                    </div>
                    
                    <div class="category-card">
                        <div class="card-icon">
                            <i class="fas fa-utensils"></i>
                        </div>
                        <h3>Pantry Essentials</h3>
                        <p>All your cooking essentials in one place</p>
                        <a href="products.jsp" class="btn btn-secondary">Shop Now</a>
                    </div>
                </div>
            </div>
        </section>
            
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
                        <li><a href="info.jsp">About</a></li>
                        <li><a href="info.jsp">Contact</a></li>
                        <li><a href="info.jsp">FAQs</a></li>
                    </ul>
                </div>
                
                <div class="footer-column">
                    <h4>Our Service</h4>
                    <ul>
                        <li>Fresh Stock</li>
                        <li>Friendly Staff</li>
                        <li>Secure Payments</li>
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
    
    <!-- JavaScript for Logout Confirmation -->
    <script>
        // Logout confirmation function
        function confirmLogout() {
            return confirm('Are you sure you want to logout?\n\nYou will need to login again to access your account.');
        }
        
        }
    </script>
</body>
</html>
