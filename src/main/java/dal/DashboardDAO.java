package dal;

import java.sql.*;
import model.Dashboard;
import model.DashboardCustomer;
import model.DashboardSale;
import model.DashboardStaff;

public class DashboardDAO extends DBContext {

    public Dashboard getDashboardCustomer(int customerId) {
        Dashboard dashboard = new Dashboard();

        String sql = """
        SELECT
            (
                SELECT COUNT(*)
                FROM contracts c
                JOIN customers cu ON cu.CustomerId = c.CustomerId
                WHERE cu.CustomerId = ?
            ) AS totalContract,

            (
                SELECT COUNT(*)
                FROM sites s
                JOIN customers cu ON cu.CustomerId = s.CustomerId
                WHERE cu.CustomerId = ?
            ) AS totalSite,

            (
                SELECT COUNT(*)
                FROM maintenancerequests m
                JOIN customers cu ON cu.CustomerId = m.CustomerId
                WHERE cu.CustomerId = ?
            ) AS totalRequest
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, customerId);
            ps.setInt(3, customerId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                dashboard.setTotalContract(rs.getInt("totalContract"));
                dashboard.setTotalSite(rs.getInt("totalSite"));
                dashboard.setTotalRequest(rs.getInt("totalRequest"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return dashboard;
    }

    public DashboardStaff getDashboardStaff(int employeeId) {
        DashboardStaff dashboard = new DashboardStaff();

        String sql = """
        SELECT
            (
                SELECT COUNT(*)
                FROM supportrequests
            ) AS totalTickets,
            (
                SELECT COUNT(*)
                FROM supportrequests
                WHERE Status = 'APPROVED'
            ) AS approvedTickets,
            (
                SELECT COUNT(*)
                FROM supportrequests
                WHERE Status = 'REJECTED'
            ) AS rejectedTickets,
            (
                SELECT COUNT(*)
                FROM supportrequests
                WHERE AssignedToEmployeeId = ?
            ) AS assignedTickets
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, employeeId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dashboard.setTotalTickets(
                            rs.getInt("totalTickets"));
                    dashboard.setApprovedTickets(
                            rs.getInt("approvedTickets"));
                    dashboard.setRejectedTickets(
                            rs.getInt("rejectedTickets"));
                    dashboard.setAssignedTickets(
                            rs.getInt("assignedTickets"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return dashboard;
    }

    public Dashboard getDashboardEmployee() {
        Dashboard dashboard = new Dashboard();

        String sql = """
        SELECT
                    COUNT(*) AS totalContract,
                    COUNT(SignedDate) AS totalContractActive,
                    COUNT(*) - COUNT(SignedDate) AS totalContractPending
                FROM cms.contracts
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                dashboard.setTotalContract(rs.getInt("totalContract"));
                dashboard.setTotalContractActive(rs.getInt("totalContractActive"));
                dashboard.setTotalContractPending(rs.getInt("totalContractPending"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return dashboard;
    }

    public Dashboard getDashboardAdmin() {
        Dashboard dashboard = new Dashboard();

        String sql = """
        SELECT
            (SELECT COUNT(*) 
            FROM users u
            JOIN userroles ur ON u.UserId = ur.UserId
            join roles r on r.RoleId = ur.RoleId
            WHERE r.RoleName = 'EMPLOYEE') AS totalEmployee,
            (SELECT COUNT(*) 
            FROM users u
            JOIN userroles ur ON u.UserId = ur.UserId
            join roles r on r.RoleId = ur.RoleId
            WHERE r.RoleName = 'MANAGER') AS totalManager,
            (SELECT COUNT(*) 
            FROM users u
            JOIN userroles ur ON u.UserId = ur.UserId
            join roles r on r.RoleId = ur.RoleId
            WHERE r.RoleName = 'CUSTOMER') AS totalCustomer,                          
            (SELECT COUNT(*) FROM contracts) AS totalContract
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                dashboard.setTotalEmployee(rs.getInt("totalEmployee"));
                dashboard.setTotalManager(rs.getInt("totalManager"));
                dashboard.setTotalCustomer(rs.getInt("totalCustomer"));
                dashboard.setTotalContract(rs.getInt("totalContract"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return dashboard;
    }

}
