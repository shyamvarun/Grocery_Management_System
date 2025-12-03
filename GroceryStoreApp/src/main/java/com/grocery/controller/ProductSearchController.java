package com.grocery.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.grocery.dao.ProductDAO;
import com.grocery.dto.Product;
import com.google.gson.Gson;

@WebServlet("/ProductSearchController")
public class ProductSearchController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO = new ProductDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            List<Product> products = productDAO.searchProducts(keyword);
            
            // Convert to JSON using Gson
            Gson gson = new Gson();
            String json = gson.toJson(products);
            out.print(json);
        } else {
            out.print("[]");
        }
        
        out.flush();
    }
}
