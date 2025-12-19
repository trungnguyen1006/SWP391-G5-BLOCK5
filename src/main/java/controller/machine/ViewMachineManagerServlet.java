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

/**
 * ViewMachineManagerServlet - Hiển thị danh sách máy cho manager
 * 
 * Luồng:
 * 1. Lấy parameters: page, status, model
 * 2. Tính toán pagination (15 máy/trang)
 * 3. Lọc máy theo status và/hoặc model
 * 4. Nhóm máy theo model name
 * 5. Lấy thống kê (count by status, count by model)
 * 6. Forward đến JSP với dữ liệu accordion
 */
@WebServlet(name = "ViewMachineManagerServlet", urlPatterns = {"/mgr/machines"})
public class ViewMachineManagerServlet extends HttpServlet {

    private static final String MACHINE_LIST_PAGE = "/mgr/machine/view-machine-manager.jsp";
    private static final int PAGE_SIZE = 15; // 15 máy trên 1 trang
    private final MachineDAO machineDAO = new MachineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== LẤY PARAMETERS =====
        String pageParam = request.getParameter("page");
        String statusParam = request.getParameter("status");
        String modelParam = request.getParameter("model");
        int currentPage = 1;
        
        // Parse page number
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

        // ===== LỌCMÁY DỰA TRÊN FILTER =====
        int totalMachines;
        List<MachineUnit> machineUnits;
        
        boolean hasStatusFilter = statusParam != null && !statusParam.isEmpty();
        boolean hasModelFilter = modelParam != null && !modelParam.isEmpty();
        
        // Có cả 2 filter (status + model)
        if (hasStatusFilter && hasModelFilter) {
            totalMachines = machineDAO.getTotalMachineUnitsWithBothFilters(statusParam, modelParam);
            machineUnits = machineDAO.getMachineUnitsByPageWithBothFilters(currentPage, PAGE_SIZE, statusParam, modelParam);
        } 
        // Chỉ có filter status
        else if (hasStatusFilter) {
            totalMachines = machineDAO.getTotalMachineUnitsWithFilter(statusParam);
            machineUnits = machineDAO.getMachineUnitsByPageWithFilter(currentPage, PAGE_SIZE, statusParam);
        } 
        // Chỉ có filter model
        else if (hasModelFilter) {
            totalMachines = machineDAO.getTotalMachineUnitsByModel(modelParam);
            machineUnits = machineDAO.getMachineUnitsByPageWithModel(currentPage, PAGE_SIZE, modelParam);
        } 
        // Không có filter
        else {
            totalMachines = machineDAO.getTotalMachineUnits();
            machineUnits = machineDAO.getMachineUnitsByPage(currentPage, PAGE_SIZE);
        }
        
        // ===== TÍNH TOÁN PAGINATION =====
        int totalPages = (int) Math.ceil((double) totalMachines / PAGE_SIZE);
        
        // Nếu page hiện tại > tổng pages, set về trang cuối
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        // ===== NHÓM MÁY THEO MODEL =====
        // Dùng LinkedHashMap để giữ thứ tự insertion
        Map<String, List<MachineUnit>> groupedByModel = new LinkedHashMap<>();
        for (MachineUnit unit : machineUnits) {
            String modelName = unit.getMachineModel() != null ? unit.getMachineModel().getModelName() : "Unknown";
            groupedByModel.computeIfAbsent(modelName, k -> new ArrayList<>()).add(unit);
        }

        // ===== LẤY THỐNG KÊ =====
        Map<String, Integer> statusCount = machineDAO.getMachineCountByStatus();
        Map<String, Integer> modelCount = machineDAO.getMachineCountByModel();
        
        // ===== SET ATTRIBUTES CHO JSP =====
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

    /**
     * POST: Gọi doGet để xử lý
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}