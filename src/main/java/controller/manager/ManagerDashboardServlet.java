package controller.manager;

import dal.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

import java.io.IOException;
import model.Dashboard;

@WebServlet(name = "ManagerDashboardServlet", urlPatterns = {"/mgr/dashboard"})
public class ManagerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        
        DashboardDAO dashboardDAO = new DashboardDAO();
        Dashboard dashboard = dashboardDAO.getDashboardManager();

        request.setAttribute("dashboard", dashboard);
        request.getRequestDispatcher("/mgr/dashboard.jsp").forward(request, response);
    }
}