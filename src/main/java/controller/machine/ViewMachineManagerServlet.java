package controller.machine;

import dal.MachineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MachineUnit;

import java.io.IOException;
import java.util.*;
import java.util.LinkedHashMap;

@WebServlet(name = "ViewMachineManagerServlet", urlPatterns = {"/mgr/machines"})
public class ViewMachineManagerServlet extends HttpServlet {

    private static final String MACHINE_LIST_PAGE = "/mgr/machine/view-machine-manager.jsp";
    private static final int PAGE_SIZE = 15;
    private final MachineDAO machineDAO = new MachineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pageParam = request.getParameter("page");
        String statusParam = request.getParameter("status");
        String modelParam = request.getParameter("model");
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

        int totalMachines;
        List<MachineUnit> machineUnits;
        
        boolean hasStatusFilter = statusParam != null && !statusParam.isEmpty();
        boolean hasModelFilter = modelParam != null && !modelParam.isEmpty();
        
        if (hasStatusFilter && hasModelFilter) {
            totalMachines = machineDAO.getTotalMachineUnitsWithBothFilters(statusParam, modelParam);
            machineUnits = machineDAO.getMachineUnitsByPageWithBothFilters(currentPage, PAGE_SIZE, statusParam, modelParam);
        } else if (hasStatusFilter) {
            totalMachines = machineDAO.getTotalMachineUnitsWithFilter(statusParam);
            machineUnits = machineDAO.getMachineUnitsByPageWithFilter(currentPage, PAGE_SIZE, statusParam);
        } else if (hasModelFilter) {
            totalMachines = machineDAO.getTotalMachineUnitsByModel(modelParam);
            machineUnits = machineDAO.getMachineUnitsByPageWithModel(currentPage, PAGE_SIZE, modelParam);
        } else {
            totalMachines = machineDAO.getTotalMachineUnits();
            machineUnits = machineDAO.getMachineUnitsByPage(currentPage, PAGE_SIZE);
        }
        
        int totalPages = (int) Math.ceil((double) totalMachines / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        // Group machines by model
        Map<String, List<MachineUnit>> groupedByModel = new LinkedHashMap<>();
        for (MachineUnit unit : machineUnits) {
            String modelName = unit.getMachineModel() != null ? unit.getMachineModel().getModelName() : "Unknown";
            groupedByModel.computeIfAbsent(modelName, k -> new ArrayList<>()).add(unit);
        }

        Map<String, Integer> statusCount = machineDAO.getMachineCountByStatus();
        Map<String, Integer> modelCount = machineDAO.getMachineCountByModel();
        
        request.setAttribute("groupedByModel", groupedByModel);
        request.setAttribute("machineUnits", machineUnits);
        request.setAttribute("statusCount", statusCount);
        request.setAttribute("modelCount", modelCount);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalMachines", totalMachines);
        request.setAttribute("status", statusParam);
        request.setAttribute("model", modelParam);
        
        request.getRequestDispatcher(MACHINE_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}