package controller.role;

import dal.RoleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Roles;
import model.Users;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewRoleDetailServlet", urlPatterns = {"/admin/role-detail"})
public class ViewRoleDetailServlet extends HttpServlet {

    private static final String ROLE_DETAIL_PAGE = "role-manage/view-role-detail.jsp";
    private static final String ROLE_LIST_URL = "/admin/role-list";

    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roleIdParam = request.getParameter("id");

        if (roleIdParam == null || roleIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + ROLE_LIST_URL);
            return;
        }

        try {
            int roleId = Integer.parseInt(roleIdParam);
            Roles role = roleDAO.findRoleById(roleId);

            if (role == null) {
                response.sendRedirect(request.getContextPath() + ROLE_LIST_URL);
                return;
            }

            int userCount = roleDAO.getUserCountByRole(roleId);
            List<Users> usersWithRole = roleDAO.getUsersByRoleId(roleId);

            request.setAttribute("role", role);
            request.setAttribute("userCount", userCount);
            request.setAttribute("usersWithRole", usersWithRole);
            request.getRequestDispatcher(ROLE_DETAIL_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + ROLE_LIST_URL);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

}
