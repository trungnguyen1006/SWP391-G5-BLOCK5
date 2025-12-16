<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Add Machine</title>
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
                        <h5 class="mb-0">Add New Machine</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/mgr/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/mgr/machines">Machines</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Add Machine</li>
                            </ul>
                        </nav>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="row justify-content-center">
                        <!-- Single Machine Form -->
                        <div class="col-lg-8 mt-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <h5 class="text-md-start text-center mb-4">Add New Machine</h5>

                                    <form action="${pageContext.request.contextPath}/mgr/add-machine" method="POST" id="addSingleForm">
                                        
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="mb-3">
                                                    <label class="form-label">Machine Model <span class="text-danger">*</span></label>
                                                    <select name="modelId" class="form-control" required>
                                                        <option value="">Select Machine Model</option>
                                                        <c:forEach var="model" items="${machineModels}">
                                                            <option value="${model.modelId}">${model.modelName} (${model.modelCode})</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Serial Number <span class="text-danger">*</span></label>
                                                    <input name="serialNumber" type="text" class="form-control" placeholder="Enter serial number" required>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Status</label>
                                                    <select name="status" class="form-control">
                                                        <option value="IN_STOCK">In Stock</option>
                                                        <option value="ALLOCATED">Allocated</option>
                                                        <option value="ON_SITE">On Site</option>
                                                        <option value="MAINTENANCE">Maintenance</option>
                                                        <option value="BROKEN">Broken</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-12">
                                                <div class="mb-3">
                                                    <label class="form-label">Warehouse</label>
                                                    <select name="warehouseId" class="form-control">
                                                        <option value="">Select Warehouse (Optional)</option>
                                                        <c:forEach var="warehouse" items="${warehouses}">
                                                            <option value="${warehouse.warehouseId}">${warehouse.warehouseName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-12">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="mdi mdi-plus me-1"></i>Add Machine
                                                </button>
                                                <a href="${pageContext.request.contextPath}/mgr/machines" class="btn btn-soft-primary ms-2">
                                                    <i class="mdi mdi-arrow-left me-1"></i>Back to List
                                                </a>
                                            </div>
                                        </div>
                                    </form>
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
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script>
        feather.replace();

        // Form validation and enhancement
        document.getElementById('addSingleForm').addEventListener('submit', function(e) {
            const serialNumber = document.querySelector('input[name="serialNumber"]').value.trim();
            const modelId = document.querySelector('select[name="modelId"]').value;
            
            if (!modelId) {
                e.preventDefault();
                alert('Please select a machine model');
                return false;
            }
            
            if (!serialNumber) {
                e.preventDefault();
                alert('Serial Number is required');
                return false;
            }
            
            // Convert serial number to uppercase for consistency
            document.querySelector('input[name="serialNumber"]').value = serialNumber.toUpperCase();
        });

        // Auto-uppercase serial number as user types
        document.querySelector('input[name="serialNumber"]').addEventListener('input', function(e) {
            e.target.value = e.target.value.toUpperCase();
        });

        // Show model details when selected
        document.querySelector('select[name="modelId"]').addEventListener('change', function(e) {
            const selectedOption = e.target.options[e.target.selectedIndex];
            if (selectedOption.value) {
                console.log('Selected model:', selectedOption.text);
            }
        });
    </script>
</body>
</html>
