package controller.machine;

import dal.MachineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MachineModel;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewMachineCustomerServlet", urlPatterns = {"/customer/machines"})
public class ViewMachineCustomerServlet extends HttpServlet {

    private static final String MACHINE_LIST_PAGE = "machine/view-machine-customer.jsp";
    private static final int PAGE_SIZE = 10;
    private final MachineDAO machineDAO = new MachineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pageParam = request.getParameter("page");
        String categoryParam = request.getParameter("category");
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

        // Customer chỉ xem được thông tin model, không xem serial number
        int totalModels;
        List<MachineModel> machineModels;
        
        if (categoryParam != null && !categoryParam.isEmpty()) {
            totalModels = machineDAO.getTotalMachineModelsByCategory(categoryParam);
            machineModels = machineDAO.getMachineModelsByPageAndCategory(currentPage, PAGE_SIZE, categoryParam);
        } else {
            totalModels = machineDAO.getTotalMachineModels();
            machineModels = machineDAO.getMachineModelsByPage(currentPage, PAGE_SIZE);
        }
        
        int totalPages = (int) Math.ceil((double) totalModels / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        
        request.setAttribute("machineModels", machineModels);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalModels", totalModels);
        request.setAttribute("category", categoryParam);
        request.getRequestDispatcher(MACHINE_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}