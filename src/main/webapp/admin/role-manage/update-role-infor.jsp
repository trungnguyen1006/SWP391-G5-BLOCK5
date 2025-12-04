<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Update Role</title>
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
                    <h5 class="mb-0">Update Role</h5>

                    <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                        <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/role-list">Roles</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Update Role</li>
                        </ul>
                    </nav>
                </div>

                <div class="row">
                    <div class="col-lg-8 mt-4">
                        <div class="card border-0 rounded shadow">
                            <div class="card-body">
                                <h5 class="text-md-start text-center mb-4">Role Information</h5>

                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <strong>Error!</strong> ${errorMessage}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                    </div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/admin/update-role" method="POST">
                                    <input type="hidden" name="roleId" value="${role.roleId}">
                                    
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Role ID</label>
                                                <input type="text" class="form-control" value="${role.roleId}" disabled>
                                                <small class="text-muted">Role ID cannot be changed</small>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Role Name <span class="text-danger">*</span></label>
                                                <input name="roleName" type="text" class="form-control" placeholder="Enter role name" required value="${role.roleName}">
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Status <span class="text-danger">*</span></label>
                                                <select name="isActive" class="form-control">
                                                    <option value="1" ${role.active ? 'selected' : ''}>Active</option>
                                                    <option value="0" ${!role.active ? 'selected' : ''}>Inactive</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Users with this Role</label>
                                                <input type="text" class="form-control" value="${userCount} users" disabled>
                                            </div>
                                        </div>

                                        <div class="col-12">
                                            <button type="submit" class="btn btn-primary">Update Role</button>
                                            <a href="${pageContext.request.contextPath}/admin/role-list" class="btn btn-soft-primary ms-2">Cancel</a>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4 mt-4">
                        <div class="card border-0 rounded shadow">
                            <div class="card-body">
                                <h5 class="text-md-start text-center mb-4">Current Details</h5>
                                <ul class="list-unstyled mb-0">
                                    <li class="d-flex mt-3">
                                        <i class="uil uil-shield-check h5 mb-0 me-2"></i>
                                        <div class="flex-1">
                                            <h6 class="mb-0">Role ID</h6>
                                            <p class="text-muted mb-0">${role.roleId}</p>
                                        </div>
                                    </li>
                                    <li class="d-flex mt-3">
                                        <i class="uil uil-users-alt h5 mb-0 me-2"></i>
                                        <div class="flex-1">
                                            <h6 class="mb-0">Total Users</h6>
                                            <p class="text-muted mb-0">${userCount} users</p>
                                        </div>
                                    </li>
                                    <li class="d-flex mt-3">
                                        <i class="uil uil-check-circle h5 mb-0 me-2"></i>
                                        <div class="flex-1">
                                            <h6 class="mb-0">Current Status</h6>
                                            <c:choose>
                                                <c:when test="${role.active}">
                                                    <span class="badge bg-soft-success">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-soft-danger">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <div class="card border-0 rounded shadow mt-4">
                            <div class="card-body">
                                <h5 class="text-md-start text-center mb-4">Instructions</h5>
                                <ul class="list-unstyled mb-0">
                                    <li class="d-flex mt-3">
                                        <i class="uil uil-check-circle text-primary h5 mb-0 me-2"></i>
                                        <div class="flex-1">
                                            <p class="text-muted mb-0">Role ID cannot be changed</p>
                                        </div>
                                    </li>
                                    <li class="d-flex mt-3">
                                        <i class="uil uil-check-circle text-primary h5 mb-0 me-2"></i>
                                        <div class="flex-1">
                                            <p class="text-muted mb-0">Role name must be unique</p>
                                        </div>
                                    </li>
                                    <li class="d-flex mt-3">
                                        <i class="uil uil-check-circle text-primary h5 mb-0 me-2"></i>
                                        <div class="flex-1">
                                            <p class="text-muted mb-0">Deactivating a role won't remove it from users</p>
                                        </div>
                                    </li>
                                </ul>
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

</body>

</html>
