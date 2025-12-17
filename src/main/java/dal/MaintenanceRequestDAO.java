/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author Administrator
 */
import model.*;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class MaintenanceRequestDAO extends DBContext {

    // 1. Customer gửi đơn
    public void createRequest(MaintenanceRequest r) {
        String sql = """
            INSERT INTO maintenancerequests
            (RequestCode, RequestType, CustomerId, ContractId, UnitId,
             Title, Description, Status, CreatedBy)
            VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING', ?)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, r.getRequestCode());
            ps.setString(2, r.getRequestType());
            ps.setInt(3, r.getCustomerId());
            ps.setObject(4, r.getContractId());
            ps.setInt(5, r.getUnitId());
            ps.setString(6, r.getTitle());
            ps.setString(7, r.getDescription());
            ps.setInt(8, r.getCreatedBy());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Manager duyệt / từ chối (CHỈ áp dụng cho PENDING)
    public void updateStatus(int requestId, String status, int employeeId) {
        String sql = """
        UPDATE maintenancerequests
        SET Status = ?, ApprovedBy = ?, ApprovedDate = NOW()
        WHERE RequestId = ?
          AND Status = 'PENDING'
          AND IsDelete = 0
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status); // APPROVED | REJECTED
            ps.setInt(2, employeeId);
            ps.setInt(3, requestId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void completeRequest(int requestId) {
        String sql = """
            UPDATE maintenancerequests
            SET Status = 'COMPLETED', CompletedDate = NOW()
            WHERE RequestId = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 4. Lấy danh sách theo trạng thái
    public List<MaintenanceRequest> getByStatus(String status) {
        List<MaintenanceRequest> list = new ArrayList<>();
        String sql = """
            SELECT * FROM maintenancerequests
            WHERE Status = ? AND IsDelete = 0
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MaintenanceRequest r = new MaintenanceRequest();
                r.setRequestId(rs.getInt("RequestId"));
                r.setRequestCode(rs.getString("RequestCode"));
                r.setStatus(rs.getString("Status"));
                r.setTitle(rs.getString("Title"));
                r.setCreatedDate(rs.getTimestamp("CreatedDate"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<MaintenanceRequest> getByCustomer(int customerId) {
        List<MaintenanceRequest> list = new ArrayList<>();

        String sql = """
        SELECT
            RequestId,
            RequestCode,
            RequestType,
            Title,
            Status,
            CreatedDate
        FROM maintenancerequests
        WHERE CustomerId = ?
          AND IsDelete = 0
        ORDER BY CreatedDate DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                MaintenanceRequest r = new MaintenanceRequest();
                r.setRequestId(rs.getInt("RequestId"));
                r.setRequestCode(rs.getString("RequestCode"));
                r.setRequestType(rs.getString("RequestType"));
                r.setTitle(rs.getString("Title"));
                r.setStatus(rs.getString("Status"));
                r.setCreatedDate(rs.getTimestamp("CreatedDate"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
