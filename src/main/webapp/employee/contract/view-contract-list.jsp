<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Contract List</title>
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

                    <c:if test="${param.deleted == 'true'}">
                        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                            <strong>Success!</strong> Contract has been deleted successfully.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${param.error == 'only_draft_can_be_deleted'}">
                        <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                            <strong>Error!</strong> Only draft contracts can be deleted.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Filter Form -->
                    <div class="row mt-3">
                        <div class="col-12">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <form method="GET" action="${pageContext.request.contextPath}/employee/contracts" class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label">Filter by Status</label>
                                            <select name="status" class="form-control">
                                                <option value="">-- All Status --</option>
                                                <option value="DRAFT" ${status == 'DRAFT' ? 'selected' : ''}>Draft</option>
                                                <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                                                <option value="COMPLETED" ${status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                                <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6 d-flex align-items-end">
                                            <button type="submit" class="btn btn-primary w-100">
                                                <i class="mdi mdi-filter me-1"></i> Filter
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Statistics Cards -->
                    <div class="row mt-3">
                        <div class="col-xl-3 col-lg-6 col-md-6 mt-4">
                            <div class="card border-0 shadow rounded">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div class="flex-1">
                                            <h6 class="text-muted mb-0">Total Contracts</h6>
                                            <h4 class="mb-0">${totalContracts}</h4>
                                        </div>
                                        <div class="avatar avatar-md-sm rounded-circle bg-soft-primary d-flex align-items-center justify-content-center">
                                            <i class="mdi mdi-file-contract text-primary h5 mb-0"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="row mt-3">
                        <div class="col-12">
                            <a href="${pageContext.request.contextPath}/employee/add-contract" class="btn btn-primary">
                                <i class="mdi mdi-plus me-1"></i> Create New Contract
                            </a>
                        </div>
                    </div>

                    <!-- Contract List -->
                    <div class="row">
                        <div class="col-12 mt-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty contracts}">
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
                                                        <c:forEach var="contract" items="${contracts}">
                                                            <tr>
                                                                <td class="p-3">
                                                                    <strong>${contract.contractCode}</strong>
                                                                </td>
                                                                <td class="p-3">
                                                                    ${contract.customerName}
                                                                </td>
                                                                <td class="p-3">
                                                                    ${contract.startDate}
                                                                </td>
                                                                <td class="p-3">
                                                                    ${contract.endDate}
                                                                </td>
                                                                <td class="p-3">
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
                                                                </td>
                                                                <td class="p-3">
                                                                    <a href="${pageContext.request.contextPath}/employee/contract-detail?id=${contract.contractId}" 
                                                                       class="btn btn-icon btn-pills btn-soft-primary btn-sm" title="View Details">
                                                                        <i class="mdi mdi-eye"></i>
                                                                    </a>
                                                                    <c:if test="${contract.status == 'DRAFT'}">
                                                                        <a href="${pageContext.request.contextPath}/employee/delete-contract?id=${contract.contractId}" 
                                                                           class="btn btn-icon btn-pills btn-soft-danger btn-sm" title="Delete"
                                                                           onclick="return confirm('Are you sure you want to delete this draft contract?');">
                                                                            <i class="mdi mdi-delete"></i>
                                                                        </a>
                                                                    </c:if>
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
                                                        Showing page ${currentPage} of ${totalPages} (Total: ${totalContracts} contracts)
                                                    </div>
                                                    <nav aria-label="Page navigation">
                                                        <ul class="pagination mb-0">
                                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                                <a class="page-link" href="${pageContext.request.contextPath}/employee/contracts?page=${currentPage - 1}${not empty status ? '&status=' : ''}${status}">Previous</a>
                                                            </li>
                                                            
                                                            <c:forEach var="i" begin="1" end="${totalPages > 5 ? 5 : totalPages}">
                                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                                    <a class="page-link" href="${pageContext.request.contextPath}/employee/contracts?page=${i}${not empty status ? '&status=' : ''}${status}">${i}</a>
                                                                </li>
                                                            </c:forEach>
                                                            
                                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                                <a class="page-link" href="${pageContext.request.contextPath}/employee/contracts?page=${currentPage + 1}${not empty status ? '&status=' : ''}${status}">Next</a>
                                                            </li>
                                                        </ul>
                                                    </nav>
                                                </div>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-5">
                                                <i class="mdi mdi-file-document-outline h1 text-muted"></i>
                                                <p class="text-muted mt-3">No contracts found. Create your first contract.</p>
                                                <a href="${pageContext.request.contextPath}/employee/add-contract" class="btn btn-primary mt-3">
                                                    <i class="mdi mdi-plus me-1"></i> Create Contract
                                                </a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
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
