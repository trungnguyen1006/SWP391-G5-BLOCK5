package controller.user;

import dal.RoleDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Roles;
import model.Users;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewUserDetailServlet", urlPatterns = {"/admin/user-detail"})
public class ViewUserDetailServlet extends HttpServlet {

    private static final String USER_DETAIL_PAGE = "user-manage/view-user-infor.jsp";

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdParam = request.getParameter("id");

        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/user-list");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            Users user = userDAO.findUserById(userId);

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin/user-list");
                return;
            }

            List<Roles> userRoles = roleDAO.getRolesByUserId(userId);

            request.setAttribute("user", user);
            request.setAttribute("userRoles", userRoles);
            request.getRequestDispatcher(USER_DETAIL_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/user-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

}
