package controller.user;

import dal.UserDAO;
import dal.RoleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Users;
import model.Roles;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet(name = "ViewUserListServlet", urlPatterns = {"/admin/user-list"})
public class ViewUserListServlet extends HttpServlet {

    private static final String USER_LIST_PAGE = "user-manage/view-user-list.jsp";
    private static final int PAGE_SIZE = 5;
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pageParam = request.getParameter("page");
        String statusParam = request.getParameter("status");
        String roleParam = request.getParameter("role");
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

        int totalUsers;
        List<Users> userList;
        RoleDAO roleDAO = new RoleDAO();
        List<Roles> allRoles = roleDAO.getAllActiveRoles();
        
        if (roleParam != null && !roleParam.isEmpty()) {
            try {
                int roleId = Integer.parseInt(roleParam);
                totalUsers = userDAO.getTotalUsersWithRoleFilter(roleId);
                userList = userDAO.getUsersByPageWithRoleFilter(currentPage, PAGE_SIZE, roleId);
            } catch (NumberFormatException e) {
                totalUsers = userDAO.getTotalUsers();
                userList = userDAO.getUsersByPage(currentPage, PAGE_SIZE);
            }
        } else if (statusParam != null && !statusParam.isEmpty()) {
            totalUsers = userDAO.getTotalUsersWithFilter(statusParam);
            userList = userDAO.getUsersByPageWithFilter(currentPage, PAGE_SIZE, statusParam);
        } else {
            totalUsers = userDAO.getTotalUsers();
            userList = userDAO.getUsersByPage(currentPage, PAGE_SIZE);
        }
        
        // Fetch and set role for each user
        for (Users user : userList) {
            List<Roles> userRoles = roleDAO.getRolesByUserId(user.getUserId());
            if (userRoles != null && !userRoles.isEmpty()) {
                user.setRole(userRoles.get(0).getRoleName());
            } else {
                user.setRole("-");
            }
        }
        
        int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        
        request.setAttribute("userList", userList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("status", statusParam);
        request.setAttribute("role", roleParam);
        request.setAttribute("allRoles", allRoles);
        
        request.getRequestDispatcher(USER_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

}
