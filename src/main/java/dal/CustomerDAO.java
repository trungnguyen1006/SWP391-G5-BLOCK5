/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import model.Customers;

/**
 *
 * @author Administrator
 */
public class CustomerDAO extends DBContext{
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
}
