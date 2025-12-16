package controller.machine;

import dal.MachineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MachineUnit;

import java.io.IOException;

@WebServlet(name = "DeleteMachineServlet", urlPatterns = {"/mgr/delete-machine"})
public class DeleteMachineServlet extends HttpServlet {

    private static final String MACHINE_LIST_URL = "/mgr/machines";
    private final MachineDAO machineDAO = new MachineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String unitIdParam = request.getParameter("id");

        if (unitIdParam == null || unitIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + MACHINE_LIST_URL);
            return;
        }

        try {
            int unitId = Integer.parseInt(unitIdParam);
            MachineUnit machineUnit = machineDAO.getMachineUnitById(unitId);

            if (machineUnit == null) {
                response.sendRedirect(request.getContextPath() + MACHINE_LIST_URL);
                return;
            }

            // Soft delete - mark as inactive
            boolean success = machineDAO.deleteMachineUnit(unitId);

            if (success) {
                response.sendRedirect(request.getContextPath() + MACHINE_LIST_URL + "?deleted=true");
            } else {
                response.sendRedirect(request.getContextPath() + MACHINE_LIST_URL + "?error=delete_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + MACHINE_LIST_URL);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + MACHINE_LIST_URL + "?error=exception");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
