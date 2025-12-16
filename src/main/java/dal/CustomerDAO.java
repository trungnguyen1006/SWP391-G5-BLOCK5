package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Customers;

public class CustomerDAO extends DBContext {
    
    public Customers getCustomerByUserId(int userId) {
        String sql = "SELECT * FROM customers WHERE UserId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customers c = new Customers();
                    c.setCustomerId(rs.getInt("CustomerId"));
                    c.setUserId(rs.getInt("UserId"));
                    c.setCustomerCode(rs.getString("CustomerCode"));
                    c.setCustomerName(rs.getString("CustomerName"));
                    c.setAddress(rs.getString("Address"));
                    c.setContactName(rs.getString("ContactName"));
                    c.setContactPhone(rs.getString("ContactPhone"));
                    c.setContactEmail(rs.getString("ContactEmail"));
                    c.setActive(rs.getBoolean("IsActive"));

                    Timestamp ts = rs.getTimestamp("CreatedDate");
                    c.setCreatedDate(ts != null ? ts.toLocalDateTime() : null);

                    return c;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Get all active customers
    public List<Customers> getAllCustomers() {
        List<Customers> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customers WHERE IsActive = 1 ORDER BY CustomerName";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Customers c = mapCustomer(rs);
                customers.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    private Customers mapCustomer(ResultSet rs) throws SQLException {
        Customers c = new Customers();
        c.setCustomerId(rs.getInt("CustomerId"));
        c.setUserId(rs.getObject("UserId", Integer.class));
        c.setCustomerCode(rs.getString("CustomerCode"));
        c.setCustomerName(rs.getString("CustomerName"));
        c.setAddress(rs.getString("Address"));
        c.setContactName(rs.getString("ContactName"));
        c.setContactPhone(rs.getString("ContactPhone"));
        c.setContactEmail(rs.getString("ContactEmail"));
        c.setActive(rs.getBoolean("IsActive"));
        Timestamp ts = rs.getTimestamp("CreatedDate");
        c.setCreatedDate(ts != null ? ts.toLocalDateTime() : null);
        return c;
    }
}
