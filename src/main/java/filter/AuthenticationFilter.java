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

        // Các trang không cần login
        if (path.equals("/") || path.equals("/login") || path.equals("/register") || path.equals("/logout") || path.equals("/common/homepage.jsp") || 
            path.startsWith("/assets/") || path.startsWith("/uploads/") || path.startsWith("/common/") || path.equals("/ForgotPassword.jsp") || 
            path.equals("/changePassword.jsp") || path.equals("/access-denied.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // Các trang có thể truy cập bởi tất cả users đã login (không cần kiểm tra role)
        if (path.equals("/profile") || path.equals("/change-password") || path.equals("/edit-profile") || 
            path.equals("/changePassword")) {
            // Kiểm tra session
            if (session == null || session.getAttribute("user") == null) {
                httpResponse.sendRedirect(contextPath + "/login");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // Kiểm tra session
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        List<Roles> roles = (List<Roles>) session.getAttribute("roles");

        // Kiểm tra role có active không
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

        // Check role access
        if (!hasAccessToPath(path, userRole)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean hasAccessToPath(String path, String role) {
        if (role == null) {
            return false;
        }

        // ADMIN - có quyền truy cập /admin
        if (role.equals("ADMIN")) {
            return path.startsWith("/admin") || path.startsWith("/common");
        }

        // MANAGER - có quyền truy cập /mgr
        if (role.equals("MANAGER")) {
            return path.startsWith("/mgr") || path.startsWith("/common");
        }

        // EMPLOYEE - có quyền truy cập /employee
        if (role.equals("EMPLOYEE")) {
            return path.startsWith("/employee") || path.startsWith("/common");
        }

        // CUSTOMER - có quyền truy cập /customer
        if (role.equals("CUSTOMER")) {
            return path.startsWith("/customer") || path.startsWith("/common");
        }

        return false;
    }

    @Override
    public void init(FilterConfig config) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}
