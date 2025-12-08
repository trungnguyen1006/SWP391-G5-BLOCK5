<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Password</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

    <div class="container d-flex justify-content-center align-items-center" style="min-height: 100vh;">
        <div class="card p-4 shadow-sm" style="max-width: 450px; width: 100%;">

            <h3 class="text-center mb-4 fw-bold">Change Password</h3>

            <!-- Error -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger text-center">${errorMessage}</div>
            </c:if>

            <!-- Success -->
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success text-center">${successMessage}</div>
            </c:if>

            <form action="changePassword" method="post">

                <div class="mb-3">
                    <label class="form-label">Current Password</label>
                    <input type="password" name="oldPass" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">New Password</label>
                    <input type="password" name="newPass" class="form-control" required>
                </div>

                <div class="mb-4">
                    <label class="form-label">Confirm New Password</label>
                    <input type="password" name="confirmPass" class="form-control" required>
                </div>

                <div class="d-flex justify-content-between">
                    <button type="submit" class="btn btn-secondary px-4">Save</button>
                    <a href="javascript:history.back()" class="btn btn-outline-secondary px-4">Cancel</a>
                </div>

            </form>
        </div>
    </div>

</body>
</html>
