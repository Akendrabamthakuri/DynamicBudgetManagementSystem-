package com.budgetmanagement.controllers;

import com.budgetmanagement.service.UserService;
import com.budgetmanagement.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * ForgotPasswordController handles password reset by verifying email and setting a new password.
 */
public class ForgotPasswordController extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");

        if (ValidationUtil.isNullOrEmpty(email) || ValidationUtil.isNullOrEmpty(newPassword)) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidPassword(newPassword)) {
            request.setAttribute("error", "Password must be at least 6 characters with letters and numbers.");
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
            return;
        }

        if (!userService.emailExists(email)) {
            request.setAttribute("error", "No account found with that email address.");
            request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
            return;
        }

        // Get user by email and update password
        boolean updated = userService.updatePasswordByEmail(email, newPassword);
        if (updated) {
            request.setAttribute("success", "Password reset successful. You can now login.");
        } else {
            request.setAttribute("error", "Something went wrong. Please try again.");
        }
        request.getRequestDispatcher("/WEB-INF/pages/forgotPassword.jsp").forward(request, response);
    }
}
