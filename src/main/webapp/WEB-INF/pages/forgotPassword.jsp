<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - BudgetTrack</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-body">
<div class="auth-wrapper">
    <div class="auth-card">
        <h2>BudgetTrack</h2>
        <p class="subtitle">Reset your password</p>

        <% if (request.getAttribute("error") != null) { %>
            <p class="msg error"><%= request.getAttribute("error") %></p>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <p class="msg success"><%= request.getAttribute("success") %></p>
        <% } %>

        <form action="forgotPassword" method="post">
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" required placeholder="Enter your registered email">
            </div>
            <div class="form-group">
                <label>New Password</label>
                <input type="password" name="newPassword" required placeholder="Min 6 chars with letters and numbers">
            </div>
            <button type="submit" class="btn-primary">Reset Password</button>
        </form>
        <p class="link-text"><a href="login">Back to Login</a></p>
    </div>
</div>
</body>
</html>
