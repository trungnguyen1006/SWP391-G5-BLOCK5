package controller.machine;

import dal.MachineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.MachineUnit;
import model.Users;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewMachineListServlet", urlPatterns = {"/mgr/machines"})
public class ViewMachineListServlet extends HttpServlet {

    private static final String MACHINE_LIST_PAGE = "/mgr/machine/view-machine-manager.jsp";
    private static final int PAGE_SIZE = 10;
    private final MachineDAO machineDAO = new MachineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pageParam = request.getParameter("page");
        String searchParam = request.getParameter("search");
        String statusParam = request.getParameter("status");
        
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

        List<MachineUnit> machines = machineDAO.getMachineUnitsByPage(currentPage, PAGE_SIZE);
        
        request.setAttribute("machines", machines);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalMachines", totalMachines);
        request.setAttribute("search", searchParam);
        request.setAttribute("status", statusParam);
        
        request.getRequestDispatcher(MACHINE_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
