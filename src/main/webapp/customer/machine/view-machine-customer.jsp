<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Machine Catalog</title>
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
        <jsp:include page="../common/sidebar.jsp" />

        <main class="page-content bg-light">
            <jsp:include page="../common/header.jsp" />

            <div class="container-fluid">
                <div class="layout-specing">
                    <div class="d-md-flex justify-content-between">
                        <h5 class="mb-0">Machine Catalog</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Machines</li>
                            </ul>
                        </nav>
                    </div>

                    <div class="row">
                        <c:forEach var="model" items="${machineModels}">
                            <div class="col-lg-4 col-md-6 mt-4">
                                <div class="card border-0 rounded shadow">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center justify-content-between">
                                            <div class="flex-1">
                                                <h6 class="mb-1">${model.modelName}</h6>
                                                <p class="text-muted mb-2">${model.brand} - ${model.category}</p>
                                                <span class="badge bg-soft-primary">${model.modelCode}</span>
                                            </div>
                                            <div class="avatar avatar-md-sm rounded-circle bg-soft-primary d-flex align-items-center justify-content-center">
                                                <i class="mdi mdi-cog text-primary h5 mb-0"></i>
                                            </div>
                                        </div>
                                        
                                        <c:if test="${not empty model.specs}">
                                            <div class="mt-3">
                                                <h6 class="mb-2">Specifications:</h6>
                                                <div class="text-muted small">
                                                    ${model.specs}
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <div class="mt-3">
                                            <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#machineModal${model.modelId}">
                                                View Details
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Machine Detail Modal -->
                            <div class="modal fade" id="machineModal${model.modelId}" tabindex="-1" aria-labelledby="machineModalLabel${model.modelId}" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="machineModalLabel${model.modelId}">${model.modelName}</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <h6>Basic Information</h6>
                                                    <table class="table table-borderless">
                                                        <tr>
                                                            <td><strong>Model Code:</strong></td>
                                                            <td>${model.modelCode}</td>
                                                        </tr>
                                                        <tr>
                                                            <td><strong>Brand:</strong></td>
                                                            <td>${model.brand}</td>
                                                        </tr>
                                                        <tr>
                                                            <td><strong>Category:</strong></td>
                                                            <td>${model.category}</td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <div class="col-md-6">
                                                    <h6>Specifications</h6>
                                                    <div class="text-muted">
                                                        <c:choose>
                                                            <c:when test="${not empty model.specs}">
                                                                ${model.specs}
                                                            </c:when>
                                                            <c:otherwise>
                                                                No specifications available
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                            <a href="${pageContext.request.contextPath}/customer/request-support" class="btn btn-primary">Request Support</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <c:if test="${empty machineModels}">
                        <div class="row">
                            <div class="col-12">
                                <div class="text-center mt-5">
                                    <div class="avatar avatar-xl rounded-circle bg-soft-primary mx-auto mb-4">
                                        <i class="mdi mdi-cog text-primary h1 mb-0"></i>
                                    </div>
                                    <h5>No Machines Available</h5>
                                    <p class="text-muted">There are currently no machines in our catalog.</p>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="d-flex justify-content-between align-items-center mt-4 px-3">
                            <div class="text-muted">
                                Showing page ${currentPage} of ${totalPages} (Total: ${totalModels} machines)
                            </div>
                            <nav aria-label="Page navigation">
                                <ul class="pagination mb-0">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/customer/machines?page=${currentPage - 1}">Previous</a>
                                    </li>
                                    
                                    <c:forEach var="i" begin="1" end="${totalPages > 5 ? 5 : totalPages}">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/customer/machines?page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/customer/machines?page=${currentPage + 1}">Next</a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </c:if>
                </div>
            </div>

            <jsp:include page="../common/footer.jsp" />
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