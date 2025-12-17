<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Update Customer</title>
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
                        <h5 class="mb-0">Update Customer</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employee/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employee/customers">Customers</a></li>
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
                                    <h5 class="mb-4">Customer Information</h5>

                                    <form action="${pageContext.request.contextPath}/employee/update-customer" method="POST" id="updateCustomerForm">
                                        <input type="hidden" name="customerId" value="${customer.customerId}">
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Customer Code <span class="text-danger">*</span></label>
                                                    <input name="customerCode" type="text" class="form-control" value="${customer.customerCode}" required>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Customer Name <span class="text-danger">*</span></label>
                                                    <input name="customerName" type="text" class="form-control" value="${customer.customerName}" required>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-12">
                                                <div class="mb-3">
                                                    <label class="form-label">Address</label>
                                                    <input name="address" type="text" class="form-control" value="${customer.address}">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Contact Name</label>
                                                    <input name="contactName" type="text" class="form-control" value="${customer.contactName}">
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Contact Phone</label>
                                                    <input name="contactPhone" type="tel" class="form-control" value="${customer.contactPhone}">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-12">
                                                <div class="mb-3">
                                                    <label class="form-label">Contact Email</label>
                                                    <input name="contactEmail" type="email" class="form-control" value="${customer.contactEmail}">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-12">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="mdi mdi-check me-1"></i> Update Customer
                                                </button>
                                                <a href="${pageContext.request.contextPath}/employee/customers" class="btn btn-soft-primary ms-2">
                                                    <i class="mdi mdi-close me-1"></i> Cancel
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

            <jsp:include page="../../employee/common/footer.jsp" />
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/simplebar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/feather.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script>
        feather.replace();

        document.getElementById('updateCustomerForm').addEventListener('submit', function(e) {
            const customerName = document.querySelector('input[name="customerName"]').value.trim();
            if (!customerName) {
                e.preventDefault();
                alert('Customer Name is required');
                return false;
            }
        });
    </script>
</body>
</html>
