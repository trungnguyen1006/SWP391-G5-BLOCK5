<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>Invoice Management</title>
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
            <jsp:include page="../../admin/common/sidebar.jsp" />

            <main class="page-content bg-light">
                <jsp:include page="../../admin/common/header.jsp" />

                <div class="container-fluid">
                    <div class="layout-specing">
                        <div class="d-md-flex justify-content-between">
                            <h5 class="mb-0">Invoice Management</h5>
                            <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                                <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/sale/dashboard">Dashboard</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Invoices</li>
                                </ul>
                            </nav>
                        </div>

                        <c:if test="${param.added == 'true'}">
                            <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                                <strong>Success!</strong> Invoice has been created successfully.
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Action Buttons -->
                        <div class="row mt-3">
                            <div class="col-12">
                                <a href="${pageContext.request.contextPath}/sale/add-invoice" class="btn btn-primary">
                                    <i class="mdi mdi-plus me-1"></i> Create New Invoice
                                </a>
                            </div>
                        </div>

                        <!-- Invoice List -->
                        <div class="row">
                            <div class="col-12 mt-4">
                                <div class="card border-0 rounded shadow">
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-center bg-white mb-0">
                                                <thead>
                                                    <tr>
                                                        <th class="border-bottom p-3">Contract Code</th>
                                                        <th class="border-bottom p-3">Customer</th>
                                                        <th class="border-bottom p-3">Site</th>
                                                        <th class="border-bottom p-3">Status</th>
                                                        <th class="border-bottom p-3">Start Date</th>
                                                        <th class="border-bottom p-3">End Date</th>
                                                        <th class="border-bottom p-3">Created Date</th>
                                                        <th class="border-bottom p-3">Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="contract" items="${contracts}">
                                                        <tr>
                                                            <td class="p-3">
                                                                <strong>${contract.contractCode}</strong>
                                                            </td>
                                                            <td class="p-3">${contract.customerName}</td>
                                                            <td class="p-3">
                                                                <c:choose>
                                                                    <c:when test="${not empty contract.siteName}">
                                                                        ${contract.siteName}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-muted">-</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="p-3">
                                                                <c:choose>
                                                                    <c:when test="${contract.status == 'DRAFT'}">
                                                                        <span class="badge bg-soft-secondary">Draft</span>
                                                                    </c:when>
                                                                    <c:when test="${contract.status == 'PENDING_APPROVAL'}">
                                                                        <span class="badge bg-soft-warning">Pending Approval</span>
                                                                    </c:when>
                                                                    <c:when test="${contract.status == 'APPROVED'}">
                                                                        <span class="badge bg-soft-info">Approved</span>
                                                                    </c:when>
                                                                    <c:when test="${contract.status == 'ACTIVE'}">
                                                                        <span class="badge bg-soft-success">Active</span>
                                                                    </c:when>
                                                                    <c:when test="${contract.status == 'CLOSED'}">
                                                                        <span class="badge bg-soft-dark">Closed</span>
                                                                    </c:when>
                                                                    <c:when test="${contract.status == 'CANCELLED'}">
                                                                        <span class="badge bg-soft-danger">Cancelled</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-soft-secondary">${contract.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="p-3">
                                                                <c:choose>
                                                                    <c:when test="${not empty contract.startDate}">
                                                                        <fmt:formatDate value="${contract.startDateAsDate}" pattern="dd/MM/yyyy" />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-muted">-</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="p-3">
                                                                <c:choose>
                                                                    <c:when test="${not empty contract.endDate}">
                                                                        <fmt:formatDate value="${contract.endDateAsDate}" pattern="dd/MM/yyyy" />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-muted">-</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="p-3">
                                                                <fmt:formatDate value="${contract.createdDateAsDate}" pattern="dd/MM/yyyy HH:mm" />

                                                            </td>
                                                            <td class="p-3">
                                                                <a href="${pageContext.request.contextPath}/sale/invoice-detail?id=${contract.contractId}" style="cursor: pointer;">
                                                                    <i class="mdi mdi-eye" title="View Details"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Pagination -->
                                        <c:if test="${totalPages > 1}">
                                            <div class="d-flex justify-content-between align-items-center mt-4 px-3">
                                                <div class="text-muted">
                                                    Showing page ${currentPage} of ${totalPages} (Total: ${totalContracts} invoices)
                                                </div>
                                                <nav aria-label="Page navigation">
                                                    <ul class="pagination mb-0">
                                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                            <a class="page-link" href="${pageContext.request.contextPath}/sale/invoices?page=${currentPage - 1}">Previous</a>
                                                        </li>

                                                        <c:forEach var="i" begin="1" end="${totalPages > 5 ? 5 : totalPages}">
                                                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                                <a class="page-link" href="${pageContext.request.contextPath}/sale/invoices?page=${i}">${i}</a>
                                                            </li>
                                                        </c:forEach>

                                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                            <a class="page-link" href="${pageContext.request.contextPath}/sale/invoices?page=${currentPage + 1}">Next</a>
                                                        </li>
                                                    </ul>
                                                </nav>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <jsp:include page="../../admin/common/footer.jsp" />
            </main>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/simplebar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/feather.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
        <script>
            feather.replace();

            function printInvoice(contractId) {
                window.open('${pageContext.request.contextPath}/sale/print-invoice?id=' + contractId, '_blank');
            }

            // Print button handler
            document.querySelectorAll('.print-btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    const contractId = this.getAttribute('data-contract-id');
                    printInvoice(contractId);
                });
            });
        </script>
    </body>
</html>