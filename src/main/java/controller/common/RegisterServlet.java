package controller.common;

import dal.RoleDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Users;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private static final String REGISTER_PAGE = "common/register.jsp";
    private static final String LOGIN_PAGE = "login";
    private static final int DEFAULT_ROLE_ID = 2;

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(REGISTER_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (fullName == null || email == null || username == null || 
            password == null || confirmPassword == null ||
            fullName.trim().isEmpty() || email.trim().isEmpty() || 
            username.trim().isEmpty() || password.isEmpty()) {
            request.setAttribute("message", "All fields are required.");
            request.setAttribute("isSuccess", false);
            request.getRequestDispatcher(REGISTER_PAGE).forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("message", "Passwords do not match.");
            request.setAttribute("isSuccess", false);
            request.getRequestDispatcher(REGISTER_PAGE).forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("message", "Password must be at least 6 characters long.");
            request.setAttribute("isSuccess", false);
            request.getRequestDispatcher(REGISTER_PAGE).forward(request, response);
            return;
        }

        if (userDAO.isUserExists(username, email)) {
            request.setAttribute("message", "Username or email already exists.");
            request.setAttribute("isSuccess", false);
            request.getRequestDispatcher(REGISTER_PAGE).forward(request, response);
            return;
        }

        Users newUser = new Users();
        newUser.setUsername(username);
        newUser.setEmail(email);
//        newUser.setActive(true);
        newUser.setFullName(fullName);

        String hashedPassword = PasswordHasher.hashPassword(password);
        int newUserId = userDAO.createNewUser(newUser, hashedPassword);

        if (newUserId > 0) {
            roleDAO.assignDefaultRole(newUserId, DEFAULT_ROLE_ID);
            response.sendRedirect(request.getContextPath() + "/" + LOGIN_PAGE + "?registered=true");
        } else {
            request.setAttribute("message", "Registration failed. Please try again.");
            request.setAttribute("isSuccess", false);
            request.getRequestDispatcher(REGISTER_PAGE).forward(request, response);
        }
    }

}