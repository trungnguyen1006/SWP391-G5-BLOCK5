package controller.contract;

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

@WebServlet(name = "DeleteContractEmployeeServlet", urlPatterns = {"/employee/delete-contract"})
public class DeleteContractEmployeeServlet extends HttpServlet {

    private static final String CONTRACT_LIST_URL = "/employee/contracts";
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

            // Only allow deletion of DRAFT contracts
            if (!"DRAFT".equalsIgnoreCase(contract.getStatus())) {
                response.sendRedirect(request.getContextPath() + CONTRACT_LIST_URL + "?error=only_draft_can_be_deleted");
                return;
            }

            // Delete the contract
            boolean success = contractDAO.deleteContract(contractId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + CONTRACT_LIST_URL + "?deleted=true");
            } else {
                response.sendRedirect(request.getContextPath() + CONTRACT_LIST_URL + "?error=delete_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + CONTRACT_LIST_URL);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + CONTRACT_LIST_URL + "?error=exception");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
