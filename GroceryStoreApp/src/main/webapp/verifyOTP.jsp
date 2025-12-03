<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String email = (String) session.getAttribute("resetEmail");
    if (email == null) {
        response.sendRedirect("forgotPassword.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP - Grocery Store</title>
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
            max-width: 500px;
            width: 100%;
        }
        
        .otp-container {
            display: flex;
            justify-content: center;
            gap: 12px;
            margin: 30px 0;
        }
        
        .otp-input {
            width: 55px;
            height: 65px;
            text-align: center;
            font-size: 28px;
            font-weight: bold;
            border: 2px solid #ddd;
            border-radius: 10px;
            transition: all 0.3s;
        }
        
        .otp-input:focus {
            outline: none;
            border-color: #4CAF50;
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1);
        }
        
        .resend-section {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #666;
        }
        
        .resend-section a {
            color: #4CAF50;
            text-decoration: none;
            font-weight: 600;
        }
        
        .resend-section a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-wrapper">
            <div class="form-header">
                <i class="fas fa-shield-alt"></i>
                <h1>Verify OTP</h1>
                <p style="color: #666; font-size: 14px; margin-top: 10px;">
                    Enter the 6-digit code sent to<br>
                    <strong style="color: #4CAF50;"><%= email %></strong>
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
            
            <form action="VerifyOTPController" method="post" id="otpForm">
                <div class="otp-container">
                    <input type="text" class="otp-input" id="otp1" name="otp1" maxlength="1" required autocomplete="off">
                    <input type="text" class="otp-input" id="otp2" name="otp2" maxlength="1" required autocomplete="off">
                    <input type="text" class="otp-input" id="otp3" name="otp3" maxlength="1" required autocomplete="off">
                    <input type="text" class="otp-input" id="otp4" name="otp4" maxlength="1" required autocomplete="off">
                    <input type="text" class="otp-input" id="otp5" name="otp5" maxlength="1" required autocomplete="off">
                    <input type="text" class="otp-input" id="otp6" name="otp6" maxlength="1" required autocomplete="off">
                </div>
                
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-check"></i> Verify OTP
                </button>
                
                <div class="resend-section">
                    Didn't receive OTP? 
                    <a href="ForgotPasswordController?resend=true">
                        <i class="fas fa-redo"></i> Resend OTP
                    </a>
                    <br>
                    <a href="login.jsp">
                        <i class="fas fa-sign-in-alt"></i> Back to login
                    </a>
                    
                    
                    
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // OTP Input Auto-Focus
        var inputs = document.querySelectorAll('.otp-input');
        
        inputs.forEach(function(input, index) {
            // Move to next input on keyup
            input.addEventListener('keyup', function(e) {
                if (e.key >= '0' && e.key <= '9') {
                    if (index < inputs.length - 1) {
                        inputs[index + 1].focus();
                    }
                } else if (e.key === 'Backspace') {
                    if (index > 0 && input.value === '') {
                        inputs[index - 1].focus();
                    }
                }
            });
            
            // Only allow numbers
            input.addEventListener('keypress', function(e) {
                if (!(e.key >= '0' && e.key <= '9')) {
                    e.preventDefault();
                }
            });
            
            // Handle paste (full OTP)
            input.addEventListener('paste', function(e) {
                e.preventDefault();
                var pasteData = e.clipboardData.getData('text');
                if (pasteData.length === 6 && /^\d{6}$/.test(pasteData)) {
                    for (var i = 0; i < 6; i++) {
                        inputs[i].value = pasteData[i];
                    }
                    inputs[5].focus();
                }
            });
        });
        
        // Focus first input on load
        inputs[0].focus();
    </script>
</body>
</html>
