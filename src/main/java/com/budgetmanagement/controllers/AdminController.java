package com.budgetmanagement.controllers;

import com.budgetmanagement.service.TransactionService;
import com.budgetmanagement.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * AdminController handles the admin dashboard, user management, and all transactions view.
 */
public class AdminController extends HttpServlet {
    private final UserService userService = new UserService();
    private final TransactionService transactionService = new TransactionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/adminDashboard":
                request.setAttribute("users", userService.getAllUsers());
                request.setAttribute("transactions", transactionService.getAllTransactions());
                request.getRequestDispatcher("/WEB-INF/pages/adminDashboard.jsp").forward(request, response);
                break;
            case "/adminUsers":
                String action = request.getParameter("action");
                if ("delete".equals(action)) {
                    int userId = Integer.parseInt(request.getParameter("id"));
                    userService.deleteUser(userId);
                }
                request.setAttribute("users", userService.getAllUsers());
                request.getRequestDispatcher("/WEB-INF/pages/adminUsers.jsp").forward(request, response);
                break;
            case "/adminTransactions":
                request.setAttribute("transactions", transactionService.getAllTransactions());
                request.getRequestDispatcher("/WEB-INF/pages/adminTransactions.jsp").forward(request, response);
                break;
        }
    }
}
