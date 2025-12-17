package controller.contract;

import dal.ContractDAO;
import dal.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Contract;
import model.Customers;
import model.Users;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewCustomerContractListServlet", urlPatterns = {"/customer/contracts"})
public class ViewCustomerContractListServlet extends HttpServlet {

    private static final String CONTRACT_LIST_PAGE = "/customer/contract/view-contract-list.jsp";
    private static final int PAGE_SIZE = 10;
    private final ContractDAO contractDAO = new ContractDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();

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

        // Get customer info from user
        Customers customer = customerDAO.getCustomerByUserId(currentUser.getUserId());
        
        if (customer == null) {
            // No customer record found for this user
            System.out.println("DEBUG: No customer found for user ID: " + currentUser.getUserId());
            request.setAttribute("errorMessage", "No customer profile found for your account. Please contact support.");
            request.getRequestDispatcher(CONTRACT_LIST_PAGE).forward(request, response);
            return;
        }

        System.out.println("DEBUG: Found customer ID " + customer.getCustomerId() + " for user ID " + currentUser.getUserId());

        // Get contracts for this customer
        List<Contract> contracts = contractDAO.getContractsByCustomer(customer.getCustomerId(), currentPage, PAGE_SIZE);
        int totalContracts = contractDAO.getTotalContractsByCustomer(customer.getCustomerId());
        int totalPages = (int) Math.ceil((double) totalContracts / PAGE_SIZE);
        
        System.out.println("DEBUG: Found " + totalContracts + " total contracts for customer ID " + customer.getCustomerId());
        System.out.println("DEBUG: Retrieved " + (contracts != null ? contracts.size() : 0) + " contracts for page " + currentPage);
        
        if (contracts != null && !contracts.isEmpty()) {
            for (Contract c : contracts) {
                System.out.println("DEBUG: Contract - ID: " + c.getContractId() + ", Code: " + c.getContractCode() + ", Status: " + c.getStatus());
            }
        }
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        request.setAttribute("contracts", contracts);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalContracts", totalContracts);
        
        request.getRequestDispatcher(CONTRACT_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
