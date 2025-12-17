<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Contract Details</title>
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
        <jsp:include page="../../customer/common/sidebar.jsp" />

        <main class="page-content bg-light">
            <jsp:include page="../../customer/common/header.jsp" />

            <div class="container-fluid">
                <div class="layout-specing">
                    <div class="d-md-flex justify-content-between">
                        <h5 class="mb-0">Contract Details</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/customer/contracts">Contracts</a></li>
                                <li class="breadcrumb-item active" aria-current="page">${contract.contractCode}</li>
                            </ul>
                        </nav>
                    </div>

                    <div class="row mt-4">
                        <!-- Contract Information -->
                        <div class="col-lg-8">
                            <div class="card border-0 rounded shadow mb-4">
                                <div class="card-body">
                                    <h6 class="mb-4">Contract Information</h6>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="text-muted">Contract Code</label>
                                            <p class="mb-0"><strong>${contract.contractCode}</strong></p>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="text-muted">Status</label>
                                            <p class="mb-0">
                                                <c:choose>
                                                    <c:when test="${contract.status == 'DRAFT'}">
                                                        <span class="badge bg-soft-warning">Draft</span>
                                                    </c:when>
                                                    <c:when test="${contract.status == 'ACTIVE'}">
                                                        <span class="badge bg-soft-success">Active</span>
                                                    </c:when>
                                                    <c:when test="${contract.status == 'COMPLETED'}">
                                                        <span class="badge bg-soft-info">Completed</span>
                                                    </c:when>
                                                    <c:when test="${contract.status == 'CANCELLED'}">
                                                        <span class="badge bg-soft-danger">Cancelled</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-soft-secondary">${contract.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="text-muted">Site</label>
                                            <p class="mb-0"><strong>${contract.siteName != null ? contract.siteName : 'N/A'}</strong></p>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="text-muted">Signed Date</label>
                                            <p class="mb-0"><strong>${contract.signedDate}</strong></p>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="text-muted">Start Date</label>
                                            <p class="mb-0"><strong>${contract.startDate}</strong></p>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="text-muted">End Date</label>
                                            <p class="mb-0"><strong>${contract.endDate}</strong></p>
                                        </div>
                                    </div>

                                    <c:if test="${not empty contract.note}">
                                        <div class="row mb-3">
                                            <div class="col-12">
                                                <label class="text-muted">Note</label>
                                                <p class="mb-0">${contract.note}</p>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Contract Items (Machines) -->
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <h6 class="mb-4">Rented Machines</h6>
                                    
                                    <c:choose>
                                        <c:when test="${not empty contract.contractItems}">
                                            <div class="table-responsive">
                                                <table class="table table-sm">
                                                    <thead>
                                                        <tr>
                                                            <th>Serial Number</th>
                                                            <th>Model</th>
                                                            <th>Brand</th>
                                                            <th>Delivery Date</th>
                                                            <th>Return Due Date</th>
                                                            <th>Price</th>
                                                            <th>Deposit</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="item" items="${contract.contractItems}">
                                                            <tr>
                                                                <td><strong>${item.serialNumber}</strong></td>
                                                                <td>${item.modelName}</td>
                                                                <td>${item.brand}</td>
                                                                <td>${item.deliveryDate}</td>
                                                                <td>${item.returnDueDate}</td>
                                                                <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" /></td>
                                                                <td><fmt:formatNumber value="${item.deposit}" type="currency" currencySymbol="₫" /></td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted">No machines in this contract.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Actions Sidebar -->
                        <div class="col-lg-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <h6 class="mb-4">Contract Summary</h6>
                                    
                                    <div class="mb-3">
                                        <label class="text-muted">Total Machines</label>
                                        <p class="mb-0"><strong>${contract.contractItems != null ? contract.contractItems.size() : 0}</strong></p>
                                    </div>

                                    <div class="mb-3">
                                        <label class="text-muted">Total Rental Cost</label>
                                        <p class="mb-0"><strong>
                                            <c:set var="totalPrice" value="0" />
                                            <c:forEach var="item" items="${contract.contractItems}">
                                                <c:set var="totalPrice" value="${totalPrice + item.price}" />
                                            </c:forEach>
                                            <fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₫" />
                                        </strong></p>
                                    </div>

                                    <div class="mb-3">
                                        <label class="text-muted">Total Deposit</label>
                                        <p class="mb-0"><strong>
                                            <c:set var="totalDeposit" value="0" />
                                            <c:forEach var="item" items="${contract.contractItems}">
                                                <c:set var="totalDeposit" value="${totalDeposit + item.deposit}" />
                                            </c:forEach>
                                            <fmt:formatNumber value="${totalDeposit}" type="currency" currencySymbol="₫" />
                                        </strong></p>
                                    </div>

                                    <hr>
                                    
                                    <a href="${pageContext.request.contextPath}/customer/contracts" class="btn btn-secondary w-100">
                                        <i class="mdi mdi-arrow-left me-1"></i> Back to List
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="../../customer/common/footer.jsp" />
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
