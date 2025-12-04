<%-- 
    Document   : changePassword
    Created on : Dec 3, 2025, 10:56:23 PM
    Author     : Administrator
--%>
<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            .error {
                color: red;
                margin-top: 10px;
                text-align: center;
            }
            .success {
                color: green;
                margin-top: 10px;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <h2 style="text-align:center;">Change Password</h2>
        <c:if test="${not empty errorMessage}">
            <div class="error">${errorMessage}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="success">${successMessage}</div>
        </c:if>
        <form action="changePassword" method="post">
            <label for="oldPassword">Current Password:</label>
            <input type="password" id="oldPass" name="oldPass" required>

            <label for="newPassword">New Password:</label>
            <input type="password" id="newPass" name="newPass" required>

            <label for="confirmPassword">Confirm New Password:</label>
            <input type="password" id="confirmPass" name="confirmPass" required>

            <input type="submit" value="Change Password">
        </form>
    </body>
</html>
