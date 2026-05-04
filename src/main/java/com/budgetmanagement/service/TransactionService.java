package com.budgetmanagement.service;

import com.budgetmanagement.config.DBConnection;
import com.budgetmanagement.model.Transaction;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * TransactionService handles all business logic and database operations for transactions.
 */
public class TransactionService {

    // Add a new transaction
    public boolean addTransaction(Transaction t) {
        String query = "INSERT INTO transactions (user_id, type, amount, category, description, transaction_date) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, t.getUserId());
            ps.setString(2, t.getType());
            ps.setDouble(3, t.getAmount());
            ps.setString(4, t.getCategory());
            ps.setString(5, t.getDescription());
            ps.setString(6, t.getTransactionDate());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Add transaction error: " + e.getMessage());
            return false;
        }
    }

    // Get all transactions for a specific user
    public List<Transaction> getUserTransactions(int userId) {
        List<Transaction> list = new ArrayList<>();
        String query = "SELECT * FROM transactions WHERE user_id = ? ORDER BY transaction_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapTransaction(rs));
        } catch (SQLException e) {
            System.err.println("Get transactions error: " + e.getMessage());
        }
        return list;
    }

    // Get all transactions (admin use)
    public List<Transaction> getAllTransactions() {
        List<Transaction> list = new ArrayList<>();
        String query = "SELECT * FROM transactions ORDER BY transaction_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapTransaction(rs));
        } catch (SQLException e) {
            System.err.println("Get all transactions error: " + e.getMessage());
        }
        return list;
    }

    // Update a transaction
    public boolean updateTransaction(Transaction t) {
        String query = "UPDATE transactions SET type = ?, amount = ?, category = ?, description = ?, transaction_date = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, t.getType());
            ps.setDouble(2, t.getAmount());
            ps.setString(3, t.getCategory());
            ps.setString(4, t.getDescription());
            ps.setString(5, t.getTransactionDate());
            ps.setInt(6, t.getId());
            ps.setInt(7, t.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Update transaction error: " + e.getMessage());
            return false;
        }
    }

    // Delete a transaction
    public boolean deleteTransaction(int transactionId, int userId) {
        String query = "DELETE FROM transactions WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, transactionId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Delete transaction error: " + e.getMessage());
            return false;
        }
    }

    // Get total income for a user (all time)
    public double getTotalIncome(int userId) {
        return getTotal(userId, "Income", "all");
    }

    // Get total expense for a user (all time)
    public double getTotalExpense(int userId) {
        return getTotal(userId, "Expense", "all");
    }

    // Get total income for a user by period
    public double getTotalIncomeByPeriod(int userId, String period) {
        return getTotal(userId, "Income", period);
    }

    // Get total expense for a user by period
    public double getTotalExpenseByPeriod(int userId, String period) {
        return getTotal(userId, "Expense", period);
    }

    // Get transactions filtered by period
    public List<Transaction> getUserTransactionsByPeriod(int userId, String period) {
        List<Transaction> list = new ArrayList<>();
        String dateFilter = getDateFilter(period);
        String query = "SELECT * FROM transactions WHERE user_id = ?" + dateFilter + " ORDER BY transaction_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapTransaction(rs));
        } catch (SQLException e) {
            System.err.println("Get transactions by period error: " + e.getMessage());
        }
        return list;
    }

    private double getTotal(int userId, String type, String period) {
        String dateFilter = getDateFilter(period);
        String query = "SELECT SUM(amount) FROM transactions WHERE user_id = ? AND type = ?" + dateFilter;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setString(2, type);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            System.err.println("Get total error: " + e.getMessage());
        }
        return 0.0;
    }

    // Returns SQL date filter clause based on period
    private String getDateFilter(String period) {
        if ("month".equals(period)) {
            return " AND MONTH(transaction_date) = MONTH(CURDATE()) AND YEAR(transaction_date) = YEAR(CURDATE())";
        } else if ("week".equals(period)) {
            return " AND transaction_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
        }
        return ""; // all time
    }

    // Get a single transaction by id
    public Transaction getTransactionById(int id) {
        String query = "SELECT * FROM transactions WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapTransaction(rs);
        } catch (SQLException e) {
            System.err.println("Get transaction error: " + e.getMessage());
        }
        return null;
    }

    private Transaction mapTransaction(ResultSet rs) throws SQLException {
        Transaction t = new Transaction();
        t.setId(rs.getInt("id"));
        t.setUserId(rs.getInt("user_id"));
        t.setType(rs.getString("type"));
        t.setAmount(rs.getDouble("amount"));
        t.setCategory(rs.getString("category"));
        t.setDescription(rs.getString("description"));
        t.setTransactionDate(rs.getString("transaction_date"));
        return t;
    }
}
