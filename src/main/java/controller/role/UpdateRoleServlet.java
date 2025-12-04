package controller.role;

import dal.RoleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Roles;

import java.io.IOException;

@WebServlet(name = "UpdateRoleServlet", urlPatterns = {"/admin/update-role"})
public class UpdateRoleServlet extends HttpServlet {

    private static final String UPDATE_ROLE_PAGE = "role-manage/update-role-infor.jsp";
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

            request.setAttribute("role", role);
            request.setAttribute("userCount", userCount);
            request.getRequestDispatcher(UPDATE_ROLE_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + ROLE_LIST_URL);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roleIdParam = request.getParameter("roleId");
        String roleName = request.getParameter("roleName");
        String isActiveParam = request.getParameter("isActive");

        try {
            int roleId = Integer.parseInt(roleIdParam);
            Roles role = roleDAO.findRoleById(roleId);

            if (role == null) {
                response.sendRedirect(request.getContextPath() + ROLE_LIST_URL);
                return;
            }

            int userCount = roleDAO.getUserCountByRole(roleId);
            request.setAttribute("role", role);
            request.setAttribute("userCount", userCount);

            if (roleName == null || roleName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Role name is required.");
                request.getRequestDispatcher(UPDATE_ROLE_PAGE).forward(request, response);
                return;
            }

            if (roleDAO.isRoleNameExistsForOtherRole(roleName.trim(), roleId)) {
                request.setAttribute("errorMessage", "Role name already exists.");
                request.getRequestDispatcher(UPDATE_ROLE_PAGE).forward(request, response);
                return;
            }

            role.setRoleName(roleName.trim());
            role.setActive(isActiveParam != null && isActiveParam.equals("1"));

            boolean updated = roleDAO.updateRole(role);

            if (updated) {
                response.sendRedirect(request.getContextPath() + ROLE_LIST_URL + "?updated=true");
            } else {
                request.setAttribute("errorMessage", "Failed to update role. Please try again.");
                request.getRequestDispatcher(UPDATE_ROLE_PAGE).forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + ROLE_LIST_URL);
        }
    }

}
