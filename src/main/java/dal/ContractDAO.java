package dal;

import model.*;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ContractDAO extends DBContext {

    // Get all contracts with pagination
    public List<Contract> getContractsByPage(int page, int pageSize) {
        List<Contract> contracts = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = """
            SELECT c.*, cust.CustomerName, s.SiteName, 
                   u1.FullName as SaleEmployeeName, u2.FullName as ManagerEmployeeName
            FROM Contracts c
            LEFT JOIN Customers cust ON c.CustomerId = cust.CustomerId
            LEFT JOIN Sites s ON c.SiteId = s.SiteId
            LEFT JOIN Employees e1 ON c.SaleEmployeeId = e1.EmployeeId
            LEFT JOIN Users u1 ON e1.UserId = u1.UserId
            LEFT JOIN Employees e2 ON c.ManagerEmployeeId = e2.EmployeeId
            LEFT JOIN Users u2 ON e2.UserId = u2.UserId
            ORDER BY c.CreatedDate DESC
            LIMIT ? OFFSET ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Contract contract = mapContract(rs);
                    contracts.add(contract);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return contracts;
    }

    // Get contracts by sale employee
    public List<Contract> getContractsBySaleEmployee(int saleEmployeeId, int page, int pageSize) {
        List<Contract> contracts = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = """
            SELECT c.*, cust.CustomerName, s.SiteName, 
                   u1.FullName as SaleEmployeeName, u2.FullName as ManagerEmployeeName
            FROM Contracts c
            LEFT JOIN Customers cust ON c.CustomerId = cust.CustomerId
            LEFT JOIN Sites s ON c.SiteId = s.SiteId
            LEFT JOIN Employees e1 ON c.SaleEmployeeId = e1.EmployeeId
            LEFT JOIN Users u1 ON e1.UserId = u1.UserId
            LEFT JOIN Employees e2 ON c.ManagerEmployeeId = e2.EmployeeId
            LEFT JOIN Users u2 ON e2.UserId = u2.UserId
            WHERE c.SaleEmployeeId = ?
            ORDER BY c.CreatedDate DESC
            LIMIT ? OFFSET ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, saleEmployeeId);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Contract contract = mapContract(rs);
                    contracts.add(contract);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return contracts;
    }

    public int getTotalContracts() {
        String sql = "SELECT COUNT(*) FROM Contracts";
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

    public int getTotalContractsBySaleEmployee(int saleEmployeeId) {
        String sql = "SELECT COUNT(*) FROM Contracts WHERE SaleEmployeeId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, saleEmployeeId);
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

    // Get contract by ID with details
    public Contract getContractById(int contractId) {
        String sql = """
            SELECT c.*, cust.CustomerName, cust.Address as CustomerAddress, cust.ContactName, cust.ContactPhone, cust.ContactEmail,
                   s.SiteName, s.Address as SiteAddress,
                   u1.FullName as SaleEmployeeName, u2.FullName as ManagerEmployeeName
            FROM Contracts c
            LEFT JOIN Customers cust ON c.CustomerId = cust.CustomerId
            LEFT JOIN Sites s ON c.SiteId = s.SiteId
            LEFT JOIN Employees e1 ON c.SaleEmployeeId = e1.EmployeeId
            LEFT JOIN Users u1 ON e1.UserId = u1.UserId
            LEFT JOIN Employees e2 ON c.ManagerEmployeeId = e2.EmployeeId
            LEFT JOIN Users u2 ON e2.UserId = u2.UserId
            WHERE c.ContractId = ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Contract contract = mapContract(rs);
                    // Load contract items
                    contract.setContractItems(getContractItems(contractId));
                    return contract;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // Get contract items
    public List<ContractItem> getContractItems(int contractId) {
        List<ContractItem> items = new ArrayList<>();
        String sql = """
            SELECT ci.*, u.SerialNumber, m.ModelName, m.ModelCode, m.Brand, m.Category
            FROM ContractItems ci
            LEFT JOIN MachineUnits u ON ci.UnitId = u.UnitId
            LEFT JOIN MachineModels m ON u.ModelId = m.ModelId
            WHERE ci.ContractId = ?
            ORDER BY ci.ContractItemId
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ContractItem item = new ContractItem();
                    item.setContractItemId(rs.getInt("ContractItemId"));
                    item.setContractId(rs.getInt("ContractId"));
                    item.setUnitId(rs.getInt("UnitId"));
                    
                    Date deliveryDate = rs.getDate("DeliveryDate");
                    item.setDeliveryDate(deliveryDate != null ? deliveryDate.toLocalDate() : null);
                    
                    Date returnDueDate = rs.getDate("ReturnDueDate");
                    item.setReturnDueDate(returnDueDate != null ? returnDueDate.toLocalDate() : null);
                    
                    item.setPrice(rs.getBigDecimal("Price"));
                    item.setDeposit(rs.getBigDecimal("Deposit"));
                    item.setNote(rs.getString("Note"));
                    
                    // Machine info
                    item.setSerialNumber(rs.getString("SerialNumber"));
                    item.setModelName(rs.getString("ModelName"));
                    item.setModelCode(rs.getString("ModelCode"));
                    item.setBrand(rs.getString("Brand"));
                    item.setCategory(rs.getString("Category"));
                    
                    items.add(item);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return items;
    }

    // Add new contract
    public int addContract(Contract contract) {
        String sql = """
            INSERT INTO Contracts (ContractCode, CustomerId, SiteId, SaleEmployeeId, ManagerEmployeeId, 
                                 SignedDate, StartDate, EndDate, Status, Note, CreatedBy, CreatedDate)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, contract.getContractCode());
            ps.setInt(2, contract.getCustomerId());
            if (contract.getSiteId() != null) {
                ps.setInt(3, contract.getSiteId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            if (contract.getSaleEmployeeId() != null) {
                ps.setInt(4, contract.getSaleEmployeeId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            if (contract.getManagerEmployeeId() != null) {
                ps.setInt(5, contract.getManagerEmployeeId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            if (contract.getSignedDate() != null) {
                ps.setDate(6, Date.valueOf(contract.getSignedDate()));
            } else {
                ps.setNull(6, Types.DATE);
            }
            if (contract.getStartDate() != null) {
                ps.setDate(7, Date.valueOf(contract.getStartDate()));
            } else {
                ps.setNull(7, Types.DATE);
            }
            if (contract.getEndDate() != null) {
                ps.setDate(8, Date.valueOf(contract.getEndDate()));
            } else {
                ps.setNull(8, Types.DATE);
            }
            ps.setString(9, contract.getStatus());
            ps.setString(10, contract.getNote());
            ps.setInt(11, contract.getCreatedBy());
            
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

    // Add contract item
    public int addContractItem(ContractItem item) {
        String sql = """
            INSERT INTO ContractItems (ContractId, UnitId, DeliveryDate, ReturnDueDate, Price, Deposit, Note)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, item.getContractId());
            ps.setInt(2, item.getUnitId());
            if (item.getDeliveryDate() != null) {
                ps.setDate(3, Date.valueOf(item.getDeliveryDate()));
            } else {
                ps.setNull(3, Types.DATE);
            }
            if (item.getReturnDueDate() != null) {
                ps.setDate(4, Date.valueOf(item.getReturnDueDate()));
            } else {
                ps.setNull(4, Types.DATE);
            }
            ps.setBigDecimal(5, item.getPrice());
            ps.setBigDecimal(6, item.getDeposit());
            ps.setString(7, item.getNote());
            
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

    // Get customers
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customers WHERE IsActive = 1 ORDER BY CustomerName";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("CustomerId"));
                customer.setCustomerCode(rs.getString("CustomerCode"));
                customer.setCustomerName(rs.getString("CustomerName"));
                customer.setAddress(rs.getString("Address"));
                customer.setContactName(rs.getString("ContactName"));
                customer.setContactPhone(rs.getString("ContactPhone"));
                customer.setContactEmail(rs.getString("ContactEmail"));
                customer.setActive(rs.getBoolean("IsActive"));
                customers.add(customer);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return customers;
    }

    // Get sites by customer
    public List<Site> getSitesByCustomer(int customerId) {
        List<Site> sites = new ArrayList<>();
        String sql = "SELECT * FROM Sites WHERE CustomerId = ? AND IsActive = 1 ORDER BY SiteName";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Site site = new Site();
                    site.setSiteId(rs.getInt("SiteId"));
                    site.setSiteCode(rs.getString("SiteCode"));
                    site.setSiteName(rs.getString("SiteName"));
                    site.setAddress(rs.getString("Address"));
                    site.setCustomerId(rs.getInt("CustomerId"));
                    site.setActive(rs.getBoolean("IsActive"));
                    sites.add(site);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return sites;
    }

    // Generate contract code
    public String generateContractCode() {
        String sql = "SELECT COUNT(*) + 1 as NextNumber FROM Contracts";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int nextNumber = rs.getInt("NextNumber");
                return String.format("CON%04d", nextNumber);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return "CON0001";
    }

    // Check if contract code exists
    public boolean isContractCodeExists(String contractCode) {
        String sql = "SELECT COUNT(*) FROM Contracts WHERE ContractCode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, contractCode);
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

    private Contract mapContract(ResultSet rs) throws SQLException {
        Contract contract = new Contract();
        contract.setContractId(rs.getInt("ContractId"));
        contract.setContractCode(rs.getString("ContractCode"));
        contract.setCustomerId(rs.getInt("CustomerId"));
        contract.setSiteId(rs.getObject("SiteId", Integer.class));
        contract.setSaleEmployeeId(rs.getObject("SaleEmployeeId", Integer.class));
        contract.setManagerEmployeeId(rs.getObject("ManagerEmployeeId", Integer.class));
        
        Date signedDate = rs.getDate("SignedDate");
        contract.setSignedDate(signedDate != null ? signedDate.toLocalDate() : null);
        
        Date startDate = rs.getDate("StartDate");
        contract.setStartDate(startDate != null ? startDate.toLocalDate() : null);
        
        Date endDate = rs.getDate("EndDate");
        contract.setEndDate(endDate != null ? endDate.toLocalDate() : null);
        
        contract.setStatus(rs.getString("Status"));
        contract.setNote(rs.getString("Note"));
        contract.setCreatedBy(rs.getInt("CreatedBy"));
        
        Timestamp createdDate = rs.getTimestamp("CreatedDate");
        contract.setCreatedDate(createdDate != null ? createdDate.toLocalDateTime() : null);
        
        // Additional fields
        contract.setCustomerName(rs.getString("CustomerName"));
        contract.setSiteName(rs.getString("SiteName"));
        contract.setSaleEmployeeName(rs.getString("SaleEmployeeName"));
        contract.setManagerEmployeeName(rs.getString("ManagerEmployeeName"));
        
        return contract;
    }
}