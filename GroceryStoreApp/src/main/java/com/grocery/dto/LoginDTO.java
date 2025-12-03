package com.grocery.dto;

import java.io.Serializable;

/**
 * LoginDTO - Data Transfer Object for user login
 */
public class LoginDTO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    private String username;
    private String password;
    private boolean rememberMe;
    
    // Default Constructor
    public LoginDTO() {
    }
    
    // Parameterized Constructor
    public LoginDTO(String username, String password) {
        this.username = username;
        this.password = password;
    }
    
    // Getters and Setters
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public boolean isRememberMe() {
        return rememberMe;
    }
    
    public void setRememberMe(boolean rememberMe) {
        this.rememberMe = rememberMe;
    }
    
    @Override
    public String toString() {
        return "LoginDTO [username=" + username + ", rememberMe=" + rememberMe + "]";
    }
}
