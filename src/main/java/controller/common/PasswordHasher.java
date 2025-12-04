package controller.common;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordHasher {
    private static final int COST_FACTOR = 12;

    public static String hashPassword(String password) {
        String salt = BCrypt.gensalt(COST_FACTOR);
        return BCrypt.hashpw(password, salt);
    }

    public static boolean checkPassword(String candidatePassword, String hashedPassword) {
        if (hashedPassword == null || hashedPassword.isEmpty()) {
            return false;
        }

        try {
            if (hashedPassword.startsWith("$2a$") || hashedPassword.startsWith("$2b$") || hashedPassword.startsWith("$2y$")) {
                return BCrypt.checkpw(candidatePassword, hashedPassword);
            } else {
                return candidatePassword.equals(hashedPassword);
            }
        } catch (IllegalArgumentException e) {
            return candidatePassword.equals(hashedPassword);
        }
    }
}
