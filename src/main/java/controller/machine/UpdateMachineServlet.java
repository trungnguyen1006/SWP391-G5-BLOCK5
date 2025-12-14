package controller.machine;

import dal.MachineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MachineModel;
import model.MachineUnit;
import model.Warehouse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UpdateMachineServlet", urlPatterns = {"/admin/update-machine"})
public class UpdateMachineServlet extends HttpServlet {

    private static final String UPDATE_MACHINE_PAGE = "machine/update-machine.jsp";
    private static final String MACHINE_LIST_URL = "machines";
    private final MachineDAO machineDAO = new MachineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String unitIdParam = request.getParameter("id");
        
        if (unitIdParam == null || unitIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/" + MACHINE_LIST_URL);
            return;
        }

        try {
            int unitId = Integer.parseInt(unitIdParam);
            MachineUnit machineUnit = machineDAO.getMachineUnitById(unitId);
            
            if (machineUnit == null) {
                response.sendRedirect(request.getContextPath() + "/admin/" + MACHINE_LIST_URL);
                return;
            }

            List<MachineModel> machineModels = machineDAO.getAllMachineModels();
            List<Warehouse> warehouses = machineDAO.getAllWarehouses();
            
            request.setAttribute("machineUnit", machineUnit);
            request.setAttribute("machineModels", machineModels);
            request.setAttribute("warehouses", warehouses);
            request.getRequestDispatcher(UPDATE_MACHINE_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/" + MACHINE_LIST_URL);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String unitIdParam = request.getParameter("unitId");
        String modelIdParam = request.getParameter("modelId");
        String serialNumber = request.getParameter("serialNumber");
        String status = request.getParameter("status");
        String warehouseIdParam = request.getParameter("warehouseId");
        String siteIdParam = request.getParameter("siteId");

        if (unitIdParam == null || unitIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/" + MACHINE_LIST_URL);
            return;
        }

        try {
            int unitId = Integer.parseInt(unitIdParam);
            MachineUnit existingUnit = machineDAO.getMachineUnitById(unitId);
            
            if (existingUnit == null) {
                response.sendRedirect(request.getContextPath() + "/admin/" + MACHINE_LIST_URL);
                return;
            }

            List<MachineModel> machineModels = machineDAO.getAllMachineModels();
            List<Warehouse> warehouses = machineDAO.getAllWarehouses();
            request.setAttribute("machineUnit", existingUnit);
            request.setAttribute("machineModels", machineModels);
            request.setAttribute("warehouses", warehouses);

            // Validation
            if (modelIdParam == null || modelIdParam.isEmpty() || 
                serialNumber == null || serialNumber.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Model and Serial Number are required.");
                request.getRequestDispatcher(UPDATE_MACHINE_PAGE).forward(request, response);
                return;
            }

            // Check if serial number exists for other units
            if (machineDAO.isSerialNumberExistsForOtherUnit(serialNumber.trim(), unitId)) {
                request.setAttribute("errorMessage", "Serial Number already exists: " + serialNumber);
                request.getRequestDispatcher(UPDATE_MACHINE_PAGE).forward(request, response);
                return;
            }

            // Update machine unit
            MachineUnit updatedUnit = new MachineUnit();
            updatedUnit.setUnitId(unitId);
            updatedUnit.setModelId(Integer.parseInt(modelIdParam));
            updatedUnit.setSerialNumber(serialNumber.trim());
            updatedUnit.setCurrentStatus(status != null ? status : "IN_STOCK");
            
            if (warehouseIdParam != null && !warehouseIdParam.isEmpty()) {
                updatedUnit.setCurrentWarehouseId(Integer.parseInt(warehouseIdParam));
            }
            
            if (siteIdParam != null && !siteIdParam.isEmpty()) {
                updatedUnit.setCurrentSiteId(Integer.parseInt(siteIdParam));
            }

            boolean success = machineDAO.updateMachineUnit(updatedUnit);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/" + MACHINE_LIST_URL + "?updated=true");
            } else {
                request.setAttribute("errorMessage", "Failed to update machine. Please try again.");
                request.getRequestDispatcher(UPDATE_MACHINE_PAGE).forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input format.");
            request.getRequestDispatcher(UPDATE_MACHINE_PAGE).forward(request, response);
        }
    }
}