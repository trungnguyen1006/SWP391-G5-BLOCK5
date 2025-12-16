package controller.contract;

import dal.ContractDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Contract;
import model.ContractItem;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "ViewContractDetailServlet", urlPatterns = {"/employee/contract-detail"})
public class ViewContractDetailServlet extends HttpServlet {

    private static final String CONTRACT_DETAIL_PAGE = "/employee/contract/view-contract-detail.jsp";
    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String contractIdParam = request.getParameter("id");
        
        if (contractIdParam == null || contractIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/employee/contracts");
            return;
        }

        try {
            int contractId = Integer.parseInt(contractIdParam);
            Contract contract = contractDAO.getContractById(contractId);
            
            if (contract == null) {
                response.sendRedirect(request.getContextPath() + "/employee/contracts");
                return;
            }

            // Calculate totals
            BigDecimal totalAmount = BigDecimal.ZERO;
            BigDecimal totalDeposit = BigDecimal.ZERO;
            
            if (contract.getContractItems() != null) {
                for (ContractItem item : contract.getContractItems()) {
                    if (item.getPrice() != null) {
                        totalAmount = totalAmount.add(item.getPrice());
                    }
                    if (item.getDeposit() != null) {
                        totalDeposit = totalDeposit.add(item.getDeposit());
                    }
                }
            }
            
            contract.setTotalAmount(totalAmount);
            contract.setTotalDeposit(totalDeposit);
            
            request.setAttribute("contract", contract);
            request.getRequestDispatcher(CONTRACT_DETAIL_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/employee/contracts");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
