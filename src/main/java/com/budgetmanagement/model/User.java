package com.budgetmanagement.model;

/**
 * User model representing a system user.
 */
public class User {
    private int id;
    private String username;
    private String email;
    private String password;
    private String role;
    private double budgetLimit;

    public User() {}

    public User(String username, String email, String password, String role, double budgetLimit) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.role = role;
        this.budgetLimit = budgetLimit;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public double getBudgetLimit() { return budgetLimit; }
    public void setBudgetLimit(double budgetLimit) { this.budgetLimit = budgetLimit; }
}
