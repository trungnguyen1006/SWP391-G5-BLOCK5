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

        // ===== VALIDATE INPUT - CHI TIẾT CHO TỪNG FIELD =====
        
        // Kiểm tra Model Code
        if (modelCode == null || modelCode.trim().isEmpty()) {
            request.setAttribute("errorMessage", "❌ Model Code is required. Please enter a model code (e.g., EXC001).");
            request.getRequestDispatcher(ADD_MODEL_PAGE).forward(request, response);
            return;
        }
        
        // Kiểm tra Model Name
        if (modelName == null || modelName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "❌ Model Name is required. Please enter a model name (e.g., Excavator CAT 320D).");
            request.getRequestDispatcher(ADD_MODEL_PAGE).forward(request, response);
            return;
        }
        
        // Kiểm tra Model Code có chứa số không
        if (!modelCode.matches(".*\\d.*")) {
            request.setAttribute("errorMessage", "❌ Model Code must contain at least one number (e.g., EXC001, CAT320).");
            request.getRequestDispatcher(ADD_MODEL_PAGE).forward(request, response);
            return;
        }
        
        // Kiểm tra độ dài Model Code
        if (modelCode.trim().length() > 50) {
            request.setAttribute("errorMessage", "❌ Model Code is too long. Maximum 50 characters allowed.");
            request.getRequestDispatcher(ADD_MODEL_PAGE).forward(request, response);
            return;
        }
        
        // Kiểm tra độ dài Model Name
        if (modelName.trim().length() > 100) {
            request.setAttribute("errorMessage", "❌ Model Name is too long. Maximum 100 characters allowed.");
            request.getRequestDispatcher(ADD_MODEL_PAGE).forward(request, response);
            return;
        }
        
        // Kiểm tra Brand độ dài
        if (brand != null && brand.trim().length() > 50) {
            request.setAttribute("errorMessage", "❌ Brand is too long. Maximum 50 characters allowed.");
            request.getRequestDispatcher(ADD_MODEL_PAGE).forward(request, response);
            return;
        }
        
        // Kiểm tra Specs độ dài
        if (specs != null && specs.trim().length() > 500) {
            request.setAttribute("errorMessage", "❌ Specifications is too long. Maximum 500 characters allowed.");
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
                request.setAttribute("errorMessage", "❌ Failed to add machine model. Please try again.");
                request.getRequestDispatcher(ADD_MODEL_PAGE).forward(request, response);
            }

        } catch (java.sql.SQLException sqlEx) {
            // ===== CATCH SQL EXCEPTION - THÔNG BÁO CHI TIẾT LỖI DATABASE =====
            String sqlErrorMsg = sqlEx.getMessage();
            String errorMessage = "❌ Database Error: ";
            
            // Phân tích lỗi SQL để thông báo chi tiết
            if (sqlErrorMsg != null) {
                if (sqlErrorMsg.contains("Duplicate entry") || sqlErrorMsg.contains("UNIQUE")) {
                    errorMessage += "Model Code already exists. Please use a different code.";
                } else if (sqlErrorMsg.contains("Data too long")) {
                    errorMessage += "One of the fields contains too much data. Please check your input.";
                } else if (sqlErrorMsg.contains("Column") && sqlErrorMsg.contains("cannot be null")) {
                    errorMessage += "A required field is missing or empty.";
                } else if (sqlErrorMsg.contains("Connection")) {
                    errorMessage += "Cannot connect to database. Please try again later.";
                } else {
                    errorMessage += sqlErrorMsg;
                }
            } else {
                errorMessage += "Unknown database error occurred.";
            }
            
            System.out.println("DEBUG: SQL Error - " + sqlErrorMsg);
            sqlEx.printStackTrace();
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher(ADD_MODEL_PAGE).forward(request, response);
            
        } catch (Exception e) {
            // ===== CATCH OTHER EXCEPTIONS =====
            e.printStackTrace();
            String errorMsg = e.getMessage() != null ? e.getMessage() : "Unknown error occurred";
            request.setAttribute("errorMessage", "❌ Error: " + errorMsg);
            request.getRequestDispatcher(ADD_MODEL_PAGE).forward(request, response);
        }
    }
}