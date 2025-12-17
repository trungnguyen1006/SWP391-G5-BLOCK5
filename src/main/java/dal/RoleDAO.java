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

    public List<Roles> getAllRoles() {
        List<Roles> roles = new ArrayList<>();
        String sql = "SELECT * FROM Roles WHERE IsActive = 1 ORDER BY RoleName";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Roles role = new Roles(
                        rs.getInt("RoleId"),
                        rs.getString("RoleName"),
                        rs.getBoolean("IsActive")
                );
                roles.add(role);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return roles;
    }

    public List<Roles> getAllActiveRoles() {
        List<Roles> roles = new ArrayList<>();
        String sql = "SELECT * FROM Roles ORDER BY RoleName";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Roles role = new Roles(
                        rs.getInt("RoleId"),
                        rs.getString("RoleName"),
                        rs.getBoolean("IsActive")
                );
                roles.add(role);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return roles;
    }

    public int getTotalRoles() {
        String sql = "SELECT COUNT(*) FROM Roles";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    public List<Roles> getRolesByPage(int page, int pageSize) {
        List<Roles> roles = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM Roles ORDER BY RoleName LIMIT ? OFFSET ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
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

    public List<Roles> getRolesByPageWithFilter(int page, int pageSize, String status) {
        List<Roles> roles = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM Roles WHERE IsActive = ? ORDER BY RoleName LIMIT ? OFFSET ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            boolean isActive = "active".equalsIgnoreCase(status);
            ps.setBoolean(1, isActive);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);
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

    public int getTotalRolesWithFilter(String status) {
        String sql = "SELECT COUNT(*) FROM Roles WHERE IsActive = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            boolean isActive = "active".equalsIgnoreCase(status);
            ps.setBoolean(1, isActive);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    public int getUserCountByRole(int roleId) {
        String sql = "SELECT COUNT(*) FROM UserRoles WHERE RoleId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    public boolean assignRolesToUser(int userId, int[] roleIds) {
        String sql = "INSERT INTO UserRoles (UserId, RoleId) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int roleId : roleIds) {
                ps.setInt(1, userId);
                ps.setInt(2, roleId);
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            return results.length > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean removeAllUserRoles(int userId) {
        String sql = "DELETE FROM UserRoles WHERE UserId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            return true;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean updateUserRoles(int userId, int[] roleIds) {
        try {
            removeAllUserRoles(userId);
            if (roleIds != null && roleIds.length > 0) {
                return assignRolesToUser(userId, roleIds);
            }
            return true;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public Roles findRoleById(int roleId) {
        String sql = "SELECT * FROM Roles WHERE RoleId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Roles(
                            rs.getInt("RoleId"),
                            rs.getString("RoleName"),
                            rs.getBoolean("IsActive")
                    );
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public boolean updateRole(Roles role) {
        String sql = "UPDATE Roles SET RoleName = ?, IsActive = ? WHERE RoleId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, role.getRoleName());
            ps.setBoolean(2, role.isActive());
            ps.setInt(3, role.getRoleId());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean isRoleNameExists(String roleName) {
        String sql = "SELECT COUNT(*) FROM Roles WHERE RoleName = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, roleName);
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

    public boolean isRoleNameExistsForOtherRole(String roleName, int roleId) {
        String sql = "SELECT COUNT(*) FROM Roles WHERE RoleName = ? AND RoleId != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, roleName);
            ps.setInt(2, roleId);
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

    public List<model.Users> getUsersByRoleId(int roleId) {
        List<model.Users> users = new ArrayList<>();
        String sql = "SELECT u.* FROM Users u " +
                     "JOIN UserRoles ur ON u.UserId = ur.UserId " +
                     "WHERE ur.RoleId = ? ORDER BY u.FullName";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.Users user = new model.Users();
                    user.setUserId(rs.getInt("UserId"));
                    user.setUsername(rs.getString("Username"));
                    user.setEmail(rs.getString("Email"));
                    user.setFullName(rs.getString("FullName"));
                    user.setActive(rs.getBoolean("IsActive"));
                    java.sql.Timestamp ts = rs.getTimestamp("CreatedDate");
                    user.setCreatedDate(ts != null ? ts.toLocalDateTime() : null);
                    users.add(user);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return users;
    }

    public boolean addRole(Roles role) {
        String sql = "INSERT INTO Roles (RoleName, IsActive) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, role.getRoleName());
            ps.setBoolean(2, role.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

}