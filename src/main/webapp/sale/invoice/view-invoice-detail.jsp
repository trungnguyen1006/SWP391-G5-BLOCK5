<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Invoice Detail - ${contract.contractCode}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link href="../../assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../../assets/css/materialdesignicons.min.css" rel="stylesheet" type="text/css" />
    <link href="../../assets/css/style.min.css" rel="stylesheet" type="text/css" />
    
    <style>
        @media print {
            .no-print { display: none !important; }
            .page-wrapper { margin: 0; padding: 0; }
            .container-fluid { padding: 0; }
        }
    </style>
</head>

<body>
    <div class="page-wrapper doctris-theme toggled">
        <jsp:include page="../common/sidebar.jsp" />

        <main class="page-content bg-light">
            <jsp:include page="../common/header.jsp" />

            <div class="container-fluid">
                <div class="layout-specing">
                    <div class="d-md-flex justify-content-between no-print">
                        <h5 class="mb-0">Invoice Detail - ${contract.contractCode}</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/sale/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/sale/invoices">Invoices</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Detail</li>
                            </ul>
                        </nav>
                    </div>

                    <!-- Action Buttons -->
                    <div class="row mt-3 no-print">
                        <div class="col-12">
                            <a href="${pageContext.request.contextPath}/sale/invoices" class="btn btn-soft-primary">
                                <i class="mdi mdi-arrow-left me-1"></i> Back to List
                            </a>
                            <button type="button" class="btn btn-primary" onclick="window.print()">
                                <i class="mdi mdi-printer me-1"></i> Print Invoice
                            </button>
                            <c:if test="${contract.status == 'DRAFT'}">
                                <a href="${pageContext.request.contextPath}/sale/edit-invoice?id=${contract.contractId}" class="btn btn-success">
                                    <i class="mdi mdi-pencil me-1"></i> Edit Invoice
                                </a>
                            </c:if>
                        </div>
                    </div>

                    <!-- Invoice Content -->
                    <div class="row">
                        <div class="col-12 mt-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <!-- Invoice Header -->
                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <h3 class="mb-3">INVOICE</h3>
                                            <h5 class="text-primary">${contract.contractCode}</h5>
                                            <p class="text-muted mb-0">
                                                Created: <fmt:formatDate value="${contract.createdDate}" pattern="dd/MM/yyyy HH:mm" />
                                            </p>
                                        </div>
                                        <div class="col-md-6 text-md-end">
                                            <div class="mt-3">
                                                <c:choose>
                                                    <c:when test="${contract.status == 'DRAFT'}">
                                                        <span class="badge bg-secondary fs-6">Draft</span>
                                                    </c:when>
                                                    <c:when test="${contract.status == 'PENDING_APPROVAL'}">
                                                        <span class="badge bg-warning fs-6">Pending Approval</span>
                                                    </c:when>
                                                    <c:when test="${contract.status == 'APPROVED'}">
                                                        <span class="badge bg-info fs-6">Approved</span>
                                                    </c:when>
                                                    <c:when test="${contract.status == 'ACTIVE'}">
                                                        <span class="badge bg-success fs-6">Active</span>
                                                    </c:when>
                                                    <c:when test="${contract.status == 'CLOSED'}">
                                                        <span class="badge bg-dark fs-6">Closed</span>
                                                    </c:when>
                                                    <c:when test="${contract.status == 'CANCELLED'}">
                                                        <span class="badge bg-danger fs-6">Cancelled</span>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Customer & Contract Info -->
                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <h6 class="mb-3">Bill To:</h6>
                                            <address class="mb-0">
                                                <strong>${contract.customerName}</strong><br>
                                                <c:if test="${not empty contract.siteName}">
                                                    Site: ${contract.siteName}<br>
                                                </c:if>
                                            </address>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="mb-3">Contract Details:</h6>
                                            <table class="table table-borderless table-sm">
                                                <tr>
                                                    <td><strong>Start Date:</strong></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty contract.startDate}">
                                                                <fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy" />
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><strong>End Date:</strong></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty contract.endDate}">
                                                                <fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy" />
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Sale Person:</strong></td>
                                                    <td>${not empty contract.saleEmployeeName ? contract.saleEmployeeName : '-'}</td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>

                                    <!-- Contract Items -->
                                    <div class="row">
                                        <div class="col-12">
                                            <h6 class="mb-3">Machine Details:</h6>
                                            <div class="table-responsive">
                                                <table class="table table-bordered">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Serial Number</th>
                                                            <th>Machine Model</th>
                                                            <th>Brand</th>
                                                            <th>Delivery Date</th>
                                                            <th>Return Due Date</th>
                                                            <th class="text-end">Price</th>
                                                            <th class="text-end">Deposit</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="item" items="${contract.contractItems}">
                                                            <tr>
                                                                <td><strong>${item.serialNumber}</strong></td>
                                                                <td>
                                                                    ${item.modelName}
                                                                    <br><small class="text-muted">${item.modelCode}</small>
                                                                </td>
                                                                <td>${item.brand}</td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty item.deliveryDate}">
                                                                            <fmt:formatDate value="${item.deliveryDate}" pattern="dd/MM/yyyy" />
                                                                        </c:when>
                                                                        <c:otherwise>-</c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty item.returnDueDate}">
                                                                            <fmt:formatDate value="${item.returnDueDate}" pattern="dd/MM/yyyy" />
                                                                        </c:when>
                                                                        <c:otherwise>-</c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-end">
                                                                    <c:choose>
                                                                        <c:when test="${not empty item.price}">
                                                                            <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" />
                                                                        </c:when>
                                                                        <c:otherwise>-</c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-end">
                                                                    <c:choose>
                                                                        <c:when test="${not empty item.deposit}">
                                                                            <fmt:formatNumber value="${item.deposit}" type="currency" currencySymbol="₫" />
                                                                        </c:when>
                                                                        <c:otherwise>-</c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                    <tfoot class="table-light">
                                                        <tr>
                                                            <th colspan="5" class="text-end">Total Amount:</th>
                                                            <th class="text-end">
                                                                <fmt:formatNumber value="${contract.totalAmount}" type="currency" currencySymbol="₫" />
                                                            </th>
                                                            <th class="text-end">
                                                                <fmt:formatNumber value="${contract.totalDeposit}" type="currency" currencySymbol="₫" />
                                                            </th>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Notes -->
                                    <c:if test="${not empty contract.note}">
                                        <div class="row mt-4">
                                            <div class="col-12">
                                                <h6 class="mb-2">Notes:</h6>
                                                <p class="text-muted">${contract.note}</p>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Footer -->
                                    <div class="row mt-5">
                                        <div class="col-12 text-center">
                                            <p class="text-muted mb-0">Thank you for your business!</p>
                                        </div>
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
    <script src="../../assets/js/feather.min.js"></script>
    <script>
        feather.replace();
    </script>
</body>
</html>