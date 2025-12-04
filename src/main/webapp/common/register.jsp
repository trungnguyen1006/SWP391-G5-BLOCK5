<%@ page isELIgnored="false" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register New Account</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }
        .register-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
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
            color: #555;
        }
        .form-group input[type="text"],
        .form-group input[type="password"],
        .form-group input[type="email"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }
        .form-group input:focus {
            outline: none;
            border-color: #007bff;
        }
        .btn-register {
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            margin-top: 10px;
        }
        .btn-register:hover {
            background-color: #0056b3;
        }
        .login-link {
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
        }
        .login-link a {
            color: #007bff;
            text-decoration: none;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
        .message {
            text-align: center;
            margin-bottom: 15px;
            padding: 10px;
            border-radius: 4px;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
    </style>
</head>
<body>

<div class="register-container">
    <h2>Register Account</h2>

    <c:if test="${not empty requestScope.message}">
        <div class="message ${requestScope.isSuccess ? 'success-message' : 'error-message'}">
            ${requestScope.message}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="POST">

        <div class="form-group">
            <label for="fullName">Full Name:</label>
            <input type="text" id="fullName" name="fullName" required
                   value="${param.fullName}" placeholder="Enter your full name">
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required
                   value="${param.email}" placeholder="Enter your email">
        </div>

        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required
                   value="${param.username}" placeholder="Choose a username">
        </div>

        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required
                   placeholder="At least 6 characters">
        </div>

        <div class="form-group">
            <label for="confirmPassword">Confirm Password:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required
                   placeholder="Re-enter your password">
        </div>

        <button type="submit" class="btn-register">Register</button>
    </form>

    <div class="login-link">
        Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
    </div>

</div>

</body>
</html>
