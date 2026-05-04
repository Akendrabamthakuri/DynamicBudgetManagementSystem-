package com.budgetmanagement.controllers;

import com.budgetmanagement.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * AuthFilter protects all pages except login and register.
 * Also enforces role-based access for admin routes.
 */
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Restrict admin routes to admin role only
        String path = req.getServletPath();
        if (path.startsWith("/admin") && !"admin".equals(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        chain.doFilter(request, response);
    }
}
