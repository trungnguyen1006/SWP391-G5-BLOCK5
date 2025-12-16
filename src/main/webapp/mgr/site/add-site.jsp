<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Add New Site</title>
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
        <jsp:include page="../../manager/common/sidebar.jsp" />

        <main class="page-content bg-light">
            <jsp:include page="../../manager/common/header.jsp" />

            <div class="container-fluid">
                <div class="layout-specing">
                    <div class="d-md-flex justify-content-between">
                        <h5 class="mb-0">Add New Site</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/mgr/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/mgr/sites">Sites</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Add</li>
                            </ul>
                        </nav>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/mgr/add-site" method="POST" id="addSiteForm">
                        <div class="row">
                            <div class="col-lg-8 mt-4">
                                <div class="card border-0 rounded shadow">
                                    <div class="card-body">
                                        <h5 class="mb-4">Site Information</h5>
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Site Code <span class="text-danger">*</span></label>
                                                    <input name="siteCode" type="text" class="form-control" value="${nextSiteCode}" required>
                                                    <small class="text-muted">Auto-generated code</small>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Site Name <span class="text-danger">*</span></label>
                                                    <input name="siteName" type="text" class="form-control" placeholder="Enter site name" required>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Customer</label>
                                                    <select name="customerId" class="form-control">
                                                        <option value="">Select Customer</option>
                                                        <c:forEach var="customer" items="${customers}">
                                                            <option value="${customer.customerId}">${customer.customerName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Address</label>
                                                    <input name="address" type="text" class="form-control" placeholder="Enter address">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-4 mt-4">
                                <div class="card border-0 rounded shadow">
                                    <div class="card-body">
                                        <h5 class="mb-4">Actions</h5>
                                        
                                        <div class="d-grid gap-2">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="mdi mdi-check"></i> Create Site
                                            </button>
                                            <a href="${pageContext.request.contextPath}/mgr/sites" class="btn btn-soft-primary">
                                                Cancel
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <jsp:include page="../../manager/common/footer.jsp" />
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/simplebar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/feather.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script>
        feather.replace();

        document.getElementById('addSiteForm').addEventListener('submit', function(e) {
            const siteName = document.querySelector('input[name="siteName"]').value.trim();
            if (!siteName) {
                e.preventDefault();
                alert('Please enter site name');
                return false;
            }
        });
    </script>
</body>
</html>
