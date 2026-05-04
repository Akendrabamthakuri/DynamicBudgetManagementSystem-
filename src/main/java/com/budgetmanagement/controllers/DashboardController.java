package com.budgetmanagement.controllers;

import com.budgetmanagement.model.User;
import com.budgetmanagement.service.TransactionService;
import com.budgetmanagement.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * DashboardController loads the user dashboard with transaction summary.
 */
public class DashboardController extends HttpServlet {
    private final TransactionService transactionService = new TransactionService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        int userId = user.getId();

        // Always fetch fresh user data so budget limit reflects latest profile update
        User freshUser = userService.getUserById(userId);
        if (freshUser != null) {
            request.getSession().setAttribute("user", freshUser);
            user = freshUser;
        }

        // Get period filter: month, week, or all (default: month)
        String period = request.getParameter("period");
        if (period == null || period.isEmpty()) period = "month";

        double totalIncome = transactionService.getTotalIncomeByPeriod(userId, period);
        double totalExpense = transactionService.getTotalExpenseByPeriod(userId, period);

        request.setAttribute("transactions", transactionService.getUserTransactionsByPeriod(userId, period));
        request.setAttribute("totalIncome", totalIncome);
        request.setAttribute("totalExpense", totalExpense);
        request.setAttribute("balance", totalIncome - totalExpense);
        request.setAttribute("period", period);

        request.getRequestDispatcher("/WEB-INF/pages/dashboard.jsp").forward(request, response);
    }
}
