<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Update Machine</title>
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
        <jsp:include page="../../mgr/common/sidebar.jsp" />

        <main class="page-content bg-light">
            <jsp:include page="../../mgr/common/header.jsp" />

            <div class="container-fluid">
                <div class="layout-specing">
                    <div class="d-md-flex justify-content-between">
                        <h5 class="mb-0">Update Machine</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/mgr/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/mgr/machines">Machines</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Update</li>
                            </ul>
                        </nav>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="row">
                        <div class="col-lg-8 mt-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <h5 class="text-md-start text-center mb-4">Machine Information</h5>

                                    <form action="${pageContext.request.contextPath}/mgr/update-machine" method="POST" id="updateMachineForm">
                                        <input type="hidden" name="unitId" value="${machineUnit.unitId}">
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Machine Model <span class="text-danger">*</span></label>
                                                    <select name="modelId" class="form-control" required>
                                                        <option value="">Select Machine Model</option>
                                                        <c:forEach var="model" items="${machineModels}">
                                                            <option value="${model.modelId}" ${model.modelId == machineUnit.modelId ? 'selected' : ''}>
                                                                ${model.modelName} (${model.modelCode})
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Serial Number <span class="text-danger">*</span></label>
                                                    <input name="serialNumber" type="text" class="form-control" 
                                                           value="${machineUnit.serialNumber}" placeholder="Enter serial number" required>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Status</label>
                                                    <select name="status" class="form-control">
                                                        <option value="IN_STOCK" ${machineUnit.currentStatus == 'IN_STOCK' ? 'selected' : ''}>In Stock</option>
                                                        <option value="ALLOCATED" ${machineUnit.currentStatus == 'ALLOCATED' ? 'selected' : ''}>Allocated</option>
                                                        <option value="ON_SITE" ${machineUnit.currentStatus == 'ON_SITE' ? 'selected' : ''}>On Site</option>
                                                        <option value="MAINTENANCE" ${machineUnit.currentStatus == 'MAINTENANCE' ? 'selected' : ''}>Maintenance</option>
                                                        <option value="BROKEN" ${machineUnit.currentStatus == 'BROKEN' ? 'selected' : ''}>Broken</option>
                                                        <option value="LOST" ${machineUnit.currentStatus == 'LOST' ? 'selected' : ''}>Lost</option>
                                                        <option value="RETIRED" ${machineUnit.currentStatus == 'RETIRED' ? 'selected' : ''}>Retired</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Warehouse</label>
                                                    <select name="warehouseId" class="form-control">
                                                        <option value="">Select Warehouse</option>
                                                        <c:forEach var="warehouse" items="${warehouses}">
                                                            <option value="${warehouse.warehouseId}" 
                                                                    ${warehouse.warehouseId == machineUnit.currentWarehouseId ? 'selected' : ''}>
                                                                ${warehouse.warehouseName}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-12">
                                                <button type="submit" class="btn btn-primary">Update Machine</button>
                                                <a href="${pageContext.request.contextPath}/mgr/machines" class="btn btn-soft-primary ms-2">Cancel</a>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Machine Details -->
                        <div class="col-lg-4 mt-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <h5 class="mb-4">Current Machine Details</h5>
                                    
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Unit ID</label>
                                        <p class="mb-0">${machineUnit.unitId}</p>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Current Model</label>
                                        <p class="mb-0">${machineUnit.machineModel.modelName}</p>
                                        <small class="text-muted">${machineUnit.machineModel.modelCode}</small>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Brand</label>
                                        <p class="mb-0">${machineUnit.machineModel.brand}</p>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Category</label>
                                        <p class="mb-0">${machineUnit.machineModel.category}</p>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Current Location</label>
                                        <p class="mb-0">
                                            <c:choose>
                                                <c:when test="${not empty machineUnit.warehouseName}">
                                                    <i class="mdi mdi-warehouse text-muted me-1"></i>${machineUnit.warehouseName}
                                                </c:when>
                                                <c:when test="${not empty machineUnit.siteName}">
                                                    <i class="mdi mdi-map-marker text-muted me-1"></i>${machineUnit.siteName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">No location assigned</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label text-muted">Created Date</label>
                                        <p class="mb-0">
                                            <fmt:formatDate value="${machineUnit.createdDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="../../mgr/common/footer.jsp" />
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/simplebar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/feather.min.js"></script>
    <script>
        feather.replace();

        // Form validation
        document.getElementById('updateMachineForm').addEventListener('submit', function(e) {
            const serialNumber = document.querySelector('input[name="serialNumber"]').value.trim();
            if (!serialNumber) {
                e.preventDefault();
                alert('Serial Number is required');
                return false;
            }
        });
    </script>
</body>
</html>
