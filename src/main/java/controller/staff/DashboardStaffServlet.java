/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.staff;

import dal.CustomerDAO;
import dal.DashboardDAO;
import dal.EmployeeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Employee;
import model.DashboardCustomer;
import model.DashboardStaff;
import model.Users;

/**
 *
 * @author Administrator
 */
@WebServlet("/staff/dashboard")

public class DashboardStaffServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        DashboardDAO dao = new DashboardDAO();
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("/login");
            return;
        }
        Users u = (Users) session.getAttribute("user");
        System.out.println("ID user: " + u.getUserId());
        EmployeeDAO empDAO = new EmployeeDAO();
        Employee customer = empDAO.getEmployeebyUserId(u.getUserId());
        DashboardStaff dashboard = dao.getDashboardStaff(customer.getEmployeeId());
        if (dashboard == null) {
            dashboard = new DashboardStaff();
        }
        req.setAttribute("dashboard", dashboard);
        req.getRequestDispatcher("/staff/staff-dashboard.jsp").forward(req, resp);
    }

}
