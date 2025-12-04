package controller.role;

import dal.RoleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Roles;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewRoleListServlet", urlPatterns = {"/admin/role-list"})
public class ViewRoleListServlet extends HttpServlet {

    private static final String ROLE_LIST_PAGE = "role-manage/view-role-list.jsp";

    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Roles> roleList = roleDAO.getAllActiveRoles();
        request.setAttribute("roleList", roleList);
        request.getRequestDispatcher(ROLE_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

}
