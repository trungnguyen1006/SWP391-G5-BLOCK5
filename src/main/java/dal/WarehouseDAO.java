package dal;

import model.Warehouse;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WarehouseDAO extends DBContext {

    // Get all warehouses with pagination
    public List<Warehouse> getWarehousesByPage(int page, int pageSize) {
        List<Warehouse> warehouses = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = """
            SELECT * FROM Warehouses
            WHERE IsActive = 1
            ORDER BY WarehouseName
            LIMIT ? OFFSET ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Warehouse warehouse = mapWarehouse(rs);
                    warehouses.add(warehouse);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return warehouses;
    }

    // Get total warehouses count
    public int getTotalWarehouses() {
        String sql = "SELECT COUNT(*) FROM Warehouses WHERE IsActive = 1";
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

    // Get warehouse by ID
    public Warehouse getWarehouseById(int warehouseId) {
        String sql = "SELECT * FROM Warehouses WHERE WarehouseId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapWarehouse(rs);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // Add new warehouse
    public int addWarehouse(Warehouse warehouse) {
        String sql = """
            INSERT INTO Warehouses (WarehouseCode, WarehouseName, Address, IsActive)
            VALUES (?, ?, ?, 1)
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, warehouse.getWarehouseCode());
            ps.setString(2, warehouse.getWarehouseName());
            ps.setString(3, warehouse.getAddress());
            
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

    // Update warehouse
    public boolean updateWarehouse(Warehouse warehouse) {
        String sql = """
            UPDATE Warehouses 
            SET WarehouseCode = ?, WarehouseName = ?, Address = ?
            WHERE WarehouseId = ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, warehouse.getWarehouseCode());
            ps.setString(2, warehouse.getWarehouseName());
            ps.setString(3, warehouse.getAddress());
            ps.setInt(4, warehouse.getWarehouseId());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // Delete warehouse (soft delete - set IsActive to 0)
    public boolean deleteWarehouse(int warehouseId) {
        String sql = "UPDATE Warehouses SET IsActive = 0 WHERE WarehouseId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // Map ResultSet to Warehouse object
    private Warehouse mapWarehouse(ResultSet rs) throws SQLException {
        Warehouse warehouse = new Warehouse();
        warehouse.setWarehouseId(rs.getInt("WarehouseId"));
        warehouse.setWarehouseCode(rs.getString("WarehouseCode"));
        warehouse.setWarehouseName(rs.getString("WarehouseName"));
        warehouse.setAddress(rs.getString("Address"));
        warehouse.setActive(rs.getBoolean("IsActive"));
        return warehouse;
    }
}

    public List<Warehouse> getWarehousesByPageWithFilter(int page, int pageSize, String status) {
        List<Warehouse> warehouses = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = """
            SELECT * FROM Warehouses
            WHERE IsActive = ?
            ORDER BY WarehouseName
            LIMIT ? OFFSET ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            boolean isActive = "active".equalsIgnoreCase(status);
            ps.setBoolean(1, isActive);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Warehouse warehouse = new Warehouse();
                    warehouse.setWarehouseId(rs.getInt("WarehouseId"));
                    warehouse.setWarehouseCode(rs.getString("WarehouseCode"));
                    warehouse.setWarehouseName(rs.getString("WarehouseName"));
                    warehouse.setAddress(rs.getString("Address"));
                    warehouse.setActive(rs.getBoolean("IsActive"));
                    warehouses.add(warehouse);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return warehouses;
    }

    public int getTotalWarehousesWithFilter(String status) {
        String sql = "SELECT COUNT(*) FROM Warehouses WHERE IsActive = ?";
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
