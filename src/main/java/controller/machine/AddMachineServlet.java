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

@WebServlet(name = "AddMachineServlet", urlPatterns = {"/admin/add-machine"})
public class AddMachineServlet extends HttpServlet {

    private static final String ADD_MACHINE_PAGE = "machine/add-machine.jsp";
    private static final String MACHINE_LIST_URL = "machines";
    private final MachineDAO machineDAO = new MachineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<MachineModel> machineModels = machineDAO.getAllMachineModels();
        List<Warehouse> warehouses = machineDAO.getAllWarehouses();
        
        request.setAttribute("machineModels", machineModels);
        request.setAttribute("warehouses", warehouses);
        request.getRequestDispatcher(ADD_MACHINE_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        handleAddSingleMachine(request, response);
    }

    private void handleAddSingleMachine(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String modelIdParam = request.getParameter("modelId");
        String serialNumber = request.getParameter("serialNumber");
        String warehouseIdParam = request.getParameter("warehouseId");
        String status = request.getParameter("status");

        List<MachineModel> machineModels = machineDAO.getAllMachineModels();
        List<Warehouse> warehouses = machineDAO.getAllWarehouses();
        request.setAttribute("machineModels", machineModels);
        request.setAttribute("warehouses", warehouses);

        if (modelIdParam == null || serialNumber == null || serialNumber.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Model and Serial Number are required.");
            request.getRequestDispatcher(ADD_MACHINE_PAGE).forward(request, response);
            return;
        }

        try {
            int modelId = Integer.parseInt(modelIdParam);
            
            if (machineDAO.isSerialNumberExists(serialNumber.trim())) {
                request.setAttribute("errorMessage", "Serial Number already exists: " + serialNumber);
                request.getRequestDispatcher(ADD_MACHINE_PAGE).forward(request, response);
                return;
            }

            MachineUnit unit = new MachineUnit();
            unit.setModelId(modelId);
            unit.setSerialNumber(serialNumber.trim());
            unit.setCurrentStatus(status != null ? status : "IN_STOCK");
            
            if (warehouseIdParam != null && !warehouseIdParam.isEmpty()) {
                unit.setCurrentWarehouseId(Integer.parseInt(warehouseIdParam));
            }
            
            unit.setActive(true);

            int newUnitId = machineDAO.addMachineUnit(unit);
            
            if (newUnitId > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/" + MACHINE_LIST_URL + "?added=true");
            } else {
                request.setAttribute("errorMessage", "Failed to add machine. Please try again.");
                request.getRequestDispatcher(ADD_MACHINE_PAGE).forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input format.");
            request.getRequestDispatcher(ADD_MACHINE_PAGE).forward(request, response);
        }
    }
}