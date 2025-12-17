<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="model.Users"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<%
    Users user = (Users) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<div class="container d-flex justify-content-center mt-5 mb-5">

    <div class="card p-4 shadow-sm bg-body-tertiary" style="max-width: 500px; width: 100%;">

        <h3 class="fw-bold text-center mb-4">Edit Profile</h3>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${param.updated == 'true'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Profile updated successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/edit-profile" method="POST" enctype="multipart/form-data">

            <!-- Profile Image -->
            <div class="d-flex justify-content-center mb-4">
                <div style="position: relative; display: inline-block;">
                    <c:choose>
                        <c:when test="${not empty user.image}">
                            <img id="profileImage" src="${pageContext.request.contextPath}/uploads/${user.image}" 
                                 class="rounded-circle" 
                                 alt="${user.fullName}"
                                 style="width:120px; height:120px; object-fit: cover; border: 3px solid #007bff; cursor: pointer;"
                                 onerror="this.style.display='none'; document.getElementById('fallbackIcon').style.display='flex';"
                                 onclick="document.getElementById('imageInput').click();">
                            <div id="fallbackIcon" class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" 
                                 style="display: none; position: absolute; top: 0; left: 0; width:120px; height:120px; cursor: pointer;"
                                 onclick="document.getElementById('imageInput').click();">
                                <i class="fas fa-user" style="font-size: 2.5rem;"></i>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div id="fallbackIcon" class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center"
                                 style="width:120px; height:120px; cursor: pointer;"
                                 onclick="document.getElementById('imageInput').click();">
                                <i class="fas fa-user" style="font-size: 2.5rem;"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <input type="file" id="imageInput" name="image" accept="image/*" style="display: none;" onchange="previewImage(this);">
                    <small class="text-muted d-block text-center mt-2">Click to change photo</small>
                </div>
            </div>

            <!-- Full Name -->
            <div class="mb-3">
                <label class="form-label">Full Name <span class="text-danger">*</span></label>
                <input type="text" class="form-control" name="fullName" value="${user.fullName}" required>
            </div>

            <!-- Username (Read-only) -->
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" class="form-control" value="${user.username}" readonly>
                <small class="text-muted">Username cannot be changed</small>
            </div>

            <!-- Email -->
            <div class="mb-3">
                <label class="form-label">Email <span class="text-danger">*</span></label>
                <input type="email" class="form-control" name="email" value="${user.email}" required>
            </div>

            <!-- Phone -->
            <div class="mb-3">
                <label class="form-label">Phone</label>
                <input type="tel" class="form-control" name="phone" value="${user.phone}">
            </div>

            <!-- Account Status (Read-only) -->
            <div class="mb-4">
                <label class="form-label">Account Status</label>
                <input type="text" class="form-control" value="${user.active ? 'Active' : 'Inactive'}" readonly>
            </div>

            <!-- Buttons -->
            <div class="d-flex justify-content-between gap-2">
                <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary px-4">Cancel</a>
                <button type="submit" class="btn btn-primary px-4">Save Changes</button>
            </div>

        </form>

    </div>

</div>

<script>
    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const profileImage = document.getElementById('profileImage');
                const fallbackIcon = document.getElementById('fallbackIcon');
                
                if (profileImage) {
                    profileImage.src = e.target.result;
                    profileImage.style.display = 'block';
                    if (fallbackIcon) fallbackIcon.style.display = 'none';
                } else {
                    if (fallbackIcon) {
                        fallbackIcon.style.backgroundImage = 'url(' + e.target.result + ')';
                    }
                }
            };
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
