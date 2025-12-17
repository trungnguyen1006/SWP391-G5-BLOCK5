package controller.contract;

import dal.ContractDAO;
import dal.MachineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

import java.io.IOException;

@WebServlet(name = "ReturnMachineServlet", urlPatterns = {"/employee/return-machine"})
public class ReturnMachineServlet extends HttpServlet {

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
        String returnNote = request.getParameter("returnNote");

        if (contractIdParam == null || contractIdParam.isEmpty() || 
            warehouseIdParam == null || warehouseIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + CONTRACT_DETAIL_URL + "?id=" + contractIdParam + "&error=missing_params");
            return;
        }

        try {
            int contractId = Integer.parseInt(contractIdParam);
            int warehouseId = Integer.parseInt(warehouseIdParam);

            // Cancel contract and return all machines to warehouse
            boolean success = contractDAO.cancelContractAndReturnUnits(
                    contractId,
                    warehouseId,
                    currentUser.getUserId(),
                    returnNote != null ? returnNote : ""
            );

            if (success) {
                response.sendRedirect(request.getContextPath() + CONTRACT_DETAIL_URL + "?id=" + contractId + "&returned=true");
            } else {
                response.sendRedirect(request.getContextPath() + CONTRACT_DETAIL_URL + "?id=" + contractId + "&error=return_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + CONTRACT_DETAIL_URL + "?id=" + contractIdParam + "&error=invalid_format");
        }
    }
}
