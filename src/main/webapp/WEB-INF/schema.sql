-- Budget Management System Database Schema
CREATE DATABASE IF NOT EXISTS budget_management;
USE budget_management;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user') DEFAULT 'user',
    budget_limit DOUBLE DEFAULT 50000.0,
    failed_attempts INT DEFAULT 0,
    is_locked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type ENUM('Income', 'Expense') NOT NULL,
    amount DOUBLE NOT NULL,
    category VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Default admin account (password: Admin@123)
INSERT INTO users (username, email, password, role) VALUES
('admin', 'admin@budget.com', 'Admin@123', 'admin');

-- Sample transactions to match dashboard demo values
-- Replace user_id with the actual user id after registration
INSERT INTO transactions (user_id, type, amount, category, description, transaction_date) VALUES
(2, 'Income', 40000.00, 'Salary', 'Monthly salary', '2026-04-15'),
(2, 'Expense', 18000.00, 'Other', 'shopping', '2026-04-16');

-- Update budget limit for the demo user to 25000
UPDATE users SET budget_limit = 25000.00 WHERE id = 2;
