package controller.machine;

import dal.ContractDAO;
import dal.MachineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.MachineModel;
import model.Users;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewMachineCustomerServlet", urlPatterns = {"/customer/machines"})
public class ViewMachineCustomerServlet extends HttpServlet {

    private static final String MACHINE_LIST_PAGE = "machine/view-machine-customer.jsp";
    private static final int PAGE_SIZE = 10;
    private final MachineDAO machineDAO = new MachineDAO();
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

        // Get machines from customer's contracts only
        List<MachineModel> machineModels = contractDAO.getMachineModelsFromCustomerContracts(currentUser.getUserId());
        
        int totalModels = machineModels.size();
        int totalPages = (int) Math.ceil((double) totalModels / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        
        // Paginate
        int startIndex = (currentPage - 1) * PAGE_SIZE;
        int endIndex = Math.min(startIndex + PAGE_SIZE, totalModels);
        List<MachineModel> paginatedModels = machineModels.subList(startIndex, endIndex);
        
        request.setAttribute("machineModels", paginatedModels);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalModels", totalModels);
        request.getRequestDispatcher(MACHINE_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}