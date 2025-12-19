package controller.sale;

import dal.DashboardDAO;
import dal.EmployeeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Dashboard;
import model.Employee;
import model.Users;

/**
 *
 * @author Administrator
 */
@WebServlet(name = "DashboardEmployeeServlet", urlPatterns = {"/employee/dashboard"})

public class DashboardEmployeeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        System.out.println("DEBUG DashboardEmployeeServlet: session=" + (session != null ? session.getId() : "null"));
        if (session == null) {
            System.out.println("DEBUG DashboardEmployeeServlet: Session is null, redirecting to login");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Users u = (Users) session.getAttribute("user");
        System.out.println("DEBUG DashboardEmployeeServlet: user=" + (u != null ? u.getUsername() : "null"));
        if (u == null) {
            System.out.println("DEBUG DashboardEmployeeServlet: User is null, redirecting to login");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        EmployeeDAO employeeDAO = new EmployeeDAO();
        Employee employee = employeeDAO.getEmployeebyUserId(u.getUserId());

        if (employee == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        DashboardDAO dao = new DashboardDAO();
        Dashboard dashboard = dao.getDashboardEmployee();

        req.setAttribute("dashboard", dashboard);
        req.getRequestDispatcher("/employee/dashboard.jsp")
                .forward(req, resp);
    }
}
