<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Create New Invoice</title>
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
                        <h5 class="mb-0">Create New Invoice</h5>
                        <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
                            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/sale/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/sale/invoices">Invoices</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Create</li>
                            </ul>
                        </nav>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/sale/add-invoice" method="POST" id="addInvoiceForm">
                        <div class="row">
                            <!-- Contract Information -->
                            <div class="col-lg-8 mt-4">
                                <div class="card border-0 rounded shadow">
                                    <div class="card-body">
                                        <h5 class="mb-4">Contract Information</h5>
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Contract Code <span class="text-danger">*</span></label>
                                                    <input name="contractCode" type="text" class="form-control" value="${nextContractCode}" required>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Customer <span class="text-danger">*</span></label>
                                                    <select name="customerId" id="customerId" class="form-control" required>
                                                        <option value="">Select Customer</option>
                                                        <c:forEach var="customer" items="${customers}">
                                                            <option value="${customer.customerId}">${customer.customerName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Site</label>
                                                    <select name="siteId" id="siteId" class="form-control">
                                                        <option value="">Select Site</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Signed Date</label>
                                                    <input name="signedDate" type="date" class="form-control">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">Start Date</label>
                                                    <input name="startDate" type="date" class="form-control">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="form-label">End Date</label>
                                                    <input name="endDate" type="date" class="form-control">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-12">
                                                <div class="mb-3">
                                                    <label class="form-label">Notes</label>
                                                    <textarea name="note" class="form-control" rows="3" placeholder="Additional notes..."></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Machine Items -->
                                <div class="card border-0 rounded shadow mt-4">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center mb-4">
                                            <h5 class="mb-0">Machine Items</h5>
                                            <button type="button" class="btn btn-primary btn-sm" onclick="addMachineItem()">
                                                <i class="mdi mdi-plus"></i> Add Machine
                                            </button>
                                        </div>
                                        
                                        <div id="machineItemsContainer">
                                            <!-- Machine items will be added here dynamically -->
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Summary -->
                            <div class="col-lg-4 mt-4">
                                <div class="card border-0 rounded shadow">
                                    <div class="card-body">
                                        <h5 class="mb-4">Summary</h5>
                                        
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Total Items:</span>
                                            <span id="totalItems">0</span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Total Amount:</span>
                                            <span id="totalAmount">₫0</span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-3">
                                            <span>Total Deposit:</span>
                                            <span id="totalDeposit">₫0</span>
                                        </div>
                                        
                                        <hr>
                                        
                                        <div class="d-grid gap-2">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="mdi mdi-check"></i> Create Invoice
                                            </button>
                                            <a href="${pageContext.request.contextPath}/sale/invoices" class="btn btn-soft-primary">
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

            <jsp:include page="../common/footer.jsp" />
        </main>
    </div>
    <script src="../../assets/js/bootstrap.bundle.min.js"></script>
    <script src="../../assets/js/feather.min.js"></script>
    <script>
        feather.replace();

        let itemCounter = 0;
        const availableMachines = [
            <c:forEach var="machine" items="${availableMachines}" varStatus="status">
                {
                    unitId: ${machine.unitId},
                    serialNumber: '${machine.serialNumber}',
                    modelName: '${machine.machineModel.modelName}',
                    modelCode: '${machine.machineModel.modelCode}',
                    brand: '${machine.machineModel.brand}'
                }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        // Load sites when customer changes
        document.getElementById('customerId').addEventListener('change', function() {
            const customerId = this.value;
            const siteSelect = document.getElementById('siteId');
            
            siteSelect.innerHTML = '<option value="">Select Site</option>';
            
            if (customerId) {
                fetch('${pageContext.request.contextPath}/api/sites?customerId=' + customerId)
                    .then(response => response.json())
                    .then(sites => {
                        sites.forEach(site => {
                            const option = document.createElement('option');
                            option.value = site.siteId;
                            option.textContent = site.siteName;
                            siteSelect.appendChild(option);
                        });
                    })
                    .catch(error => console.error('Error loading sites:', error));
            }
        });

        function addMachineItem() {
            itemCounter++;
            const container = document.getElementById('machineItemsContainer');
            
            const itemHtml = `
                <div class="machine-item border rounded p-3 mb-3" id="item-${itemCounter}">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="mb-0">Machine Item #${itemCounter}</h6>
                        <button type="button" class="btn btn-sm btn-soft-danger" onclick="removeMachineItem(${itemCounter})">
                            <i class="mdi mdi-close"></i>
                        </button>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Machine <span class="text-danger">*</span></label>
                                <select name="unitId" class="form-control machine-select" required onchange="updateMachineInfo(this, ${itemCounter})">
                                    <option value="">Select Machine</option>
                                    ${availableMachines.map(machine => 
                                        `<option value="${machine.unitId}">${machine.serialNumber} - ${machine.modelName}</option>`
                                    ).join('')}
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Price</label>
                                <input name="price" type="number" class="form-control price-input" step="0.01" min="0" onchange="updateSummary()">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Deposit</label>
                                <input name="deposit" type="number" class="form-control deposit-input" step="0.01" min="0" onchange="updateSummary()">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Delivery Date</label>
                                <input name="deliveryDate" type="date" class="form-control">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Return Due Date</label>
                                <input name="returnDueDate" type="date" class="form-control">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Notes</label>
                                <input name="itemNote" type="text" class="form-control" placeholder="Item notes...">
                            </div>
                        </div>
                    </div>
                    
                    <div id="machine-info-${itemCounter}" class="machine-info" style="display: none;">
                        <div class="alert alert-info">
                            <strong>Machine Details:</strong>
                            <div id="machine-details-${itemCounter}"></div>
                        </div>
                    </div>
                </div>
            `;
            
            container.insertAdjacentHTML('beforeend', itemHtml);
            updateSummary();
        }

        function removeMachineItem(itemId) {
            const item = document.getElementById(`item-${itemId}`);
            if (item) {
                item.remove();
                updateSummary();
            }
        }

        function updateMachineInfo(selectElement, itemId) {
            const unitId = selectElement.value;
            const machine = availableMachines.find(m => m.unitId == unitId);
            const infoDiv = document.getElementById(`machine-info-${itemId}`);
            const detailsDiv = document.getElementById(`machine-details-${itemId}`);
            
            if (machine) {
                detailsDiv.innerHTML = `
                    Serial: ${machine.serialNumber}<br>
                    Model: ${machine.modelName} (${machine.modelCode})<br>
                    Brand: ${machine.brand}
                `;
                infoDiv.style.display = 'block';
            } else {
                infoDiv.style.display = 'none';
            }
        }

        function updateSummary() {
            const priceInputs = document.querySelectorAll('.price-input');
            const depositInputs = document.querySelectorAll('.deposit-input');
            
            let totalAmount = 0;
            let totalDeposit = 0;
            let totalItems = 0;
            
            priceInputs.forEach(input => {
                if (input.value) {
                    totalAmount += parseFloat(input.value);
                    totalItems++;
                }
            });
            
            depositInputs.forEach(input => {
                if (input.value) {
                    totalDeposit += parseFloat(input.value);
                }
            });
            
            document.getElementById('totalItems').textContent = totalItems;
            document.getElementById('totalAmount').textContent = '₫' + totalAmount.toLocaleString();
            document.getElementById('totalDeposit').textContent = '₫' + totalDeposit.toLocaleString();
        }

        // Add first machine item by default
        addMachineItem();

        // Form validation
        document.getElementById('addInvoiceForm').addEventListener('submit', function(e) {
            const machineItems = document.querySelectorAll('.machine-item');
            if (machineItems.length === 0) {
                e.preventDefault();
                alert('Please add at least one machine item');
                return false;
            }
            
            let hasValidItem = false;
            machineItems.forEach(item => {
                const select = item.querySelector('.machine-select');
                if (select && select.value) {
                    hasValidItem = true;
                }
            });
            
            if (!hasValidItem) {
                e.preventDefault();
                alert('Please select at least one machine');
                return false;
            }
        });
    </script>
</body>
</html>