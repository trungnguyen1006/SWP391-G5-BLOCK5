<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Staff Dashboard</title>
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
    <main class="page-content bg-light">
        <div class="container-fluid">
            <div class="layout-specing">

                <div class="d-md-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Staff Dashboard</h5>
                    <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                        <li class="breadcrumb-item active">Dashboard</li>
                    </ul>
                </div>

                <div class="row">

                    <!-- Total Tickets -->
                    <div class="col-xl-3 col-md-6 mt-4">
                        <div class="card features rounded shadow p-4 text-center">
                            <i class="uil uil-ticket h3"></i>
                            <h5 class="mb-0">
                                <c:choose>
                                    <c:when test="${not empty dashboard}">
                                        ${empty dashboard.totalTickets ? 0 : dashboard.totalTickets}
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h5>
                            <p class="text-muted mb-0">Total Tickets</p>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mt-4">
                        <div class="card features rounded shadow p-4 text-center">
                            <i class="uil uil-check-circle h3"></i>
                            <h5 class="mb-0">
                                <c:choose>
                                    <c:when test="${not empty dashboard}">
                                        ${empty dashboard.approvedTickets ? 0 : dashboard.approvedTickets}
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h5>
                            <p class="text-muted mb-0">Approved</p>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mt-4">
                        <div class="card features rounded shadow p-4 text-center">
                            <i class="uil uil-times-circle h3"></i>
                            <h5 class="mb-0">
                                <c:choose>
                                    <c:when test="${not empty dashboard}">
                                        ${empty dashboard.rejectedTickets ? 0 : dashboard.rejectedTickets}
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h5>
                            <p class="text-muted mb-0">Rejected</p>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mt-4">
                        <div class="card features rounded shadow p-4 text-center">
                            <i class="uil uil-user-check h3"></i>
                            <h5 class="mb-0">
                                <c:choose>
                                    <c:when test="${not empty dashboard}">
                                        ${empty dashboard.assignedTickets ? 0 : dashboard.assignedTickets}
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </h5>
                            <p class="text-muted mb-0">My Assigned Tickets</p>
                        </div>
                    </div>

                </div>

                <c:if test="${empty dashboard}">
                    <div class="alert alert-warning mt-4">
                        Dashboard data is not available.
                    </div>
                </c:if>

            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
