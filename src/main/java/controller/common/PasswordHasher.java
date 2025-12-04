package controller.common;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordHasher {
    // Cost factor: Xác định độ khó và thời gian băm. 12 là mức tốt.
    // Việc tăng số này lên 1 đơn vị sẽ làm tăng thời gian băm lên gấp đôi.
    private static final int COST_FACTOR = 12;

    public static String hashPassword(String password) {
        String salt = BCrypt.gensalt(COST_FACTOR);
        return BCrypt.hashpw(password, salt);
    }

    public static boolean checkPassword(String candidatePassword, String hashedPassword) {
        return BCrypt.checkpw(candidatePassword, hashedPassword);
    }
}
