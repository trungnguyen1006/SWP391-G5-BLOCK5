<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/assets/css/simplebar.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/assets/css/materialdesignicons.min.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/assets/css/remixicon.css" rel="stylesheet" />
    <link href="https://unicons.iconscout.com/release/v3.0.6/css/line.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.min.css" rel="stylesheet" />
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
                                    <h5 class="mb-0">${dashboard.totalUser}</h5>
                                    <p class="text-muted mb-0">Total Users</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-user-md h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">${dashboard.totalEmployee}</h5>
                                    <p class="text-muted mb-0">Total Employees</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-check-circle h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">${dashboard.totalActive}</h5>
                                    <p class="text-muted mb-0">Active Accounts</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-times-circle h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">${dashboard.totalDeActive}</h5>
                                    <p class="text-muted mb-0">Deactive Accounts</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-building h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">${dashboard.totalCustomer}</h5>
                                    <p class="text-muted mb-0">Total Customers</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-file-contract h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">${dashboard.totalContract}</h5>
                                    <p class="text-muted mb-0">Total Contracts</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-check-square h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">${dashboard.totalContractSigned}</h5>
                                    <p class="text-muted mb-0">Signed Contracts</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-play-circle h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">${dashboard.totalContractActive}</h5>
                                    <p class="text-muted mb-0">Active Contracts</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-ticket h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">${dashboard.totalTicket}</h5>
                                    <p class="text-muted mb-0">Total Tickets</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-check-circle h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">${dashboard.totalTicketApproved}</h5>
                                    <p class="text-muted mb-0">Approved Tickets</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-times-circle h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">${dashboard.totalTicketRejected}</h5>
                                    <p class="text-muted mb-0">Rejected Tickets</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-envelope-open h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">${dashboard.totalTicketOpen}</h5>
                                    <p class="text-muted mb-0">Open Tickets</p>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Machine & Invoice Management -->
                <div class="row">
                    <div class="col-xl-6 col-lg-6 col-md-12 mt-4">
                        <div class="card border-0 shadow rounded">
                            <div class="card-header bg-white border-bottom">
                                <div class="d-flex align-items-center">
                                    <div class="icon text-center rounded-md me-3">
                                        <i class="uil uil-cog h3 mb-0 text-success"></i>
                                    </div>
                                    <div>
                                        <h5 class="card-title mb-0">Machine Management</h5>
                                        <p class="text-muted mb-0">Equipment Overview & Statistics</p>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-6">
                                        <div class="text-center">
                                            <h3 class="text-success mb-1">${totalMachines}</h3>
                                            <p class="text-muted mb-0">Total Machines</p>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="text-center">
                                            <h3 class="text-primary mb-1">${machinesByStatus['Available'] != null ? machinesByStatus['Available'] : 0}</h3>
                                            <p class="text-muted mb-0">Available</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row mt-3">
                                    <div class="col-6">
                                        <div class="text-center">
                                            <h3 class="text-warning mb-1">${machinesByStatus['Rented'] != null ? machinesByStatus['Rented'] : 0}</h3>
                                            <p class="text-muted mb-0">Rented</p>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="text-center">
                                            <h3 class="text-danger mb-1">${machinesByStatus['Maintenance'] != null ? machinesByStatus['Maintenance'] : 0}</h3>
                                            <p class="text-muted mb-0">Maintenance</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mt-4 d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/admin/machines" class="btn btn-success flex-fill">
                                        <i class="uil uil-list-ul me-1"></i>View All
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/add-machine" class="btn btn-outline-success flex-fill">
                                        <i class="uil uil-plus me-1"></i>Add New
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-6 col-lg-6 col-md-12 mt-4">
                        <div class="card border-0 shadow rounded">
                            <div class="card-header bg-white border-bottom">
                                <div class="d-flex align-items-center">
                                    <div class="icon text-center rounded-md me-3">
                                        <i class="uil uil-invoice h3 mb-0 text-warning"></i>
                                    </div>
                                    <div>
                                        <h5 class="card-title mb-0">Invoice Management</h5>
                                        <p class="text-muted mb-0">Contract & Sales Overview</p>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-4">
                                        <div class="text-center">
                                            <h3 class="text-success mb-1">12</h3>
                                            <p class="text-muted mb-0 small">Active</p>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="text-center">
                                            <h3 class="text-warning mb-1">5</h3>
                                            <p class="text-muted mb-0 small">Pending</p>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="text-center">
                                            <h3 class="text-info mb-1">8</h3>
                                            <p class="text-muted mb-0 small">Completed</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mt-4 d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/sale/invoices" class="btn btn-warning flex-fill">
                                        <i class="uil uil-list-ul me-1"></i>View All
                                    </a>
                                    <a href="${pageContext.request.contextPath}/sale/add-invoice" class="btn btn-outline-warning flex-fill">
                                        <i class="uil uil-plus me-1"></i>Create New
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Quick Actions -->
                <div class="row">
                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-info rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-eye h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">Customer View</h5>
                                    <p class="text-muted mb-0">Machine Catalog</p>
                                </div>
                            </div>
                            <div class="mt-3">
                                <a href="${pageContext.request.contextPath}/customer/machines" class="btn btn-sm btn-info">View Catalog</a>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-secondary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-users-alt h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">User Management</h5>
                                    <p class="text-muted mb-0">Manage Users</p>
                                </div>
                            </div>
                            <div class="mt-3">
                                <a href="${pageContext.request.contextPath}/admin/user-list" class="btn btn-sm btn-secondary">View Users</a>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-primary rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-wheelchair h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">Role Management</h5>
                                    <p class="text-muted mb-0">Manage Roles</p>
                                </div>
                            </div>
                            <div class="mt-3">
                                <a href="${pageContext.request.contextPath}/admin/role-list" class="btn btn-sm btn-primary">View Roles</a>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-4 col-md-6 mt-4">
                        <div class="card features feature-danger rounded border-0 shadow p-4">
                            <div class="d-flex align-items-center">
                                <div class="icon text-center rounded-md">
                                    <i class="uil uil-bug h3 mb-0"></i>
                                </div>
                                <div class="flex-1 ms-2">
                                    <h5 class="mb-0">System Test</h5>
                                    <p class="text-muted mb-0">Debug & Testing</p>
                                </div>
                            </div>
                            <div class="mt-3">
                                <a href="${pageContext.request.contextPath}/test" class="btn btn-sm btn-danger">Test System</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Machine Models Breakdown -->
                <div class="row">
                    <div class="col-12 mt-4">
                        <div class="card border-0 shadow rounded">
                            <div class="card-header bg-white border-bottom">
                                <h5 class="card-title mb-0">Machine Models Overview</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <c:choose>
                                        <c:when test="${not empty machinesByModel}">
                                            <c:forEach var="model" items="${machinesByModel}" varStatus="status">
                                                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-3">
                                                    <div class="text-center p-3 bg-light rounded">
                                                        <h4 class="text-primary mb-1">${model.value}</h4>
                                                        <p class="text-muted mb-0 small">${model.key}</p>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="col-12">
                                                <div class="text-center py-4">
                                                    <i class="uil uil-cog h1 text-muted"></i>
                                                    <p class="text-muted">No machine models found. <a href="${pageContext.request.contextPath}/admin/add-machine">Add your first machine</a></p>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
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
<script src="${pageContext.request.contextPath}/assets/js/feather.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

</body>
</html>
