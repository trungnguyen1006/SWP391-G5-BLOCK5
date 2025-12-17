package controller.contract;

import dal.ContractDAO;
import dal.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Contract;
import model.Customers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "TestContractServlet", urlPatterns = {"/test-contracts"})
public class TestContractServlet extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<html><head><title>Contract Debug</title><style>body{font-family:Arial;margin:20px;} .section{margin:20px 0; padding:10px; border:1px solid #ccc;} .error{color:red;} .success{color:green;}</style></head><body>");
        out.println("<h1>Contract Debug Test</h1>");

        try {
            // Test 1: Get all contracts
            List<Contract> allContracts = contractDAO.getContractsByPage(1, 100);
            out.println("<div class='section'>");
            out.println("<h2>Test 1: All Contracts (" + allContracts.size() + " found)</h2>");
            if (allContracts.isEmpty()) {
                out.println("<p class='error'>❌ No contracts in database</p>");
            } else {
                out.println("<p class='success'>✓ Contracts found:</p>");
                for (Contract c : allContracts) {
                    out.println("<p>&nbsp;&nbsp;- " + c.getContractCode() + " (Customer ID: " + c.getCustomerId() + ", Status: " + c.getStatus() + ")</p>");
                }
            }
            out.println("</div>");

            // Test 2: Get contracts for customer 1
            List<Contract> customerContracts = contractDAO.getContractsByCustomer(1, 1, 100);
            out.println("<div class='section'>");
            out.println("<h2>Test 2: Contracts for Customer ID 1 (" + customerContracts.size() + " found)</h2>");
            if (customerContracts.isEmpty()) {
                out.println("<p class='error'>❌ No contracts for customer 1</p>");
            } else {
                out.println("<p class='success'>✓ Contracts found:</p>");
                for (Contract c : customerContracts) {
                    out.println("<p>&nbsp;&nbsp;- " + c.getContractCode() + "</p>");
                }
            }
            out.println("</div>");

            // Test 3: Get customer by user ID
            Customers customer = customerDAO.getCustomerByUserId(5); // cust01 user ID
            out.println("<div class='section'>");
            out.println("<h2>Test 3: Customer lookup by User ID 5</h2>");
            if (customer == null) {
                out.println("<p class='error'>❌ No customer found for user ID 5</p>");
            } else {
                out.println("<p class='success'>✓ Customer found:</p>");
                out.println("<p>&nbsp;&nbsp;- Customer ID: " + customer.getCustomerId() + "</p>");
                out.println("<p>&nbsp;&nbsp;- Customer Name: " + customer.getCustomerName() + "</p>");
                out.println("<p>&nbsp;&nbsp;- Customer Code: " + customer.getCustomerCode() + "</p>");
                
                // Now get contracts for this customer
                List<Contract> userCustomerContracts = contractDAO.getContractsByCustomer(customer.getCustomerId(), 1, 100);
                out.println("<p>&nbsp;&nbsp;- Contracts for this customer: " + userCustomerContracts.size() + "</p>");
            }
            out.println("</div>");

            // Test 4: Total contracts
            int total = contractDAO.getTotalContracts();
            out.println("<div class='section'>");
            out.println("<h2>Test 4: Total Contracts in DB: " + total + "</h2>");
            out.println("</div>");

        } catch (Exception e) {
            out.println("<div class='section error'>");
            out.println("<h2>Error occurred:</h2>");
            out.println("<p>" + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
            out.println("</div>");
        }

        out.println("<div class='section'><p><a href='" + request.getContextPath() + "/customer/contracts'>Back to Contracts</a></p></div>");
        out.println("</body></html>");
    }
}
