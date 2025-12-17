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
import java.util.List;

@WebServlet(name = "ViewCustomerListEmployeeServlet", urlPatterns = {"/employee/customers"})
public class ViewCustomerListEmployeeServlet extends HttpServlet {

    private static final String CUSTOMER_LIST_PAGE = "/employee/customer/view-customer-list.jsp";
    private static final int PAGE_SIZE = 10;
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

        String pageParam = request.getParameter("page");
        int currentPage = 1;
        
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int totalCustomers = customerDAO.getTotalCustomers();
        int totalPages = (int) Math.ceil((double) totalCustomers / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        List<Customers> customers = customerDAO.getCustomersByPage(currentPage, PAGE_SIZE);
        
        request.setAttribute("customers", customers);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCustomers", totalCustomers);
        
        request.getRequestDispatcher(CUSTOMER_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
