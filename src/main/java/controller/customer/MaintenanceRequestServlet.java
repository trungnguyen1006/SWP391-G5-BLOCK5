package controller.customer;

import dal.CustomerDAO;
import dal.MachineDAO;
import dal.MaintenanceRequestDAO;
import dal.MaintenanceRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Customers;
import model.MachineUnit;
import model.MaintenanceRequest;
import model.Users;

@WebServlet(name = "MaintenanceRequestServlet", urlPatterns = {"/customer/sendrequest"})
public class MaintenanceRequestServlet extends HttpServlet {

    // ===================== GET =====================
    // Hiển thị form gửi đơn + danh sách thiết bị
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        CustomerDAO customerDAO = new CustomerDAO();
        Customers cust = customerDAO.getCustomerByUserId(user.getUserId());
        MachineDAO unitDAO = new MachineDAO();
        List<MachineUnit> units = unitDAO.getAvailableUnitsForCustomer(cust.getCustomerId());
        req.setAttribute("units", units);
        req.getRequestDispatcher("/customer/send_request.jsp").forward(req, resp);
    }

    // ===================== POST =====================
    // Xử lý gửi đơn
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Users user = (Users) session.getAttribute("user");

        CustomerDAO customerDAO = new CustomerDAO();
        int userID = user.getUserId();
        Customers cust = customerDAO.getCustomerByUserId(userID);
        int unitId = Integer.parseInt(req.getParameter("unitId"));
        String requestType = req.getParameter("requestType"); // REPAIR | WARRANTY
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String requestCode = "MR-" + System.currentTimeMillis();
        MaintenanceRequest request = new MaintenanceRequest();
        request.setRequestCode(requestCode);
        request.setRequestType(requestType);
        request.setCustomerId(cust.getCustomerId());
        request.setUnitId(unitId);
        request.setTitle(title);
        request.setDescription(description);
        request.setCreatedBy(user.getUserId());

        MaintenanceRequestDAO requestDAO = new MaintenanceRequestDAO();
        requestDAO.createRequest(request);
        session.setAttribute("success", "Gửi đơn sửa chữa/bảo hành thành công!");
        resp.sendRedirect(req.getContextPath() + "/customer/requests");
    }
}
