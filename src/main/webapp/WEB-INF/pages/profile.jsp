<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.budgetmanagement.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - BudgetTrack</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<% User user = (User) session.getAttribute("user"); %>
<nav class="navbar">
    <span class="brand">BudgetTrack</span>
    <div class="nav-links">
        <a href="dashboard">Dashboard</a>
        <a href="profile">Profile</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="page-wrapper">
    <% if (request.getAttribute("error") != null) { %>
        <p class="msg error"><%= request.getAttribute("error") %></p>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
        <p class="msg success"><%= request.getAttribute("success") %></p>
    <% } %>

    <div class="form-card">
        <h3>Update Profile</h3>
        <form action="profile" method="post">
            <input type="hidden" name="action" value="updateProfile">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="username" value="<%= user.getUsername() %>" required>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" value="<%= user.getEmail() %>" disabled>
            </div>
            <div class="form-group">
                <label>Budget Limit (Rs.)</label>
                <input type="number" name="budgetLimit" step="0.01" value="<%= user.getBudgetLimit() %>" required>
            </div>
            <button type="submit" class="btn-primary">Update Profile</button>
        </form>
    </div>

    <div class="form-card">
        <h3>Change Password</h3>
        <form action="profile" method="post">
            <input type="hidden" name="action" value="updatePassword">
            <div class="form-group">
                <label>New Password</label>
                <input type="password" name="newPassword" required placeholder="Min 6 chars with letters and numbers">
            </div>
            <button type="submit" class="btn-primary">Update Password</button>
        </form>
    </div>
</div>
</body>
</html>
