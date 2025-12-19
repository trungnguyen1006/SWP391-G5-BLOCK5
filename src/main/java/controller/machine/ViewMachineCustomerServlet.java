package controller.machine;

import dal.ContractDAO;
import dal.MachineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.MachineModel;
import model.Users;

import java.io.IOException;
import java.util.List;

/**
 * ViewMachineCustomerServlet - Hiển thị danh sách máy cho customer
 * 
 * Luồng:
 * 1. Lấy user từ session
 * 2. Lấy danh sách máy từ các hợp đồng của customer
 * 3. Phân trang (10 máy/trang)
 * 4. Forward đến JSP
 * 
 * Lưu ý: Customer chỉ thấy máy từ các hợp đồng của họ, không thấy tất cả máy
 */
@WebServlet(name = "ViewMachineCustomerServlet", urlPatterns = {"/customer/machines"})
public class ViewMachineCustomerServlet extends HttpServlet {

    private static final String MACHINE_LIST_PAGE = "machine/view-machine-customer.jsp";
    private static final int PAGE_SIZE = 10; // 10 máy trên 1 trang
    private final MachineDAO machineDAO = new MachineDAO();
    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===== LẤY USER TỪ SESSION =====
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ===== LẤY PAGE NUMBER =====
        String pageParam = request.getParameter("page");
        int currentPage = 1;
        
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        // ===== LẤY MÁY TỪ HỢP ĐỒNG CỦA CUSTOMER =====
        // Chỉ lấy máy từ các hợp đồng của customer, không phải tất cả máy
        List<MachineModel> machineModels = contractDAO.getMachineModelsFromCustomerContracts(currentUser.getUserId());
        
        // ===== TÍNH TOÁN PAGINATION =====
        int totalModels = machineModels.size();
        int totalPages = (int) Math.ceil((double) totalModels / PAGE_SIZE);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        
        // ===== PHÂN TRANG =====
        int startIndex = (currentPage - 1) * PAGE_SIZE;
        int endIndex = Math.min(startIndex + PAGE_SIZE, totalModels);
        List<MachineModel> paginatedModels = machineModels.subList(startIndex, endIndex);
        
        // ===== SET ATTRIBUTES CHO JSP =====
        request.setAttribute("machineModels", paginatedModels);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalModels", totalModels);
        request.getRequestDispatcher(MACHINE_LIST_PAGE).forward(request, response);
    }

    /**
     * POST: Gọi doGet để xử lý
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}