package controller.user;

import controller.common.PasswordHasher;
import dal.RoleDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Roles;
import model.Users;
import util.FileUploadUtil;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UpdateUserServlet", urlPatterns = {"/admin/update-user"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class UpdateUserServlet extends HttpServlet {

    private static final String UPDATE_USER_PAGE = "user-manage/update-user.jsp";
    private static final String USER_LIST_URL = "user-list";

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdParam = request.getParameter("id");

        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + USER_LIST_URL);
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            Users user = userDAO.findUserById(userId);

            if (user == null) {
                response.sendRedirect(request.getContextPath() + USER_LIST_URL);
                return;
            }

            List<Roles> allRoles = roleDAO.getAllRoles();
            List<Roles> userRoles = roleDAO.getRolesByUserId(userId);

            request.setAttribute("user", user);
            request.setAttribute("allRoles", allRoles);
            request.setAttribute("userRoles", userRoles);
            request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + USER_LIST_URL);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdParam = request.getParameter("userId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String isActiveParam = request.getParameter("isActive");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String[] roleIds = request.getParameterValues("roleIds");
        
        Part imagePart = request.getPart("imageFile");
        String newImagePath = null;

        try {
            int userId = Integer.parseInt(userIdParam);
            Users user = userDAO.findUserById(userId);

            if (user == null) {
                response.sendRedirect(request.getContextPath() + USER_LIST_URL);
                return;
            }

            List<Roles> allRoles = roleDAO.getAllRoles();
            List<Roles> userRoles = roleDAO.getRolesByUserId(userId);
            request.setAttribute("user", user);
            request.setAttribute("allRoles", allRoles);
            request.setAttribute("userRoles", userRoles);

            if (fullName == null || email == null || fullName.trim().isEmpty() || email.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Full name and email are required.");
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            if (userDAO.isEmailExistsForOtherUser(email, userId)) {
                request.setAttribute("errorMessage", "Email already exists for another user.");
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            if (newPassword != null && !newPassword.isEmpty()) {
                if (!newPassword.equals(confirmPassword)) {
                    request.setAttribute("errorMessage", "Passwords do not match.");
                    request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                    return;
                }

                if (newPassword.length() < 6) {
                    request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
                    request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                    return;
                }

                String hashedPassword = PasswordHasher.hashPassword(newPassword);
                userDAO.updateUserPassword(userId, hashedPassword);
            }

            if (roleIds == null || roleIds.length == 0) {
                request.setAttribute("errorMessage", "Please select at least one role.");
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            try {
                if (imagePart != null && imagePart.getSize() > 0) {
                    String uploadPath = getServletContext().getRealPath("") + "uploads";
                    newImagePath = FileUploadUtil.saveFile(imagePart, uploadPath);
                    
                    if (user.getImage() != null && !user.getImage().isEmpty()) {
                        String webappPath = getServletContext().getRealPath("");
                        FileUploadUtil.deleteFile(user.getImage(), webappPath);
                    }
                }
            } catch (IOException e) {
                request.setAttribute("errorMessage", "Failed to upload image: " + e.getMessage());
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            if (newImagePath != null) {
                user.setImage(newImagePath);
            }
            user.setActive(isActiveParam != null && isActiveParam.equals("1"));

            boolean userUpdated = userDAO.updateUser(user);

            if (userUpdated) {
                int[] roleIdArray = new int[roleIds.length];
                for (int i = 0; i < roleIds.length; i++) {
                    roleIdArray[i] = Integer.parseInt(roleIds[i]);
                }
                roleDAO.updateUserRoles(userId, roleIdArray);
                response.sendRedirect(request.getContextPath() + USER_LIST_URL + "?updated=true");
            } else {
                request.setAttribute("errorMessage", "Failed to update user. Please try again.");
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + USER_LIST_URL);
        }
    }

}
