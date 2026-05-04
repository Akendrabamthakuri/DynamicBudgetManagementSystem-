<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.budgetmanagement.model.Transaction" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Transactions - BudgetTrack</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<% List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions"); %>
<nav class="navbar">
    <span class="brand">BudgetTrack Admin</span>
    <div class="nav-links">
        <a href="adminDashboard">Dashboard</a>
        <a href="adminUsers">Users</a>
        <a href="adminTransactions">Transactions</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="page-wrapper">
    <h2>All Transactions</h2>
    <table class="data-table">
        <thead>
            <tr><th>ID</th><th>User ID</th><th>Date</th><th>Type</th><th>Category</th><th>Description</th><th>Amount</th></tr>
        </thead>
        <tbody>
        <% if (transactions != null && !transactions.isEmpty()) {
               for (Transaction t : transactions) { %>
            <tr>
                <td><%= t.getId() %></td>
                <td><%= t.getUserId() %></td>
                <td><%= t.getTransactionDate() %></td>
                <td><span class="badge <%= t.getType().toLowerCase() %>"><%= t.getType() %></span></td>
                <td><%= t.getCategory() %></td>
                <td><%= t.getDescription() != null ? t.getDescription() : "-" %></td>
                <td>Rs. <%= String.format("%.2f", t.getAmount()) %></td>
            </tr>
        <% } } else { %>
            <tr><td colspan="7" class="empty-msg">No transactions found.</td></tr>
        <% } %>
        </tbody>
    </table>
</div>
</body>
</html>
