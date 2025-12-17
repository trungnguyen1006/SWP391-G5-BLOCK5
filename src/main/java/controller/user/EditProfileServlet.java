package controller.user;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Users;
import util.FileUploadUtil;

import java.io.IOException;

@WebServlet(name = "EditProfileServlet", urlPatterns = {"/edit-profile"})
@MultipartConfig(maxFileSize = 5242880)
public class EditProfileServlet extends HttpServlet {

    private static final String EDIT_PROFILE_PAGE = "/edit-profile.jsp";
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("user", currentUser);
        request.getRequestDispatcher(EDIT_PROFILE_PAGE).forward(request, response);
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

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        Part imagePart = request.getPart("image");

        // Validation
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Full name is required.");
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher(EDIT_PROFILE_PAGE).forward(request, response);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email is required.");
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher(EDIT_PROFILE_PAGE).forward(request, response);
            return;
        }

        try {
            Users updatedUser = new Users();
            updatedUser.setUserId(currentUser.getUserId());
            updatedUser.setFullName(fullName.trim());
            updatedUser.setEmail(email.trim());
            updatedUser.setPhone(phone != null ? phone.trim() : "");
            updatedUser.setUsername(currentUser.getUsername());
            updatedUser.setPassword(currentUser.getPassword());
            updatedUser.setActive(currentUser.isActive());

            // Handle image upload
            if (imagePart != null && imagePart.getSize() > 0) {
                try {
                    String uploadPath = FileUploadUtil.getSourceWebappPath(request.getServletContext().getRealPath("/")) + "uploads";
                    String fileName = FileUploadUtil.saveFile(imagePart, uploadPath);
                    if (fileName != null && !fileName.isEmpty()) {
                        updatedUser.setImage(fileName);
                    } else {
                        updatedUser.setImage(currentUser.getImage());
                    }
                } catch (Exception e) {
                    updatedUser.setImage(currentUser.getImage());
                }
            } else {
                updatedUser.setImage(currentUser.getImage());
            }

            boolean success = userDAO.updateUser(updatedUser);

            if (success) {
                // Update session with new user data
                updatedUser.setCreatedDate(currentUser.getCreatedDate());
                session.setAttribute("user", updatedUser);
                response.sendRedirect(request.getContextPath() + "/profile?updated=true");
            } else {
                request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
                request.setAttribute("user", currentUser);
                request.getRequestDispatcher(EDIT_PROFILE_PAGE).forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher(EDIT_PROFILE_PAGE).forward(request, response);
        }
    }
}
