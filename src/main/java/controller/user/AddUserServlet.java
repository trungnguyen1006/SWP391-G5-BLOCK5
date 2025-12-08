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

@WebServlet(name = "AddUserServlet", urlPatterns = {"/admin/add-user"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class AddUserServlet extends HttpServlet {

    private static final String ADD_USER_PAGE = "user-manage/add-user.jsp";
    private static final String USER_LIST_URL = "user-list";

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Roles> allRoles = roleDAO.getAllRoles();
        request.setAttribute("allRoles", allRoles);
        request.getRequestDispatcher(ADD_USER_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String isActiveParam = request.getParameter("isActive");
        String[] roleIds = request.getParameterValues("roleIds");
        
        Part imagePart = request.getPart("imageFile");
        String imagePath = null;

        List<Roles> allRoles = roleDAO.getAllRoles();
        request.setAttribute("allRoles", allRoles);

        if (fullName == null || email == null || username == null || 
            password == null || confirmPassword == null ||
            fullName.trim().isEmpty() || email.trim().isEmpty() || 
            username.trim().isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher(ADD_USER_PAGE).forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher(ADD_USER_PAGE).forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            request.getRequestDispatcher(ADD_USER_PAGE).forward(request, response);
            return;
        }

        if (userDAO.isUserExists(username, email)) {
            request.setAttribute("errorMessage", "Username or email already exists.");
            request.getRequestDispatcher(ADD_USER_PAGE).forward(request, response);
            return;
        }

        if (roleIds == null || roleIds.length == 0) {
            request.setAttribute("errorMessage", "Please select at least one role.");
            request.getRequestDispatcher(ADD_USER_PAGE).forward(request, response);
            return;
        }

        try {
            if (imagePart != null && imagePart.getSize() > 0) {
                String realPath = getServletContext().getRealPath("/");
                String webappPath = FileUploadUtil.getSourceWebappPath(realPath);
                String uploadPath = webappPath + "uploads";
                imagePath = FileUploadUtil.saveFile(imagePart, uploadPath);
            }
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Failed to upload image: " + e.getMessage());
            request.getRequestDispatcher(ADD_USER_PAGE).forward(request, response);
            return;
        }

        Users newUser = new Users();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setFullName(fullName);
        newUser.setPhone(phone);
        newUser.setImage(imagePath);
        newUser.setActive(isActiveParam != null && isActiveParam.equals("1"));

        String hashedPassword = PasswordHasher.hashPassword(password);
        int newUserId = userDAO.createNewUser(newUser, hashedPassword);

        if (newUserId > 0) {
            int[] roleIdArray = new int[roleIds.length];
            for (int i = 0; i < roleIds.length; i++) {
                roleIdArray[i] = Integer.parseInt(roleIds[i]);
            }
            roleDAO.assignRolesToUser(newUserId, roleIdArray);
            response.sendRedirect(request.getContextPath() + USER_LIST_URL + "?added=true");
        } else {
            request.setAttribute("errorMessage", "Failed to create user. Please try again.");
            request.getRequestDispatcher(ADD_USER_PAGE).forward(request, response);
        }
    }

}
