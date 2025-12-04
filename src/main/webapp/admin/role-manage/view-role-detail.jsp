<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Role Details</title>
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
                    <h5 class="mb-0">Role Details</h5>

                    <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                        <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/role-list">Roles</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Role Details</li>
                        </ul>
                    </nav>
                </div>

                <div class="row">
                    <div class="col-lg-4 mt-4">
                        <div class="card border-0 rounded shadow">
                            <div class="card-body">
                                <h5 class="text-md-start text-center">Role Information</h5>

                                <div class="mt-4">
                                    <div class="d-flex align-items-center mt-3">
                                        <i class="uil uil-shield-check h5 mb-0 me-2"></i>
                                        <div class="flex-1">
                                            <h6 class="mb-0">Role ID</h6>
                                            <p class="text-muted mb-0">${role.roleId}</p>
                                        </div>
                                    </div>

                                    <div class="d-flex align-items-center mt-3">
                                        <i class="uil uil-tag-alt h5 mb-0 me-2"></i>
                                        <div class="flex-1">
                                            <h6 class="mb-0">Role Name</h6>
                                            <p class="text-muted mb-0">${role.roleName}</p>
                                        </div>
                                    </div>

                                    <div class="d-flex align-items-center mt-3">
                                        <i class="uil uil-check-circle h5 mb-0 me-2"></i>
                                        <div class="flex-1">
                                            <h6 class="mb-0">Status</h6>
                                            <c:choose>
                                                <c:when test="${role.active}">
                                                    <span class="badge bg-soft-success">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-soft-danger">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <div class="d-flex align-items-center mt-3">
                                        <i class="uil uil-users-alt h5 mb-0 me-2"></i>
                                        <div class="flex-1">
                                            <h6 class="mb-0">Total Users</h6>
                                            <p class="text-muted mb-0">${userCount} users</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/admin/role-list" class="btn btn-soft-primary">Back to List</a>
                                    <a href="${pageContext.request.contextPath}/admin/update-role?id=${role.roleId}" class="btn btn-primary">Edit Role</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-8 mt-4">
                        <div class="card border-0 rounded shadow">
                            <div class="card-header border-bottom">
                                <h5 class="mb-0">Users with this Role</h5>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty usersWithRole}">
                                        <div class="table-responsive">
                                            <table class="table table-center bg-white mb-0">
                                                <thead>
                                                    <tr>
                                                        <th class="border-bottom p-3">ID</th>
                                                        <th class="border-bottom p-3">Username</th>
                                                        <th class="border-bottom p-3">Full Name</th>
                                                        <th class="border-bottom p-3">Email</th>
                                                        <th class="border-bottom p-3">Status</th>
                                                        <th class="border-bottom p-3">Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="user" items="${usersWithRole}">
                                                        <tr>
                                                            <td class="p-3">${user.userId}</td>
                                                            <td class="p-3">${user.username}</td>
                                                            <td class="p-3">${user.fullName}</td>
                                                            <td class="p-3">${user.email}</td>
                                                            <td class="p-3">
                                                                <c:choose>
                                                                    <c:when test="${user.active}">
                                                                        <span class="badge bg-soft-success">Active</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-soft-danger">Inactive</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="p-3">
                                                                <a href="${pageContext.request.contextPath}/admin/user-detail?id=${user.userId}" class="btn btn-icon btn-pills btn-soft-primary">
                                                                    <i data-feather="eye" class="fea icon-sm"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-5">
                                            <i class="uil uil-users-alt h1 text-muted"></i>
                                            <p class="text-muted mt-3">No users have been assigned this role yet.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
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
