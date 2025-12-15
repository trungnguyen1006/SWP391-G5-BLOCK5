package controller.invoice;

import dal.ContractDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Users;

import java.io.IOException;

@WebServlet("/sale/delete-contract")
public class DeleteContractServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("/login");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        try {
            int contractId = Integer.parseInt(request.getParameter("contractId"));
            int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));

            ContractDAO dao = new ContractDAO();
            boolean success = dao.cancelContractAndReturnUnits(
                    contractId,
                    warehouseId,
                    user.getUserId(),
                    "Cancelled by user"
            );

            if (success) {
                session.setAttribute("deleteSuccess",
                        "Contract has been cancelled successfully");
            } else {
                session.setAttribute("deleteError",
                        "Failed to cancel contract");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("deleteError",
                    "System error occurred");
        }
        response.sendRedirect(request.getContextPath() + "/sale/invoices");
    }
}
