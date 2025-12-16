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

@WebServlet(name = "UpdateCustomerServlet", urlPatterns = {"/mgr/update-customer"})
public class UpdateCustomerServlet extends HttpServlet {

    private static final String UPDATE_CUSTOMER_PAGE = "/mgr/customer/update-customer.jsp";
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
            Customers customer = customerDAO.getCustomerById(customerId);
            
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL);
                return;
            }
            
            request.setAttribute("customer", customer);
            request.getRequestDispatcher(UPDATE_CUSTOMER_PAGE).forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("customerId");
        String customerCode = request.getParameter("customerCode");
        String customerName = request.getParameter("customerName");
        String address = request.getParameter("address");
        String contactName = request.getParameter("contactName");
        String contactPhone = request.getParameter("contactPhone");
        String contactEmail = request.getParameter("contactEmail");

        if (idParam == null || customerCode == null || customerCode.trim().isEmpty() ||
            customerName == null || customerName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Customer Code and Name are required.");
            request.getRequestDispatcher(UPDATE_CUSTOMER_PAGE).forward(request, response);
            return;
        }

        try {
            int customerId = Integer.parseInt(idParam);
            Customers customer = new Customers();
            customer.setCustomerId(customerId);
            customer.setCustomerCode(customerCode.trim());
            customer.setCustomerName(customerName.trim());
            customer.setAddress(address != null ? address.trim() : "");
            customer.setContactName(contactName != null ? contactName.trim() : "");
            customer.setContactPhone(contactPhone != null ? contactPhone.trim() : "");
            customer.setContactEmail(contactEmail != null ? contactEmail.trim() : "");

            if (customerDAO.updateCustomer(customer)) {
                response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL + "?updated=true");
            } else {
                request.setAttribute("errorMessage", "Failed to update customer. Please try again.");
                request.setAttribute("customer", customer);
                request.getRequestDispatcher(UPDATE_CUSTOMER_PAGE).forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL);
        }
    }
}
