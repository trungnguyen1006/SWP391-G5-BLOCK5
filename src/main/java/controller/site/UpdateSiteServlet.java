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
import model.Customer;
import model.Customers;
import model.Users;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UpdateSiteServlet", urlPatterns = {"/mgr/update-site"})
public class UpdateSiteServlet extends HttpServlet {

    private static final String UPDATE_SITE_PAGE = "/mgr/site/update-site.jsp";
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
            Site site = siteDAO.getSiteById(siteId);
            
            if (site == null) {
                response.sendRedirect(request.getContextPath() + "/admin/" + SITE_LIST_URL);
                return;
            }

            // Load customers for dropdown
            List<Customer> customers = getAllCustomers();
            
            request.setAttribute("site", site);
            request.setAttribute("customers", customers);
            request.getRequestDispatcher(UPDATE_SITE_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/" + SITE_LIST_URL);
        }
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

        String siteIdParam = request.getParameter("siteId");
        String siteCode = request.getParameter("siteCode");
        String siteName = request.getParameter("siteName");
        String address = request.getParameter("address");
        String customerIdParam = request.getParameter("customerId");

        // Reload form data for error cases
        List<Customer> customers = getAllCustomers();
        request.setAttribute("customers", customers);

        // Validation
        if (siteIdParam == null || siteIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Site ID is required.");
            request.getRequestDispatcher(UPDATE_SITE_PAGE).forward(request, response);
            return;
        }

        if (siteCode == null || siteCode.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Site code is required.");
            request.getRequestDispatcher(UPDATE_SITE_PAGE).forward(request, response);
            return;
        }

        if (siteName == null || siteName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Site name is required.");
            request.getRequestDispatcher(UPDATE_SITE_PAGE).forward(request, response);
            return;
        }

        try {
            int siteId = Integer.parseInt(siteIdParam);
            
            // Check if site code exists for other site
            if (siteDAO.isSiteCodeExistsForOtherSite(siteCode.trim(), siteId)) {
                request.setAttribute("errorMessage", "Site code already exists: " + siteCode);
                Site site = siteDAO.getSiteById(siteId);
                request.setAttribute("site", site);
                request.getRequestDispatcher(UPDATE_SITE_PAGE).forward(request, response);
                return;
            }

            Site site = new Site();
            site.setSiteId(siteId);
            site.setSiteCode(siteCode.trim());
            site.setSiteName(siteName.trim());
            site.setAddress(address != null ? address.trim() : "");
            
            if (customerIdParam != null && !customerIdParam.isEmpty()) {
                site.setCustomerId(Integer.parseInt(customerIdParam));
            }

            if (siteDAO.updateSite(site)) {
                response.sendRedirect(request.getContextPath() + "/mgr/" + SITE_LIST_URL + "?updated=true");
            } else {
                request.setAttribute("errorMessage", "Failed to update site. Please try again.");
                site = siteDAO.getSiteById(siteId);
                request.setAttribute("site", site);
                request.getRequestDispatcher(UPDATE_SITE_PAGE).forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input format: " + e.getMessage());
            request.getRequestDispatcher(UPDATE_SITE_PAGE).forward(request, response);
        }
    }

    private List<Customer> getAllCustomers() {
        CustomerDAO customerDAO = new CustomerDAO();
        List<Customers> customersList = customerDAO.getAllCustomers();
        List<Customer> result = new java.util.ArrayList<>();
        for (Customers c : customersList) {
            Customer customer = new Customer();
            customer.setCustomerId(c.getCustomerId());
            customer.setCustomerCode(c.getCustomerCode());
            customer.setCustomerName(c.getCustomerName());
            customer.setAddress(c.getAddress());
            customer.setContactName(c.getContactName());
            customer.setContactPhone(c.getContactPhone());
            customer.setContactEmail(c.getContactEmail());
            customer.setActive(c.isActive());
            result.add(customer);
        }
        return result;
    }
}
