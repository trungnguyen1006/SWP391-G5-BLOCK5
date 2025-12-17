package controller.manager;

import dal.MaintenanceRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/mgr/maintenance-requests")
public class ManagerMaintenanceListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        MaintenanceRequestDAO dao = new MaintenanceRequestDAO();
        req.setAttribute("requests", dao.getByStatus("PENDING"));

        req.getRequestDispatcher("/mgr/manager_requests.jsp")
           .forward(req, resp);
    }
}
