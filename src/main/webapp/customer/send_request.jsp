<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Gửi yêu cầu sửa chữa / bảo hành</title>

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    </head>

    <body class="bg-light">
        <jsp:include page="common/sidebar.jsp" />

        <main class="page-content bg-light">
            <jsp:include page="common/header.jsp" />
            <div class="container mt-5">
                <div class="row justify-content-center">
                    <div class="col-lg-8 col-md-10">

                        <div class="card shadow-lg border-0 rounded-4">
                            <div class="card-header bg-primary text-white rounded-top-4">
                                <h4 class="mb-0">
                                    <i class="bi bi-tools"></i>
                                    Gửi yêu cầu sửa chữa / bảo hành
                                </h4>
                            </div>

                            <div class="card-body p-4">

                                <!-- Success message -->
                                <c:if test="${not empty sessionScope.success}">
                                    <div class="alert alert-success">
                                        ${sessionScope.success}
                                    </div>
                                    <c:remove var="success" scope="session"/>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/customer/sendrequest" method="post">

                                    <!-- Thiết bị -->
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

                                    <!-- Loại yêu cầu -->
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">
                                            <i class="bi bi-wrench-adjustable"></i> Loại yêu cầu
                                        </label>
                                        <select name="requestType" class="form-select" required>
                                            <option value="REPAIR">Sửa chữa</option>
                                            <option value="WARRANTY">Bảo hành</option>
                                        </select>
                                    </div>

                                    <!-- Tiêu đề -->
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">
                                            <i class="bi bi-card-text"></i> Tiêu đề
                                        </label>
                                        <input type="text" name="title" class="form-control"
                                               placeholder="Nhập tiêu đề yêu cầu" required>
                                    </div>

                                    <!-- Mô tả -->
                                    <div class="mb-4">
                                        <label class="form-label fw-semibold">
                                            <i class="bi bi-chat-left-text"></i> Mô tả chi tiết
                                        </label>
                                        <textarea name="description" rows="4" class="form-control"
                                                  placeholder="Mô tả lỗi, tình trạng thiết bị..."></textarea>
                                    </div>

                                    <!-- Buttons -->
                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/customer/dashboard"
                                           class="btn btn-outline-secondary">
                                            <i class="bi bi-arrow-left"></i> Quay lại
                                        </a>

                                        <button type="submit" class="btn btn-primary px-4">
                                            <i class="bi bi-send"></i> Gửi yêu cầu
                                        </button>
                                    </div>

                                </form>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
            <jsp:include page="common/footer.jsp" />

        </main>

    </body>

</html>
