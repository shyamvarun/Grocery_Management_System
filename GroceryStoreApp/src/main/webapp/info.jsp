<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.grocery.dto.RegistrationDTO" %>
<%
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
    <title>About Us - Grocery Store</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Info Page Styles */
        .info-section {
            padding: 60px 20px;
            max-width: 1000px;
            margin: 0 auto;
        }
        
        .info-section h1 {
            text-align: center;
            color: var(--primary-color);
            margin-bottom: 20px;
            font-size: 36px;
        }
        
        .info-section h2 {
            color: var(--dark-color);
            margin-top: 40px;
            margin-bottom: 20px;
            font-size: 28px;
            border-bottom: 3px solid var(--primary-color);
            padding-bottom: 10px;
        }
        
        .info-section p {
            line-height: 1.8;
            color: #555;
            margin-bottom: 15px;
            font-size: 16px;
        }
        
        .info-section ul {
            margin-left: 20px;
            line-height: 1.8;
        }
        
        .info-section ul li {
            margin-bottom: 10px;
            color: #555;
        }
        
        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 30px;
            margin: 40px 0;
        }
        
        .stat-card {
            background: linear-gradient(135deg, var(--primary-color), #45a049);
            color: white;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .stat-card i {
            font-size: 40px;
            margin-bottom: 15px;
        }
        
        .stat-card h3 {
            font-size: 32px;
            margin: 10px 0;
        }
        
        .stat-card p {
            color: white;
            opacity: 0.9;
            font-size: 14px;
        }
        
        /* Contact Grid */
        .contact-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin: 40px 0;
        }
        
        .contact-card {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            border: 2px solid #e9ecef;
            transition: all 0.3s;
        }
        
        .contact-card:hover {
            border-color: var(--primary-color);
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.1);
        }
        
        .contact-card i {
            font-size: 40px;
            color: var(--primary-color);
            margin-bottom: 15px;
        }
        
        .contact-card h3 {
            margin-bottom: 10px;
            color: var(--dark-color);
        }
        
        .contact-card p {
            color: #666;
        }
        
        .contact-card a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }
        
        .contact-card a:hover {
            text-decoration: underline;
        }
        
        /* FAQ */
        .faq-item {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            margin-bottom: 15px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .faq-question {
            background: #f8f9fa;
            padding: 20px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s;
        }
        
        .faq-question:hover {
            background: #e9ecef;
        }
        
        .faq-question h3 {
            margin: 0;
            color: var(--dark-color);
            font-size: 18px;
            font-weight: 600;
        }
        
        .faq-question i {
            color: var(--primary-color);
            transition: transform 0.3s;
        }
        
        .faq-question.active i {
            transform: rotate(180deg);
        }
        
        .faq-answer {
            padding: 0 20px;
            max-height: 0;
            overflow: hidden;
            transition: all 0.3s;
        }
        
        .faq-answer.active {
            padding: 20px;
            max-height: 500px;
        }
        
        .faq-answer p {
            margin: 0;
            color: #666;
            line-height: 1.6;
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
            
            <button class="nav-toggle" id="navToggle">
                <i class="fas fa-bars"></i>
            </button>
            
            <ul class="nav-menu" id="navMenu">
                <li><a href="home.jsp"><i class="fas fa-home"></i> Home</a></li>
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
        
        <!-- About Us -->
        <section class="info-section">
            <h1><i class="fas fa-store"></i> About Us</h1>
            
            <p>Welcome to <strong>Grocery Store</strong> - Your trusted partner. We are committed to providing high-quality products at affordable prices with exceptional customer service.</p>
            
            <div class="stats-grid">
                <div class="stat-card">
                    <i class="fas fa-box"></i>
                    <h3>500+</h3>
                    <p>Products Available</p>
                </div>
                
                <div class="stat-card">
                    <i class="fas fa-users"></i>
                    <h3>10,000+</h3>
                    <p>Happy Customers</p>
                </div>
                
                <div class="stat-card">
                    <i class="fas fa-star"></i>
                    <h3>4.8/5</h3>
                    <p>Customer Rating</p>
                </div>
            </div>
            
            <h2><i class="fas fa-heart"></i> Why Choose Us?</h2>
            <ul>
                <li><strong>Fresh Products:</strong> We source directly from farms and trusted suppliers to ensure freshness</li>
                <li><strong>Quality Assurance:</strong> Every product goes through strict quality checks</li>
                <li><strong>Best Prices:</strong> Competitive pricing with regular discounts and offers</li>
                <li><strong>Secure Payments:</strong> Multiple payment options with secure transactions</li>
            </ul>
            
            <h2><i class="fas fa-leaf"></i> Our Values</h2>
            <ul>
                <li><strong>Quality:</strong> We never compromise on product quality</li>
                <li><strong>Trust:</strong> Building long-term relationships with our customers</li>
                <li><strong>Sustainability:</strong> Supporting local farmers and eco-friendly practices</li>
            </ul>
        </section>
        
        <!-- Contact Us -->
        <section class="info-section" style="background: #f8f9fa; padding: 60px 20px;">
            <h1><i class="fas fa-envelope"></i> Contact Us</h1>
            
            <p style="text-align: center;">Have questions? We'd love to hear from you! Reach out to us through any of the following channels.</p>
            
            <div class="contact-grid">
                <div class="contact-card">
                    <i class="fas fa-phone-alt"></i>
                    <h3>Phone</h3>
                    <p><a href="tel:+911234567890">+91 1234567890</a></p>
                    <p style="font-size: 14px; margin-top: 10px;">Mon-Sat: 9 AM - 8 PM</p>
                </div>
                
                <div class="contact-card">
                    <i class="fas fa-envelope"></i>
                    <h3>Email</h3>
                    <p><a href="mailto:shyamvarun18@gmail.com">shyamvarun18@gmail.com</a></p>
                    <p style="font-size: 14px; margin-top: 10px;">We reply within 24 hours</p>
                </div>
                
                <div class="contact-card">
                    <i class="fas fa-map-marker-alt"></i>
                    <h3>Address</h3>
                    <p>123 Main Street<br>Hyderabad, Telangana<br>500001, India</p>
                </div>
                
                <div class="contact-card">
                    <i class="fas fa-clock"></i>
                    <h3>Business Hours</h3>
                    <p><strong>Mon-Sat:</strong> 9:00 AM - 8:00 PM</p>
                    <p><strong>Sunday:</strong> 10:00 AM - 6:00 PM</p>
                </div>
            </div>
        </section>
        
        <!-- FAQ -->
        <section class="info-section">
            <h1><i class="fas fa-question-circle"></i> Frequently Asked Questions</h1>
            
            <div class="faq-container">
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <h3>What payment methods do you accept?</h3>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>We accept Credit/Debit Cards, UPI (Google Pay, PhonePe, Paytm), and Net Banking. All online transactions are 100% secure.</p>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <h3>What is your return/refund policy?</h3>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>We accept returns for damaged or defective products within 24 hours of delivery. Fresh produce and perishable items cannot be returned unless there's a quality issue. Refunds are processed within 5-7 business days.</p>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <h3>How do I contact customer support?</h3>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>You can reach us via phone at +91 1234567890 (9 AM - 8 PM) or email us at shyamvarun18@gmail.com. We typically respond within 24 hours.</p>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <h3>Are the products fresh and of good quality?</h3>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Absolutely! We source directly from trusted farms and suppliers. All products undergo quality checks before packaging. If you're not satisfied, we offer hassle-free returns on quality issues.</p>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <h3>Do you offer discounts or loyalty programs?</h3>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Yes! We regularly offer seasonal discounts, festive sales, and exclusive deals for registered users. Sign up for our newsletter to receive notifications about upcoming offers.</p>
                    </div>
                </div>
            </div>
        </section>
        
    </main>
    
    <!-- Footer -->
    <footer class="footer">
        <div class="footer-bottom">
            <p>&copy; 2025 Grocery Store. All rights reserved.</p>
        </div>
    </footer>
    
    <!-- JavaScript -->
    <script>
        // Mobile nav toggle
        const navToggle = document.getElementById('navToggle');
        const navMenu = document.getElementById('navMenu');
        
        if (navToggle && navMenu) {
            navToggle.addEventListener('click', function() {
                navMenu.classList.toggle('active');
            });
        }
        
        // FAQ toggle
        function toggleFAQ(element) {
            const answer = element.nextElementSibling;
            const allQuestions = document.querySelectorAll('.faq-question');
            const allAnswers = document.querySelectorAll('.faq-answer');
            
            allQuestions.forEach(q => {
                if (q !== element) q.classList.remove('active');
            });
            
            allAnswers.forEach(a => {
                if (a !== answer) a.classList.remove('active');
            });
            
            element.classList.toggle('active');
            answer.classList.toggle('active');
        }
    </script>
</body>
</html>
