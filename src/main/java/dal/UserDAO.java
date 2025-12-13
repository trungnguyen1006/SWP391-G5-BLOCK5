package dal;

import model.Users;
import java.sql.*;
import model.Dashboard;

public class UserDAO extends DBContext {

    public Users findUserByUsername(String username) {
    String sql = "SELECT * FROM Users WHERE Username = ?";

    try (
        PreparedStatement ps = connection.prepareStatement(sql)
    ) {
        ps.setString(1, username);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Users user = new Users();
                user.setUserId(rs.getInt("UserId"));
                user.setUsername(rs.getString("Username"));
                user.setPassword(rs.getString("Password"));
                user.setEmail(rs.getString("Email"));
                user.setFullName(rs.getString("FullName"));
                user.setActive(rs.getBoolean("IsActive"));
                Timestamp ts = rs.getTimestamp("CreatedDate");
                user.setCreatedDate(ts != null ? ts.toLocalDateTime() : null);
                user.setPhone(rs.getString("Phone"));
                user.setImage(rs.getString("Image"));
                return user;
            }
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
    }
    return null;
}


    public int createNewUser(Users user, String hashedPassword) {
        String sql = "INSERT INTO Users (Username, Password, Email, FullName, Phone, Image, IsActive, CreatedDate) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
        int newUserId = 0;
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, hashedPassword);
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getImage());
            ps.setBoolean(7, user.isActive());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        newUserId = generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return newUserId;
    }

    public boolean isUserExists(String username, String email) {
        String sql = "SELECT COUNT(*) FROM Users WHERE Username = ? OR Email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public void saveResetToken(String email, String token) throws SQLException {
        String sql = "UPDATE users SET Password = ? WHERE Email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setString(2, email);

            int updated = ps.executeUpdate();
            if (updated == 0) {
                throw new SQLException("không tìm thấy user có email là:  " + email);
            }
        } catch (SQLException e) {
            throw new SQLException("lỗi " + e.getMessage());
        }
    }

    public java.util.List<Users> getAllUsers() {
        java.util.List<Users> users = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY CreatedDate DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Users user = new Users();
                user.setUserId(rs.getInt("UserId"));
                user.setUsername(rs.getString("Username"));
                user.setPassword(rs.getString("Password"));
                user.setEmail(rs.getString("Email"));
                user.setFullName(rs.getString("FullName"));
                user.setActive(rs.getBoolean("IsActive"));
                Timestamp ts = rs.getTimestamp("CreatedDate");
                user.setCreatedDate(ts != null ? ts.toLocalDateTime() : null);
                user.setPhone(rs.getString("Phone"));
                user.setImage(rs.getString("Image"));
                users.add(user);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return users;
    }

    public java.util.List<Users> getUsersByPage(int page, int pageSize) {
        java.util.List<Users> users = new java.util.ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM Users ORDER BY CreatedDate DESC LIMIT ? OFFSET ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Users user = new Users();
                    user.setUserId(rs.getInt("UserId"));
                    user.setUsername(rs.getString("Username"));
                    user.setPassword(rs.getString("Password"));
                    user.setEmail(rs.getString("Email"));
                    user.setFullName(rs.getString("FullName"));
                    user.setActive(rs.getBoolean("IsActive"));
                    Timestamp ts = rs.getTimestamp("CreatedDate");
                    user.setCreatedDate(ts != null ? ts.toLocalDateTime() : null);
                    user.setPhone(rs.getString("Phone"));
                    user.setImage(rs.getString("Image"));
                    users.add(user);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return users;
    }

    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    public Users findUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE UserId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Users user = new Users();
                    user.setUserId(rs.getInt("UserId"));
                    user.setUsername(rs.getString("Username"));
                    user.setPassword(rs.getString("Password"));
                    user.setEmail(rs.getString("Email"));
                    user.setFullName(rs.getString("FullName"));
                    user.setActive(rs.getBoolean("IsActive"));
                    Timestamp ts = rs.getTimestamp("CreatedDate");
                    user.setCreatedDate(ts != null ? ts.toLocalDateTime() : null);
                    user.setPhone(rs.getString("Phone"));
                    user.setImage(rs.getString("Image"));
                    return user;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public boolean changePassword(int id, String newPassword) {
        String query = "Update Users set Password = ? where UserId = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, newPassword);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi " + e);
        }
        return false;
    }

    public boolean updateUser(Users user) {
        String sql = "UPDATE Users SET FullName = ?, Email = ?, Phone = ?, Image = ?, IsActive = ? WHERE UserId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getImage());
            ps.setBoolean(5, user.isActive());
            ps.setInt(6, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean updateUserPassword(int userId, String hashedPassword) {
        String sql = "UPDATE Users SET Password = ? WHERE UserId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean isEmailExistsForOtherUser(String email, int userId) {
        String sql = "SELECT COUNT(*) FROM Users WHERE Email = ? AND UserId != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public Users getUserByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE Email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Users user = new Users();
                    user.setUserId(rs.getInt("UserId"));
                    user.setUsername(rs.getString("Username"));
                    user.setPassword(rs.getString("Password"));
                    user.setEmail(rs.getString("Email"));
                    user.setFullName(rs.getString("FullName"));
                    user.setActive(rs.getBoolean("IsActive"));
                    Timestamp ts = rs.getTimestamp("CreatedDate");
                    user.setCreatedDate(ts != null ? ts.toLocalDateTime() : null);
                    user.setPhone(rs.getString("Phone"));
                    user.setImage(rs.getString("Image"));
                    return user;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

public Dashboard getDashboardAdmin() {
    Dashboard dashboard = new Dashboard();

    String sql = """
         SELECT
                (SELECT COUNT(*) FROM users) AS totalUser,
                (
                    SELECT COUNT(DISTINCT ur.UserId)
                    FROM userroles ur
                    JOIN roles r ON ur.RoleId = r.RoleId
                    WHERE LOWER(r.RoleName) IN ('admin','manager','staff')
                ) AS totalEmployee,
                (SELECT COUNT(*) FROM users WHERE IsActive = 1) AS totalActive,
                (SELECT COUNT(*) FROM users WHERE IsActive = 0) AS totalDeActive
        """;

    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            dashboard.setTotalUser(rs.getInt("totalUser"));
            dashboard.setTotalEmployee(rs.getInt("totalEmployee"));
            dashboard.setTotalActive(rs.getInt("totalActive"));
            dashboard.setTotalDeActive(rs.getInt("totalDeActive"));
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return dashboard;
}

   

}
