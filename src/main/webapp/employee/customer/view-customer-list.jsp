<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Customer List</title>
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
                        <h5 class="mb-0">Customer Management</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employee/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Customers</li>
                            </ul>
                        </nav>
                    </div>

                    <c:if test="${param.added == 'true'}">
                        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                            <strong>Success!</strong> Customer has been added successfully.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${param.updated == 'true'}">
                        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                            <strong>Success!</strong> Customer has been updated successfully.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${param.deleted == 'true'}">
                        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                            <strong>Success!</strong> Customer has been deleted successfully.
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
                                            <h6 class="text-muted mb-0">Total Customers</h6>
                                            <h4 class="mb-0">${totalCustomers}</h4>
                                        </div>
                                        <div class="avatar avatar-md-sm rounded-circle bg-soft-primary d-flex align-items-center justify-content-center">
                                            <i class="mdi mdi-account-multiple text-primary h5 mb-0"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>



                    <!-- Customer List -->
                    <div class="row">
                        <div class="col-12 mt-4">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty customers}">
                                            <div class="table-responsive">
                                                <table class="table table-center bg-white mb-0">
                                                    <thead>
                                                        <tr>
                                                            <th class="border-bottom p-3">Customer Code</th>
                                                            <th class="border-bottom p-3">Customer Name</th>
                                                            <th class="border-bottom p-3">Contact Name</th>
                                                            <th class="border-bottom p-3">Phone</th>
                                                            <th class="border-bottom p-3">Email</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="customer" items="${customers}">
                                                            <tr>
                                                                <td class="p-3">
                                                                    <strong>${customer.customerCode}</strong>
                                                                </td>
                                                                <td class="p-3">
                                                                    ${customer.customerName}
                                                                </td>
                                                                <td class="p-3">
                                                                    ${customer.contactName}
                                                                </td>
                                                                <td class="p-3">
                                                                    ${customer.contactPhone}
                                                                </td>
                                                                <td class="p-3">
                                                                    ${customer.contactEmail}
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
                                                        Showing page ${currentPage} of ${totalPages} (Total: ${totalCustomers} customers)
                                                    </div>
                                                    <nav aria-label="Page navigation">
                                                        <ul class="pagination mb-0">
                                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                                <a class="page-link" href="${pageContext.request.contextPath}/employee/customers?page=${currentPage - 1}">Previous</a>
                                                            </li>
                                                            
                                                            <c:forEach var="i" begin="1" end="${totalPages > 5 ? 5 : totalPages}">
                                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                                    <a class="page-link" href="${pageContext.request.contextPath}/employee/customers?page=${i}">${i}</a>
                                                                </li>
                                                            </c:forEach>
                                                            
                                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                                <a class="page-link" href="${pageContext.request.contextPath}/employee/customers?page=${currentPage + 1}">Next</a>
                                                            </li>
                                                        </ul>
                                                    </nav>
                                                </div>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-5">
                                                <i class="mdi mdi-account-multiple-outline h1 text-muted"></i>
                                                <p class="text-muted mt-3">No customers found.</p>
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
