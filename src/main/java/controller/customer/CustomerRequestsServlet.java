package controller.customer;

import dal.MaintenanceRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.MaintenanceRequest;
import model.Users;
import dal.CustomerDAO;
import model.Customers;

@WebServlet(name = "CustomerRequestsServlet", urlPatterns = {"/customer/requests"})
public class CustomerRequestsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Users user = (Users) session.getAttribute("user");

        CustomerDAO customerDAO = new CustomerDAO();
        Customers customer = customerDAO.getCustomerByUserId(user.getUserId());

        MaintenanceRequestDAO dao = new MaintenanceRequestDAO();
        List<MaintenanceRequest> requests =
                dao.getByCustomer(customer.getCustomerId());

        req.setAttribute("requests", requests);
        req.getRequestDispatcher("/customer/request_list.jsp")
           .forward(req, resp);
    }
}
