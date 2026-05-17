<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Transaction - BudgetTrack</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
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
        <h3>Add Transaction</h3>

        <% if (request.getAttribute("error") != null) { %>
            <p class="msg error"><%= request.getAttribute("error") %></p>
        <% } %>

        <form action="transactions" method="post">
            <input type="hidden" name="action" value="add">
            <div class="form-group">
                <label>Type</label>
                <select name="type" required>
                    <option value="">Select type</option>
                    <option value="Income">Income</option>
                    <option value="Expense">Expense</option>
                </select>
            </div>
            <div class="form-group">
                <label>Amount (Rs.)</label>
                <input type="number" name="amount" step="0.01" min="0.01" required placeholder="Enter amount">
            </div>
            <div class="form-group">
                <label>Category</label>
                <input type="text" name="category" required placeholder="Enter category name">
            </div>
            <div class="form-group">
                <label>Description</label>
                <input type="text" name="description" placeholder="Optional description">
            </div>
            <div class="form-group">
                <label>Date</label>
                <input type="date" name="transactionDate" required>
            </div>
            <button type="submit" class="btn-primary">Add Transaction</button>
            <a href="dashboard" class="btn-secondary">Cancel</a>
        </form>
    </div>
</div>
</body>
</html>
