<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="model.Users"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Profile</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<%
    Users user = (Users) session.getAttribute("user");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
%>

<div class="container d-flex justify-content-center mt-5">

    <div class="card p-4 shadow-sm bg-body-tertiary" style="max-width: 400px; width: 100%;">

        <h3 class="fw-bold text-center mb-4">View Profile</h3>

        <div class="d-flex justify-content-center mb-4">
            <c:choose>
                <c:when test="${not empty user.image}">
                    <div style="position: relative; display: inline-block;">
                        <img src="<%= request.getContextPath() %>/uploads/<%= user.getImage() %>" 
                             class="rounded-circle" 
                             alt="<%= user.getFullName() %>"
                             style="width:100px; height:100px; object-fit: cover; border: 3px solid #007bff;"
                             onerror="this.style.display='none'; this.parentElement.querySelector('div').style.display='flex';">
                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" style="display: none; position: absolute; top: 0; left: 0; width:100px; height:100px;">
                            <i class="mdi mdi-account" style="font-size: 2rem;"></i>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center"
                         style="width:100px; height:100px;">
                        <i class="mdi mdi-account" style="font-size: 2rem;"></i>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="mb-3">
            <label class="form-label">FullName</label>
            <p class="form-control bg-white">
                <%= user.getFullName() %>
            </p>
        </div>

        <div class="mb-3">
            <label class="form-label">UserName</label>
            <p class="form-control bg-white">
                <%= user.getUsername() %>
            </p>
        </div>

        <div class="mb-3">
            <label class="form-label">Email</label>
            <p class="form-control bg-white">
                <%= user.getEmail() %>
            </p>
        </div>

        <div class="mb-3">
            <label class="form-label">Phone</label>
            <p class="form-control bg-white">
                <%= user.getPhone() != null ? user.getPhone() : "" %>
            </p>
        </div>

        <div class="mb-3">
            <label class="form-label">IsActive</label>
            <p class="form-control bg-white">
                <%= user.isActive() ? "Active" : "Inactive" %>
            </p>
        </div>

        <div class="mb-4">
            <label class="form-label">CreatedDate</label>
            <p class="form-control bg-white">
                <%= user.getCreatedDate() != null ? dtf.format(user.getCreatedDate()) : "" %>
            </p>
        </div>

        <div class="d-flex justify-content-between">
            <a href="${pageContext.request.contextPath}/edit-profile" class="btn btn-primary px-4">Edit Profile</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-secondary px-4">Logout</a>
        </div>

    </div>

</div>

</body>
</html>
