<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - BudgetTrack</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card">
        <h2>BudgetTrack</h2>
        <p class="subtitle">Create a new account</p>

        <% if (request.getAttribute("error") != null) { %>
            <p class="msg error"><%= request.getAttribute("error") %></p>
        <% } %>

        <form action="register" method="post">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="username" required placeholder="Enter your full name">
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" required placeholder="Enter your email">
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required placeholder="Min 6 chars with letters and numbers">
            </div>
            <button type="submit" class="btn-primary">Register</button>
        </form>
        <p class="link-text">Already have an account? <a href="login">Login here</a></p>
    </div>
</div>
</body>
</html>
