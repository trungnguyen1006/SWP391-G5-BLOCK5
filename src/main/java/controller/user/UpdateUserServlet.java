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
import util.Validator;

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
        String roleId = request.getParameter("roleId");
        
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

            if (!Validator.isValidFullName(fullName)) {
                request.setAttribute("errorMessage", Validator.getFullNameErrorMessage());
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            if (!Validator.isValidEmail(email)) {
                request.setAttribute("errorMessage", Validator.getEmailErrorMessage());
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            if (phone != null && !phone.trim().isEmpty() && !Validator.isValidPhone(phone)) {
                request.setAttribute("errorMessage", Validator.getPhoneErrorMessage());
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            if (userDAO.isEmailExistsForOtherUser(email, userId)) {
                request.setAttribute("errorMessage", "Email already exists for another user.");
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            // Password change is disabled - do not allow password updates
            // Password fields are ignored in admin user management

            if (roleId == null || roleId.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Please select a role.");
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            // Check if trying to assign Admin role (roleId = 1)
            if (roleId.equals("1")) {
                request.setAttribute("errorMessage", "Cannot assign Admin role to users.");
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            try {
                if (imagePart != null && imagePart.getSize() > 0) {
                    String realPath = getServletContext().getRealPath("/");
                    String webappPath = FileUploadUtil.getSourceWebappPath(realPath);
                    String uploadPath = webappPath + "uploads";
                    newImagePath = FileUploadUtil.saveFile(imagePart, uploadPath);
                    
                    if (user.getImage() != null && !user.getImage().isEmpty()) {
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
                int assignedRoleId = Integer.parseInt(roleId);
                Roles selectedRole = roleDAO.findRoleById(assignedRoleId);
                
                // Only assign role if it's active
                if (selectedRole != null && selectedRole.isActive()) {
                    roleDAO.removeAllUserRoles(userId);
                    roleDAO.assignDefaultRole(userId, assignedRoleId);
                    response.sendRedirect(request.getContextPath() + "/admin/user-list?updated=true");
                } else {
                    request.setAttribute("errorMessage", "Selected role is not active. Please select an active role.");
                    request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Failed to update user. Please try again.");
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + USER_LIST_URL);
        }
    }

}
