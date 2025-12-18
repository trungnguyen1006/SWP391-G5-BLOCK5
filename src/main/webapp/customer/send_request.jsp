<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Gửi yêu cầu sửa chữa / bảo hành</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            html, body {
                height: 100%;
            }

            body {
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                background-color: #f8f9fa;
            }

            .main-content {
                flex: 1;
            }

            .card {
                border-radius: 16px;
            }
        </style>
    </head>

    <body>

        <jsp:include page="common/header.jsp" />

        <div class="main-content">
            <div class="container py-5">
                <div class="row justify-content-center">
                    <div class="col-xl-7 col-lg-8 col-md-10">

                        <div class="card shadow-sm border-0">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">
                                    <i class="bi bi-tools me-2"></i>
                                    Gửi yêu cầu sửa chữa / bảo hành
                                </h5>
                            </div>

                            <div class="card-body p-4">

                                <c:if test="${not empty sessionScope.success}">
                                    <div class="alert alert-success alert-dismissible fade show">
                                        <i class="bi bi-check-circle me-1"></i>
                                        ${sessionScope.success}
                                        <button type="button" class="btn-close"
                                                data-bs-dismiss="alert"></button>
                                    </div>
                                    <c:remove var="success" scope="session"/>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/customer/sendrequest"
                                      method="post">

                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">
                                            <i class="bi bi-cpu"></i> Thiết bị
                                        </label>
                                        <select name="unitId" class="form-select" required>
                                            <option value="">-- Chọn thiết bị --</option>
                                            <c:forEach items="${units}" var="u">
                                                <option value="${u.unitId}">
                                                    ${u.machineModel.modelName}
                                                    | SN: ${u.serialNumber}
                                                    | ${u.machineModel.brand}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">
                                            <i class="bi bi-wrench-adjustable"></i> Loại yêu cầu
                                        </label>
                                        <select name="requestType" class="form-select" required>
                                            <option value="" disabled selected>-- Chọn loại yêu cầu --</option>
                                            <option value="REPAIR">Sửa chữa</option>
                                            <option value="WARRANTY">Bảo hành</option>
                                        </select>

                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">
                                            <i class="bi bi-card-text"></i> Tiêu đề
                                        </label>
                                        <input type="text" name="title"
                                               class="form-control"
                                               required>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label fw-semibold">
                                            <i class="bi bi-chat-left-text"></i> Mô tả chi tiết
                                        </label>
                                        <textarea name="description"
                                                  rows="4"
                                                  class="form-control"
                                                  >                                                     
                                        </textarea>
                                    </div>

                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/customer/dashboard"
                                           class="btn btn-outline-secondary">
                                            <i class="bi bi-arrow-left"></i> Quay lại
                                        </a>

                                        <button type="submit" class="btn btn-primary px-4">
                                            <i class="bi bi-send me-1"></i> Gửi yêu cầu
                                        </button>
                                    </div>

                                </form>

                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="common/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
