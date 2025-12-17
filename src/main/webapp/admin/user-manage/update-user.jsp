<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Update User</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Premium Bootstrap 4 Landing Page Template" />
    <meta name="keywords" content="Appointment, Booking, System, Dashboard, Health" />
    <meta name="author" content="Shreethemes" />
    <meta name="email" content="support@shreethemes.in" />
    <meta name="website" content="../../../index.html" />
    <meta name="Version" content="v1.2.0" />

    <link href="../../assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../../assets/css/simplebar.css" rel="stylesheet" type="text/css" />
    <link href="../../assets/css/select2.min.css" rel="stylesheet" />
    <link href="../../assets/css/materialdesignicons.min.css" rel="stylesheet" type="text/css" />
    <link href="../../assets/css/remixicon.css" rel="stylesheet" type="text/css" />
    <link href="https://unicons.iconscout.com/release/v3.0.6/css/line.css"  rel="stylesheet">
    <link href="../../assets/css/tiny-slider.css" rel="stylesheet" />
    <link href="../../assets/css/style.min.css" rel="stylesheet" type="text/css" id="theme-opt" />

</head>

<body>

<div class="page-wrapper doctris-theme toggled">
    <jsp:include page="../common/sidebar.jsp" />

    <main class="page-content bg-light">
        <jsp:include page="../common/header.jsp" />

        <div class="container-fluid">
            <div class="layout-specing">
                <div class="d-md-flex justify-content-between">
                    <h5 class="mb-0">Update User</h5>

                    <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                        <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/user-list">Users</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Update User</li>
                        </ul>
                    </nav>
                </div>

                <div class="row">
                    <div class="col-lg-4 mt-4">
                        <div class="card border-0 rounded shadow">
                            <div class="card-body text-center">
                                <div id="imagePreviewContainer" style="position: relative; display: inline-block;">
                                    <c:choose>
                                        <c:when test="${not empty user.image}">
                                            <img id="userAvatar" src="${pageContext.request.contextPath}/${user.image}" class="avatar avatar-large rounded-circle shadow" alt="${user.fullName}">
                                        </c:when>
                                        <c:otherwise>
                                            <div id="userAvatar" class="avatar avatar-large rounded-circle bg-soft-primary shadow d-inline-flex align-items-center justify-content-center">
                                                <i class="mdi mdi-account text-white" style="font-size: 4rem;"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <h5 class="mt-3 mb-0">${user.fullName}</h5>
                                <p class="text-muted mb-0">@${user.username}</p>
                                <div class="mt-3">
                                    <label for="imageFileInput" class="btn btn-sm btn-primary">
                                        <i class="mdi mdi-upload"></i> Change Image
                                    </label>
                                    <button type="button" id="removeImageBtn" class="btn btn-sm btn-soft-danger" style="display: none;">
                                        <i class="mdi mdi-close"></i> Cancel
                                    </button>
                                </div>
                                <small class="text-muted d-block mt-2">Max 5MB. JPG, PNG, GIF</small>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-8 mt-4">
                        <div class="card border-0 rounded shadow">
                            <div class="card-body">
                                <h5 class="text-md-start text-center mb-4">User Information</h5>

                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <strong>Error!</strong> ${errorMessage}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                    </div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/admin/update-user" method="POST" enctype="multipart/form-data" id="updateUserForm">
                                    <input type="hidden" name="userId" value="${user.userId}">
                                    <input name="imageFile" type="file" id="imageFileInput" accept="image/*" style="display: none;">
                                    
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Username</label>
                                                <input type="text" class="form-control" value="${user.username}" disabled>
                                                <small class="text-muted">Username cannot be changed</small>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Full Name <span class="text-danger">*</span></label>
                                                <input name="fullName" type="text" class="form-control" placeholder="Enter full name" required value="${user.fullName}">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Email <span class="text-danger">*</span></label>
                                                <input name="email" type="email" class="form-control" placeholder="Enter email" required value="${user.email}">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Phone</label>
                                                <input name="phone" type="text" class="form-control" placeholder="Enter phone number" value="${user.phone}">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Status <span class="text-danger">*</span></label>
                                                <select name="isActive" class="form-control">
                                                    <option value="1" ${user.active ? 'selected' : ''}>Active</option>
                                                    <option value="0" ${!user.active ? 'selected' : ''}>Inactive</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-md-6"></div>

                                        <!-- Password change is disabled -->
                                        <input name="newPassword" type="hidden" value="">
                                        <input name="confirmPassword" type="hidden" value="">

                                        <div class="col-12">
                                            <hr>
                                            <div class="mb-3">
                                                <label class="form-label">Assign Roles <span class="text-danger">*</span></label>
                                                <div class="row">
                                                    <c:forEach var="role" items="${allRoles}">
                                                        <!-- Hide Admin role (roleId = 1) -->
                                                        <c:if test="${role.roleId != 1}">
                                                            <div class="col-md-6">
                                                                <div class="form-check mb-2">
                                                                    <input class="form-check-input" type="checkbox" name="roleIds" value="${role.roleId}" id="role${role.roleId}"
                                                                        <c:forEach var="userRole" items="${userRoles}">
                                                                            <c:if test="${userRole.roleId == role.roleId}">checked</c:if>
                                                                        </c:forEach>
                                                                    >
                                                                    <label class="form-check-label" for="role${role.roleId}">
                                                                        ${role.roleName}
                                                                    </label>
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-12">
                                            <button type="submit" class="btn btn-primary">Update User</button>
                                            <a href="${pageContext.request.contextPath}/admin/user-list" class="btn btn-soft-primary ms-2">Cancel</a>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>


                </div>

            </div>
        </div>

        <jsp:include page="../common/footer.jsp" />
    </main>
</div>

<script src="../../assets/js/bootstrap.bundle.min.js"></script>
<script src="../../assets/js/simplebar.min.js"></script>
<script src="../../assets/js/feather.min.js"></script>
<script src="../../assets/js/app.js"></script>

<script>
    const imageFileInput = document.getElementById('imageFileInput');
    const userAvatar = document.getElementById('userAvatar');
    const removeImageBtn = document.getElementById('removeImageBtn');
    const imagePreviewContainer = document.getElementById('imagePreviewContainer');
    
    const originalAvatarHTML = userAvatar.outerHTML;
    const hasOriginalImage = ${not empty user.image ? 'true' : 'false'};

    imageFileInput.addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            if (file.size > 5 * 1024 * 1024) {
                alert('File size exceeds 5MB limit');
                imageFileInput.value = '';
                return;
            }

            const reader = new FileReader();
            reader.onload = function(e) {
                imagePreviewContainer.innerHTML = '<img id="userAvatar" src="' + e.target.result + '" class="avatar avatar-large rounded-circle shadow" alt="Preview">';
                removeImageBtn.style.display = 'inline-block';
            };
            reader.readAsDataURL(file);
        }
    });

    removeImageBtn.addEventListener('click', function() {
        imageFileInput.value = '';
        imagePreviewContainer.innerHTML = originalAvatarHTML;
        removeImageBtn.style.display = 'none';
    });
</script>

</body>

</html>
