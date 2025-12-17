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

@WebServlet(name = "ViewCustomerContractDetailServlet", urlPatterns = {"/customer/contract-detail"})
public class ViewCustomerContractDetailServlet extends HttpServlet {

    private static final String CONTRACT_DETAIL_PAGE = "/customer/contract/view-contract-detail.jsp";
    private static final String CONTRACT_LIST_URL = "/customer/contracts";
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

        String contractIdParam = request.getParameter("id");
        
        if (contractIdParam == null || contractIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + CONTRACT_LIST_URL);
            return;
        }

        try {
            int contractId = Integer.parseInt(contractIdParam);
            Contract contract = contractDAO.getContractById(contractId);
            
            if (contract == null) {
                response.sendRedirect(request.getContextPath() + CONTRACT_LIST_URL);
                return;
            }

            // Verify that this contract belongs to the current customer
            Customers customer = customerDAO.getCustomerByUserId(currentUser.getUserId());
            
            if (customer == null || contract.getCustomerId() != customer.getCustomerId()) {
                // Customer trying to access contract that doesn't belong to them
                response.sendRedirect(request.getContextPath() + CONTRACT_LIST_URL);
                return;
            }

            request.setAttribute("contract", contract);
            request.getRequestDispatcher(CONTRACT_DETAIL_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + CONTRACT_LIST_URL);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
