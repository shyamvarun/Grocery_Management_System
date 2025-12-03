<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Grocery Store</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .form-wrapper {
            max-width: 450px;
            width: 100%;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-wrapper">
            <div class="form-header">
                <i class="fas fa-lock"></i>
                <h1>Forgot Password?</h1>
                <p style="color: #666; font-size: 14px; margin-top: 10px;">
                    Enter your email to receive a password reset OTP
                </p>
            </div>
            
            <!-- Display messages -->
            <% 
                String errorMsg = (String) session.getAttribute("errorMsg");
                String successMsg = (String) session.getAttribute("successMsg");
                
                if (errorMsg != null) {
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <%= errorMsg %>
                </div>
            <%
                    session.removeAttribute("errorMsg");
                }
                
                if (successMsg != null) {
            %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <%= successMsg %>
                </div>
            <%
                    session.removeAttribute("successMsg");
                }
            %>
            
            <form action="ForgotPasswordController" method="post" class="login-form">
                <div class="form-group">
                    <label for="email">
                        <i class="fas fa-envelope"></i> Email Address
                    </label>
                    <input type="email" id="email" name="email" 
                           placeholder="Enter your registered email" 
                           required autofocus>
                </div>
                
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-paper-plane"></i> Send OTP
                </button>
                
                <div class="form-footer">
                    <p>
                        <a href="login.jsp">
                            <i class="fas fa-arrow-left"></i> Back to Login
                        </a>
                    </p>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
