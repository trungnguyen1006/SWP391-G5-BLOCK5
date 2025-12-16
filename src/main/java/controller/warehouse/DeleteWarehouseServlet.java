package controller.warehouse;

import dal.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

import java.io.IOException;

@WebServlet(name = "DeleteWarehouseServlet", urlPatterns = {"/mgr/delete-warehouse"})
public class DeleteWarehouseServlet extends HttpServlet {

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
            if (warehouseDAO.deleteWarehouse(warehouseId)) {
                response.sendRedirect(request.getContextPath() + WAREHOUSE_LIST_URL + "?deleted=true");
            } else {
                response.sendRedirect(request.getContextPath() + WAREHOUSE_LIST_URL + "?error=true");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + WAREHOUSE_LIST_URL);
        }
    }
}
