package controller.customer;

import dal.CustomerDAO;
import dal.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

import java.io.IOException;
import model.Customers;
import model.Dashboard;

@WebServlet(name = "CustomerDashboardServlet", urlPatterns = {"/customer/dashboard"})
public class CustomerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        DashboardDAO dao = new DashboardDAO();
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        Users u = (Users) session.getAttribute("user");
        CustomerDAO customerDAO = new CustomerDAO();
        Customers customer = customerDAO.getCustomerByUserId(u.getUserId());
        
        if (customer == null) {
            resp.sendRedirect(req.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        int cusId = customer.getCustomerId();
        Dashboard dashboard = dao.getDashboardCustomer(cusId);
        req.setAttribute("dashboard", dashboard);
        req.getRequestDispatcher("/customer/dashboard.jsp").forward(req, resp);
    }
}
