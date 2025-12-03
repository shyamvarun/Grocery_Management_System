package com.grocery.utility;

import java.util.Properties;
import java.util.Random;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtility {
    
    // ⚠️ EMAIL CONFIGURATION
    private static final String FROM_EMAIL = "shyamvarun18@gmail.com";
    private static final String EMAIL_PASSWORD = "xpahegerkxicjytv";
    private static final String WAREHOUSE_EMAIL = "shyamvarun2004@gmail.com"; // For stock alerts
    
    /**
     * Generate 6-digit OTP
     */
    public static String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
    
    /**
     * Send OTP Email for Password Reset
     */
    public static boolean sendOTPEmail(String toEmail, String otp, String userName) {
        Properties props = getEmailProperties();
        
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, EMAIL_PASSWORD);
            }
        });
        
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("🔐 Password Reset OTP - Grocery Store");
            
            String emailBody = createOTPEmailBody(userName, otp);
            message.setContent(emailBody, "text/html; charset=utf-8");
            
            Transport.send(message);
            
            System.out.println("✅ OTP email sent successfully to: " + toEmail);
            return true;
            
        } catch (MessagingException e) {
            System.err.println("❌ Failed to send OTP email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Send Low Stock Alert Email to Warehouse
     */
    public static boolean sendLowStockAlert(String productName, int currentStock, String barcode) {
        Properties props = getEmailProperties();
        
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, EMAIL_PASSWORD);
            }
        });
        
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(WAREHOUSE_EMAIL));
            message.setSubject("⚠️ LOW STOCK ALERT - " + productName);
            
            String emailBody = createLowStockEmailBody(productName, currentStock, barcode);
            message.setContent(emailBody, "text/html; charset=utf-8");
            
            Transport.send(message);
            
            System.out.println("✅ Low stock email sent successfully for: " + productName);
            return true;
            
        } catch (MessagingException e) {
            System.err.println("❌ Failed to send low stock email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Common Email Properties
     */
    private static Properties getEmailProperties() {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        return props;
    }
    
    /**
     * OTP Email HTML Template
     */
    private static String createOTPEmailBody(String userName, String otp) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head><style>" +
               "body { font-family: Arial, sans-serif; background: #f5f5f5; padding: 20px; margin: 0; }" +
               ".container { background: white; padding: 30px; border-radius: 12px; max-width: 600px; margin: 0 auto; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }" +
               ".header { background: linear-gradient(135deg, #4CAF50, #45a049); color: white; padding: 25px; border-radius: 10px; text-align: center; margin-bottom: 25px; }" +
               ".header h1 { margin: 10px 0; font-size: 28px; }" +
               ".otp-box { background: #e8f5e9; padding: 25px; border-radius: 10px; text-align: center; margin: 25px 0; border: 3px solid #4CAF50; }" +
               ".otp-code { font-size: 42px; font-weight: bold; color: #4CAF50; letter-spacing: 8px; margin: 15px 0; font-family: monospace; }" +
               ".warning { background: #fff3cd; padding: 15px; border-left: 4px solid #ff9800; margin: 20px 0; border-radius: 5px; }" +
               ".footer { text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; color: #999; font-size: 12px; }" +
               "</style></head>" +
               "<body>" +
               "<div class='container'>" +
               "<div class='header'>" +
               "<div style='font-size: 50px;'>🔐</div>" +
               "<h1>Password Reset Request</h1>" +
               "</div>" +
               "<p>Hi <strong>" + userName + "</strong>,</p>" +
               "<p>We received a request to reset your password. Use the OTP below:</p>" +
               "<div class='otp-box'>" +
               "<p style='margin: 0; color: #666;'>Your OTP Code</p>" +
               "<div class='otp-code'>" + otp + "</div>" +
               "<p style='margin: 0; color: #666;'>⏰ Valid for 10 minutes</p>" +
               "</div>" +
               "<div class='warning'>" +
               "<p style='margin: 0; font-weight: bold; color: #e65100;'>⚠️ Security Tips:</p>" +
               "<ul style='margin: 10px 0;'>" +
               "<li>Never share this OTP with anyone</li>" +
               "<li>Our team will never ask for your OTP</li>" +
               "<li>If you didn't request this, ignore this email</li>" +
               "</ul>" +
               "</div>" +
               "<div class='footer'>" +
               "<p><strong>Grocery Store</strong></p>" +
               "<p>© 2025 All rights reserved</p>" +
               "</div>" +
               "</div>" +
               "</body></html>";
    }
    
    /**
     * Low Stock Alert Email HTML Template
     */
    private static String createLowStockEmailBody(String productName, int currentStock, String barcode) {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head><style>" +
               "body { font-family: Arial, sans-serif; background: #f5f5f5; padding: 20px; }" +
               ".container { background: white; padding: 30px; border-radius: 10px; max-width: 600px; margin: 0 auto; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }" +
               ".header { background: linear-gradient(135deg, #f44336, #e91e63); color: white; padding: 25px; border-radius: 8px; text-align: center; }" +
               ".alert-icon { font-size: 64px; margin-bottom: 10px; }" +
               ".product-info { background: #fff3cd; padding: 20px; border-left: 5px solid #ff9800; margin: 25px 0; border-radius: 5px; }" +
               ".product-info h3 { color: #ff9800; margin-top: 0; }" +
               ".stock-count { font-size: 48px; color: #f44336; font-weight: bold; text-align: center; margin: 30px 0; padding: 20px; background: #ffebee; border-radius: 8px; }" +
               ".action-required { background: #e8f5e9; padding: 20px; border-radius: 8px; border-left: 5px solid #4CAF50; margin-top: 25px; }" +
               ".action-required h3 { color: #4CAF50; margin-top: 0; }" +
               ".footer { text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; color: #666; font-size: 12px; }" +
               "ul { padding-left: 20px; }" +
               "li { margin: 8px 0; }" +
               "</style></head>" +
               "<body>" +
               "<div class='container'>" +
               "<div class='header'>" +
               "<div class='alert-icon'>⚠️</div>" +
               "<h1 style='margin: 10px 0;'>LOW STOCK ALERT</h1>" +
               "<p style='margin: 5px 0; font-size: 16px;'>Immediate Attention Required!</p>" +
               "</div>" +
               "<div class='product-info'>" +
               "<h3>📦 Product Details</h3>" +
               "<p style='margin: 8px 0;'><strong>Product:</strong> " + productName + "</p>" +
               "<p style='margin: 8px 0;'><strong>Barcode:</strong> " + barcode + "</p>" +
               "<p style='margin: 8px 0;'><strong>Store:</strong> Grocery Store</p>" +
               "</div>" +
               "<div class='stock-count'>" +
               "⚠️ Only " + currentStock + " units remaining!" +
               "</div>" +
               "<div class='action-required'>" +
               "<h3>✅ Action Required</h3>" +
               "<ul>" +
               "<li>Reorder stock immediately from supplier</li>" +
               "<li>Update inventory management system</li>" +
               "<li>Notify purchasing department</li>" +
               "<li>Check for alternative suppliers if needed</li>" +
               "</ul>" +
               "</div>" +
               "<div class='footer'>" +
               "<p><strong>Grocery Store Management System</strong></p>" +
               "<p>Automated Stock Alert | " + new java.util.Date() + "</p>" +
               "<p style='margin-top: 10px;'>This is an automated message. Please do not reply.</p>" +
               "</div>" +
               "</div>" +
               "</body></html>";
    }
    
    /**
     * Test Method
     */
    public static void main(String[] args) {
        System.out.println("=================================");
        System.out.println("🧪 TESTING EMAIL SYSTEM...");
        System.out.println("=================================");
        
        // Test 1: Low Stock Alert
        System.out.println("\n📧 Test 1: Low Stock Alert");
        boolean test1 = sendLowStockAlert("Test Product - Apples", 5, "TEST12345");
        System.out.println(test1 ? "✅ Low stock alert sent!" : "❌ Failed!");
        
        // Test 2: OTP Email
        System.out.println("\n📧 Test 2: OTP Email");
        String testOTP = generateOTP();
        boolean test2 = sendOTPEmail("shyamvarun2004@gmail.com", testOTP, "Test User");
        System.out.println(test2 ? "✅ OTP email sent! OTP: " + testOTP : "❌ Failed!");
        
        System.out.println("\n=================================");
        System.out.println("📬 Check your inbox now!");
        System.out.println("=================================");
    }
}
