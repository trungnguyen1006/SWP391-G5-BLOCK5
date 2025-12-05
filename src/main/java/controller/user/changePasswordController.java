/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.user;

import controller.common.PasswordHasher;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;

/**
 *
 * @author Administrator
 */
@WebServlet(name = "changePasswordController", urlPatterns = {"/changePassword"})

public class changePasswordController extends HttpServlet{

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("changePassword.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        Users u =(Users)  session.getAttribute("user");
        int userId = u.getUserId();
        String oldPass = req.getParameter("oldPass");
        String newPass = req.getParameter("newPass");
        String confirmPass = req.getParameter("confirmPass");
        String errorMessage = null;
        String successMessage = null;
        UserDAO dao = new UserDAO();
        Users acc = dao.findUserById(userId);
        boolean oldPassHasher = PasswordHasher.checkPassword(oldPass,acc.getPassword());
        if (acc == null) {
            errorMessage = "Tài khoản không tồn tại!";

        } else if (!oldPassHasher) {
            
            errorMessage = "Mật khẩu cũ không đúng!";
        } else if (!newPass.equals(confirmPass)) {
            errorMessage = "Mật khẩu nhập lại không khớp!";
        } else {
                    String hashedPassword = PasswordHasher.hashPassword(newPass);
            boolean isSuccess = dao.changePassword(userId, hashedPassword);
            if (isSuccess) {
                successMessage = "Đổi mật khẩu thành công!";
            } else {
                errorMessage = "Đổi mật khẩu thất bại!";
            }
        }
        if (errorMessage != null) {
            req.setAttribute("errorMessage", errorMessage);
        }
        if (successMessage != null) {
            req.setAttribute("successMessage", successMessage);
        }
        req.getRequestDispatcher("changePassword.jsp").forward(req, resp);
    }
    
}
