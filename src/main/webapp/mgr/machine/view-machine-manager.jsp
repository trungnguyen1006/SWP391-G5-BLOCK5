<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Machine Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/assets/css/simplebar.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/assets/css/materialdesignicons.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/assets/css/remixicon.css" rel="stylesheet" type="text/css" />
    <link href="https://unicons.iconscout.com/release/v3.0.6/css/line.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.min.css" rel="stylesheet" type="text/css" />
    <style>
        .accordion-button {
            padding: 1rem;
            font-weight: 500;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
        }
        .accordion-button:not(.collapsed) {
            background-color: #e7f1ff;
            color: #0d6efd;
        }
        .accordion-button:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
        .accordion-body {
            padding: 0;
        }
        .accordion-item {
            border: 1px solid #dee2e6;
            margin-bottom: 0.5rem;
        }
        .accordion-header {
            padding: 0;
        }
    </style>
</head>

<body>
    <div class="page-wrapper doctris-theme toggled">
        <jsp:include page="../../mgr/common/sidebar.jsp" />

        <main class="page-content bg-light">
            <jsp:include page="../../mgr/common/header.jsp" />

            <div class="container-fluid">
                <div class="layout-specing">
                    <div class="d-md-flex justify-content-between">
                        <h5 class="mb-0">Machine Management</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/mgr/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Machines</li>
                            </ul>
                        </nav>
                    </div>

                    <c:if test="${param.added == 'true'}">
                        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                            <strong>Success!</strong> Machine has been added successfully.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty param.imported}">
                        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                            <strong>Success!</strong> ${param.imported} machines have been imported successfully.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${param.updated == 'true'}">
                        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                            <strong>Success!</strong> Machine has been updated successfully.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${param.deleted == 'true'}">
                        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                            <strong>Success!</strong> Machine has been deleted successfully.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Statistics Cards -->
                    <div class="row mt-3">
                        <div class="col-xl-3 col-lg-6 col-md-6 mt-4">
                            <div class="card border-0 shadow rounded">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div class="flex-1">
                                            <h6 class="text-muted mb-0">Total Machines</h6>
                                            <h4 class="mb-0">${totalMachines}</h4>
                                        </div>
                                        <div class="avatar avatar-md-sm rounded-circle bg-soft-primary d-flex align-items-center justify-content-center">
                                            <i class="mdi mdi-cog text-primary h5 mb-0"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-lg-6 col-md-6 mt-4">
                            <div class="card border-0 shadow rounded">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div class="flex-1">
                                            <h6 class="text-muted mb-0">In Stock</h6>
                                            <h4 class="mb-0">${statusCount['IN_STOCK'] != null ? statusCount['IN_STOCK'] : 0}</h4>
                                        </div>
                                        <div class="avatar avatar-md-sm rounded-circle bg-soft-success d-flex align-items-center justify-content-center">
                                            <i class="mdi mdi-check-circle text-success h5 mb-0"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-lg-6 col-md-6 mt-4">
                            <div class="card border-0 shadow rounded">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div class="flex-1">
                                            <h6 class="text-muted mb-0">On Site</h6>
                                            <h4 class="mb-0">${statusCount['ON_SITE'] != null ? statusCount['ON_SITE'] : 0}</h4>
                                        </div>
                                        <div class="avatar avatar-md-sm rounded-circle bg-soft-warning d-flex align-items-center justify-content-center">
                                            <i class="mdi mdi-map-marker text-warning h5 mb-0"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-lg-6 col-md-6 mt-4">
                            <div class="card border-0 shadow rounded">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div class="flex-1">
                                            <h6 class="text-muted mb-0">Maintenance</h6>
                                            <h4 class="mb-0">${statusCount['MAINTENANCE'] != null ? statusCount['MAINTENANCE'] : 0}</h4>
                                        </div>
                                        <div class="avatar avatar-md-sm rounded-circle bg-soft-danger d-flex align-items-center justify-content-center">
                                            <i class="mdi mdi-wrench text-danger h5 mb-0"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="row mt-3">
                        <div class="col-12">
                            <a href="${pageContext.request.contextPath}/mgr/add-machine" class="btn btn-primary">
                                <i class="mdi mdi-plus me-1"></i> Add New Machine
                            </a>
                        </div>
                    </div>

                    <!-- Filter Form -->
                    <div class="row mt-3">
                        <div class="col-12">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <form method="GET" action="${pageContext.request.contextPath}/mgr/machines" class="row g-3">
                                        <div class="col-md-4">
                                            <label class="form-label">Filter by Status</label>
                                            <select name="status" class="form-control">
                                                <option value="">-- All Status --</option>
                                                <option value="IN_STOCK" ${status == 'IN_STOCK' ? 'selected' : ''}>In Stock</option>
                                                <option value="ON_SITE" ${status == 'ON_SITE' ? 'selected' : ''}>On Site</option>
                                                <option value="MAINTENANCE" ${status == 'MAINTENANCE' ? 'selected' : ''}>Maintenance</option>
                                                <option value="ALLOCATED" ${status == 'ALLOCATED' ? 'selected' : ''}>Allocated</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Filter by Model</label>
                                            <select name="model" class="form-control">
                                                <option value="">-- All Models --</option>
                                                <c:forEach var="modelEntry" items="${modelCount}">
                                                    <option value="${modelEntry.key}" ${model == modelEntry.key ? 'selected' : ''}>${modelEntry.key}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-4 d-flex align-items-end gap-2">
                                            <button type="submit" class="btn btn-primary flex-fill">
                                                <i class="mdi mdi-filter me-1"></i> Filter
                                            </button>
                                            <a href="${pageContext.request.contextPath}/mgr/machines" class="btn btn-secondary">
                                                <i class="mdi mdi-refresh me-1"></i> Reset
                                            </a>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Machine List - Accordion by Model -->
                    <div class="row">
                        <div class="col-12 mt-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${empty groupedByModel}">
                                            <div class="alert alert-info">No machines found.</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="accordion" id="machineAccordion">
                                                <c:forEach var="modelEntry" items="${groupedByModel}" varStatus="status">
                                                    <c:set var="modelName" value="${modelEntry.key}" />
                                                    <c:set var="units" value="${modelEntry.value}" />
                                                    <c:set var="modelId" value="model_${status.index}" />
                                                    <div class="accordion-item">
                                                        <h2 class="accordion-header">
                                                            <div class="accordion-button" onclick="toggleAccordion('${modelId}')">
                                                                <strong>${modelName}</strong>
                                                                <span class="badge bg-primary ms-2">${units.size()} unit(s)</span>
                                                            </div>
                                                        </h2>
                                                        <div id="${modelId}" class="accordion-collapse collapse" data-bs-parent="#machineAccordion">
                                                            <div class="accordion-body p-0">
                                                                <div class="table-responsive">
                                                                    <table class="table table-sm table-hover mb-0">
                                                                        <thead class="table-light">
                                                                            <tr>
                                                                                <th class="p-3">Serial Number</th>
                                                                                <th class="p-3">Status</th>
                                                                                <th class="p-3">Location</th>
                                                                                <th class="p-3">Actions</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <c:forEach var="unit" items="${units}">
                                                                                <tr>
                                                                                    <td class="p-3">
                                                                                        <strong>${unit.serialNumber}</strong>
                                                                                        <br><small class="text-muted">ID: ${unit.unitId}</small>
                                                                                    </td>
                                                                                    <td class="p-3">
                                                                                        <c:choose>
                                                                                            <c:when test="${unit.currentStatus == 'IN_STOCK'}">
                                                                                                <span class="badge bg-soft-success">In Stock</span>
                                                                                            </c:when>
                                                                                            <c:when test="${unit.currentStatus == 'ON_SITE'}">
                                                                                                <span class="badge bg-soft-warning">On Site</span>
                                                                                            </c:when>
                                                                                            <c:when test="${unit.currentStatus == 'MAINTENANCE'}">
                                                                                                <span class="badge bg-soft-danger">Maintenance</span>
                                                                                            </c:when>
                                                                                            <c:when test="${unit.currentStatus == 'ALLOCATED'}">
                                                                                                <span class="badge bg-soft-info">Allocated</span>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span class="badge bg-soft-secondary">${unit.currentStatus}</span>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td class="p-3">
                                                                                        <c:choose>
                                                                                            <c:when test="${not empty unit.warehouseName}">
                                                                                                <i class="mdi mdi-warehouse text-muted me-1"></i>${unit.warehouseName}
                                                                                            </c:when>
                                                                                            <c:when test="${not empty unit.siteName}">
                                                                                                <i class="mdi mdi-map-marker text-muted me-1"></i>${unit.siteName}
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span class="text-muted">-</span>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td class="p-3">
                                                                                        <button type="button" class="btn btn-icon btn-pills btn-soft-primary btn-sm" 
                                                                                                data-bs-toggle="modal" data-bs-target="#machineDetailModal_${unit.unitId}" title="View Details">
                                                                                            <i class="mdi mdi-eye"></i>
                                                                                        </button>
                                                                                        <a href="${pageContext.request.contextPath}/mgr/update-machine?id=${unit.unitId}" 
                                                                                           class="btn btn-icon btn-pills btn-soft-success btn-sm" title="Edit">
                                                                                            <i class="mdi mdi-pencil"></i>
                                                                                        </a>
                                                                                        <a href="${pageContext.request.contextPath}/mgr/delete-machine?id=${unit.unitId}" 
                                                                                           class="btn btn-icon btn-pills btn-soft-danger btn-sm" title="Delete" 
                                                                                           onclick="return confirm('Are you sure?');">
                                                                                            <i class="mdi mdi-delete"></i>
                                                                                        </a>
                                                                                    </td>
                                                                                </tr>
                                                                            </c:forEach>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Machine Detail Modals -->
                    <c:forEach var="unit" items="${machineUnits}">
                        <div class="modal fade" id="machineDetailModal_${unit.unitId}" tabindex="-1" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Machine Details - ${unit.serialNumber}</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <h6 class="mb-3">Basic Information</h6>
                                                <table class="table table-borderless table-sm">
                                                    <tr>
                                                        <td><strong>Serial Number:</strong></td>
                                                        <td>${unit.serialNumber}</td>
                                                    </tr>
                                                    <tr>
                                                        <td><strong>Model:</strong></td>
                                                        <td>${unit.machineModel.modelName}</td>
                                                    </tr>
                                                    <tr>
                                                        <td><strong>Model Code:</strong></td>
                                                        <td>${unit.machineModel.modelCode}</td>
                                                    </tr>
                                                    <tr>
                                                        <td><strong>Brand:</strong></td>
                                                        <td>${unit.machineModel.brand}</td>
                                                    </tr>
                                                    <tr>
                                                        <td><strong>Category:</strong></td>
                                                        <td>${unit.machineModel.category}</td>
                                                    </tr>
                                                    <tr>
                                                        <td><strong>Status:</strong></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${unit.currentStatus == 'IN_STOCK'}">
                                                                    <span class="badge bg-soft-success">In Stock</span>
                                                                </c:when>
                                                                <c:when test="${unit.currentStatus == 'ON_SITE'}">
                                                                    <span class="badge bg-soft-warning">On Site</span>
                                                                </c:when>
                                                                <c:when test="${unit.currentStatus == 'MAINTENANCE'}">
                                                                    <span class="badge bg-soft-danger">Maintenance</span>
                                                                </c:when>
                                                                <c:when test="${unit.currentStatus == 'ALLOCATED'}">
                                                                    <span class="badge bg-soft-info">Allocated</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-soft-secondary">${unit.currentStatus}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div class="col-md-6">
                                                <h6 class="mb-3">Location & Specifications</h6>
                                                <table class="table table-borderless table-sm">
                                                    <tr>
                                                        <td><strong>Location:</strong></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty unit.warehouseName}">
                                                                    <i class="mdi mdi-warehouse text-muted me-1"></i>${unit.warehouseName}
                                                                </c:when>
                                                                <c:when test="${not empty unit.siteName}">
                                                                    <i class="mdi mdi-map-marker text-muted me-1"></i>${unit.siteName}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">-</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <h6 class="mb-2 mt-3">Specifications</h6>
                                                <div class="text-muted small">
                                                    <c:choose>
                                                        <c:when test="${not empty unit.machineModel.specs}">
                                                            ${unit.machineModel.specs}
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
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="row mt-4">
                            <div class="col-12">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="text-muted">
                                        Page ${currentPage} of ${totalPages} (Total: ${totalMachines} machines)
                                    </div>
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination mb-0">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/mgr/machines?page=${currentPage - 1}${not empty status ? '&status=' : ''}${status}${not empty model ? '&model=' : ''}${model}">Previous</a>
                                            </li>
                                            
                                            <c:forEach var="i" begin="1" end="${totalPages > 5 ? 5 : totalPages}">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/mgr/machines?page=${i}${not empty status ? '&status=' : ''}${status}${not empty model ? '&model=' : ''}${model}">${i}</a>
                                                </li>
                                            </c:forEach>
                                            
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/mgr/machines?page=${currentPage + 1}${not empty status ? '&status=' : ''}${status}${not empty model ? '&model=' : ''}${model}">Next</a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <jsp:include page="../../mgr/common/footer.jsp" />
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/simplebar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/feather.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script>
        feather.replace();
        
        function toggleAccordion(modelId) {
            const element = document.getElementById(modelId);
            if (element) {
                element.classList.toggle('show');
                const button = element.closest('.accordion-item').querySelector('.accordion-button');
                if (button) {
                    button.classList.toggle('collapsed');
                }
            }
        }
    </script>
</body>
</html>
