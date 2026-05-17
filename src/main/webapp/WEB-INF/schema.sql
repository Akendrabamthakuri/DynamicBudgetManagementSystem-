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
    lock_until TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- categories table removed (categories stored as plain text in related tables)

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

CREATE TABLE IF NOT EXISTS budget_goals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    goal_amount DOUBLE NOT NULL,
    current_amount DOUBLE DEFAULT 0,
    month INT NOT NULL,
    year INT NOT NULL,
    start_date DATE,
    target_date DATE,
    monthly_contribution_target DOUBLE DEFAULT 0,
    priority TINYINT DEFAULT 0,
    status ENUM('active','completed','paused','abandoned') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_goal (user_id, category, month, year)
);

CREATE TABLE IF NOT EXISTS audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    username VARCHAR(50) NOT NULL,
    action VARCHAR(50) NOT NULL,
    details VARCHAR(255),
    ip_address VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    status ENUM('unread', 'read') DEFAULT 'unread',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Default admin account (password: Admin@123)
INSERT INTO users (username, email, password, role) VALUES
('admin', 'admin@budget.com', 'Admin@123', 'admin');

-- Default categories removed (no categories table)

-- Sample transactions
INSERT INTO transactions (user_id, type, amount, category, description, transaction_date) VALUES
(2, 'Income', 40000.00, 'Salary', 'Monthly salary', '2026-04-15'),
(2, 'Expense', 18000.00, 'Shopping', 'shopping', '2026-04-16');

-- Update budget limit for the demo user to 25000
UPDATE users SET budget_limit = 25000.00 WHERE id = 2;
