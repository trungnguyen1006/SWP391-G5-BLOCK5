<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Add New User</title>
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
                    <h5 class="mb-0">Add New User</h5>

                    <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                        <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/user-list">Users</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Add User</li>
                        </ul>
                    </nav>
                </div>

                <div class="row">
                    <div class="col-lg-4 mt-4">
                        <div class="card border-0 rounded shadow">
                            <div class="card-body text-center">
                                <div id="imagePreviewContainer" class="position-relative d-inline-block" style="width: 120px; height: 120px;">
                                    <div id="defaultAvatar" class="avatar avatar-large rounded-circle bg-soft-primary shadow d-flex align-items-center justify-content-center" style="width: 120px; height: 120px;">
                                        <i class="mdi mdi-account text-white" style="font-size: 4rem;"></i>
                                    </div>
                                    <img id="imagePreview" src="" class="avatar avatar-large rounded-circle shadow position-absolute top-0 start-0" style="display: none; width: 120px; height: 120px; object-fit: cover;" alt="Preview">
                                </div>
                                <div class="mt-3">
                                    <label for="imageFileInput" class="btn btn-sm btn-primary">
                                        <i class="mdi mdi-upload"></i> Choose Image
                                    </label>
                                    <button type="button" id="removeImageBtn" class="btn btn-sm btn-soft-danger" style="display: none;">
                                        <i class="mdi mdi-close"></i> Remove
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

                                <form action="${pageContext.request.contextPath}/admin/add-user" method="POST" enctype="multipart/form-data" id="addUserForm">
                                    <input name="imageFile" type="file" id="imageFileInput" accept="image/*" style="display: none;">
                                    
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Full Name <span class="text-danger">*</span></label>
                                                <input name="fullName" type="text" class="form-control" placeholder="Enter full name" required value="${param.fullName}">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Email <span class="text-danger">*</span></label>
                                                <input name="email" type="email" class="form-control" placeholder="Enter email" required value="${param.email}">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Username <span class="text-danger">*</span></label>
                                                <input name="username" type="text" class="form-control" placeholder="Enter username" required value="${param.username}">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Phone</label>
                                                <input name="phone" type="text" class="form-control" placeholder="Enter phone number" value="${param.phone}">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Status <span class="text-danger">*</span></label>
                                                <select name="isActive" class="form-control">
                                                    <option value="1" ${param.isActive == '1' ? 'selected' : ''}>Active</option>
                                                    <option value="0" ${param.isActive == '0' ? 'selected' : ''}>Inactive</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-md-6"></div>

                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Password <span class="text-danger">*</span></label>
                                                <input name="password" type="password" class="form-control" placeholder="At least 6 characters" required>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Confirm Password <span class="text-danger">*</span></label>
                                                <input name="confirmPassword" type="password" class="form-control" placeholder="Re-enter password" required>
                                            </div>
                                        </div>

                                        <div class="col-12">
                                            <div class="mb-3">
                                                <label class="form-label">Assign Role <span class="text-danger">*</span></label>
                                                <select name="roleId" class="form-control" required>
                                                    <option value="">-- Select a role --</option>
                                                    <c:forEach var="role" items="${allRoles}">
                                                        <option value="${role.roleId}">${role.roleName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-12">
                                            <button type="submit" class="btn btn-primary">Create User</button>
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
    const imagePreview = document.getElementById('imagePreview');
    const defaultAvatar = document.getElementById('defaultAvatar');
    const removeImageBtn = document.getElementById('removeImageBtn');

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
                imagePreview.src = e.target.result;
                imagePreview.style.display = 'block';
                defaultAvatar.style.display = 'none';
                removeImageBtn.style.display = 'inline-block';
            };
            reader.readAsDataURL(file);
        }
    });

    removeImageBtn.addEventListener('click', function() {
        imageFileInput.value = '';
        imagePreview.src = '';
        imagePreview.style.display = 'none';
        defaultAvatar.style.display = 'flex';
        removeImageBtn.style.display = 'none';
    });
</script>

</body>

</html>
