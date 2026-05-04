<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>500 - Server Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="error-page">
    <h1>500</h1>
    <h2>Something Went Wrong</h2>
    <p>An unexpected error occurred. Please try again later.</p>
    <a href="${pageContext.request.contextPath}/login" class="btn-primary">Go to Login</a>
</div>
</body>
</html>
