package controller.admin;

import dal.UserDAO;
import dal.MachineDAO;
import dal.ContractDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import model.Dashboard;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/admin/dashboard"})
public class DashboardServlet extends HttpServlet {

    private static final String DASHBOARD_PAGE = "dashboard.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        MachineDAO machineDAO = new MachineDAO();
        ContractDAO contractDAO = new ContractDAO();
        
        Dashboard d = userDAO.getDashboardAdmin();
        
        // Get machine statistics
        int totalMachines = machineDAO.getTotalMachineUnits();
        
        request.setAttribute("dashboard", d);
        request.setAttribute("totalMachines", totalMachines);
        request.getRequestDispatcher(DASHBOARD_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

}
