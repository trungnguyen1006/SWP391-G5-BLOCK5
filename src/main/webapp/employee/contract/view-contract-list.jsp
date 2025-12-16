<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Contract Management</title>
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
                        <h5 class="mb-0">Contract Management</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employee/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Contracts</li>
                            </ul>
                        </nav>
                    </div>

                    <c:if test="${param.added == 'true'}">
                        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                            <strong>Success!</strong> Contract has been created successfully.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Action Buttons -->
                    <div class="row mt-3">
                        <div class="col-12">
                            <a href="${pageContext.request.contextPath}/employee/add-contract" class="btn btn-primary">
                                <i class="mdi mdi-plus me-1"></i> Add New Contract
                            </a>
                        </div>
                    </div>

                    <!-- Contract List -->
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
                                                    <th class="border-bottom p-3">Start Date</th>
                                                    <th class="border-bottom p-3">End Date</th>
                                                    <th class="border-bottom p-3">Status</th>
                                                    <th class="border-bottom p-3">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${not empty contracts}">
                                                        <c:forEach var="contract" items="${contracts}">
                                                            <tr>
                                                                <td class="p-3">
                                                                    <strong>${contract.contractCode}</strong>
                                                                </td>
                                                                <td class="p-3">${contract.customerName}</td>
                                                                <td class="p-3">
                                                                    <c:choose>
                                                                        <c:when test="${not empty contract.startDate}">
                                                                            ${contract.startDate}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">-</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="p-3">
                                                                    <c:choose>
                                                                        <c:when test="${not empty contract.endDate}">
                                                                            ${contract.endDate}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">-</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="p-3">
                                                                    <span class="badge bg-info">${contract.status}</span>
                                                                </td>
                                                                <td class="p-3">
                                                                    <a href="${pageContext.request.contextPath}/employee/contract-detail?id=${contract.contractId}" class="btn btn-sm btn-soft-primary" title="View">
                                                                        <i class="mdi mdi-eye"></i>
                                                                    </a>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr>
                                                            <td colspan="6" class="text-center p-3 text-muted">
                                                                No contracts found
                                                            </td>
                                                        </tr>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Pagination -->
                                    <c:if test="${totalPages > 1}">
                                        <div class="d-flex justify-content-between align-items-center mt-4 px-3">
                                            <div class="text-muted">
                                                Showing page ${currentPage} of ${totalPages} (Total: ${totalContracts} contracts)
                                            </div>
                                            <nav aria-label="Page navigation">
                                                <ul class="pagination mb-0">
                                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/employee/contracts?page=${currentPage - 1}">Previous</a>
                                                    </li>

                                                    <c:forEach var="i" begin="1" end="${totalPages > 5 ? 5 : totalPages}">
                                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                            <a class="page-link" href="${pageContext.request.contextPath}/employee/contracts?page=${i}">${i}</a>
                                                        </li>
                                                    </c:forEach>

                                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/employee/contracts?page=${currentPage + 1}">Next</a>
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
