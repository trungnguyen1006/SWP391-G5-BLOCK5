package controller.machine;

import dal.MachineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MachineModel;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

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
        
        // ===== VALIDATE SPECS - PHẢI LÀ JSON HOẶC NULL =====
        String specsJson = null;
        if (specs != null && !specs.trim().isEmpty()) {
            specs = specs.trim();
            // Nếu specs không phải JSON format, convert thành JSON object
            if (!specs.startsWith("{") && !specs.startsWith("[")) {
                // Nếu là plain text, convert thành JSON object: {"description": "text"}
                // Escape special characters properly for JSON
                String escapedSpecs = specs
                    .replace("\\", "\\\\")  // Escape backslash first
                    .replace("\"", "\\\"")  // Escape double quotes
                    .replace("\n", "\\n")   // Escape newlines
                    .replace("\r", "\\r")   // Escape carriage returns
                    .replace("\t", "\\t");  // Escape tabs
                specsJson = "{\"description\": \"" + escapedSpecs + "\"}";
            } else {
                // Nếu đã là JSON, validate format using Gson
                try {
                    Gson gson = new Gson();
                    gson.fromJson(specs, Object.class);
                    specsJson = specs;
                } catch (JsonSyntaxException e) {
                    request.setAttribute("errorMessage", "❌ Specifications must be valid JSON format or plain text.");
                    request.getRequestDispatcher(ADD_MODEL_PAGE).forward(request, response);
                    return;
                }
            }
        }

        try {
            MachineModel model = new MachineModel();
            model.setModelCode(modelCode.trim().toUpperCase());
            model.setModelName(modelName.trim());
            model.setBrand(brand != null ? brand.trim() : "");
            model.setCategory(category != null ? category.trim() : "");
            model.setSpecs(specsJson != null ? specsJson : "");
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
                } else if (sqlErrorMsg.contains("Invalid JSON")) {
                    errorMessage += "Specifications contains invalid JSON format. Please check your input.";
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