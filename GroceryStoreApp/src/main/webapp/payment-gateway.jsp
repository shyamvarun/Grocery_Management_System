<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.math.*" %>
<%
    Integer orderId = (Integer) session.getAttribute("orderId");
    BigDecimal orderTotal = (BigDecimal) session.getAttribute("orderTotal");
    String paymentMethod = (String) session.getAttribute("paymentMethod");
    String customerName = (String) session.getAttribute("customerName");
    String customerPhone = (String) session.getAttribute("customerPhone");
    String customerEmail = (String) session.getAttribute("customerEmail");
    
    if (orderId == null) {
        response.sendRedirect("billing.jsp");
        return;
    }
    
    // Convert to paise (Razorpay uses smallest currency unit: 1 Rupee = 100 paise)
    BigDecimal amountInPaise = orderTotal.multiply(new BigDecimal("100"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Gateway - Grocery Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .payment-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            max-width: 500px;
            width: 100%;
        }
        
        .payment-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .payment-header i {
            font-size: 60px;
            color: #4CAF50;
            margin-bottom: 15px;
        }
        
        .payment-header h2 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .order-info {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .order-info p {
            color: #666;
            margin: 5px 0;
            font-size: 14px;
        }
        
        .amount-display {
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 30px;
            color: white;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        }
        
        .amount-display p {
            font-size: 14px;
            margin-bottom: 5px;
            opacity: 0.9;
        }
        
        .amount-display h1 {
            font-size: 42px;
            margin: 10px 0;
            font-weight: bold;
        }
        
        .payment-options {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-bottom: 25px;
        }
        
        .payment-icon {
            padding: 15px;
            background: #f5f5f5;
            border-radius: 10px;
            text-align: center;
            transition: all 0.3s;
        }
        
        .payment-icon:hover {
            background: #e8f5e9;
            transform: translateY(-3px);
        }
        
        .payment-icon i {
            font-size: 28px;
            color: #4CAF50;
            margin-bottom: 5px;
        }
        
        .payment-icon p {
            font-size: 11px;
            color: #666;
            margin-top: 5px;
        }
        
        .proceed-btn {
            width: 100%;
            padding: 18px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .proceed-btn:hover {
            background: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(76, 175, 80, 0.4);
        }
        
        .proceed-btn:active {
            transform: translateY(0);
        }
        
        .cancel-btn {
            width: 100%;
            padding: 15px;
            background: transparent;
            color: #f44336;
            border: 2px solid #f44336;
            border-radius: 10px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 15px;
            transition: all 0.3s;
        }
        
        .cancel-btn:hover {
            background: #f44336;
            color: white;
        }
        
        .info-text {
            text-align: center;
            color: #666;
            font-size: 13px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .secure-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            color: #4CAF50;
            font-weight: bold;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="payment-container">
        <!-- Header -->
        <div class="payment-header">
            <i class="fas fa-credit-card"></i>
            <h2>Complete Your Payment</h2>
            <p style="color: #666;">Order #<%= orderId %></p>
        </div>
        
        <!-- Order Info -->
        <div class="order-info">
            <p><strong>Customer:</strong> <%= customerName != null ? customerName : "Walk-in Customer" %></p>
            <% if (customerPhone != null) { %>
                <p><strong>Phone:</strong> <%= customerPhone %></p>
            <% } %>
            <p><strong>Payment:</strong> <%= paymentMethod.toUpperCase() %></p>
        </div>
        
        <!-- Amount Display -->
        <div class="amount-display">
            <p>Total Amount to Pay</p>
            <h1>₹<%= orderTotal %></h1>
            <p style="font-size: 12px;">Including all taxes</p>
        </div>
        
        <!-- Payment Method Icons -->
        <div class="payment-options">
            <div class="payment-icon">
                <i class="fas fa-mobile-alt"></i>
                <p>UPI</p>
            </div>
            <div class="payment-icon">
                <i class="fas fa-credit-card"></i>
                <p>Cards</p>
            </div>
            <div class="payment-icon">
                <i class="fas fa-university"></i>
                <p>NetBanking</p>
            </div>
        </div>
        
        <!-- Pay Button -->
        <button id="rzp-button" class="proceed-btn">
            <i class="fas fa-lock"></i>
            Pay ₹<%= orderTotal %> Securely
        </button>
        
        <!-- Cancel Button -->
        <button class="cancel-btn" onclick="if(confirm('Are you sure you want to cancel this order?')) window.location.href='checkout.jsp'">
            <i class="fas fa-times"></i> Cancel Order
        </button>
        
        <!-- Home Button -->
		<button style="width: 100%; padding: 15px; background: transparent; color: #2196F3; border: 2px solid #2196F3; border-radius: 10px; font-size: 16px; cursor: pointer; margin-top: 10px; transition: all 0.3s;" 
		        onmouseover="this.style.background='#2196F3'; this.style.color='white';" 
		        onmouseout="this.style.background='transparent'; this.style.color='#2196F3';"
		        onclick="window.location.href='home.jsp'">
		    <i class="fas fa-home"></i> Back to Home
		</button>
        
        <!-- Security Info -->
        <div class="info-text">
            <div class="secure-badge">
                <i class="fas fa-shield-alt"></i>
                100% Secure Payment
            </div>
            <p style="margin-top: 10px; font-size: 12px;">Powered by Razorpay</p>
        </div>
    </div>
    
    
    
    <!-- Razorpay Checkout Script -->
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    
    <script>
        var options = {
            // 🔑 YOUR RAZORPAY KEY
            "key": "rzp_test_RlBWiXnIXk5iaU",
            
            // Amount in paise (multiply rupees by 100)
            "amount": "<%= amountInPaise.intValue() %>",
            
            // Currency
            "currency": "INR",
            
            // Business/Store Name
            "name": "Grocery Store",
            
            // Order Description
            "description": "Order #<%= orderId %> - Grocery Purchase",
            
            // Your Logo (optional - you can change this URL)
            "image": "https://cdn-icons-png.flaticon.com/512/2331/2331966.png",
            
            // Success Handler - Called when payment is successful
            "handler": function (response) {
                console.log('✅ Payment Successful!');
                console.log('Payment ID:', response.razorpay_payment_id);
                console.log('Order ID:', response.razorpay_order_id);
                console.log('Signature:', response.razorpay_signature);
                
                // Show success message
                alert('✅ Payment Successful!\nPayment ID: ' + response.razorpay_payment_id);
                
                // Submit payment details to backend
                submitPaymentDetails(response.razorpay_payment_id);
            },
            
            // Pre-fill customer details
            "prefill": {
                "name": "<%= customerName != null ? customerName : "" %>",
                "email": "<%= customerEmail != null && !customerEmail.isEmpty() ? customerEmail : "" %>",
                "contact": "<%= customerPhone != null ? customerPhone : "" %>"
            },
            
            // Enable/Disable payment methods
            "method": {
                "upi": true,           // UPI (Google Pay, PhonePe, Paytm, etc.)
                "card": true,          // Credit/Debit Cards
                "netbanking": true,    // Net Banking
                "wallet": false,       // Disable wallets
                "emi": false          // Disable EMI
            },
            
            // Store/Order metadata
            "notes": {
                "order_id": "<%= orderId %>",
                "store": "Grocery Store",
                "customer": "<%= customerName != null ? customerName : "Walk-in" %>"
            },
            
            // Theme customization
            "theme": {
                "color": "#4CAF50",           // Primary color
                "backdrop_color": "#667eea"   // Background color
            },
            
            // Modal behavior
            "modal": {
                "ondismiss": function() {
                    console.log('Payment popup closed by user');
                    if (confirm('⚠️ Payment cancelled!\n\nDo you want to try again?')) {
                        rzp.open();
                    }
                },
                "escape": true,      // Allow ESC key to close
                "backdropclose": false  // Don't close on backdrop click
            }
        };
        
        // Create Razorpay instance
        var rzp = new Razorpay(options);
        
        // Open payment modal on button click
        document.getElementById('rzp-button').onclick = function(e) {
            e.preventDefault();
            console.log('Opening Razorpay payment gateway...');
            rzp.open();
        };
        
        // Handle payment failure
        rzp.on('payment.failed', function (response) {
            console.error('❌ Payment Failed:', response.error);
            
            alert('❌ Payment Failed!\n\n' +
                  'Reason: ' + response.error.description + '\n' +
                  'Error Code: ' + response.error.code);
            
            // Optionally redirect or retry
            if (confirm('Do you want to try again?')) {
                rzp.open();
            }
        });
        
        // Submit payment details to backend
        function submitPaymentDetails(paymentId) {
            console.log('Submitting payment details to server...');
            
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = 'PaymentSuccessController';
            
            // Add hidden inputs
            form.innerHTML = `
                <input type="hidden" name="orderId" value="<%= orderId %>">
                <input type="hidden" name="paymentId" value="${paymentId}">
            `;
            
            document.body.appendChild(form);
            form.submit();
        }
        
        // Auto-open payment on page load (optional)
        // Uncomment next line if you want payment to open automatically
        // window.onload = function() { rzp.open(); };
    </script>
</body>
</html>
