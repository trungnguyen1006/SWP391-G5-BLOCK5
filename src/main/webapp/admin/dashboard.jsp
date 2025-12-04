<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <title>Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Premium Bootstrap 4 Landing Page Template" />
    <meta name="keywords" content="Appointment, Booking, System, Dashboard, Health" />
    <meta name="author" content="Shreethemes" />
    <meta name="email" content="support@shreethemes.in" />
    <meta name="website" content="../../../index.html" />
    <meta name="Version" content="v1.2.0" />

    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/assets/css/simplebar.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/assets/css/select2.min.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/assets/css/materialdesignicons.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/assets/css/remixicon.css" rel="stylesheet" type="text/css" />
    <link href="https://unicons.iconscout.com/release/v3.0.6/css/line.css"  rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/tiny-slider.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/assets/css/style.min.css" rel="stylesheet" type="text/css" id="theme-opt" />

</head>

<body>

<div class="page-wrapper doctris-theme toggled">
    <jsp:include page="common/sidebar.jsp" />

    <main class="page-content bg-light">
        <jsp:include page="common/header.jsp" />

        <div class="container-fluid">
            <div class="layout-specing">
                <div class="d-md-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Dashboard</h5>
                    <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                        <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                            <li class="breadcrumb-item active" aria-current="page">Dashboard</li>
                        </ul>
                    </nav>
                </div>

                <div class="row">
                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-users-alt h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">150</h5>
                                    <p class="text-muted mb-0">Total Users</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-user-check h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">142</h5>
                                    <p class="text-muted mb-0">Active Users</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-shield-check h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">5</h5>
                                    <p class="text-muted mb-0">Total Roles</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-calendar-alt h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">25</h5>
                                    <p class="text-muted mb-0">New This Month</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-xl-8 col-lg-7 mt-4">
                        <div class="card border-0 shadow rounded">
                            <div class="card-header border-bottom">
                                <h5 class="mb-0">Quick Actions</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6 mt-3">
                                        <a href="${pageContext.request.contextPath}/admin/user-list" class="btn btn-soft-primary w-100 d-flex align-items-center justify-content-between">
                                            <span><i class="uil uil-list-ul me-2"></i>View All Users</span>
                                            <i class="uil uil-arrow-right"></i>
                                        </a>
                                    </div>
                                    <div class="col-md-6 mt-3">
                                        <a href="${pageContext.request.contextPath}/admin/add-user" class="btn btn-soft-primary w-100 d-flex align-items-center justify-content-between">
                                            <span><i class="uil uil-user-plus me-2"></i>Add New User</span>
                                            <i class="uil uil-arrow-right"></i>
                                        </a>
                                    </div>
                                    <div class="col-md-6 mt-3">
                                        <a href="${pageContext.request.contextPath}/admin/role-list" class="btn btn-soft-primary w-100 d-flex align-items-center justify-content-between">
                                            <span><i class="uil uil-shield me-2"></i>Manage Roles</span>
                                            <i class="uil uil-arrow-right"></i>
                                        </a>
                                    </div>
                                    <div class="col-md-6 mt-3">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-soft-primary w-100 d-flex align-items-center justify-content-between">
                                            <span><i class="uil uil-setting me-2"></i>System Settings</span>
                                            <i class="uil uil-arrow-right"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-4 col-lg-5 mt-4">
                        <div class="card border-0 shadow rounded">
                            <div class="card-header border-bottom">
                                <h5 class="mb-0">System Information</h5>
                            </div>
                            <div class="card-body">
                                <ul class="list-unstyled mb-0">
                                    <li class="d-flex justify-content-between align-items-center mt-3">
                                        <span class="text-muted">System Version:</span>
                                        <span class="fw-bold">v1.0.0</span>
                                    </li>
                                    <li class="d-flex justify-content-between align-items-center mt-3">
                                        <span class="text-muted">Database:</span>
                                        <span class="fw-bold">MySQL 8.0</span>
                                    </li>
                                    <li class="d-flex justify-content-between align-items-center mt-3">
                                        <span class="text-muted">Server Status:</span>
                                        <span class="badge bg-soft-success">Online</span>
                                    </li>
                                    <li class="d-flex justify-content-between align-items-center mt-3">
                                        <span class="text-muted">Last Backup:</span>
                                        <span class="fw-bold">Today</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-12 mt-4">
                        <div class="card border-0 shadow rounded">
                            <div class="card-header border-bottom">
                                <h5 class="mb-0">Recent Activities</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-center bg-white mb-0">
                                        <thead>
                                            <tr>
                                                <th class="border-bottom p-3">Activity</th>
                                                <th class="border-bottom p-3">User</th>
                                                <th class="border-bottom p-3">Date</th>
                                                <th class="border-bottom p-3">Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="p-3">New user registered</td>
                                                <td class="p-3">john.doe@example.com</td>
                                                <td class="p-3">2 hours ago</td>
                                                <td class="p-3"><span class="badge bg-soft-success">Success</span></td>
                                            </tr>
                                            <tr>
                                                <td class="p-3">User role updated</td>
                                                <td class="p-3">jane.smith@example.com</td>
                                                <td class="p-3">5 hours ago</td>
                                                <td class="p-3"><span class="badge bg-soft-success">Success</span></td>
                                            </tr>
                                            <tr>
                                                <td class="p-3">Failed login attempt</td>
                                                <td class="p-3">unknown@example.com</td>
                                                <td class="p-3">1 day ago</td>
                                                <td class="p-3"><span class="badge bg-soft-danger">Failed</span></td>
                                            </tr>
                                            <tr>
                                                <td class="p-3">New user created by admin</td>
                                                <td class="p-3">admin@example.com</td>
                                                <td class="p-3">2 days ago</td>
                                                <td class="p-3"><span class="badge bg-soft-success">Success</span></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <jsp:include page="common/footer.jsp" />
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/simplebar.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/apexcharts.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/columnchart.init.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/feather.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

</body>

</html>
