package controller.contract;

import dal.ContractDAO;
import dal.MachineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Contract;
import model.ContractItem;
import model.Users;

import java.io.IOException;

@WebServlet(name = "ConfirmMachineReceiptServlet", urlPatterns = {"/employee/confirm-receipt"})
public class ConfirmMachineReceiptServlet extends HttpServlet {

    private static final String CONTRACT_DETAIL_URL = "/employee/contract-detail";
    private final ContractDAO contractDAO = new ContractDAO();
    private final MachineDAO machineDAO = new MachineDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String contractIdParam = request.getParameter("contractId");
        String warehouseIdParam = request.getParameter("warehouseId");

        if (contractIdParam == null || contractIdParam.isEmpty() || 
            warehouseIdParam == null || warehouseIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + CONTRACT_DETAIL_URL + "?id=" + contractIdParam + "&error=missing_params");
            return;
        }

        try {
            int contractId = Integer.parseInt(contractIdParam);
            int warehouseId = Integer.parseInt(warehouseIdParam);
            Contract contract = contractDAO.getContractById(contractId);

            if (contract == null) {
                response.sendRedirect(request.getContextPath() + CONTRACT_DETAIL_URL + "?id=" + contractId + "&error=contract_not_found");
                return;
            }

            // Update all machines in contract to AVAILABLE status and return to warehouse
            boolean allUpdated = true;
            if (contract.getContractItems() != null) {
                for (ContractItem item : contract.getContractItems()) {
                    boolean updated = machineDAO.updateMachineStatus(item.getUnitId(), "AVAILABLE", warehouseId, null);
                    if (!updated) {
                        allUpdated = false;
                        System.out.println("DEBUG: Failed to update machine status for unit " + item.getUnitId());
                    }
                }
            }

            if (allUpdated) {
                response.sendRedirect(request.getContextPath() + CONTRACT_DETAIL_URL + "?id=" + contractId + "&receipt_confirmed=true");
            } else {
                response.sendRedirect(request.getContextPath() + CONTRACT_DETAIL_URL + "?id=" + contractId + "&error=receipt_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + CONTRACT_DETAIL_URL + "?error=invalid_format");
        }
    }
}
