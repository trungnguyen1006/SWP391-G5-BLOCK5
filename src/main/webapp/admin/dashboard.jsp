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

                            <div class="col-xl-3 col-lg-6 col-md-6 col-sm-12 mt-4">
                                <div class="card border-0 shadow-sm rounded h-100">
                                    <div class="card-body d-flex align-items-center">
                                        <div class="icon bg-soft-primary text-primary rounded-circle p-3 me-3">
                                            <i class="uil uil-users-alt h4 mb-0"></i>
                                        </div>
                                        <div>
                                            <h4 class="mb-0 fw-bold">${dashboard.totalEmployee}</h4>
                                            <small class="text-muted">Total Employees</small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-lg-6 col-md-6 col-sm-12 mt-4">
                                <div class="card border-0 shadow-sm rounded h-100">
                                    <div class="card-body d-flex align-items-center">
                                        <div class="icon bg-soft-info text-info rounded-circle p-3 me-3">
                                            <i class="uil uil-user-check h4 mb-0"></i>
                                        </div>
                                        <div>
                                            <h4 class="mb-0 fw-bold">${dashboard.totalManager}</h4>
                                            <small class="text-muted">Total Managers</small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-lg-6 col-md-6 col-sm-12 mt-4">
                                <div class="card border-0 shadow-sm rounded h-100">
                                    <div class="card-body d-flex align-items-center">
                                        <div class="icon bg-soft-success text-success rounded-circle p-3 me-3">
                                            <i class="uil uil-building h4 mb-0"></i>
                                        </div>
                                        <div>
                                            <h4 class="mb-0 fw-bold">${dashboard.totalCustomer}</h4>
                                            <small class="text-muted">Total Customers</small>
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
