<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Add Machine Model</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link href="../../assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../../assets/css/materialdesignicons.min.css" rel="stylesheet" type="text/css" />
    <link href="../../assets/css/remixicon.css" rel="stylesheet" type="text/css" />
    <link href="https://unicons.iconscout.com/release/v3.0.6/css/line.css" rel="stylesheet">
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
                        <h5 class="mb-0">Add Machine Model</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/machines">Machines</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Add Model</li>
                            </ul>
                        </nav>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${param.added == 'true'}">
                        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                            Machine model added successfully!
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="row">
                        <!-- Add Model Form -->
                        <div class="col-lg-8 mt-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <h5 class="mb-4">Add New Machine Model</h5>

                                    <form action="${pageContext.request.contextPath}/admin/add-machine-model" method="POST" id="addModelForm">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Model Code <span class="text-danger">*</span></label>
                                                    <input name="modelCode" type="text" class="form-control" placeholder="e.g., EXC001" required>
                                                    <small class="text-muted">Unique identifier for the model</small>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Model Name <span class="text-danger">*</span></label>
                                                    <input name="modelName" type="text" class="form-control" placeholder="e.g., Excavator CAT 320D" required>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Brand</label>
                                                    <input name="brand" type="text" class="form-control" placeholder="e.g., Caterpillar">
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Category</label>
                                                    <select name="category" class="form-control">
                                                        <option value="">Select Category</option>
                                                        <option value="Excavator">Excavator</option>
                                                        <option value="Crane">Crane</option>
                                                        <option value="Bulldozer">Bulldozer</option>
                                                        <option value="Loader">Loader</option>
                                                        <option value="Dump Truck">Dump Truck</option>
                                                        <option value="Compactor">Compactor</option>
                                                        <option value="Other">Other</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-12">
                                                <div class="mb-3">
                                                    <label class="form-label">Specifications</label>
                                                    <textarea name="specs" class="form-control" rows="4" placeholder="Enter machine specifications (weight, engine, capacity, etc.)"></textarea>
                                                </div>
                                            </div>

                                            <div class="col-12">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="mdi mdi-plus me-1"></i>Add Model
                                                </button>
                                                <a href="${pageContext.request.contextPath}/admin/add-machine" class="btn btn-soft-primary ms-2">
                                                    <i class="mdi mdi-arrow-left me-1"></i>Back to Add Machine
                                                </a>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Existing Models -->
                        <div class="col-lg-4 mt-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <h5 class="mb-4">Existing Models</h5>
                                    
                                    <c:choose>
                                        <c:when test="${not empty machineModels}">
                                            <div class="table-responsive">
                                                <table class="table table-sm">
                                                    <thead>
                                                        <tr>
                                                            <th>Code</th>
                                                            <th>Name</th>
                                                            <th>Brand</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="model" items="${machineModels}">
                                                            <tr>
                                                                <td><small>${model.modelCode}</small></td>
                                                                <td><small>${model.modelName}</small></td>
                                                                <td><small>${model.brand}</small></td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-4">
                                                <i class="mdi mdi-cog h1 text-muted"></i>
                                                <p class="text-muted">No machine models found. Add your first model above.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
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
    <script src="../../assets/js/simplebar.min.js"></script>
    <script src="../../assets/js/feather.min.js"></script>
    <script src="../../assets/js/app.js"></script>
    <script>
        feather.replace();

        // Form validation
        document.getElementById('addModelForm').addEventListener('submit', function(e) {
            const modelCode = document.querySelector('input[name="modelCode"]').value.trim();
            const modelName = document.querySelector('input[name="modelName"]').value.trim();
            
            if (!modelCode) {
                e.preventDefault();
                alert('Model Code is required');
                return false;
            }
            
            if (!modelName) {
                e.preventDefault();
                alert('Model Name is required');
                return false;
            }
            
            // Convert model code to uppercase
            document.querySelector('input[name="modelCode"]').value = modelCode.toUpperCase();
        });

        // Auto-uppercase model code as user types
        document.querySelector('input[name="modelCode"]').addEventListener('input', function(e) {
            e.target.value = e.target.value.toUpperCase();
        });
    </script>
</body>
</html>