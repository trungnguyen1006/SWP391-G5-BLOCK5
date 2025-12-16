package controller.site;

import dal.SiteDAO;
import dal.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Site;
import model.Users;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewSiteListServlet", urlPatterns = {"/mgr/sites"})
public class ViewSiteListServlet extends HttpServlet {

    private static final String SITE_LIST_PAGE = "/mgr/site/view-site-list.jsp";
    private static final int PAGE_SIZE = 10;
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

        String pageParam = request.getParameter("page");
        int currentPage = 1;
        
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int totalSites = siteDAO.getTotalSites();
        int totalPages = (int) Math.ceil((double) totalSites / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        List<Site> sites = siteDAO.getSitesByPage(currentPage, PAGE_SIZE);
        
        request.setAttribute("sites", sites);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSites", totalSites);
        
        request.getRequestDispatcher(SITE_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
