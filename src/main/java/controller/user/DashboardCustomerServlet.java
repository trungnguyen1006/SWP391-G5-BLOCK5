/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user;

import dal.CustomerDAO;
import dal.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Customers;
import model.Users;
import model.DashboardCustomer;

/**
 *
 * @author Administrator
 */
@WebServlet(name = "DashboardCustomer", urlPatterns = {"/dashboard"})

public class DashboardCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        DashboardDAO dao = new DashboardDAO();
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("/login");
            return;
        }
        Users u = (Users) session.getAttribute("user");
        CustomerDAO customerDAO = new CustomerDAO();
        Customers customer = customerDAO.getCustomerByUserId(u.getUserId());
        int cusId = customer.getCustomerId();
        DashboardCustomer dashboard = dao.getDashboardCustomer(cusId);
        req.setAttribute("dashboard", dashboard);
        req.getRequestDispatcher("/customer/customer-dashboard.jsp").forward(req, resp);
    }

}
