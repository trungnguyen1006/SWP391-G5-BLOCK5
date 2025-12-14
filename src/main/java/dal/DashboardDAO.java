package dal;

import java.sql.*;
import model.DashboardCustomer;

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
}
