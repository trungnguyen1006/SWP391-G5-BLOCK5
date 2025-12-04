<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Access Denied</title>
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
        .access-denied-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
        }
        .error-icon {
            font-size: 80px;
            color: #dc3545;
            margin-bottom: 20px;
        }
        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 32px;
        }
        h2 {
            color: #666;
            margin-bottom: 20px;
            font-size: 20px;
            font-weight: normal;
        }
        p {
            color: #777;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .btn-container {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
    </style>
</head>
<body>

<div class="access-denied-container">
    <div class="error-icon">🚫</div>
    <h1>Access Denied</h1>
    <h2>403 - Forbidden</h2>
    <p>
        You don't have permission to access this page. 
        This area is restricted to administrators only.
    </p>
    <p>
        If you believe this is an error, please contact your system administrator.
    </p>
    <div class="btn-container">
        <a href="${pageContext.request.contextPath}/common/homepage.jsp" class="btn btn-primary">Go to Home</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">Logout</a>
    </div>
</div>

</body>
</html>
