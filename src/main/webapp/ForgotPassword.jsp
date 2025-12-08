<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>

    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

    <div class="container d-flex justify-content-center align-items-center" style="min-height: 100vh;">
        <div class="card p-4 shadow-sm bg-body-tertiary" style="max-width: 450px; width:100%;">

            <h3 class="text-center fw-bold mb-4">Forgot your Password</h3>

            <form method="post" action="ForgotPassword">

                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" name="email" required>
                    <c:if test="${not empty msgEmail}">
                        <div class="text-danger mt-1">${msgEmail}</div>
                    </c:if>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-outline-secondary px-4">
                        Send reset link
                    </button>
                </div>
            </form>

            <c:if test="${not empty Error}">
                <div class="alert alert-danger text-center mt-3">${Error}</div>
            </c:if>

            <c:if test="${not empty Success}">
                <div class="alert alert-success text-center mt-3">${Success}</div>
            </c:if>

        </div>
    </div>

</body>
</html>
