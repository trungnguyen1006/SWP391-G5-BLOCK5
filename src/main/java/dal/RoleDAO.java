package dal;

import model.Roles;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO extends DBContext {

    public List<Roles> getRolesByUserId(int userId) {
        List<Roles> roles = new ArrayList<>();
        String sql = "SELECT r.* FROM Roles r JOIN UserRoles ur ON r.RoleId = ur.RoleId WHERE ur.UserId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Roles role = new Roles(
                            rs.getInt("RoleId"),
                            rs.getString("RoleName"),
                            rs.getBoolean("IsActive")
                    );
                    roles.add(role);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return roles;
    }

    public boolean assignDefaultRole(int userId, int defaultRoleId) {
        String sql = "INSERT INTO UserRoles (UserId, RoleId) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, defaultRoleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

}