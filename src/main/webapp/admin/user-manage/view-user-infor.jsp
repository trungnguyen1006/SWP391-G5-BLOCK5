<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>User Details</title>
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
                    <h5 class="mb-0">User Details</h5>

                    <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                        <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/user-list">Users</a></li>
                            <li class="breadcrumb-item active" aria-current="page">User Details</li>
                        </ul>
                    </nav>
                </div>

                <div class="row">
                    <div class="col-lg-4 mt-4">
                        <div class="card border-0 rounded shadow">
                            <div class="card-body text-center">
                                <c:choose>
                                    <c:when test="${not empty user.image}">
                                        <img src="${pageContext.request.contextPath}/${user.image}" class="avatar avatar-large rounded-circle shadow" alt="${user.fullName}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="avatar avatar-large rounded-circle bg-soft-primary shadow mx-auto d-flex align-items-center justify-content-center">
                                            <i class="mdi mdi-account text-white" style="font-size: 4rem;"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <h5 class="mt-3 mb-0">${user.fullName}</h5>
                                <p class="text-muted mb-0">@${user.username}</p>
                                <div class="mt-3">
                                    <c:choose>
                                        <c:when test="${user.active}">
                                            <span class="badge bg-soft-success">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-soft-danger">Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-8 mt-4">
                        <div class="card border-0 rounded shadow">
                            <div class="card-body">
                                <h5 class="text-md-start text-center">User Information</h5>

                                <div class="mt-4">
                                    <div class="row">
                                        <div class="col-md-6 mt-3">
                                            <div class="d-flex align-items-center">
                                                <i class="uil uil-user h5 mb-0 me-2"></i>
                                                <div class="flex-1">
                                                    <h6 class="mb-0">User ID</h6>
                                                    <p class="text-muted mb-0">${user.userId}</p>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-6 mt-3">
                                            <div class="d-flex align-items-center">
                                                <i class="uil uil-user-circle h5 mb-0 me-2"></i>
                                                <div class="flex-1">
                                                    <h6 class="mb-0">Username</h6>
                                                    <p class="text-muted mb-0">${user.username}</p>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-6 mt-3">
                                            <div class="d-flex align-items-center">
                                                <i class="uil uil-user-check h5 mb-0 me-2"></i>
                                                <div class="flex-1">
                                                    <h6 class="mb-0">Full Name</h6>
                                                    <p class="text-muted mb-0">${user.fullName}</p>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-6 mt-3">
                                            <div class="d-flex align-items-center">
                                                <i class="uil uil-envelope h5 mb-0 me-2"></i>
                                                <div class="flex-1">
                                                    <h6 class="mb-0">Email</h6>
                                                    <p class="text-muted mb-0">${user.email}</p>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-6 mt-3">
                                            <div class="d-flex align-items-center">
                                                <i class="uil uil-phone h5 mb-0 me-2"></i>
                                                <div class="flex-1">
                                                    <h6 class="mb-0">Phone</h6>
                                                    <p class="text-muted mb-0">${not empty user.phone ? user.phone : 'Not provided'}</p>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-md-6 mt-3">
                                            <div class="d-flex align-items-center">
                                                <i class="uil uil-calendar-alt h5 mb-0 me-2"></i>
                                                <div class="flex-1">
                                                    <h6 class="mb-0">Created Date</h6>
                                                    <p class="text-muted mb-0">${user.createdDate}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/admin/user-list" class="btn btn-soft-primary">Back to List</a>
                                    <a href="${pageContext.request.contextPath}/admin/update-user?id=${user.userId}" class="btn btn-primary">Edit User</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4 mt-4">
                        <div class="card border-0 rounded shadow">
                            <div class="card-body">
                                <h5 class="text-md-start text-center">Assigned Roles</h5>

                                <div class="mt-4">
                                    <c:choose>
                                        <c:when test="${not empty userRoles}">
                                            <ul class="list-unstyled mb-0">
                                                <c:forEach var="role" items="${userRoles}">
                                                    <li class="d-flex align-items-center mt-3">
                                                        <i class="uil uil-shield-check h5 mb-0 me-2 text-primary"></i>
                                                        <div class="flex-1">
                                                            <h6 class="mb-0">${role.roleName}</h6>
                                                            <c:choose>
                                                                <c:when test="${role.active}">
                                                                    <small class="text-success">Active</small>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <small class="text-danger">Inactive</small>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted text-center">No roles assigned</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
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
