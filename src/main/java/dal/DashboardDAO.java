package dal;

import java.sql.*;
import model.DashboardCustomer;
import model.DashboardSale;
import model.DashboardStaff;

public class DashboardDAO extends DBContext {

    public DashboardCustomer getDashboardCustomer(int customerId) {
        DashboardCustomer dashboard = new DashboardCustomer();

        String sql = """
            SELECT
                -- Tổng hợp đồng đã ký
                (
                    SELECT COUNT(*)
                    FROM contracts
                    WHERE CustomerId = ?
                      AND SignedDate IS NOT NULL
                ) AS totalContractsSigned,

                -- Tổng ticket đã gửi
                (
                    SELECT COUNT(*)
                    FROM supportrequests
                    WHERE CustomerId = ?
                ) AS totalTickets,

                -- Ticket được chấp thuận
                (
                    SELECT COUNT(*)
                    FROM supportrequests
                    WHERE CustomerId = ?
                      AND Status = 'APPROVED'
                ) AS totalApprovedTickets,

                -- Ticket bị reject
                (
                    SELECT COUNT(*)
                    FROM supportrequests
                    WHERE CustomerId = ?
                      AND Status = 'REJECTED'
                ) AS totalRejectedTickets
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            // set customerId cho từng sub query
            ps.setInt(1, customerId);
            ps.setInt(2, customerId);
            ps.setInt(3, customerId);
            ps.setInt(4, customerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dashboard.setTotalContractsSigned(
                            rs.getInt("totalContractsSigned"));
                    dashboard.setTotalTickets(
                            rs.getInt("totalTickets"));
                    dashboard.setTotalApprovedTickets(
                            rs.getInt("totalApprovedTickets"));
                    dashboard.setTotalRejectedTickets(
                            rs.getInt("totalRejectedTickets"));
                }
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

    public DashboardSale getDashboardSale(int saleEmployeeId) {
        DashboardSale dashboard = new DashboardSale();
        String sql = """
        SELECT
            (
                SELECT COUNT(*)
                FROM contracts
                WHERE SaleEmployeeId = ?
                  AND SignedDate IS NOT NULL
            ) AS totalContractsSigned,
            (
                SELECT COUNT(DISTINCT CustomerId)
                FROM contracts
                WHERE SaleEmployeeId = ?
                  AND SignedDate IS NOT NULL
            ) AS totalCustomers,
            (
                SELECT COALESCE(SUM(Price), 0)
                FROM contracts
                WHERE SaleEmployeeId = ?
                  AND SignedDate IS NOT NULL
            ) AS totalRevenue,
            (
                SELECT COUNT(*)
                FROM supportrequests sr
                JOIN contracts c ON sr.ContractId = c.ContractId
                WHERE c.SaleEmployeeId = ?
            ) AS totalTickets
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, saleEmployeeId);
            ps.setInt(2, saleEmployeeId);
            ps.setInt(3, saleEmployeeId);
            ps.setInt(4, saleEmployeeId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dashboard.setTotalContractsSigned(
                            rs.getInt("totalContractsSigned"));
                    dashboard.setTotalCustomers(
                            rs.getInt("totalCustomers"));
                    dashboard.setTotalRevenue(
                            rs.getDouble("totalRevenue"));
                    dashboard.setTotalTickets(
                            rs.getInt("totalTickets"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return dashboard;
    }

}
