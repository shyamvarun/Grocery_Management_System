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
    <title>Categories - Grocery Store</title>
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
                <li><a href="products.jsp"><i class="fas fa-box"></i> Products</a></li>
                <li><a href="categories.jsp" class="active"><i class="fas fa-list"></i> Categories</a></li>
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
                <h1><i class="fas fa-list"></i> Shop by Category</h1>
                <p>Explore our wide range of product categories</p>
            </div>
        </section>
        
        <!-- Categories Section -->
        <section class="categories-section">
            <div class="container">
                <div class="grid-3-columns">
                    <div class="category-card">
                        <div class="card-icon">
                            <i class="fas fa-apple-alt"></i>
                        </div>
                        <h3>Fruits & Vegetables</h3>
                        <p>Fresh organic produce delivered daily</p>
                        <a href="products.jsp?category=1" class="btn btn-secondary">Shop Now</a>
                    </div>
                    
                    <div class="category-card">
                        <div class="card-icon">
                            <i class="fas fa-bread-slice"></i>
                        </div>
                        <h3>Bakery & Dairy</h3>
                        <p>Freshly baked bread and dairy products</p>
                        <a href="products.jsp?category=2" class="btn btn-secondary">Shop Now</a>
                    </div>
                    
                    <div class="category-card">
                        <div class="card-icon">
                            <i class="fas fa-utensils"></i>
                        </div>
                        <h3>Pantry Essentials</h3>
                        <p>All your cooking essentials in one place</p>
                        <a href="products.jsp?category=3" class="btn btn-secondary">Shop Now</a>
                    </div>
                    
                    <div class="category-card">
                        <div class="card-icon">
                            <i class="fas fa-coffee"></i>
                        </div>
                        <h3>Beverages</h3>
                        <p>Refreshing drinks and beverages</p>
                        <a href="products.jsp?category=4" class="btn btn-secondary">Shop Now</a>
                    </div>
                    
                    <div class="category-card">
                        <div class="card-icon">
                            <i class="fas fa-cookie-bite"></i>
                        </div>
                        <h3>Snacks</h3>
                        <p>Tasty snacks for every occasion</p>
                        <a href="products.jsp?category=5" class="btn btn-secondary">Shop Now</a>
                    </div>
                    
                    <div class="category-card">
                        <div class="card-icon">
                            <i class="fas fa-seedling"></i>
                        </div>
                        <h3>Organic Products</h3>
                        <p>100% organic and healthy choices</p>
                        <a href="products.jsp?organic=true" class="btn btn-secondary">Shop Now</a>
                    </div>
                </div>
            </div>
        </section>
        
        