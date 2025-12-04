package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Roles;

import java.io.IOException;
import java.util.List;

@WebFilter(filterName = "AdminAuthFilter", urlPatterns = {"/admin/*"})
public class AdminAuthFilter implements Filter {

    private static final String LOGIN_PAGE = "/login";
    private static final String ACCESS_DENIED_PAGE = "/access-denied.jsp";
    private static final String ADMIN_ROLE = "Admin";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + LOGIN_PAGE);
            return;
        }

        @SuppressWarnings("unchecked")
        List<Roles> userRoles = (List<Roles>) session.getAttribute("roles");

        if (userRoles == null || !hasAdminRole(userRoles)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + ACCESS_DENIED_PAGE);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }

    private boolean hasAdminRole(List<Roles> roles) {
        for (Roles role : roles) {
            if (ADMIN_ROLE.equalsIgnoreCase(role.getRoleName())) {
                return true;
            }
        }
        return false;
    }

}
