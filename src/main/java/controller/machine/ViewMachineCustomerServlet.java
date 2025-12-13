package controller.machine;

import dal.MachineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MachineModel;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewMachineCustomerServlet", urlPatterns = {"/customer/machines"})
public class ViewMachineCustomerServlet extends HttpServlet {

    private static final String MACHINE_LIST_PAGE = "machine/view-machine-customer.jsp";
    private final MachineDAO machineDAO = new MachineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Customer chỉ xem được thông tin model, không xem serial number
        List<MachineModel> machineModels = machineDAO.getAllMachineModels();
        
        request.setAttribute("machineModels", machineModels);
        request.getRequestDispatcher(MACHINE_LIST_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}