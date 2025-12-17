package controller.customer;

import dal.CustomerManagementDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customers;
import model.Users;

import java.io.IOException;

@WebServlet(name = "DeleteCustomerEmployeeServlet", urlPatterns = {"/employee/delete-customer"})
public class DeleteCustomerEmployeeServlet extends HttpServlet {

    private static final String CUSTOMER_LIST_URL = "/employee/customers";
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

        String customerIdParam = request.getParameter("id");

        if (customerIdParam == null || customerIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL);
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdParam);
            Customers customer = customerDAO.getCustomerById(customerId);

            if (customer == null) {
                response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL);
                return;
            }

            // Soft delete - mark as inactive
            boolean success = customerDAO.deleteCustomer(customerId);

            if (success) {
                response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL + "?deleted=true");
            } else {
                response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL + "?error=delete_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL + "?error=exception");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
