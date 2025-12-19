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

/**
 * LoginServlet - Xử lý đăng nhập người dùng
 * 
 * Luồng:
 * 1. Tìm user theo username
 * 2. Kiểm tra user active + password đúng
 * 3. Lấy roles của user, nếu không có thì assign CUSTOMER mặc định
 * 4. Kiểm tra có active role không
 * 5. Filter chỉ giữ 1 active role (priority: ADMIN > MANAGER > EMPLOYEE > CUSTOMER)
 * 6. Tạo session với user + roles
 * 7. Redirect đến dashboard tương ứng với role
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    // Định nghĩa các trang
    private static final String LOGIN_PAGE = "common/login.jsp";
    private static final String ADMIN_HOME = "/admin/dashboard";
    private static final String MANAGER_HOME = "/mgr/dashboard";
    private static final String EMPLOYEE_HOME = "/employee/dashboard";
    private static final String CUSTOMER_HOME = "/customer/dashboard";
    private static final String DEFAULT_HOME = "/common/homepage.jsp";

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    /**
     * GET: Hiển thị login form
     * Kiểm tra cookie "rememberedUsername" để auto-fill username
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy username từ cookie nếu có
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

    /**
     * POST: Xử lý đăng nhập
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        // Tìm user theo username
        Users user = userDAO.findUserByUsername(username);
        String errorMessage = null;

        // Kiểm tra user tồn tại
        if (user == null) {
            errorMessage = "Username does not exist.";
        } 
        // Kiểm tra user active
        else if (!user.isActive()) {
            errorMessage = "Your account has been locked or not activated.";
        } 
        // Kiểm tra password
        else if (!PasswordHasher.checkPassword(password, user.getPassword())) {
            errorMessage = "Incorrect password.";
        } 
        // Đăng nhập thành công
        else {
            // Lấy roles của user
            List<Roles> userRoles = roleDAO.getRolesByUserId(user.getUserId());
            
            // Nếu không có role, assign CUSTOMER mặc định
            if (userRoles == null || userRoles.isEmpty()) {
                roleDAO.assignDefaultRole(user.getUserId(), 4); // Role ID 4 = CUSTOMER
                userRoles = roleDAO.getRolesByUserId(user.getUserId());
            }
            
            // Kiểm tra có active role không
            boolean hasActiveRole = false;
            if (userRoles != null && !userRoles.isEmpty()) {
                for (Roles role : userRoles) {
                    if (role.isActive()) {
                        hasActiveRole = true;
                        break;
                    }
                }
            }
            
            // Nếu tất cả roles đều inactive
            if (!hasActiveRole && userRoles != null && !userRoles.isEmpty()) {
                errorMessage = "Your roles have been deactivated. Please contact administrator.";
            } 
            // Đăng nhập thành công
            else {
                // Filter: chỉ giữ 1 active role (priority: ADMIN > MANAGER > EMPLOYEE > CUSTOMER)
                if (userRoles != null && userRoles.size() > 1) {
                    Roles primaryRole = null;
                    for (Roles role : userRoles) {
                        if (role.isActive()) {
                            primaryRole = role;
                            break;
                        }
                    }
                    if (primaryRole != null) {
                        userRoles.clear();
                        userRoles.add(primaryRole);
                    }
                }
                
                // Tạo session với user + roles
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("roles", userRoles);
                System.out.println("DEBUG LoginServlet: Session set - user=" + user.getUsername() + ", roles=" + (userRoles != null ? userRoles.size() : 0));

                // Xử lý "Remember me" checkbox
                if ("on".equals(rememberMe)) {
                    Cookie usernameCookie = new Cookie("rememberedUsername", username);
                    usernameCookie.setMaxAge(30 * 24 * 60 * 60); // 30 ngày
                    usernameCookie.setPath(request.getContextPath() + "/");
                    response.addCookie(usernameCookie);
                } else {
                    // Xóa cookie nếu không check "Remember me"
                    Cookie usernameCookie = new Cookie("rememberedUsername", "");
                    usernameCookie.setMaxAge(0);
                    usernameCookie.setPath(request.getContextPath() + "/");
                    response.addCookie(usernameCookie);
                }
                
                // Redirect đến dashboard tương ứng
                String redirectUrl = getRedirectUrlByRole(userRoles);
                response.sendRedirect(request.getContextPath() + redirectUrl);
                return;
            }
        }

        // Nếu có lỗi, quay lại login form
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher(LOGIN_PAGE).forward(request, response);
    }

    /**
     * Xác định URL redirect dựa trên role
     * Priority: ADMIN > MANAGER > EMPLOYEE > CUSTOMER
     */
    private String getRedirectUrlByRole(List<Roles> roles) {
        if (roles == null || roles.isEmpty()) {
            return DEFAULT_HOME;
        }
        
        // Kiểm tra role nào có
        boolean hasAdmin = false, hasManager = false, hasEmployee = false, hasCustomer = false;
        
        for (Roles role : roles) {
            if (role == null || role.getRoleName() == null) continue;
            
            String roleName = role.getRoleName().trim().toUpperCase();
            if ("ADMIN".equals(roleName)) hasAdmin = true;
            else if ("MANAGER".equals(roleName)) hasManager = true;
            else if ("EMPLOYEE".equals(roleName)) hasEmployee = true;
            else if ("CUSTOMER".equals(roleName)) hasCustomer = true;
        }
        
        // Return dựa trên priority
        if (hasAdmin) return ADMIN_HOME;
        if (hasManager) return MANAGER_HOME;
        if (hasEmployee) return EMPLOYEE_HOME;
        if (hasCustomer) return CUSTOMER_HOME;
        
        return DEFAULT_HOME;
    }
}
