package controller.invoice;

import dal.ContractDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Contract;
import model.Users;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewInvoiceServlet", urlPatterns = {"/sale/invoices"})
public class ViewInvoiceServlet extends HttpServlet {

    private static final String INVOICE_LIST_PAGE = "/sale/invoice/view-invoice-list.jsp";
    private static final int PAGE_SIZE = 10;
    private final ContractDAO contractDAO = new ContractDAO();

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

        // Get employee ID from current user (assuming user is linked to employee)
        // For now, we'll show all contracts. In real implementation, filter by sale employee
        int totalContracts = contractDAO.getTotalContracts();
        int totalPages = (int) Math.ceil((double) totalContracts / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        List<Contract> contracts = contractDAO.getContractsByPage(currentPage, PAGE_SIZE);
        
        request.setAttribute("contracts", contracts);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalContracts", totalContracts);
        
        request.getRequestDispatcher(INVOICE_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}