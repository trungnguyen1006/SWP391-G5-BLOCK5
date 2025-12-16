package controller.customer;

import dal.CustomerManagementDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

import java.io.IOException;

@WebServlet(name = "DeleteCustomerServlet", urlPatterns = {"/mgr/delete-customer"})
public class DeleteCustomerServlet extends HttpServlet {

    private static final String CUSTOMER_LIST_URL = "/mgr/customers";
    private final CustomerManagementDAO customerDAO = new CustomerManagementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL);
            return;
        }

        try {
            int customerId = Integer.parseInt(idParam);
            if (customerDAO.deleteCustomer(customerId)) {
                response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL + "?deleted=true");
            } else {
                response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL + "?error=true");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL);
        }
    }
}
