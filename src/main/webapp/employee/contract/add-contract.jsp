<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Add Contract</title>
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
                        <h5 class="mb-0">Add New Contract</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employee/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employee/contracts">Contracts</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Add Contract</li>
                            </ul>
                        </nav>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="row mt-4">
                        <div class="col-lg-10">
                            <div class="card border-0 rounded shadow">
                                <div class="card-body">
                                    <form method="POST" action="${pageContext.request.contextPath}/employee/add-contract">
                                        <h6 class="mb-3">Contract Information</h6>
                                        
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Contract Code <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" name="contractCode" value="${nextContractCode}" readonly>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Customer <span class="text-danger">*</span></label>
                                                <select class="form-control" name="customerId" required>
                                                    <option value="">-- Select Customer --</option>
                                                    <c:forEach var="customer" items="${customers}">
                                                        <option value="${customer.customerId}">${customer.customerName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Signed Date</label>
                                                <input type="date" class="form-control" name="signedDate">
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Start Date</label>
                                                <input type="date" class="form-control" name="startDate">
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">End Date</label>
                                                <input type="date" class="form-control" name="endDate">
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Note</label>
                                                <input type="text" class="form-control" name="note">
                                            </div>
                                        </div>

                                        <hr>
                                        <h6 class="mb-3">Contract Items</h6>
                                        
                                        <div id="itemsContainer">
                                            <div class="item-row mb-4 p-3 border rounded bg-light">
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label class="form-label">Machine <span class="text-danger">*</span></label>
                                                        <select class="form-control" name="unitId" required>
                                                            <option value="">-- Select Machine --</option>
                                                            <c:forEach var="machine" items="${availableMachines}">
                                                                <option value="${machine.unitId}">${machine.serialNumber}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-3 mb-3">
                                                        <label class="form-label">Price</label>
                                                        <input type="number" class="form-control" name="price" step="0.01" placeholder="0.00">
                                                    </div>
                                                    <div class="col-md-3 mb-3">
                                                        <label class="form-label">Deposit</label>
                                                        <input type="number" class="form-control" name="deposit" step="0.01" placeholder="0.00">
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-4 mb-3">
                                                        <label class="form-label">Delivery Date</label>
                                                        <input type="date" class="form-control" name="deliveryDate">
                                                    </div>
                                                    <div class="col-md-4 mb-3">
                                                        <label class="form-label">Return Due Date</label>
                                                        <input type="date" class="form-control" name="returnDueDate">
                                                    </div>
                                                    <div class="col-md-4 mb-3">
                                                        <label class="form-label">Note</label>
                                                        <input type="text" class="form-control" name="itemNote" placeholder="Item note">
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-12">
                                                        <button type="button" class="btn btn-sm btn-danger remove-item" style="display:none;">
                                                            <i class="mdi mdi-delete me-1"></i> Remove Item
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <button type="button" class="btn btn-sm btn-secondary mb-3" id="addItemBtn">
                                            <i class="mdi mdi-plus me-1"></i> Add Item
                                        </button>

                                        <div class="d-flex gap-2 mt-4">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="mdi mdi-check me-1"></i> Create Contract
                                            </button>
                                            <a href="${pageContext.request.contextPath}/employee/contracts" class="btn btn-secondary">
                                                <i class="mdi mdi-close me-1"></i> Cancel
                                            </a>
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
        
        document.getElementById('addItemBtn').addEventListener('click', function() {
            const container = document.getElementById('itemsContainer');
            const newRow = document.querySelector('.item-row').cloneNode(true);
            
            // Reset values
            newRow.querySelectorAll('input, select').forEach(el => el.value = '');
            
            // Show remove button
            newRow.querySelector('.remove-item').style.display = 'block';
            newRow.querySelector('.remove-item').addEventListener('click', function() {
                newRow.remove();
            });
            
            container.appendChild(newRow);
        });
    </script>
</body>
</html>
