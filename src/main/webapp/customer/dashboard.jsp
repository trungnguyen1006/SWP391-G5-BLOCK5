<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Customer Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/assets/css/simplebar.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/assets/css/materialdesignicons.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/assets/css/remixicon.css" rel="stylesheet" type="text/css" />
    <link href="https://unicons.iconscout.com/release/v3.0.6/css/line.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.min.css" rel="stylesheet" type="text/css" />
</head>

<body>
    <div class="page-wrapper doctris-theme toggled">
        <jsp:include page="common/sidebar.jsp" />

        <main class="page-content bg-light">
            <jsp:include page="common/header.jsp" />

            <div class="container-fluid">
                <div class="layout-specing">
                    <div class="d-md-flex justify-content-between">
                        <h5 class="mb-0">Customer Dashboard</h5>
                    </div>

                    <div class="row mt-4">
                        <div class="col-md-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-0">Total Contracts</h6>
                                            <h3 class="mb-0">--</h3>
                                        </div>
                                        <div class="text-end">
                                            <i class="uil uil-file-contract text-primary" style="font-size: 2rem;"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-0">Active Contracts</h6>
                                            <h3 class="mb-0">--</h3>
                                        </div>
                                        <div class="text-end">
                                            <i class="uil uil-check-circle text-success" style="font-size: 2rem;"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-0">My Sites</h6>
                                            <h3 class="mb-0">--</h3>
                                        </div>
                                        <div class="text-end">
                                            <i class="uil uil-building text-info" style="font-size: 2rem;"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <h5 class="mb-4">Quick Actions</h5>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <a href="${pageContext.request.contextPath}/customer/contracts" class="btn btn-soft-primary w-100">
                                                <i class="uil uil-file-contract me-2"></i> View My Contracts
                                            </a>
                                        </div>
                                        <div class="col-md-6">
                                            <a href="${pageContext.request.contextPath}/customer/machines" class="btn btn-soft-success w-100">
                                                <i class="uil uil-cog me-2"></i> View Machines
                                            </a>
                                        </div>
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
    <script>
        feather.replace();
    </script>
</body>
</html>
