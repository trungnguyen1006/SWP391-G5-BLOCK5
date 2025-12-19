package controller.contract;

import dal.ContractDAO;
import dal.MachineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * AddContractServlet - Tạo hợp đồng thuê máy
 * 
 * Luồng:
 * 1. GET: Hiển thị form thêm hợp đồng
 * 2. POST: Validate input
 *    - Kiểm tra ngày start < end
 *    - Kiểm tra máy có status IN_STOCK không
 * 3. Tạo contract (status = DRAFT)
 * 4. Thêm contract items
 * 5. Cập nhật machine status từ IN_STOCK → ALLOCATED
 * 6. Redirect đến contract list
 */
@WebServlet(name = "AddContractServlet", urlPatterns = {"/employee/add-contract"})
public class AddContractServlet extends HttpServlet {

    private static final String ADD_CONTRACT_PAGE = "/employee/contract/add-contract.jsp";
    private static final String CONTRACT_LIST_URL = "/employee/contracts";
    private final ContractDAO contractDAO = new ContractDAO();
    private final MachineDAO machineDAO = new MachineDAO();

    /**
     * GET: Hiển thị form thêm hợp đồng
     * Load danh sách customers, sites, machines
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu cho form
        List<Customers> customers = contractDAO.getAllCustomers();
        List<Site> sites = contractDAO.getAllSites();
        List<MachineUnit> availableMachines = machineDAO.getAllMachineUnits();
        String nextContractCode = contractDAO.generateContractCode();
        
        request.setAttribute("customers", customers);
        request.setAttribute("sites", sites);
        request.setAttribute("availableMachines", availableMachines);
        request.setAttribute("nextContractCode", nextContractCode);
        request.getRequestDispatcher(ADD_CONTRACT_PAGE).forward(request, response);
    }

    /**
     * POST: Xử lý tạo hợp đồng
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== LẤY USER TỪ SESSION =====
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ===== LẤY DỮ LIỆU TỪ FORM =====
        String contractCode = request.getParameter("contractCode");
        String customerIdParam = request.getParameter("customerId");
        String siteIdParam = request.getParameter("siteId");
        String signedDateParam = request.getParameter("signedDate");
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");
        String note = request.getParameter("note");
        
        // Contract items (arrays)
        String[] unitIds = request.getParameterValues("unitId");
        String[] prices = request.getParameterValues("price");
        String[] deposits = request.getParameterValues("deposit");
        String[] deliveryDates = request.getParameterValues("deliveryDate");
        String[] returnDueDates = request.getParameterValues("returnDueDate");
        String[] itemNotes = request.getParameterValues("itemNote");

        // Chuẩn bị dữ liệu cho form nếu có lỗi
        List<Customers> customers = contractDAO.getAllCustomers();
        List<Site> sites = contractDAO.getAllSites();
        List<MachineUnit> availableMachines = machineDAO.getAllMachineUnits();
        request.setAttribute("customers", customers);
        request.setAttribute("sites", sites);
        request.setAttribute("availableMachines", availableMachines);

        // ===== VALIDATE INPUT =====

        // Kiểm tra required fields
        if (contractCode == null || contractCode.trim().isEmpty() || 
            customerIdParam == null || customerIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Contract code and customer are required.");
            request.getRequestDispatcher(ADD_CONTRACT_PAGE).forward(request, response);
            return;
        }

        // Kiểm tra contract code đã tồn tại
        if (contractDAO.isContractCodeExists(contractCode.trim())) {
            request.setAttribute("errorMessage", "Contract code already exists: " + contractCode);
            request.getRequestDispatcher(ADD_CONTRACT_PAGE).forward(request, response);
            return;
        }

        // Kiểm tra có ít nhất 1 máy
        if (unitIds == null || unitIds.length == 0) {
            request.setAttribute("errorMessage", "Please add at least one machine to the contract.");
            request.getRequestDispatcher(ADD_CONTRACT_PAGE).forward(request, response);
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdParam);
            
            // ===== TẠO CONTRACT OBJECT =====
            Contract contract = new Contract();
            contract.setContractCode(contractCode.trim());
            contract.setCustomerId(customerId);
            
            if (siteIdParam != null && !siteIdParam.isEmpty()) {
                contract.setSiteId(Integer.parseInt(siteIdParam));
            }
            
            // Parse dates
            LocalDate signedDate = null;
            if (signedDateParam != null && !signedDateParam.isEmpty()) {
                signedDate = LocalDate.parse(signedDateParam);
                contract.setSignedDate(signedDate);
            }
            
            LocalDate startDate = null;
            if (startDateParam != null && !startDateParam.isEmpty()) {
                startDate = LocalDate.parse(startDateParam);
                contract.setStartDate(startDate);
            }
            
            LocalDate endDate = null;
            if (endDateParam != null && !endDateParam.isEmpty()) {
                endDate = LocalDate.parse(endDateParam);
                contract.setEndDate(endDate);
            }
            
            // ===== VALIDATE DATES =====
            // Kiểm tra start date < end date
            if (startDate != null && endDate != null && startDate.isAfter(endDate)) {
                request.setAttribute("errorMessage", "Start date must be before end date.");
                request.getRequestDispatcher(ADD_CONTRACT_PAGE).forward(request, response);
                return;
            }
            
            contract.setStatus("DRAFT");
            contract.setNote(note);
            contract.setCreatedBy(currentUser.getUserId());

            // ===== TẠO CONTRACT =====
            int contractId = contractDAO.addContract(contract);
            
            if (contractId > 0) {
                // ===== THÊM CONTRACT ITEMS VÀ CẬP NHẬT MACHINE STATUS =====
                boolean allItemsAdded = true;
                
                for (int i = 0; i < unitIds.length; i++) {
                    if (unitIds[i] != null && !unitIds[i].isEmpty()) {
                        int unitId = Integer.parseInt(unitIds[i]);
                        
                        // ===== VALIDATE MACHINE STATUS =====
                        // Kiểm tra máy có status IN_STOCK không (chỉ máy IN_STOCK mới được thuê)
                        MachineUnit machine = machineDAO.getMachineUnitById(unitId);
                        if (machine == null || !machine.getCurrentStatus().equals("IN_STOCK")) {
                            request.setAttribute("errorMessage", "Machine " + unitId + " is not available for rental. Only machines with IN_STOCK status can be rented.");
                            request.getRequestDispatcher(ADD_CONTRACT_PAGE).forward(request, response);
                            return;
                        }
                        
                        // Tạo contract item
                        ContractItem item = new ContractItem();
                        item.setContractId(contractId);
                        item.setUnitId(unitId);
                        
                        if (prices != null && i < prices.length && prices[i] != null && !prices[i].isEmpty()) {
                            item.setPrice(new BigDecimal(prices[i]));
                        }
                        
                        if (deposits != null && i < deposits.length && deposits[i] != null && !deposits[i].isEmpty()) {
                            item.setDeposit(new BigDecimal(deposits[i]));
                        }
                        
                        if (deliveryDates != null && i < deliveryDates.length && deliveryDates[i] != null && !deliveryDates[i].isEmpty()) {
                            item.setDeliveryDate(LocalDate.parse(deliveryDates[i]));
                        }
                        
                        if (returnDueDates != null && i < returnDueDates.length && returnDueDates[i] != null && !returnDueDates[i].isEmpty()) {
                            item.setReturnDueDate(LocalDate.parse(returnDueDates[i]));
                        }
                        
                        if (itemNotes != null && i < itemNotes.length && itemNotes[i] != null && !itemNotes[i].isEmpty()) {
                            item.setNote(itemNotes[i]);
                        }
                        
                        int itemId = contractDAO.addContractItem(item);
                        if (itemId > 0) {
                            // ===== CẬP NHẬT MACHINE STATUS: IN_STOCK → ALLOCATED =====
                            boolean statusUpdated = machineDAO.updateMachineStatus(unitId, "ALLOCATED", null, null);
                            if (!statusUpdated) {
                                System.out.println("DEBUG: Failed to update machine status for unit " + unitId);
                                allItemsAdded = false;
                            }
                        } else {
                            allItemsAdded = false;
                        }
                    }
                }
                
                if (allItemsAdded) {
                    response.sendRedirect(request.getContextPath() + CONTRACT_LIST_URL + "?added=true");
                } else {
                    request.setAttribute("errorMessage", "Contract created but some items failed to add.");
                    request.getRequestDispatcher(ADD_CONTRACT_PAGE).forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Failed to create contract. Please try again.");
                request.getRequestDispatcher(ADD_CONTRACT_PAGE).forward(request, response);
            }

        } catch (NumberFormatException | DateTimeParseException e) {
            request.setAttribute("errorMessage", "Invalid input format: " + e.getMessage());
            request.getRequestDispatcher(ADD_CONTRACT_PAGE).forward(request, response);
        }
    }
}
