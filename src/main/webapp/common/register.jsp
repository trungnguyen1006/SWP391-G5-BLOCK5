
<%@ page isELIgnored="false" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Đăng ký Tài khoản Mới</title>
    <style>

        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .register-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 350px;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input[type="text"],
        .form-group input[type="password"],
        .form-group input[type="email"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .btn-register {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        .btn-register:hover {
            background-color: #0056b3;
        }
        .login-link {
            text-align: center;
            margin-top: 15px;
            font-size: 0.9em;
        }
        .login-link a {
            color: #337ab7;
            text-decoration: none;
        }
        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<div class="register-container">
    <h2>Đăng ký Tài khoản</h2>

    <c:if test="${not empty requestScope.message}">
        <p class="error-message" style="color: ${requestScope.isSuccess ? 'green' : 'red'};">
                ${requestScope.message}
        </p>
    </c:if>

    <form action="RegisterServlet" method="POST">

        <div class="form-group">
            <label for="fullName">Họ và Tên:</label>
            <input type="text" id="fullName" name="fullName" required
                   value="${param.fullName}">
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required
                   value="${param.email}">
        </div>

        <div class="form-group">
            <label for="username">Tên đăng nhập:</label>
            <input type="text" id="username" name="username" required
                   value="${param.username}">
        </div>

        <div class="form-group">
            <label for="password">Mật khẩu:</label>
            <input type="password" id="password" name="password" required>
        </div>

        <div class="form-group">
            <label for="confirmPassword">Xác nhận Mật khẩu:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>

        <button type="submit" class="btn-register">Đăng ký</button>
    </form>

    <div class="login-link">
        Đã có tài khoản? <a href="login.jsp">Đăng nhập ngay</a>
    </div>

</div>

</body>
</html>