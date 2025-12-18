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

@WebServlet(name = "AddMachineModelServlet", urlPatterns = {"/mgr/add-machine-model"})
public class AddMachineModelServlet extends HttpServlet {

    private static final String ADD_MODEL_PAGE = "/mgr/machine/add-machine-model.jsp";
    private final MachineDAO machineDAO = new MachineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<MachineModel> machineModels = machineDAO.getAllMachineModels();
        request.setAttribute("machineModels", machineModels);
        request.getRequestDispatcher(ADD_MODEL_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String modelCode = request.getParameter("modelCode");
        String modelName = request.getParameter("modelName");
        String brand = request.getParameter("brand");
        String category = request.getParameter("category");
        String specs = request.getParameter("specs");

        // Reload form data for error cases
        List<MachineModel> machineModels = machineDAO.getAllMachineModels();
        request.setAttribute("machineModels", machineModels);

        // Validation
        if (modelCode == null || modelCode.trim().isEmpty() || 
            modelName == null || modelName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Model Code and Model Name are required.");
            request.getRequestDispatcher(ADD_MODEL_PAGE).forward(request, response);
            return;
        }

        try {
            MachineModel model = new MachineModel();
            model.setModelCode(modelCode.trim().toUpperCase());
            model.setModelName(modelName.trim());
            model.setBrand(brand != null ? brand.trim() : "");
            model.setCategory(category != null ? category.trim() : "");
            model.setSpecs(specs != null ? specs.trim() : "");
            model.setActive(true);

            int newModelId = machineDAO.addMachineModel(model);
            
            if (newModelId > 0) {
                response.sendRedirect(request.getContextPath() + "/mgr/add-machine-model?added=true");
            } else {
                request.setAttribute("errorMessage", "Failed to add machine model. Please try again.");
                request.getRequestDispatcher(ADD_MODEL_PAGE).forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = e.getMessage() != null ? e.getMessage() : "Unknown error occurred";
            request.setAttribute("errorMessage", "Error: " + errorMsg);
            request.getRequestDispatcher(ADD_MODEL_PAGE).forward(request, response);
        }
    }
}