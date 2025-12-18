package controller.contract;

import dal.ContractDAO;
import dal.EmployeeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Contract;
import model.Employee;
import model.Users;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewContractListServlet", urlPatterns = {"/employee/contracts"})
public class ViewContractListServlet extends HttpServlet {

    private static final String CONTRACT_LIST_PAGE = "/employee/contract/view-contract-list.jsp";
    private static final int PAGE_SIZE = 10;
    private final ContractDAO contractDAO = new ContractDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

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
        String statusParam = request.getParameter("status");
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

        // Get contracts with optional status filter
        int totalContracts;
        List<Contract> contracts;
        
        if (statusParam != null && !statusParam.isEmpty()) {
            totalContracts = contractDAO.getTotalContractsByStatus(statusParam);
            contracts = contractDAO.getContractsByPageAndStatus(currentPage, PAGE_SIZE, statusParam);
        } else {
            totalContracts = contractDAO.getTotalContracts();
            contracts = contractDAO.getContractsByPage(currentPage, PAGE_SIZE);
        }
        
        int totalPages = (int) Math.ceil((double) totalContracts / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        request.setAttribute("contracts", contracts);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalContracts", totalContracts);
        request.setAttribute("status", statusParam);
        
        request.getRequestDispatcher(CONTRACT_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
