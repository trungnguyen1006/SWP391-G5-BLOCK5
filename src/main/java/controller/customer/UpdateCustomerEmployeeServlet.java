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

@WebServlet(name = "UpdateCustomerEmployeeServlet", urlPatterns = {"/employee/update-customer"})
public class UpdateCustomerEmployeeServlet extends HttpServlet {

    private static final String UPDATE_CUSTOMER_PAGE = "/employee/customer/update-customer.jsp";
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

        String customerIdParam = request.getParameter("customerId");
        String customerCode = request.getParameter("customerCode");
        String customerName = request.getParameter("customerName");
        String address = request.getParameter("address");
        String contactName = request.getParameter("contactName");
        String contactPhone = request.getParameter("contactPhone");
        String contactEmail = request.getParameter("contactEmail");

        if (customerIdParam == null || customerIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL);
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdParam);
            Customers existingCustomer = customerDAO.getCustomerById(customerId);
            
            if (existingCustomer == null) {
                response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL);
                return;
            }

            // Validation
            if (customerCode == null || customerCode.trim().isEmpty() || 
                customerName == null || customerName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Customer code and name are required.");
                request.setAttribute("customer", existingCustomer);
                request.getRequestDispatcher(UPDATE_CUSTOMER_PAGE).forward(request, response);
                return;
            }

            // Check if code exists for other customers
            if (customerDAO.isCustomerCodeExistsForOther(customerCode.trim(), customerId)) {
                request.setAttribute("errorMessage", "Customer code already exists: " + customerCode);
                request.setAttribute("customer", existingCustomer);
                request.getRequestDispatcher(UPDATE_CUSTOMER_PAGE).forward(request, response);
                return;
            }

            // Update customer
            Customers updatedCustomer = new Customers();
            updatedCustomer.setCustomerId(customerId);
            updatedCustomer.setCustomerCode(customerCode.trim());
            updatedCustomer.setCustomerName(customerName.trim());
            updatedCustomer.setAddress(address != null ? address.trim() : "");
            updatedCustomer.setContactName(contactName != null ? contactName.trim() : "");
            updatedCustomer.setContactPhone(contactPhone != null ? contactPhone.trim() : "");
            updatedCustomer.setContactEmail(contactEmail != null ? contactEmail.trim() : "");
            updatedCustomer.setActive(true);

            boolean success = customerDAO.updateCustomer(updatedCustomer);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL + "?updated=true");
            } else {
                request.setAttribute("errorMessage", "Failed to update customer. Please try again.");
                request.setAttribute("customer", existingCustomer);
                request.getRequestDispatcher(UPDATE_CUSTOMER_PAGE).forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input format.");
            request.getRequestDispatcher(UPDATE_CUSTOMER_PAGE).forward(request, response);
        }
    }
}
