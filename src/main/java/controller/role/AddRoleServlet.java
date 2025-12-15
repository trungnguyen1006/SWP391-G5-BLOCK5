package controller.role;

import dal.RoleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Roles;

import java.io.IOException;

@WebServlet(name = "AddRoleServlet", urlPatterns = {"/admin/add-role"})
public class AddRoleServlet extends HttpServlet {

    private static final String ADD_ROLE_PAGE = "role-manage/add-role.jsp";
    private static final String ROLE_LIST_URL = "role-list";
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(ADD_ROLE_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roleName = request.getParameter("roleName");
        String isActiveParam = request.getParameter("isActive");

        if (roleName == null || roleName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Role name is required.");
            request.getRequestDispatcher(ADD_ROLE_PAGE).forward(request, response);
            return;
        }

        if (roleDAO.isRoleNameExists(roleName.trim())) {
            request.setAttribute("errorMessage", "Role name already exists: " + roleName);
            request.getRequestDispatcher(ADD_ROLE_PAGE).forward(request, response);
            return;
        }

        try {
            Roles role = new Roles();
            role.setRoleName(roleName.trim());
            role.setActive(isActiveParam != null && isActiveParam.equals("on"));

            boolean success = roleDAO.addRole(role);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/" + ROLE_LIST_URL + "?added=true");
            } else {
                request.setAttribute("errorMessage", "Failed to add role. Please try again.");
                request.getRequestDispatcher(ADD_ROLE_PAGE).forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher(ADD_ROLE_PAGE).forward(request, response);
        }
    }
}
