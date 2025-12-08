package util;

import java.util.regex.Pattern;

public class Validator {
    
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );
    
    private static final Pattern PHONE_PATTERN = Pattern.compile(
        "^(\\+84|0)[0-9]{9,10}$"
    );
    
    private static final Pattern USERNAME_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9_]{3,20}$"
    );
    
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }
    
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return true; // Phone is optional
        }
        String cleanPhone = phone.trim().replaceAll("\\s+", "");
        return PHONE_PATTERN.matcher(cleanPhone).matches();
    }
    
    public static boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        return USERNAME_PATTERN.matcher(username.trim()).matches();
    }
    
    public static boolean isValidPassword(String password) {
        if (password == null || password.isEmpty()) {
            return false;
        }
        return password.length() >= 6;
    }
    
    public static boolean isValidFullName(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) {
            return false;
        }
        return fullName.trim().length() >= 2 && fullName.trim().length() <= 100;
    }
    
    public static String getEmailErrorMessage() {
        return "Invalid email format. Example: user@example.com";
    }
    
    public static String getPhoneErrorMessage() {
        return "Invalid phone number. Must be 10-11 digits starting with 0 or +84";
    }
    
    public static String getUsernameErrorMessage() {
        return "Username must be 3-20 characters, only letters, numbers and underscore";
    }
    
    public static String getPasswordErrorMessage() {
        return "Password must be at least 6 characters long";
    }
    
    public static String getFullNameErrorMessage() {
        return "Full name must be 2-100 characters";
    }
}
