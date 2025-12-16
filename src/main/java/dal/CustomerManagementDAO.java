package dal;

import model.Customers;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerManagementDAO extends DBContext {

    // Get all customers with pagination
    public List<Customers> getCustomersByPage(int page, int pageSize) {
        List<Customers> customers = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = """
            SELECT * FROM Customers
            WHERE IsActive = 1
            ORDER BY CustomerName
            LIMIT ? OFFSET ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Customers customer = mapCustomer(rs);
                    customers.add(customer);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return customers;
    }

    // Get total customers count
    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) FROM Customers WHERE IsActive = 1";
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

    // Get customer by ID
    public Customers getCustomerById(int customerId) {
        String sql = "SELECT * FROM Customers WHERE CustomerId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCustomer(rs);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // Add new customer
    public int addCustomer(Customers customer) {
        String sql = """
            INSERT INTO Customers (CustomerCode, CustomerName, Address, ContactName, ContactPhone, ContactEmail, IsActive)
            VALUES (?, ?, ?, ?, ?, ?, 1)
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, customer.getCustomerCode());
            ps.setString(2, customer.getCustomerName());
            ps.setString(3, customer.getAddress());
            ps.setString(4, customer.getContactName());
            ps.setString(5, customer.getContactPhone());
            ps.setString(6, customer.getContactEmail());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    // Update customer
    public boolean updateCustomer(Customers customer) {
        String sql = """
            UPDATE Customers 
            SET CustomerCode = ?, CustomerName = ?, Address = ?, ContactName = ?, ContactPhone = ?, ContactEmail = ?
            WHERE CustomerId = ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, customer.getCustomerCode());
            ps.setString(2, customer.getCustomerName());
            ps.setString(3, customer.getAddress());
            ps.setString(4, customer.getContactName());
            ps.setString(5, customer.getContactPhone());
            ps.setString(6, customer.getContactEmail());
      
            ps.setInt(7, customer.getCustomerId());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // Delete customer (soft delete - set IsActive to 0)
    public boolean deleteCustomer(int customerId) {
        String sql = "UPDATE Customers SET IsActive = 0 WHERE CustomerId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // Map ResultSet to Customer object
    private Customers mapCustomer(ResultSet rs) throws SQLException {
        Customers customer = new Customers();
        customer.setCustomerId(rs.getInt("CustomerId"));
        customer.setUserId(rs.getInt("UserId"));
        customer.setCustomerCode(rs.getString("CustomerCode"));
        customer.setCustomerName(rs.getString("CustomerName"));
        customer.setAddress(rs.getString("Address"));
        customer.setContactName(rs.getString("ContactName"));
        customer.setContactPhone(rs.getString("ContactPhone"));
        customer.setContactEmail(rs.getString("ContactEmail"));
        customer.setActive(rs.getBoolean("IsActive"));
        java.sql.Timestamp ts = rs.getTimestamp("CreatedDate");
        customer.setCreatedDate(ts != null ? ts.toLocalDateTime() : null);
        return customer;
    }
}
