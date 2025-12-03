<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Grocery Store</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <div class="form-wrapper">
            <div class="form-header">
                <i class="fas fa-shopping-cart"></i>
                <h1>Grocery Store</h1>
                <h2>Login</h2>
            </div>
            
            <!-- Display error messages -->
            <% 
                String errorMessage = (String) request.getAttribute("errorMessage");
                
                if (errorMessage != null) {
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= errorMessage %>
                </div>
            <% 
                }
            %>
            
            <form action="LoginController" method="post" class="login-form">
                <div class="form-group">
                    <label for="username">
                        <i class="fas fa-user"></i> Username
                    </label>
                    <input type="text" id="username" name="username" 
                           placeholder="Enter your username" required autofocus>
                </div>
                
                <div class="form-group">
                    <label for="password">
                        <i class="fas fa-lock"></i> Password
                    </label>
                    <input type="password" id="password" name="password" 
                           placeholder="Enter your password" required>
                </div>
                
                <div class="form-options">
                    
                    <a href="forgotPassword.jsp" class="forgot-password">
                        <i class="fas fa-question-circle"></i> Forgot Password?
                    </a>
                </div>
                
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
                
                <div class="form-footer">
                    <p>Don't have an account? <a href="registration.jsp">Register here</a></p>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
