<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Add Machine</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link href="../../assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../../assets/css/materialdesignicons.min.css" rel="stylesheet" type="text/css" />
    <link href="../../assets/css/style.min.css" rel="stylesheet" type="text/css" />
</head>

<body>
    <div class="page-wrapper doctris-theme toggled">
        <jsp:include page="../common/sidebar.jsp" />

        <main class="page-content bg-light">
            <jsp:include page="../common/header.jsp" />

            <div class="container-fluid">
                <div class="layout-specing">
                    <div class="d-md-flex justify-content-between">
                        <h5 class="mb-0">Add New Machine</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/machines">Machines</a></li>
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

                    <div class="row">
                        <!-- Single Machine Form -->
                        <div class="col-lg-6 mt-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <h5 class="text-md-start text-center mb-4">Add Single Machine</h5>

                                    <form action="${pageContext.request.contextPath}/admin/add-machine" method="POST" id="addSingleForm">
                                        <input type="hidden" name="action" value="addSingle">
                                        
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

                                            <div class="col-12">
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

                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Warehouse</label>
                                                    <select name="warehouseId" class="form-control">
                                                        <option value="">Select Warehouse</option>
                                                        <c:forEach var="warehouse" items="${warehouses}">
                                                            <option value="${warehouse.warehouseId}">${warehouse.warehouseName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-12">
                                                <button type="submit" class="btn btn-primary">Add Machine</button>
                                                <a href="${pageContext.request.contextPath}/admin/machines" class="btn btn-soft-primary ms-2">Cancel</a>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Excel Import Form -->
                        <div class="col-lg-6 mt-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <h5 class="text-md-start text-center mb-4">Import from Excel</h5>

                                    <form action="${pageContext.request.contextPath}/admin/add-machine" method="POST" enctype="multipart/form-data" id="importExcelForm">
                                        <input type="hidden" name="action" value="importExcel">
                                        
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="mb-3">
                                                    <label class="form-label">Excel File <span class="text-danger">*</span></label>
                                                    <input name="excelFile" type="file" class="form-control" accept=".xlsx,.xls" required>
                                                    <small class="text-muted">Only .xlsx and .xls files are supported</small>
                                                </div>
                                            </div>

                                            <div class="col-12">
                                                <div class="alert alert-info">
                                                    <h6>Excel Format Requirements:</h6>
                                                    <ul class="mb-0">
                                                        <li><strong>Column A:</strong> Model ID (required)</li>
                                                        <li><strong>Column B:</strong> Serial Number (required)</li>
                                                        <li><strong>Column C:</strong> Status (optional, default: IN_STOCK)</li>
                                                        <li><strong>Column D:</strong> Warehouse ID (optional)</li>
                                                    </ul>
                                                    <p class="mt-2 mb-0"><strong>Note:</strong> First row should contain headers and will be skipped.</p>
                                                </div>
                                            </div>

                                            <div class="col-12">
                                                <button type="submit" class="btn btn-success">
                                                    <i class="mdi mdi-upload me-1"></i> Import Excel
                                                </button>
                                                <a href="${pageContext.request.contextPath}/admin/machines" class="btn btn-soft-primary ms-2">Cancel</a>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Download Template -->
                            <div class="card border-0 rounded shadow mt-4">
                                <div class="card-body">
                                    <h6 class="mb-3">Download Template</h6>
                                    <p class="text-muted mb-3">Download the Excel template to ensure correct format for importing machines.</p>
                                    <a href="${pageContext.request.contextPath}/admin/download-machine-template" class="btn btn-outline-primary btn-sm">
                                        <i class="mdi mdi-download me-1"></i> Download Template
                                    </a>
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

        // Form validation
        document.getElementById('addSingleForm').addEventListener('submit', function(e) {
            const serialNumber = document.querySelector('input[name="serialNumber"]').value.trim();
            if (!serialNumber) {
                e.preventDefault();
                alert('Serial Number is required');
                return false;
            }
        });

        document.getElementById('importExcelForm').addEventListener('submit', function(e) {
            const fileInput = document.querySelector('input[name="excelFile"]');
            if (!fileInput.files.length) {
                e.preventDefault();
                alert('Please select an Excel file');
                return false;
            }
            
            const fileName = fileInput.files[0].name;
            const fileExtension = fileName.split('.').pop().toLowerCase();
            if (fileExtension !== 'xlsx' && fileExtension !== 'xls') {
                e.preventDefault();
                alert('Please select a valid Excel file (.xlsx or .xls)');
                return false;
            }
        });
    </script>
</body>
</html>