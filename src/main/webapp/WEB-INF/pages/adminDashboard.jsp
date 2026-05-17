<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.budgetmanagement.model.User" %>
<%@ page import="com.budgetmanagement.model.Transaction" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - BudgetTrack</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%
    List<User> users = (List<User>) request.getAttribute("users");
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
%>
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
    <h2>Admin Dashboard</h2>

    <div class="summary-cards">
        <div class="card income">
            <p>Total Users</p>
            <h3><%= users != null ? users.size() : 0 %></h3>
        </div>
        <div class="card expense">
            <p>Total Transactions</p>
            <h3><%= transactions != null ? transactions.size() : 0 %></h3>
        </div>
    </div>

    <div class="section-header">
        <h3>Recent Users</h3>
        <a href="adminUsers" class="btn-primary">Manage Users</a>
    </div>

    <table class="data-table">
        <thead>
            <tr><th>ID</th><th>Name</th><th>Email</th><th>Budget Limit</th></tr>
        </thead>
        <tbody>
        <% if (users != null) { for (User u : users) { %>
            <tr>
                <td><%= u.getId() %></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.getEmail() %></td>
                <td>Rs. <%= String.format("%.2f", u.getBudgetLimit()) %></td>
            </tr>
        <% } } %>
        </tbody>
    </table>
</div>
</body>
</html>
