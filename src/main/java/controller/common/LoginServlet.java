package controller.common;

import dal.RoleDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;

import jakarta.servlet.http.HttpServletRequest;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Roles;
import model.Users;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})

public class LoginServlet extends HttpServlet {

    private static final String LOGIN_PAGE = "common/login.jsp";
    private static final String ADMIN_HOME = "/admin/dashboard";
    private static final String USER_HOME = "/common/homepage.jsp";

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(LOGIN_PAGE).forward(request, response);
    }

    @Override

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Users user = userDAO.findUserByUsername(username);

        String errorMessage = null;

        if (user == null) {
            errorMessage = "Username does not exist.";
        } else if (!user.isActive()) {
            errorMessage = "Your account has been locked or not activated.";
        } else {
            if (PasswordHasher.checkPassword(password, user.getPassword())) {

                List<Roles> userRoles = roleDAO.getRolesByUserId(user.getUserId());

                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("roles", userRoles);

                if (hasAdminRole(userRoles)) {
                    response.sendRedirect(request.getContextPath() + ADMIN_HOME);
                } else {
                    response.sendRedirect(request.getContextPath() + USER_HOME);
                }
                return;
            } else {
                errorMessage = "Incorrect password.";
            }
        }

        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher(LOGIN_PAGE).forward(request, response);
    }

    private boolean hasAdminRole(List<Roles> roles) {
        for (Roles role : roles) {
            if ("Admin".equalsIgnoreCase(role.getRoleName())) {
                return true;
            }
        }
        return false;
    }

}
