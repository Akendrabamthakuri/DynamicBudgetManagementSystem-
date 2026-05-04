<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.budgetmanagement.model.Transaction" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Transaction - BudgetTrack</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%  Transaction t = (Transaction) request.getAttribute("transaction"); %>
<nav class="navbar">
    <span class="brand">BudgetTrack</span>
    <div class="nav-links">
        <a href="dashboard">Dashboard</a>
        <a href="profile">Profile</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="page-wrapper">
    <div class="form-card">
        <h3>Edit Transaction</h3>

        <% if (request.getAttribute("error") != null) { %>
            <p class="msg error"><%= request.getAttribute("error") %></p>
        <% } %>

        <form action="transactions" method="post">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="id" value="<%= t.getId() %>">
            <div class="form-group">
                <label>Type</label>
                <select name="type" required>
                    <option value="Income" <%= "Income".equals(t.getType()) ? "selected" : "" %>>Income</option>
                    <option value="Expense" <%= "Expense".equals(t.getType()) ? "selected" : "" %>>Expense</option>
                </select>
            </div>
            <div class="form-group">
                <label>Amount (Rs.)</label>
                <input type="number" name="amount" step="0.01" min="0.01" value="<%= t.getAmount() %>" required>
            </div>
            <div class="form-group">
                <label>Category</label>
                <select name="category" required>
                    <% String[] cats = {"Salary","Food","Rent","Transport","Entertainment","Health","Education","Other"};
                       for (String cat : cats) { %>
                        <option value="<%= cat %>" <%= cat.equals(t.getCategory()) ? "selected" : "" %>><%= cat %></option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label>Description</label>
                <input type="text" name="description" value="<%= t.getDescription() != null ? t.getDescription() : "" %>">
            </div>
            <div class="form-group">
                <label>Date</label>
                <input type="date" name="transactionDate" value="<%= t.getTransactionDate() %>" required>
            </div>
            <button type="submit" class="btn-primary">Update</button>
            <a href="dashboard" class="btn-secondary">Cancel</a>
        </form>
    </div>
</div>
</body>
</html>
