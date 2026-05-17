package com.budgetmanagement.service;

import com.budgetmanagement.config.DBConnection;
import com.budgetmanagement.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * UserService handles all business logic and database operations related to users.
 */
public class UserService {

    // Register a new user with hashed password
    public boolean registerUser(User user) {
        String query = "INSERT INTO users (username, email, password, role, budget_limit) VALUES (?, ?, ?, 'user', 50000.0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Registration error: " + e.getMessage());
            return false;
        }
    }

    // Validate login credentials
    public User loginUser(String email, String password) {
        String query = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int userId = rs.getInt("id");
                String storedPassword = rs.getString("password");
                int failedAttempts = rs.getInt("failed_attempts");
                boolean isLocked = rs.getBoolean("is_locked");
                Timestamp lockUntil = rs.getTimestamp("lock_until");

                // If account is locked and lock period not expired, deny login
                if (isLocked && lockUntil != null && lockUntil.after(new Timestamp(System.currentTimeMillis()))) {
                    return null; // account still locked
                }

                // If lock period expired, reset lock fields
                if (isLocked && (lockUntil == null || !lockUntil.after(new Timestamp(System.currentTimeMillis())))) {
                    String resetQuery = "UPDATE users SET failed_attempts = 0, is_locked = FALSE, lock_until = NULL WHERE id = ?";
                    try (PreparedStatement resetPs = conn.prepareStatement(resetQuery)) {
                        resetPs.setInt(1, userId);
                        resetPs.executeUpdate();
                    }
                }

                if (storedPassword.equals(password)) {
                    // Successful login: reset attempts
                    String resetQuery = "UPDATE users SET failed_attempts = 0, is_locked = FALSE, lock_until = NULL WHERE id = ?";
                    try (PreparedStatement resetPs = conn.prepareStatement(resetQuery)) {
                        resetPs.setInt(1, userId);
                        resetPs.executeUpdate();
                    }
                    return mapUser(rs);
                } else {
                    // Wrong password: increment failed attempts
                    failedAttempts = failedAttempts + 1;
                    if (failedAttempts >= 5) {
                        String lockQuery = "UPDATE users SET failed_attempts = ?, is_locked = TRUE, lock_until = ? WHERE id = ?";
                        try (PreparedStatement lockPs = conn.prepareStatement(lockQuery)) {
                            lockPs.setInt(1, failedAttempts);
                            Timestamp until = new Timestamp(System.currentTimeMillis() + 3 * 60 * 1000); // 3 minutes
                            lockPs.setTimestamp(2, until);
                            lockPs.setInt(3, userId);
                            lockPs.executeUpdate();
                        }
                    } else {
                        String incQuery = "UPDATE users SET failed_attempts = ? WHERE id = ?";
                        try (PreparedStatement incPs = conn.prepareStatement(incQuery)) {
                            incPs.setInt(1, failedAttempts);
                            incPs.setInt(2, userId);
                            incPs.executeUpdate();
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Login error: " + e.getMessage());
        }
        return null;
    }

    // Check if email already exists
    public boolean emailExists(String email) {
        String query = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            return false;
        }
    }

    // Get all users (admin use)
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM users WHERE role = 'user'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) users.add(mapUser(rs));
        } catch (SQLException e) {
            System.err.println("Get all users error: " + e.getMessage());
        }
        return users;
    }

    // Update user profile
    public boolean updateUser(User user) {
        String query = "UPDATE users SET username = ?, budget_limit = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, user.getUsername());
            ps.setDouble(2, user.getBudgetLimit());
            ps.setInt(3, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update user error: " + e.getMessage());
            return false;
        }
    }

    // Update password by email (for forgot password)
    public boolean updatePasswordByEmail(String email, String newPassword) {
        String query = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, newPassword);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update password by email error: " + e.getMessage());
            return false;
        }
    }

    // Update password
    public boolean updatePassword(int userId, String newPassword) {
        String query = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update password error: " + e.getMessage());
            return false;
        }
    }

    // Delete user by id (admin use)
    public boolean deleteUser(int userId) {
        String query = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Delete user error: " + e.getMessage());
            return false;
        }
    }

    // Get user by id
    public User getUserById(int id) {
        String query = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (SQLException e) {
            System.err.println("Get user error: " + e.getMessage());
        }
        return null;
    }

    // Get lock_until timestamp for an email (used to inform user about lockout)
    public Timestamp getLockUntilByEmail(String email) {
        String query = "SELECT lock_until FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getTimestamp("lock_until");
        } catch (SQLException e) {
            System.err.println("Get lock_until error: " + e.getMessage());
        }
        return null;
    }

    // Map ResultSet row to User object
    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setRole(rs.getString("role"));
        user.setBudgetLimit(rs.getDouble("budget_limit"));
        return user;
    }
}
