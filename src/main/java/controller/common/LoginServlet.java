package controller.common;

import dal.RoleDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.*;

import model.Roles;
import model.Users;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})

public class LoginServlet extends HttpServlet {

    private static final String LOGIN_PAGE = "common/login.jsp";
    private static final String ADMIN_HOME = "/admin/dashboard";
    private static final String MANAGER_HOME = "/mgr/dashboard";
    private static final String EMPLOYEE_HOME = "/employee/dashboard";
    private static final String CUSTOMER_HOME = "/customer/dashboard";
    private static final String DEFAULT_HOME = "/common/homepage.jsp";

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberedUsername".equals(cookie.getName())) {
                    request.setAttribute("rememberedUsername", cookie.getValue());
                }
            }
        }

        request.getRequestDispatcher(LOGIN_PAGE).forward(request, response);
    }

    @Override

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

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

                if ("on".equals(rememberMe)) {
                    Cookie usernameCookie = new Cookie("rememberedUsername", username);
                    usernameCookie.setMaxAge(30 * 24 * 60 * 60);
                    usernameCookie.setPath(request.getContextPath() + "/");
                    response.addCookie(usernameCookie);
                } else {
                    Cookie usernameCookie = new Cookie("rememberedUsername", "");
                    usernameCookie.setMaxAge(0);
                    usernameCookie.setPath(request.getContextPath() + "/");
                    response.addCookie(usernameCookie);
                }

                // If no roles found, try to assign default role based on user
                if (userRoles == null || userRoles.isEmpty()) {
                    // Check if user has any role in database
                    userRoles = roleDAO.getRolesByUserId(user.getUserId());
                    
                    // If still no roles, assign CUSTOMER role as default
                    if (userRoles == null || userRoles.isEmpty()) {
                        roleDAO.assignDefaultRole(user.getUserId(), 4); // Role ID 4 for CUSTOMER
                        userRoles = roleDAO.getRolesByUserId(user.getUserId());
                    }
                }
                
                String redirectUrl = getRedirectUrlByRole(userRoles);
                response.sendRedirect(request.getContextPath() + redirectUrl);
                return;
            } else {
                errorMessage = "Incorrect password.";
            }
        }

        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher(LOGIN_PAGE).forward(request, response);
    }

    private String getRedirectUrlByRole(List<Roles> roles) {
        if (roles == null || roles.isEmpty()) {
            System.out.println("DEBUG: No roles found, returning DEFAULT_HOME");
            return DEFAULT_HOME;
        }
        
        System.out.println("DEBUG: Found " + roles.size() + " roles");
        
        // Priority order: ADMIN > MANAGER > EMPLOYEE > CUSTOMER
        boolean hasAdmin = false;
        boolean hasManager = false;
        boolean hasEmployee = false;
        boolean hasCustomer = false;
        
        for (Roles role : roles) {
            if (role == null || role.getRoleName() == null) {
                continue;
            }
            String roleName = role.getRoleName().trim().toUpperCase();
            System.out.println("DEBUG: Role name = '" + roleName + "'");
            
            if ("ADMIN".equals(roleName)) {
                hasAdmin = true;
            } else if ("MANAGER".equals(roleName)) {
                hasManager = true;
            } else if ("EMPLOYEE".equals(roleName)) {
                hasEmployee = true;
            } else if ("CUSTOMER".equals(roleName)) {
                hasCustomer = true;
            }
        }
        
        System.out.println("DEBUG: hasAdmin=" + hasAdmin + ", hasManager=" + hasManager + 
                         ", hasEmployee=" + hasEmployee + ", hasCustomer=" + hasCustomer);
        
        // Return based on priority
        if (hasAdmin) {
            return ADMIN_HOME;
        } else if (hasManager) {
            return MANAGER_HOME;
        } else if (hasEmployee) {
            return EMPLOYEE_HOME;
        } else if (hasCustomer) {
            return CUSTOMER_HOME;
        }
        
        return DEFAULT_HOME;
    }

}
