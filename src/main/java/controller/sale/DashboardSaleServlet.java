/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.sale;

import dal.DashboardDAO;
import dal.EmployeeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.DashboardSale;
import model.Employee;
import model.Users;

/**
 *
 * @author Administrator
 */
@WebServlet("/sale/dashboard")

public class DashboardSaleServlet extends HttpServlet{
     @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("/login");
            return;
        }

        Users u = (Users) session.getAttribute("user");

        EmployeeDAO employeeDAO = new EmployeeDAO();
        Employee employee = employeeDAO.getEmployeebyUserId(u.getUserId());

        if (employee == null) {
            resp.sendRedirect("/login");
            return;
        }

        int saleEmployeeId = employee.getEmployeeId();

        DashboardDAO dao = new DashboardDAO();
        DashboardSale dashboard = dao.getDashboardSale(saleEmployeeId);

        req.setAttribute("dashboard", dashboard);
        req.getRequestDispatcher("/sale/sale-dashboard.jsp")
           .forward(req, resp);
    }
}
