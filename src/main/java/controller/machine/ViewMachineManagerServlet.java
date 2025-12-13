package controller.machine;

import dal.MachineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MachineUnit;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ViewMachineManagerServlet", urlPatterns = {"/admin/machines"})
public class ViewMachineManagerServlet extends HttpServlet {

    private static final String MACHINE_LIST_PAGE = "machine/view-machine-manager.jsp";
    private static final int PAGE_SIZE = 15;
    private final MachineDAO machineDAO = new MachineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

        int totalMachines = machineDAO.getTotalMachineUnits();
        int totalPages = (int) Math.ceil((double) totalMachines / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        List<MachineUnit> machineUnits = machineDAO.getMachineUnitsByPage(currentPage, PAGE_SIZE);
        Map<String, Integer> statusCount = machineDAO.getMachineCountByStatus();
        Map<String, Integer> modelCount = machineDAO.getMachineCountByModel();
        
        request.setAttribute("machineUnits", machineUnits);
        request.setAttribute("statusCount", statusCount);
        request.setAttribute("modelCount", modelCount);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalMachines", totalMachines);
        
        request.getRequestDispatcher(MACHINE_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}