<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Contract Detail</title>
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
        <jsp:include page="../../employee/common/sidebar.jsp" />

        <main class="page-content bg-light">
            <jsp:include page="../../employee/common/header.jsp" />

            <div class="container-fluid">
                <div class="layout-specing">
                    <div class="d-md-flex justify-content-between">
                        <h5 class="mb-0">Contract Detail</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employee/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employee/contracts">Contracts</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Detail</li>
                            </ul>
                        </nav>
                    </div>

                    <div class="row mt-4">
                        <div class="col-lg-10">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <h6>Contract Information</h6>
                                            <p><strong>Contract Code:</strong> ${contract.contractCode}</p>
                                            <p><strong>Customer:</strong> ${contract.customerName}</p>
                                            <p><strong>Status:</strong> <span class="badge bg-info">${contract.status}</span></p>
                                        </div>
                                        <div class="col-md-6">
                                            <p><strong>Start Date:</strong> ${contract.startDate}</p>
                                            <p><strong>End Date:</strong> ${contract.endDate}</p>
                                            <p><strong>Note:</strong> ${contract.note}</p>
                                        </div>
                                    </div>

                                    <hr>

                                    <h6 class="mb-3">Contract Items</h6>
                                    <div class="table-responsive">
                                        <table class="table table-sm bg-white mb-0">
                                            <thead>
                                                <tr>
                                                    <th class="border-bottom p-3">Machine Serial</th>
                                                    <th class="border-bottom p-3">Price</th>
                                                    <th class="border-bottom p-3">Deposit</th>
                                                    <th class="border-bottom p-3">Delivery Date</th>
                                                    <th class="border-bottom p-3">Return Due Date</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${not empty contract.contractItems}">
                                                        <c:forEach var="item" items="${contract.contractItems}">
                                                            <tr>
                                                                <td class="p-3">${item.unitSerialNumber}</td>
                                                                <td class="p-3">${item.price}</td>
                                                                <td class="p-3">${item.deposit}</td>
                                                                <td class="p-3">${item.deliveryDate}</td>
                                                                <td class="p-3">${item.returnDueDate}</td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr>
                                                            <td colspan="5" class="text-center p-3 text-muted">No items</td>
                                                        </tr>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div class="row mt-4">
                                        <div class="col-md-6 offset-md-6">
                                            <div class="card bg-light">
                                                <div class="card-body">
                                                    <p><strong>Total Amount:</strong> ${contract.totalAmount}</p>
                                                    <p><strong>Total Deposit:</strong> ${contract.totalDeposit}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="d-flex gap-2 mt-4">
                                        <a href="${pageContext.request.contextPath}/employee/contracts" class="btn btn-secondary">
                                            <i class="mdi mdi-arrow-left me-1"></i> Back
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="../../employee/common/footer.jsp" />
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
