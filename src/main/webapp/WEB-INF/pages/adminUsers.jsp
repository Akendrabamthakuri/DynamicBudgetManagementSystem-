<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.budgetmanagement.model.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - BudgetTrack</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<% List<User> users = (List<User>) request.getAttribute("users"); %>
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
    <h2>Manage Users</h2>
    <table class="data-table">
        <thead>
            <tr><th>ID</th><th>Name</th><th>Email</th><th>Budget Limit</th><th>Status</th><th>Actions</th></tr>
        </thead>
        <tbody>
        <% if (users != null) { for (User u : users) { %>
            <tr>
                <td><%= u.getId() %></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.getEmail() %></td>
                <td>Rs. <%= String.format("%.2f", u.getBudgetLimit()) %></td>
                <td>
                    <a href="adminUsers?action=delete&id=<%= u.getId() %>" class="btn-delete" onclick="return confirm('Delete this user?')">Delete</a>
                </td>
            </tr>
        <% } } %>
        </tbody>
    </table>
</div>
</body>
</html>
