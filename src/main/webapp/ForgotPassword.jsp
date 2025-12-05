<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Forgot Password</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
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
        </style>    </head>
    <body>

        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Forgot Password</h5>
                            <form method="post" action="ForgotPassword">
                                <div class="mb-3">
                                    <label for="email" class="form-label">Enter your email</label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                    <span class="text-danger">${msgEmail}</span>
                                </div>
                                <button type="submit" class="btn btn-primary">Send Reset Link</button>
                            </form>
                            <c:if test="${not empty Error}">
                                <div class="error">${Error}</div>
                            </c:if>
                            <c:if test="${not empty Success}">
                                <div class="success">${Success}</div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </body>

</html>
