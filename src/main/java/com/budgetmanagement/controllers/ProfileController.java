package com.budgetmanagement.controllers;

import com.budgetmanagement.model.User;
import com.budgetmanagement.service.UserService;
import com.budgetmanagement.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * ProfileController handles viewing and updating user profile and password.
 */
public class ProfileController extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        User sessionUser = (User) request.getSession().getAttribute("user");

        if ("updateProfile".equals(action)) {
            String username = request.getParameter("username");
            String budgetLimitStr = request.getParameter("budgetLimit");

            if (!ValidationUtil.isValidName(username) || !ValidationUtil.isValidAmount(budgetLimitStr)) {
                request.setAttribute("error", "Invalid input. Name must be letters only and budget must be a positive number.");
                request.getRequestDispatcher("/WEB-INF/pages/profile.jsp").forward(request, response);
                return;
            }

            sessionUser.setUsername(username);
            sessionUser.setBudgetLimit(Double.parseDouble(budgetLimitStr));
            if (userService.updateUser(sessionUser)) {
                request.getSession().setAttribute("user", sessionUser);
                request.setAttribute("success", "Profile updated successfully.");
            } else {
                request.setAttribute("error", "Something went wrong. Please try again.");
            }
            request.getRequestDispatcher("/WEB-INF/pages/profile.jsp").forward(request, response);

        } else if ("updatePassword".equals(action)) {
            String newPassword = request.getParameter("newPassword");
            if (!ValidationUtil.isValidPassword(newPassword)) {
                request.setAttribute("error", "Password must be at least 6 characters with letters and numbers.");
                request.getRequestDispatcher("/WEB-INF/pages/profile.jsp").forward(request, response);
                return;
            }
            if (userService.updatePassword(sessionUser.getId(), newPassword)) {
                request.setAttribute("success", "Password updated successfully.");
            } else {
                request.setAttribute("error", "Something went wrong. Please try again.");
            }
            request.getRequestDispatcher("/WEB-INF/pages/profile.jsp").forward(request, response);
        }
    }
}
