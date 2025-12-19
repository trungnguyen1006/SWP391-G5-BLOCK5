package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import model.Roles;

import java.io.IOException;
import java.util.List;

/**
 * AuthenticationFilter - Kiểm tra quyền truy cập dựa trên role
 * 
 * Luồng:
 * 1. Kiểm tra request có cần login không (public pages)
 * 2. Kiểm tra session có user không
 * 3. Kiểm tra user có active role không
 * 4. Kiểm tra role có quyền truy cập path không
 * 5. Cho phép hoặc từ chối request
 */
@WebFilter(urlPatterns = {"/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // ===== BƯỚC 1: Kiểm tra trang public (không cần login) =====
        if (isPublicPage(path)) {
            chain.doFilter(request, response);
            return;
        }

        // ===== BƯỚC 2: Kiểm tra trang chung (tất cả users đã login) =====
        if (isCommonPage(path)) {
            if (session == null || session.getAttribute("user") == null) {
                httpResponse.sendRedirect(contextPath + "/login");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // ===== BƯỚC 3: Kiểm tra session =====
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        List<Roles> roles = (List<Roles>) session.getAttribute("roles");

        // ===== BƯỚC 4: Kiểm tra role active =====
        if (roles == null || roles.isEmpty()) {
            session.invalidate();
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        boolean hasActiveRole = false;
        String userRole = null;
        for (Roles role : roles) {
            if (role.isActive()) {
                hasActiveRole = true;
                userRole = role.getRoleName().toUpperCase();
                break;
            }
        }

        if (!hasActiveRole) {
            session.invalidate();
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        // ===== BƯỚC 5: Kiểm tra quyền truy cập path =====
        if (!hasAccessToPath(path, userRole)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // ===== BƯỚC 6: Cho phép request =====
        chain.doFilter(request, response);
    }

    /**
     * Kiểm tra trang có phải public (không cần login) không
     */
    private boolean isPublicPage(String path) {
        return path.equals("/") || 
               path.equals("/login") || 
               path.equals("/register") || 
               path.equals("/logout") || 
               path.equals("/common/homepage.jsp") || 
               path.startsWith("/assets/") || 
               path.startsWith("/uploads/") || 
               path.startsWith("/common/") || 
               path.equals("/ForgotPassword.jsp") || 
               path.equals("/changePassword.jsp") || 
               path.equals("/access-denied.jsp");
    }

    /**
     * Kiểm tra trang có phải chung (tất cả users đã login) không
     */
    private boolean isCommonPage(String path) {
        return path.equals("/profile") || 
               path.equals("/change-password") || 
               path.equals("/edit-profile") || 
               path.equals("/changePassword");
    }

    /**
     * Kiểm tra role có quyền truy cập path không
     * 
     * Quy tắc:
     * - ADMIN: /admin, /common
     * - MANAGER: /mgr, /common
     * - EMPLOYEE: /employee, /common
     * - CUSTOMER: /customer, /common
     */
    private boolean hasAccessToPath(String path, String role) {
        if (role == null) return false;

        switch (role) {
            case "ADMIN":
                return path.startsWith("/admin") || path.startsWith("/common");
            case "MANAGER":
                return path.startsWith("/mgr") || path.startsWith("/common");
            case "EMPLOYEE":
                return path.startsWith("/employee") || path.startsWith("/common");
            case "CUSTOMER":
                return path.startsWith("/customer") || path.startsWith("/common");
            default:
                return false;
        }
    }

    @Override
    public void init(FilterConfig config) throws ServletException {}

    @Override
    public void destroy() {}
}
