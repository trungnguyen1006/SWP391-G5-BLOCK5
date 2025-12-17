package controller.warehouse;

import dal.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Warehouse;
import model.Users;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewWarehouseListServlet", urlPatterns = {"/mgr/warehouses"})
public class ViewWarehouseListServlet extends HttpServlet {

    private static final String WAREHOUSE_LIST_PAGE = "/mgr/warehouse/view-warehouse-list.jsp";
    private static final int PAGE_SIZE = 10;
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();

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

        int totalWarehouses;
        List<Warehouse> warehouses;
        
        if (statusParam != null && !statusParam.isEmpty()) {
            totalWarehouses = warehouseDAO.getTotalWarehousesWithFilter(statusParam);
            warehouses = warehouseDAO.getWarehousesByPageWithFilter(currentPage, PAGE_SIZE, statusParam);
        } else {
            totalWarehouses = warehouseDAO.getTotalWarehouses();
            warehouses = warehouseDAO.getWarehousesByPage(currentPage, PAGE_SIZE);
        }
        
        int totalPages = (int) Math.ceil((double) totalWarehouses / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalWarehouses", totalWarehouses);
        request.setAttribute("status", statusParam);
        
        request.getRequestDispatcher(WAREHOUSE_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
