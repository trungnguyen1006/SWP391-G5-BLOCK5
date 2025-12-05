package controller.user;

import controller.common.PasswordHasher;
import dal.UserDAO;
import model.Users;
import java.io.IOException;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.mail.MessagingException;
import jakarta.servlet.annotation.WebServlet;
import util.EmailSetting;
import util.RandomPassword;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/ForgotPassword"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        String email = request.getParameter("email");
        UserDAO userDAO = new UserDAO();

        try {
            Users user = userDAO.getUserByEmail(email);
            RandomPassword rd = new RandomPassword();
            if (user != null) {
                String token = rd.randomPassword(4);
                String hashedPassword = PasswordHasher.hashPassword(token);
                userDAO.saveResetToken(email, hashedPassword);

                EmailSetting.sendEmail(
                        email,
                        "Khôi phục mật khẩu",
                        "Mật khẩu mới của bạn là: " + token
                );

                request.setAttribute("Success", "Vui lòng check mail để nhận mật khẩu mới");
            } else {
                request.setAttribute("Error", "Email không tồn tại trong hệ thống");
            }

        } catch (MessagingException e) {
            request.setAttribute("Error", "Không gửi được email");
        } catch (Exception e) {
            request.setAttribute("Error", e);
        }
        request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
    }

}
