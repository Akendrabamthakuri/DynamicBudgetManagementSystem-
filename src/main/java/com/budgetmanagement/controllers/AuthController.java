package com.budgetmanagement.controllers;

import com.budgetmanagement.model.User;
import com.budgetmanagement.service.UserService;
import com.budgetmanagement.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * AuthController handles login, registration, and logout.
 */
public class AuthController extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/login":
                request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
                break;
            case "/register":
                request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
                break;
            case "/logout":
                handleLogout(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if (path.equals("/login")) {
            handleLogin(request, response);
        } else if (path.equals("/register")) {
            handleRegister(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (ValidationUtil.isNullOrEmpty(email) || ValidationUtil.isNullOrEmpty(password)) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
            return;
        }

        User user = userService.loginUser(email, password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            // Redirect based on role
            if ("admin".equals(user.getRole())) {
                response.sendRedirect("adminDashboard");
            } else {
                response.sendRedirect("dashboard");
            }
        } else {
            // Check if account is locked
            String error = "Invalid email or password.";
            request.setAttribute("error", error);
            request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validation
        if (ValidationUtil.isNullOrEmpty(username) || ValidationUtil.isNullOrEmpty(email) || ValidationUtil.isNullOrEmpty(password)) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }
        if (!ValidationUtil.isValidName(username)) {
            request.setAttribute("error", "Username must contain letters only.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Please enter a valid email address.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }
        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("error", "Password must be at least 6 characters with letters and numbers.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }
        if (userService.emailExists(email)) {
            request.setAttribute("error", "An account with this email already exists.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
            return;
        }

        User user = new User(username, email, password, "user", 50000.0);
        if (userService.registerUser(user)) {
            response.sendRedirect("login?success=true");
        } else {
            request.setAttribute("error", "Something went wrong. Please try again.");
            request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        response.sendRedirect("login");
    }
}
