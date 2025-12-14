package dal;

import model.MachineModel;
import model.MachineUnit;
import model.Warehouse;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MachineDAO extends DBContext {

    // Machine Models
    public List<MachineModel> getAllMachineModels() {
        List<MachineModel> models = new ArrayList<>();
        String sql = "SELECT * FROM MachineModels WHERE IsActive = 1 ORDER BY ModelName";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MachineModel model = new MachineModel();
                model.setModelId(rs.getInt("ModelId"));
                model.setModelCode(rs.getString("ModelCode"));
                model.setModelName(rs.getString("ModelName"));
                model.setBrand(rs.getString("Brand"));
                model.setCategory(rs.getString("Category"));
                model.setSpecs(rs.getString("Specs"));
                model.setActive(rs.getBoolean("IsActive"));
                Timestamp ts = rs.getTimestamp("CreatedDate");
                model.setCreatedDate(ts != null ? ts.toLocalDateTime() : null);
                models.add(model);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return models;
    }

    public MachineModel getMachineModelById(int modelId) {
        String sql = "SELECT * FROM MachineModels WHERE ModelId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, modelId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MachineModel model = new MachineModel();
                    model.setModelId(rs.getInt("ModelId"));
                    model.setModelCode(rs.getString("ModelCode"));
                    model.setModelName(rs.getString("ModelName"));
                    model.setBrand(rs.getString("Brand"));
                    model.setCategory(rs.getString("Category"));
                    model.setSpecs(rs.getString("Specs"));
                    model.setActive(rs.getBoolean("IsActive"));
                    Timestamp ts = rs.getTimestamp("CreatedDate");
                    model.setCreatedDate(ts != null ? ts.toLocalDateTime() : null);
                    return model;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // Machine Units
    public List<MachineUnit> getAllMachineUnits() {
        List<MachineUnit> units = new ArrayList<>();
        String sql = """
            SELECT u.*, m.ModelCode, m.ModelName, m.Brand, m.Category, m.Specs,
                   w.WarehouseName, s.SiteName
            FROM MachineUnits u
            LEFT JOIN MachineModels m ON u.ModelId = m.ModelId
            LEFT JOIN Warehouses w ON u.CurrentWarehouseId = w.WarehouseId
            LEFT JOIN Sites s ON u.CurrentSiteId = s.SiteId
            WHERE u.IsActive = 1
            ORDER BY m.ModelName, u.SerialNumber
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MachineUnit unit = mapMachineUnit(rs);
                units.add(unit);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return units;
    }

    public List<MachineUnit> getMachineUnitsByPage(int page, int pageSize) {
        List<MachineUnit> units = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = """
            SELECT u.*, m.ModelCode, m.ModelName, m.Brand, m.Category, m.Specs,
                   w.WarehouseName, s.SiteName
            FROM MachineUnits u
            LEFT JOIN MachineModels m ON u.ModelId = m.ModelId
            LEFT JOIN Warehouses w ON u.CurrentWarehouseId = w.WarehouseId
            LEFT JOIN Sites s ON u.CurrentSiteId = s.SiteId
            WHERE u.IsActive = 1
            ORDER BY m.ModelName, u.SerialNumber
            LIMIT ? OFFSET ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MachineUnit unit = mapMachineUnit(rs);
                    units.add(unit);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return units;
    }

    public int getTotalMachineUnits() {
        String sql = "SELECT COUNT(*) FROM MachineUnits WHERE IsActive = 1";
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

    public Map<String, Integer> getMachineCountByStatus() {
        Map<String, Integer> statusCount = new HashMap<>();
        String sql = "SELECT CurrentStatus, COUNT(*) as Count FROM MachineUnits WHERE IsActive = 1 GROUP BY CurrentStatus";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                statusCount.put(rs.getString("CurrentStatus"), rs.getInt("Count"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return statusCount;
    }

    public Map<String, Integer> getMachineCountByModel() {
        Map<String, Integer> modelCount = new HashMap<>();
        String sql = """
            SELECT m.ModelName, COUNT(u.UnitId) as Count
            FROM MachineModels m
            LEFT JOIN MachineUnits u ON m.ModelId = u.ModelId AND u.IsActive = 1
            WHERE m.IsActive = 1
            GROUP BY m.ModelId, m.ModelName
            ORDER BY m.ModelName
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                modelCount.put(rs.getString("ModelName"), rs.getInt("Count"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return modelCount;
    }

    // Warehouses
    public List<Warehouse> getAllWarehouses() {
        List<Warehouse> warehouses = new ArrayList<>();
        String sql = "SELECT * FROM Warehouses WHERE IsActive = 1 ORDER BY WarehouseName";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Warehouse warehouse = new Warehouse();
                warehouse.setWarehouseId(rs.getInt("WarehouseId"));
                warehouse.setWarehouseCode(rs.getString("WarehouseCode"));
                warehouse.setWarehouseName(rs.getString("WarehouseName"));
                warehouse.setAddress(rs.getString("Address"));
                warehouse.setActive(rs.getBoolean("IsActive"));
                warehouses.add(warehouse);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return warehouses;
    }

    // Add Machine Model
    public int addMachineModel(MachineModel model) {
        String sql = "INSERT INTO MachineModels (ModelCode, ModelName, Brand, Category, Specs, IsActive, CreatedDate) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, model.getModelCode());
            ps.setString(2, model.getModelName());
            ps.setString(3, model.getBrand());
            ps.setString(4, model.getCategory());
            ps.setString(5, model.getSpecs());
            ps.setBoolean(6, model.isActive());
            
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

    // Add Machine Unit
    public int addMachineUnit(MachineUnit unit) {
        String sql = "INSERT INTO MachineUnits (ModelId, SerialNumber, CurrentStatus, CurrentWarehouseId, CurrentSiteId, IsActive, CreatedDate) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, unit.getModelId());
            ps.setString(2, unit.getSerialNumber());
            ps.setString(3, unit.getCurrentStatus());
            if (unit.getCurrentWarehouseId() != null) {
                ps.setInt(4, unit.getCurrentWarehouseId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            if (unit.getCurrentSiteId() != null) {
                ps.setInt(5, unit.getCurrentSiteId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setBoolean(6, unit.isActive());
            
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

    public boolean isSerialNumberExists(String serialNumber) {
        String sql = "SELECT COUNT(*) FROM MachineUnits WHERE SerialNumber = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
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

    public boolean isSerialNumberExistsForOtherUnit(String serialNumber, int unitId) {
        String sql = "SELECT COUNT(*) FROM MachineUnits WHERE SerialNumber = ? AND UnitId != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, serialNumber);
            ps.setInt(2, unitId);
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

    public MachineUnit getMachineUnitById(int unitId) {
        String sql = """
            SELECT u.*, m.ModelCode, m.ModelName, m.Brand, m.Category, m.Specs,
                   w.WarehouseName, s.SiteName
            FROM MachineUnits u
            LEFT JOIN MachineModels m ON u.ModelId = m.ModelId
            LEFT JOIN Warehouses w ON u.CurrentWarehouseId = w.WarehouseId
            LEFT JOIN Sites s ON u.CurrentSiteId = s.SiteId
            WHERE u.UnitId = ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, unitId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapMachineUnit(rs);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public boolean updateMachineUnit(MachineUnit unit) {
        String sql = "UPDATE MachineUnits SET ModelId = ?, SerialNumber = ?, CurrentStatus = ?, CurrentWarehouseId = ?, CurrentSiteId = ? WHERE UnitId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, unit.getModelId());
            ps.setString(2, unit.getSerialNumber());
            ps.setString(3, unit.getCurrentStatus());
            if (unit.getCurrentWarehouseId() != null) {
                ps.setInt(4, unit.getCurrentWarehouseId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            if (unit.getCurrentSiteId() != null) {
                ps.setInt(5, unit.getCurrentSiteId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setInt(6, unit.getUnitId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }



    private MachineUnit mapMachineUnit(ResultSet rs) throws SQLException {
        MachineUnit unit = new MachineUnit();
        unit.setUnitId(rs.getInt("UnitId"));
        unit.setModelId(rs.getInt("ModelId"));
        unit.setSerialNumber(rs.getString("SerialNumber"));
        unit.setCurrentStatus(rs.getString("CurrentStatus"));
        unit.setCurrentWarehouseId(rs.getObject("CurrentWarehouseId", Integer.class));
        unit.setCurrentSiteId(rs.getObject("CurrentSiteId", Integer.class));
        unit.setActive(rs.getBoolean("IsActive"));
        Timestamp ts = rs.getTimestamp("CreatedDate");
        unit.setCreatedDate(ts != null ? ts.toLocalDateTime() : null);
        
        // Set model info
        MachineModel model = new MachineModel();
        model.setModelId(rs.getInt("ModelId"));
        model.setModelCode(rs.getString("ModelCode"));
        model.setModelName(rs.getString("ModelName"));
        model.setBrand(rs.getString("Brand"));
        model.setCategory(rs.getString("Category"));
        model.setSpecs(rs.getString("Specs"));
        unit.setMachineModel(model);
        
        unit.setWarehouseName(rs.getString("WarehouseName"));
        unit.setSiteName(rs.getString("SiteName"));
        
        return unit;
    }
}