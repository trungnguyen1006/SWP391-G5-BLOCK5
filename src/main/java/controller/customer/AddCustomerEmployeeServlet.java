package controller.customer;

import dal.CustomerManagementDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.Users;

import java.io.IOException;

@WebServlet(name = "AddCustomerEmployeeServlet", urlPatterns = {"/employee/add-customer"})
public class AddCustomerEmployeeServlet extends HttpServlet {

    private static final String ADD_CUSTOMER_PAGE = "/employee/customer/add-customer.jsp";
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

        String nextCustomerCode = customerDAO.generateCustomerCode();
        request.setAttribute("nextCustomerCode", nextCustomerCode);
        request.getRequestDispatcher(ADD_CUSTOMER_PAGE).forward(request, response);
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

        String customerCode = request.getParameter("customerCode");
        String customerName = request.getParameter("customerName");
        String address = request.getParameter("address");
        String contactName = request.getParameter("contactName");
        String contactPhone = request.getParameter("contactPhone");
        String contactEmail = request.getParameter("contactEmail");

        // Validation
        if (customerCode == null || customerCode.trim().isEmpty() || 
            customerName == null || customerName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Customer code and name are required.");
            String nextCustomerCode = customerDAO.generateCustomerCode();
            request.setAttribute("nextCustomerCode", nextCustomerCode);
            request.getRequestDispatcher(ADD_CUSTOMER_PAGE).forward(request, response);
            return;
        }

        if (customerDAO.isCustomerCodeExists(customerCode.trim())) {
            request.setAttribute("errorMessage", "Customer code already exists: " + customerCode);
            String nextCustomerCode = customerDAO.generateCustomerCode();
            request.setAttribute("nextCustomerCode", nextCustomerCode);
            request.getRequestDispatcher(ADD_CUSTOMER_PAGE).forward(request, response);
            return;
        }

        try {
            Customer customer = new Customer();
            customer.setCustomerCode(customerCode.trim());
            customer.setCustomerName(customerName.trim());
            customer.setAddress(address != null ? address.trim() : "");
            customer.setContactName(contactName != null ? contactName.trim() : "");
            customer.setContactPhone(contactPhone != null ? contactPhone.trim() : "");
            customer.setContactEmail(contactEmail != null ? contactEmail.trim() : "");
            customer.setActive(true);

            int newCustomerId = customerDAO.addCustomer(customer);
            
            if (newCustomerId > 0) {
                response.sendRedirect(request.getContextPath() + CUSTOMER_LIST_URL + "?added=true");
            } else {
                request.setAttribute("errorMessage", "Failed to add customer. Please try again.");
                String nextCustomerCode = customerDAO.generateCustomerCode();
                request.setAttribute("nextCustomerCode", nextCustomerCode);
                request.getRequestDispatcher(ADD_CUSTOMER_PAGE).forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            String nextCustomerCode = customerDAO.generateCustomerCode();
            request.setAttribute("nextCustomerCode", nextCustomerCode);
            request.getRequestDispatcher(ADD_CUSTOMER_PAGE).forward(request, response);
        }
    }
}
