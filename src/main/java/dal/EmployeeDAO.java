/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import model.Employee;

/**
 * EmployeeDAO - Quản lý dữ liệu Employee
 * 
 * Chức năng:
 * - Lấy employee theo userId
 * - Tạo employee record mới
 */
public class EmployeeDAO extends DBContext {
    
    /**
     * Lấy employee theo userId
     * @param userID - ID của user
     * @return Employee object hoặc null nếu không tìm thấy
     */
    public Employee getEmployeebyUserId(int userID) {
        String sql = "SELECT * FROM employees WHERE UserId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Employee e = new Employee();
                e.setEmployeeId(rs.getInt("EmployeeId"));
                e.setUserId(rs.getInt("UserId"));
                e.setEmployeeCode(rs.getString("EmployeeCode"));
                e.setEmployeeName(rs.getString("EmployeeName"));
                e.setDepartment(rs.getString("Department"));
                e.setPosition(rs.getString("Position"));
                e.setActive(rs.getBoolean("IsActive"));
                return e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Tạo employee record mới
     * @param employee - Employee object chứa dữ liệu
     * @return ID của employee vừa tạo, hoặc 0 nếu thất bại
     */
    public int createEmployee(Employee employee) {
        String sql = "INSERT INTO Employees (UserId, EmployeeCode, EmployeeName, Department, Position, IsActive) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, employee.getUserId());
            ps.setString(2, employee.getEmployeeCode());
            ps.setString(3, employee.getEmployeeName());
            ps.setString(4, employee.getDepartment() != null ? employee.getDepartment() : "");
            ps.setString(5, employee.getPosition() != null ? employee.getPosition() : "");
            ps.setBoolean(6, employee.isActive());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("DEBUG: Error creating employee: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}