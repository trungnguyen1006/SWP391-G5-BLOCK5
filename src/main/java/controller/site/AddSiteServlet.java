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
import model.Customers;
import model.Users;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddSiteServlet", urlPatterns = {"/mgr/add-site"})
public class AddSiteServlet extends HttpServlet {

    private static final String ADD_SITE_PAGE = "/mgr/site/add-site.jsp";
    private static final String SITE_LIST_URL = "sites";
    private final SiteDAO siteDAO = new SiteDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Load customers for dropdown
        List<Customers> customers = customerDAO.getAllCustomers();
        String nextSiteCode = siteDAO.generateSiteCode();
        
        request.setAttribute("customers", customers);
        request.setAttribute("nextSiteCode", nextSiteCode);
        request.getRequestDispatcher(ADD_SITE_PAGE).forward(request, response);
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

        String siteCode = request.getParameter("siteCode");
        String siteName = request.getParameter("siteName");
        String address = request.getParameter("address");
        String customerIdParam = request.getParameter("customerId");

        // Reload form data for error cases
        List<Customers> customers = customerDAO.getAllCustomers();
        request.setAttribute("customers", customers);

        // Validation
        if (siteCode == null || siteCode.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Site code is required.");
            request.getRequestDispatcher(ADD_SITE_PAGE).forward(request, response);
            return;
        }

        if (siteName == null || siteName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Site name is required.");
            request.getRequestDispatcher(ADD_SITE_PAGE).forward(request, response);
            return;
        }

        if (siteDAO.isSiteCodeExists(siteCode.trim())) {
            request.setAttribute("errorMessage", "Site code already exists: " + siteCode);
            request.getRequestDispatcher(ADD_SITE_PAGE).forward(request, response);
            return;
        }

        try {
            Site site = new Site();
            site.setSiteCode(siteCode.trim());
            site.setSiteName(siteName.trim());
            site.setAddress(address != null ? address.trim() : "");
            
            if (customerIdParam != null && !customerIdParam.isEmpty()) {
                site.setCustomerId(Integer.parseInt(customerIdParam));
            }
            
            site.setActive(true);

            int siteId = siteDAO.addSite(site);
            
            if (siteId > 0) {
                response.sendRedirect(request.getContextPath() + "/mgr/" + SITE_LIST_URL + "?added=true");
            } else {
                request.setAttribute("errorMessage", "Failed to create site. Please try again.");
                request.getRequestDispatcher(ADD_SITE_PAGE).forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input format: " + e.getMessage());
            request.getRequestDispatcher(ADD_SITE_PAGE).forward(request, response);
        }
    }

}
