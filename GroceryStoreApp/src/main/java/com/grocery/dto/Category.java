package com.grocery.dto;

import java.io.Serializable;

public class Category implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int categoryId;
    private String categoryName;
    private String description;
    
    public Category() {}
    
    public Category(int categoryId, String categoryName) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
    }
    
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
