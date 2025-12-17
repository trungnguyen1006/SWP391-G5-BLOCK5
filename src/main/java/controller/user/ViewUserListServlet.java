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

        // Get all users and filter out Admin role users
        List<Users> allUsers = userDAO.getUsersByPage(1, Integer.MAX_VALUE);
        List<Users> filteredUsers = new ArrayList<>();
        RoleDAO roleDAO = new RoleDAO();
        
        for (Users user : allUsers) {
            // Check if user has Admin role (roleId = 1)
            boolean isAdmin = false;
            try {
                List<Roles> userRoles = roleDAO.getRolesByUserId(user.getUserId());
                for (Roles role : userRoles) {
                    if (role.getRoleId() == 1) { // Admin role
                        isAdmin = true;
                        break;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            // Only add non-admin users
            if (!isAdmin) {
                filteredUsers.add(user);
            }
        }
        
        int totalUsers = filteredUsers.size();
        int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        // Get paginated results from filtered list
        int startIndex = (currentPage - 1) * PAGE_SIZE;
        int endIndex = Math.min(startIndex + PAGE_SIZE, filteredUsers.size());
        List<Users> userList = filteredUsers.subList(startIndex, endIndex);
        
        request.setAttribute("userList", userList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        
        request.getRequestDispatcher(USER_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

}
