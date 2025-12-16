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

@WebServlet(name = "AddWarehouseServlet", urlPatterns = {"/mgr/add-warehouse"})
public class AddWarehouseServlet extends HttpServlet {

    private static final String ADD_WAREHOUSE_PAGE = "/mgr/warehouse/add-warehouse.jsp";
    private static final String WAREHOUSE_LIST_URL = "/mgr/warehouses";
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

        request.getRequestDispatcher(ADD_WAREHOUSE_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String warehouseCode = request.getParameter("warehouseCode");
        String warehouseName = request.getParameter("warehouseName");
        String address = request.getParameter("address");

        if (warehouseCode == null || warehouseCode.trim().isEmpty() ||
            warehouseName == null || warehouseName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Warehouse Code and Name are required.");
            request.getRequestDispatcher(ADD_WAREHOUSE_PAGE).forward(request, response);
            return;
        }

        Warehouse warehouse = new Warehouse();
        warehouse.setWarehouseCode(warehouseCode.trim());
        warehouse.setWarehouseName(warehouseName.trim());
        warehouse.setAddress(address != null ? address.trim() : "");

        int warehouseId = warehouseDAO.addWarehouse(warehouse);
        
        if (warehouseId > 0) {
            response.sendRedirect(request.getContextPath() + WAREHOUSE_LIST_URL + "?added=true");
        } else {
            request.setAttribute("errorMessage", "Failed to add warehouse. Please try again.");
            request.getRequestDispatcher(ADD_WAREHOUSE_PAGE).forward(request, response);
        }
    }
}
