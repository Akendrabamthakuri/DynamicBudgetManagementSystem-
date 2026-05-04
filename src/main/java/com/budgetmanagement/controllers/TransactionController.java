package com.budgetmanagement.controllers;

import com.budgetmanagement.model.Transaction;
import com.budgetmanagement.model.User;
import com.budgetmanagement.service.TransactionService;
import com.budgetmanagement.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * TransactionController handles add, edit, delete of transactions for users.
 */
public class TransactionController extends HttpServlet {
    private final TransactionService transactionService = new TransactionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        User user = (User) request.getSession().getAttribute("user");

        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("transaction", transactionService.getTransactionById(id));
            request.getRequestDispatcher("/WEB-INF/pages/editTransaction.jsp").forward(request, response);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            transactionService.deleteTransaction(id, user.getId());
            response.sendRedirect("dashboard");
        } else {
            request.getRequestDispatcher("/WEB-INF/pages/addTransaction.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        User user = (User) request.getSession().getAttribute("user");

        String type = request.getParameter("type");
        String amountStr = request.getParameter("amount");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String date = request.getParameter("transactionDate");

        if (ValidationUtil.isNullOrEmpty(type) || !ValidationUtil.isValidAmount(amountStr)
                || ValidationUtil.isNullOrEmpty(category) || ValidationUtil.isNullOrEmpty(date)) {
            request.setAttribute("error", "Please fill all required fields with valid values.");
            String page = "edit".equals(action) ? "/WEB-INF/pages/editTransaction.jsp" : "/WEB-INF/pages/addTransaction.jsp";
            request.getRequestDispatcher(page).forward(request, response);
            return;
        }

        Transaction t = new Transaction(user.getId(), type, Double.parseDouble(amountStr), category, description, date);

        if ("edit".equals(action)) {
            t.setId(Integer.parseInt(request.getParameter("id")));
            transactionService.updateTransaction(t);
        } else {
            transactionService.addTransaction(t);
        }
        response.sendRedirect("dashboard");
    }
}
