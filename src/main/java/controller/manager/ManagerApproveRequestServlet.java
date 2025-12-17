package controller.manager;

import dal.MaintenanceRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Users;

@WebServlet("/mgr/approve-request")
public class ManagerApproveRequestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Users user = (Users) session.getAttribute("user");

        String requestIdRaw = req.getParameter("requestId");
        String action = req.getParameter("action"); 

        if (requestIdRaw == null || action == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int requestId = Integer.parseInt(requestIdRaw);

        MaintenanceRequestDAO dao = new MaintenanceRequestDAO();

        if ("APPROVE".equalsIgnoreCase(action)) {
            dao.updateStatus(requestId, "APPROVED", user.getUserId());
            session.setAttribute("success", "Duyệt yêu cầu thành công!");
        }

        if ("REJECT".equalsIgnoreCase(action)) {
            dao.updateStatus(requestId, "REJECTED", user.getUserId());
            session.setAttribute("success", "Đã từ chối yêu cầu!");
        }
        resp.sendRedirect(req.getContextPath() + "/mgr/maintenance-requests");
    }
}
