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
        String statusParam = request.getParameter("status");
        String searchName = request.getParameter("searchName");
        String searchAddress = request.getParameter("searchAddress");
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

        int totalSites;
        List<Site> sites;
        
        if ((searchName != null && !searchName.isEmpty()) || (searchAddress != null && !searchAddress.isEmpty())) {
            totalSites = siteDAO.getTotalSitesWithSearch(searchName, searchAddress);
            sites = siteDAO.getSitesByPageWithSearch(currentPage, PAGE_SIZE, searchName, searchAddress);
        } else if (statusParam != null && !statusParam.isEmpty()) {
            totalSites = siteDAO.getTotalSitesWithFilter(statusParam);
            sites = siteDAO.getSitesByPageWithFilter(currentPage, PAGE_SIZE, statusParam);
        } else {
            totalSites = siteDAO.getTotalSites();
            sites = siteDAO.getSitesByPage(currentPage, PAGE_SIZE);
        }
        
        int totalPages = (int) Math.ceil((double) totalSites / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        
        request.setAttribute("sites", sites);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSites", totalSites);
        request.setAttribute("status", statusParam);
        request.setAttribute("searchName", searchName);
        request.setAttribute("searchAddress", searchAddress);
        
        request.getRequestDispatcher(SITE_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
