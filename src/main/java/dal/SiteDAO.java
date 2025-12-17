package dal;

import model.Site;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SiteDAO extends DBContext {

    // Get all sites with pagination
    public List<Site> getSitesByPage(int page, int pageSize) {
        List<Site> sites = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = """
            SELECT s.*, c.CustomerName
            FROM Sites s
            LEFT JOIN Customers c ON s.CustomerId = c.CustomerId
            WHERE s.IsActive = 1
            ORDER BY s.SiteName
            LIMIT ? OFFSET ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Site site = mapSite(rs);
                    sites.add(site);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return sites;
    }

    // Get total sites count
    public int getTotalSites() {
        String sql = "SELECT COUNT(*) FROM Sites WHERE IsActive = 1";
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

    // Get site by ID
    public Site getSiteById(int siteId) {
        String sql = """
            SELECT s.*, c.CustomerName
            FROM Sites s
            LEFT JOIN Customers c ON s.CustomerId = c.CustomerId
            WHERE s.SiteId = ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, siteId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSite(rs);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // Get all sites by customer
    public List<Site> getSitesByCustomer(int customerId) {
        List<Site> sites = new ArrayList<>();
        String sql = """
            SELECT s.*, c.CustomerName
            FROM Sites s
            LEFT JOIN Customers c ON s.CustomerId = c.CustomerId
            WHERE s.CustomerId = ? AND s.IsActive = 1
            ORDER BY s.SiteName
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Site site = mapSite(rs);
                    sites.add(site);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return sites;
    }

    // Add new site
    public int addSite(Site site) {
        String sql = """
            INSERT INTO Sites (SiteCode, SiteName, Address, CustomerId, IsActive)
            VALUES (?, ?, ?, ?, 1)
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, site.getSiteCode());
            ps.setString(2, site.getSiteName());
            ps.setString(3, site.getAddress());
            if (site.getCustomerId() != null) {
                ps.setInt(4, site.getCustomerId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            
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

    // Update site
    public boolean updateSite(Site site) {
        String sql = """
            UPDATE Sites 
            SET SiteCode = ?, SiteName = ?, Address = ?, CustomerId = ?
            WHERE SiteId = ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, site.getSiteCode());
            ps.setString(2, site.getSiteName());
            ps.setString(3, site.getAddress());
            if (site.getCustomerId() != null) {
                ps.setInt(4, site.getCustomerId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setInt(5, site.getSiteId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Delete site (soft delete)
    public boolean deleteSite(int siteId) {
        String sql = "UPDATE Sites SET IsActive = 0 WHERE SiteId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, siteId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Check if site code exists
    public boolean isSiteCodeExists(String siteCode) {
        String sql = "SELECT COUNT(*) FROM Sites WHERE SiteCode = ? AND IsActive = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, siteCode);
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

    // Check if site code exists for other site
    public boolean isSiteCodeExistsForOtherSite(String siteCode, int siteId) {
        String sql = "SELECT COUNT(*) FROM Sites WHERE SiteCode = ? AND SiteId != ? AND IsActive = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, siteCode);
            ps.setInt(2, siteId);
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

    // Generate site code
    public String generateSiteCode() {
        String sql = "SELECT COUNT(*) + 1 as NextNumber FROM Sites";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int nextNumber = rs.getInt("NextNumber");
                return String.format("SITE%04d", nextNumber);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return "SITE0001";
    }

    private Site mapSite(ResultSet rs) throws SQLException {
        Site site = new Site();
        site.setSiteId(rs.getInt("SiteId"));
        site.setSiteCode(rs.getString("SiteCode"));
        site.setSiteName(rs.getString("SiteName"));
        site.setAddress(rs.getString("Address"));
        site.setCustomerId(rs.getObject("CustomerId", Integer.class));
        site.setActive(rs.getBoolean("IsActive"));
        site.setCustomerName(rs.getString("CustomerName"));
        return site;
    }

    public List<Site> getSitesByPageWithFilter(int page, int pageSize, String status) {
        List<Site> sites = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = """
            SELECT s.*, c.CustomerName
            FROM Sites s
            LEFT JOIN Customers c ON s.CustomerId = c.CustomerId
            WHERE s.IsActive = ?
            ORDER BY s.SiteName
            LIMIT ? OFFSET ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            boolean isActive = "active".equalsIgnoreCase(status);
            ps.setBoolean(1, isActive);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Site site = mapSite(rs);
                    sites.add(site);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return sites;
    }

    public int getTotalSitesWithFilter(String status) {
        String sql = "SELECT COUNT(*) FROM Sites WHERE IsActive = ?";
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

    public List<Site> getSitesByPageWithSearch(int page, int pageSize, String searchName, String searchAddress) {
        List<Site> sites = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = """
            SELECT s.*, c.CustomerName
            FROM Sites s
            LEFT JOIN Customers c ON s.CustomerId = c.CustomerId
            WHERE s.IsActive = 1
            AND (s.SiteName LIKE ? OR s.Address LIKE ?)
            ORDER BY s.SiteName
            LIMIT ? OFFSET ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + (searchName != null ? searchName : "") + "%";
            String addressPattern = "%" + (searchAddress != null ? searchAddress : "") + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, addressPattern);
            ps.setInt(3, pageSize);
            ps.setInt(4, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Site site = mapSite(rs);
                    sites.add(site);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return sites;
    }

    public int getTotalSitesWithSearch(String searchName, String searchAddress) {
        String sql = "SELECT COUNT(*) FROM Sites WHERE IsActive = 1 AND (SiteName LIKE ? OR Address LIKE ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + (searchName != null ? searchName : "") + "%";
            String addressPattern = "%" + (searchAddress != null ? searchAddress : "") + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, addressPattern);
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
}
