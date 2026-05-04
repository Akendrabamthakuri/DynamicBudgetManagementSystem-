package com.budgetmanagement.util;

/**
 * ValidationUtil provides reusable input validation methods across the application.
 */
public class ValidationUtil {

    // Validates that a string is not null or empty
    public static boolean isNullOrEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    // Validates email format
    public static boolean isValidEmail(String email) {
        return email != null && email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");
    }

    // Validates password: min 6 chars, at least one letter and one number
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6
                && password.matches(".*[a-zA-Z].*")
                && password.matches(".*[0-9].*");
    }

    // Validates that a name contains only letters and spaces
    public static boolean isValidName(String name) {
        return name != null && name.matches("^[a-zA-Z ]+$");
    }

    // Validates that amount is a positive number
    public static boolean isValidAmount(String amount) {
        try {
            return Double.parseDouble(amount) > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
