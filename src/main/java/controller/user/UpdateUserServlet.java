package controller.user;

import controller.common.PasswordHasher;
import dal.CustomerDAO;
import dal.EmployeeDAO;
import dal.RoleDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Customers;
import model.Employee;
import model.Roles;
import model.Users;
import util.FileUploadUtil;
import util.Validator;

import java.io.IOException;
import java.util.List;

/**
 * UpdateUserServlet - Cập nhật thông tin user
 * 
 * Luồng:
 * 1. GET: Lấy user theo ID, hiển thị form edit
 * 2. POST: Validate input, cập nhật user
 * 3. Nếu role thay đổi thành CUSTOMER → tạo customer record nếu chưa có
 * 4. Nếu role thay đổi thành EMPLOYEE → tạo employee record nếu chưa có
 * 5. Redirect đến user list
 */
@WebServlet(name = "UpdateUserServlet", urlPatterns = {"/admin/update-user"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class UpdateUserServlet extends HttpServlet {

    private static final String UPDATE_USER_PAGE = "user-manage/update-user.jsp";
    private static final String USER_LIST_URL = "user-list";

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    /**
     * GET: Hiển thị form edit user
     * Lấy user theo ID từ parameter, load tất cả roles và roles của user
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdParam = request.getParameter("id");

        // Kiểm tra ID parameter
        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + USER_LIST_URL);
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            Users user = userDAO.findUserById(userId);

            // Kiểm tra user tồn tại
            if (user == null) {
                response.sendRedirect(request.getContextPath() + USER_LIST_URL);
                return;
            }

            // Lấy tất cả roles và roles của user
            List<Roles> allRoles = roleDAO.getAllRoles();
            List<Roles> userRoles = roleDAO.getRolesByUserId(userId);

            request.setAttribute("user", user);
            request.setAttribute("allRoles", allRoles);
            request.setAttribute("userRoles", userRoles);
            request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + USER_LIST_URL);
        }
    }

    /**
     * POST: Xử lý cập nhật user
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ form
        String userIdParam = request.getParameter("userId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String isActiveParam = request.getParameter("isActive");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String roleId = request.getParameter("roleId");
        
        Part imagePart = request.getPart("imageFile");
        String newImagePath = null;

        try {
            int userId = Integer.parseInt(userIdParam);
            Users user = userDAO.findUserById(userId);

            // Kiểm tra user tồn tại
            if (user == null) {
                response.sendRedirect(request.getContextPath() + USER_LIST_URL);
                return;
            }

            // Chuẩn bị dữ liệu cho form nếu có lỗi
            List<Roles> allRoles = roleDAO.getAllRoles();
            List<Roles> userRoles = roleDAO.getRolesByUserId(userId);
            request.setAttribute("user", user);
            request.setAttribute("allRoles", allRoles);
            request.setAttribute("userRoles", userRoles);

            // ===== VALIDATE INPUT =====

            // Kiểm tra required fields
            if (fullName == null || email == null || fullName.trim().isEmpty() || email.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Full name and email are required.");
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            // Validate fullName
            if (!Validator.isValidFullName(fullName)) {
                request.setAttribute("errorMessage", Validator.getFullNameErrorMessage());
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            // Validate email
            if (!Validator.isValidEmail(email)) {
                request.setAttribute("errorMessage", Validator.getEmailErrorMessage());
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            // Validate phone (nếu có)
            if (phone != null && !phone.trim().isEmpty() && !Validator.isValidPhone(phone)) {
                request.setAttribute("errorMessage", Validator.getPhoneErrorMessage());
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            // Kiểm tra email đã tồn tại cho user khác
            if (userDAO.isEmailExistsForOtherUser(email, userId)) {
                request.setAttribute("errorMessage", "Email already exists for another user.");
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            // Ghi chú: Password change bị disable - không cho phép cập nhật password từ admin

            // Kiểm tra role được chọn
            if (roleId == null || roleId.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Please select a role.");
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            // Không cho phép assign Admin role
            if (roleId.equals("1")) {
                request.setAttribute("errorMessage", "Cannot assign Admin role to users.");
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            // ===== UPLOAD IMAGE =====
            try {
                if (imagePart != null && imagePart.getSize() > 0) {
                    String realPath = getServletContext().getRealPath("/");
                    String webappPath = FileUploadUtil.getSourceWebappPath(realPath);
                    String uploadPath = webappPath + "uploads";
                    newImagePath = FileUploadUtil.saveFile(imagePart, uploadPath);
                    
                    // Xóa ảnh cũ nếu có
                    if (user.getImage() != null && !user.getImage().isEmpty()) {
                        FileUploadUtil.deleteFile(user.getImage(), webappPath);
                    }
                }
            } catch (IOException e) {
                request.setAttribute("errorMessage", "Failed to upload image: " + e.getMessage());
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                return;
            }

            // ===== CẬP NHẬT USER =====
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            if (newImagePath != null) {
                user.setImage(newImagePath);
            }
            user.setActive(isActiveParam != null && isActiveParam.equals("1"));

            boolean userUpdated = userDAO.updateUser(user);

            if (userUpdated) {
                int assignedRoleId = Integer.parseInt(roleId);
                Roles selectedRole = roleDAO.findRoleById(assignedRoleId);
                
                // Kiểm tra role active
                if (selectedRole != null && selectedRole.isActive()) {
                    // Xóa tất cả roles cũ, assign role mới
                    roleDAO.removeAllUserRoles(userId);
                    roleDAO.assignDefaultRole(userId, assignedRoleId);
                    
                    // ===== TẠO CUSTOMER RECORD (nếu role là CUSTOMER) =====
                    if ("CUSTOMER".equalsIgnoreCase(selectedRole.getRoleName())) {
                        Customers existingCustomer = customerDAO.getCustomerByUserId(userId);
                        if (existingCustomer == null) {
                            Customers customer = new Customers();
                            customer.setUserId(userId);
                            customer.setCustomerCode("CUST" + userId);
                            customer.setCustomerName(fullName);
                            customer.setContactEmail(email);
                            customer.setContactPhone(phone);
                            customer.setActive(true);
                            customerDAO.createCustomer(customer);
                        }
                    }
                    
                    // ===== TẠO EMPLOYEE RECORD (nếu role là EMPLOYEE) =====
                    if ("EMPLOYEE".equalsIgnoreCase(selectedRole.getRoleName())) {
                        Employee existingEmployee = employeeDAO.getEmployeebyUserId(userId);
                        if (existingEmployee == null) {
                            Employee employee = new Employee();
                            employee.setUserId(userId);
                            employee.setEmployeeCode("EMP" + userId);
                            employee.setEmployeeName(fullName);
                            employee.setActive(true);
                            employeeDAO.createEmployee(employee);
                        }
                    }
                    
                    response.sendRedirect(request.getContextPath() + "/admin/user-list?updated=true");
                } else {
                    request.setAttribute("errorMessage", "Selected role is not active. Please select an active role.");
                    request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Failed to update user. Please try again.");
                request.getRequestDispatcher(UPDATE_USER_PAGE).forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + USER_LIST_URL);
        }
    }

}
