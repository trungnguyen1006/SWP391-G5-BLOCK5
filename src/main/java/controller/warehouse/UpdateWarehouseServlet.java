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

@WebServlet(name = "UpdateWarehouseServlet", urlPatterns = {"/mgr/update-warehouse"})
public class UpdateWarehouseServlet extends HttpServlet {

    private static final String UPDATE_WAREHOUSE_PAGE = "/mgr/warehouse/update-warehouse.jsp";
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

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + WAREHOUSE_LIST_URL);
            return;
        }

        try {
            int warehouseId = Integer.parseInt(idParam);
            Warehouse warehouse = warehouseDAO.getWarehouseById(warehouseId);
            
            if (warehouse == null) {
                response.sendRedirect(request.getContextPath() + WAREHOUSE_LIST_URL);
                return;
            }
            
            request.setAttribute("warehouse", warehouse);
            request.getRequestDispatcher(UPDATE_WAREHOUSE_PAGE).forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + WAREHOUSE_LIST_URL);
        }
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

        String idParam = request.getParameter("warehouseId");
        String warehouseCode = request.getParameter("warehouseCode");
        String warehouseName = request.getParameter("warehouseName");
        String address = request.getParameter("address");

        if (idParam == null || warehouseCode == null || warehouseCode.trim().isEmpty() ||
            warehouseName == null || warehouseName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Warehouse Code and Name are required.");
            request.getRequestDispatcher(UPDATE_WAREHOUSE_PAGE).forward(request, response);
            return;
        }

        try {
            int warehouseId = Integer.parseInt(idParam);
            Warehouse warehouse = new Warehouse();
            warehouse.setWarehouseId(warehouseId);
            warehouse.setWarehouseCode(warehouseCode.trim());
            warehouse.setWarehouseName(warehouseName.trim());
            warehouse.setAddress(address != null ? address.trim() : "");

            if (warehouseDAO.updateWarehouse(warehouse)) {
                response.sendRedirect(request.getContextPath() + WAREHOUSE_LIST_URL + "?updated=true");
            } else {
                request.setAttribute("errorMessage", "Failed to update warehouse. Please try again.");
                request.setAttribute("warehouse", warehouse);
                request.getRequestDispatcher(UPDATE_WAREHOUSE_PAGE).forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + WAREHOUSE_LIST_URL);
        }
    }
}
