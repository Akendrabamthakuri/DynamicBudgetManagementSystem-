<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - BudgetTrack</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-body">
<div class="auth-split">

    <!-- Left Panel: Illustration -->
    <div class="auth-left">
        <div class="auth-left-content">
            <div class="auth-brand-title">BudgetTrack</div>
            <p class="auth-brand-sub">Take control of your finances</p>

            <!-- SVG Finance Illustration -->
            <svg viewBox="0 0 420 380" xmlns="http://www.w3.org/2000/svg" class="auth-illustration">
                <!-- Background circles -->
                <circle cx="210" cy="190" r="160" fill="rgba(255,255,255,0.05)"/>
                <circle cx="210" cy="190" r="120" fill="rgba(255,255,255,0.05)"/>

                <!-- Bar Chart -->
                <rect x="40" y="260" width="30" height="80" rx="6" fill="#2ecc71" opacity="0.9"/>
                <rect x="80" y="220" width="30" height="120" rx="6" fill="#27ae60" opacity="0.9"/>
                <rect x="120" y="190" width="30" height="150" rx="6" fill="#2ecc71" opacity="0.9"/>
                <rect x="160" y="230" width="30" height="110" rx="6" fill="#27ae60" opacity="0.9"/>
                <rect x="200" y="200" width="30" height="140" rx="6" fill="#1abc9c" opacity="0.9"/>
                <!-- Chart base line -->
                <line x1="30" y1="342" x2="245" y2="342" stroke="rgba(255,255,255,0.4)" stroke-width="2"/>

                <!-- Growth Arrow Line -->
                <polyline points="40,300 80,260 130,230 180,210 230,170" fill="none" stroke="#f1c40f" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
                <circle cx="230" cy="170" r="6" fill="#f1c40f"/>

                <!-- Wallet -->
                <rect x="260" y="80" width="120" height="80" rx="12" fill="#2980b9"/>
                <rect x="260" y="100" width="120" height="60" rx="0" fill="#3498db"/>
                <rect x="340" y="108" width="30" height="28" rx="14" fill="#2980b9"/>
                <circle cx="355" cy="122" r="8" fill="#f1c40f"/>
                <!-- Wallet lines -->
                <line x1="275" y1="118" x2="325" y2="118" stroke="rgba(255,255,255,0.4)" stroke-width="2"/>
                <line x1="275" y1="130" x2="315" y2="130" stroke="rgba(255,255,255,0.3)" stroke-width="2"/>

                <!-- Piggy Bank -->
                <ellipse cx="320" cy="260" rx="50" ry="42" fill="#e91e8c" opacity="0.85"/>
                <circle cx="350" cy="240" rx="18" ry="18" fill="#e91e8c" opacity="0.85"/>
                <!-- Piggy ear -->
                <ellipse cx="358" cy="228" rx="8" ry="6" fill="#c2185b" opacity="0.9"/>
                <!-- Piggy eye -->
                <circle cx="353" cy="237" r="3" fill="#fff"/>
                <circle cx="354" cy="237" r="1.5" fill="#333"/>
                <!-- Piggy nose -->
                <ellipse cx="365" cy="244" rx="5" ry="4" fill="#c2185b"/>
                <circle cx="363" cy="244" r="1" fill="#333"/>
                <circle cx="367" cy="244" r="1" fill="#333"/>
                <!-- Piggy legs -->
                <rect x="290" y="295" width="14" height="22" rx="7" fill="#c2185b"/>
                <rect x="310" y="295" width="14" height="22" rx="7" fill="#c2185b"/>
                <rect x="330" y="295" width="14" height="22" rx="7" fill="#c2185b"/>
                <rect x="350" y="295" width="14" height="22" rx="7" fill="#c2185b"/>
                <!-- Coin slot -->
                <rect x="308" y="222" width="20" height="5" rx="2" fill="#880e4f"/>

                <!-- Floating Coins -->
                <circle cx="100" cy="120" r="22" fill="#f1c40f"/>
                <text x="100" y="126" text-anchor="middle" font-size="16" font-weight="bold" fill="#e67e22">$</text>

                <circle cx="155" cy="80" r="16" fill="#f39c12"/>
                <text x="155" y="86" text-anchor="middle" font-size="12" font-weight="bold" fill="#fff">$</text>

                <circle cx="60" cy="170" r="13" fill="#f1c40f" opacity="0.8"/>
                <text x="60" y="175" text-anchor="middle" font-size="10" font-weight="bold" fill="#e67e22">$</text>

                <!-- Pie Chart -->
                <circle cx="100" cy="290" r="35" fill="none" stroke="#3498db" stroke-width="20" stroke-dasharray="66 134" stroke-dashoffset="0"/>
                <circle cx="100" cy="290" r="35" fill="none" stroke="#2ecc71" stroke-width="20" stroke-dasharray="44 156" stroke-dashoffset="-66"/>
                <circle cx="100" cy="290" r="35" fill="none" stroke="#e74c3c" stroke-width="20" stroke-dasharray="24 176" stroke-dashoffset="-110"/>
                <circle cx="100" cy="290" r="18" fill="rgba(26,60,90,0.9)"/>

                <!-- Up arrow / growth -->
                <polygon points="390,60 375,85 385,85 385,110 395,110 395,85 405,85" fill="#2ecc71" opacity="0.9"/>

                <!-- Stars / sparkles -->
                <text x="240" y="60" font-size="18" fill="#f1c40f" opacity="0.8">✦</text>
                <text x="170" y="45" font-size="12" fill="#fff" opacity="0.6">✦</text>
                <text x="390" y="160" font-size="14" fill="#2ecc71" opacity="0.7">✦</text>
            </svg>


        </div>
    </div>

    <!-- Right Panel: Login Form -->
    <div class="auth-right">
        <div class="auth-card">
            <h2>BudgetTrack</h2>
            <p class="subtitle">Sign in to your account</p>

            <% if (request.getAttribute("error") != null) { %>
                <p class="msg error"><%= request.getAttribute("error") %></p>
            <% } %>
            <% if (request.getParameter("success") != null) { %>
                <p class="msg success">Registration successful. Please login.</p>
            <% } %>

            <form action="login" method="post">
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" required placeholder="Enter your email">
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required placeholder="Enter your password">
                    <div class="forgot-link"><a href="forgotPassword">Forgot password?</a></div>
                </div>
                <button type="submit" class="btn-primary">Login</button>
            </form>
            <p class="link-text">Don't have an account? <a href="register">Register here</a></p>
        </div>
    </div>

</div>
</body>
</html>
