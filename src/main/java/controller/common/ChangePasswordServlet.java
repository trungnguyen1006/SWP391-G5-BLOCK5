package controller.common;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import util.Validator;

import java.io.IOException;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/change-password"})
public class ChangePasswordServlet extends HttpServlet {

    private static final String CHANGE_PASSWORD_PAGE = "/changePassword.jsp";
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(CHANGE_PASSWORD_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String oldPassword = request.getParameter("oldPass");
        String newPassword = request.getParameter("newPass");
        String confirmPassword = request.getParameter("confirmPass");

        // Validation
        if (oldPassword == null || oldPassword.isEmpty() || 
            newPassword == null || newPassword.isEmpty() || 
            confirmPassword == null || confirmPassword.isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher(CHANGE_PASSWORD_PAGE).forward(request, response);
            return;
        }

        // Check if new password matches confirm password
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "New password and confirm password do not match.");
            request.getRequestDispatcher(CHANGE_PASSWORD_PAGE).forward(request, response);
            return;
        }

        // Check if old password is correct
        Users user = userDAO.findUserById(currentUser.getUserId());
        if (user == null || !PasswordHasher.checkPassword(oldPassword, user.getPassword())) {
            request.setAttribute("errorMessage", "Current password is incorrect.");
            request.getRequestDispatcher(CHANGE_PASSWORD_PAGE).forward(request, response);
            return;
        }

        // Check password strength
        if (!Validator.isValidPassword(newPassword)) {
            request.setAttribute("errorMessage", Validator.getPasswordErrorMessage());
            request.getRequestDispatcher(CHANGE_PASSWORD_PAGE).forward(request, response);
            return;
        }

        // Update password
        String hashedPassword = PasswordHasher.hashPassword(newPassword);
        if (userDAO.updateUserPassword(currentUser.getUserId(), hashedPassword)) {
            request.setAttribute("successMessage", "Password changed successfully.");
            request.getRequestDispatcher(CHANGE_PASSWORD_PAGE).forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Failed to change password. Please try again.");
            request.getRequestDispatcher(CHANGE_PASSWORD_PAGE).forward(request, response);
        }
    }
}
