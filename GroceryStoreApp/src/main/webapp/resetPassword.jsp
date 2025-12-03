<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
    if (otpVerified == null || !otpVerified) {
        response.sendRedirect("forgotPassword.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Grocery Store</title>
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
                <i class="fas fa-key"></i>
                <h1>Reset Password</h1>
                <p style="color: #666; font-size: 14px; margin-top: 10px;">
                    Enter your new password
                </p>
            </div>
            
            <% 
                String errorMsg = (String) session.getAttribute("errorMsg");
                if (errorMsg != null) {
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <%= errorMsg %>
                </div>
            <%
                    session.removeAttribute("errorMsg");
                }
            %>
            
            <form action="ResetPasswordController" method="post" class="login-form">
                <div class="form-group">
                    <label for="newPassword">
                        <i class="fas fa-lock"></i> New Password
                    </label>
                    <input type="password" id="newPassword" name="newPassword" 
                           placeholder="Enter new password" 
                           required minlength="4" autofocus>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">
                        <i class="fas fa-lock"></i> Confirm Password
                    </label>
                    <input type="password" id="confirmPassword" name="confirmPassword" 
                           placeholder="Re-enter new password" 
                           required minlength="4">
                    <span id="passMatch" style="display: block; margin-top: 5px; font-size: 13px;"></span>
                </div>
                
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-check"></i> Reset Password
                </button>
            </form>
        </div>
    </div>
    
    <script>
        document.getElementById("confirmPassword").addEventListener("keyup", checkPassword);
        
        function checkPassword() {
            var pass = document.getElementById("newPassword").value;
            var confirmPass = document.getElementById("confirmPassword").value;
            var span = document.getElementById("passMatch");
            
            if (confirmPass === "") {
                span.innerHTML = "";
                return;
            }
            
            if (pass !== confirmPass) {
                span.innerHTML = "Passwords do not match";
                span.style.color = "red";
            } else {
                span.innerHTML = "Passwords match";
                span.style.color = "green";
            }
        }
    </script>
</body>
</html>
