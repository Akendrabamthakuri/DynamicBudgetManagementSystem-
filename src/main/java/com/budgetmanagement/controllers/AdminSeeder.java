package com.budgetmanagement.controllers;

import com.budgetmanagement.config.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 * AdminSeeder is a one-time use servlet to create the admin account with a proper BCrypt hash.
 * Visit /setupAdmin once, then remove or disable this servlet.
 */
public class AdminSeeder extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String delete = "DELETE FROM users WHERE email = 'admin@budget.com'";
        String insert = "INSERT INTO users (username, email, password, role, budget_limit) VALUES ('admin', 'admin@budget.com', 'Admin@123', 'admin', 50000.0)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.prepareStatement(delete).executeUpdate();
            conn.prepareStatement(insert).executeUpdate();
            response.getWriter().println("Admin account created successfully. Email: admin@budget.com | Password: Admin@123");
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
