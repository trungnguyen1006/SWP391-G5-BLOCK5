package controller.site;

import dal.SiteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

import java.io.IOException;

@WebServlet(name = "DeleteSiteServlet", urlPatterns = {"/mgr/delete-site"})
public class DeleteSiteServlet extends HttpServlet {

    private static final String SITE_LIST_URL = "sites";
    private final SiteDAO siteDAO = new SiteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String siteIdParam = request.getParameter("id");
        
        if (siteIdParam == null || siteIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/" + SITE_LIST_URL);
            return;
        }

        try {
            int siteId = Integer.parseInt(siteIdParam);
            
            if (siteDAO.deleteSite(siteId)) {
                response.sendRedirect(request.getContextPath() + "/manager/" + SITE_LIST_URL + "?deleted=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/manager/" + SITE_LIST_URL + "?error=true");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/mgr/" + SITE_LIST_URL);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
