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
    private static final int PAGE_SIZE = 10;
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pageParam = request.getParameter("page");
        int currentPage = 1;
        
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int totalRoles = roleDAO.getTotalRoles();
        int totalPages = (int) Math.ceil((double) totalRoles / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        List<Roles> roleList = roleDAO.getRolesByPage(currentPage, PAGE_SIZE);
        
        request.setAttribute("roleList", roleList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRoles", totalRoles);
        request.getRequestDispatcher(ROLE_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

}
