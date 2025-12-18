<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Danh sách đơn bảo trì</title>
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">

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
        </style>
    </head>

    <body>

        <jsp:include page="common/header.jsp" />

        <div class="main-content">
            <div class="container py-4">

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3 class="mb-0">🛠️ Đơn sửa chữa / bảo hành của tôi</h3>

                    <a href="${pageContext.request.contextPath}/customer/sendrequest"
                       class="btn btn-primary rounded-pill px-4 shadow-sm">
                        <i class="bi bi-plus-circle me-1"></i> Gửi đơn mới
                    </a>
                </div>

                <c:if test="${empty requests}">
                    <div class="alert alert-info">
                        Bạn chưa gửi đơn nào.
                    </div>
                </c:if>

                <c:if test="${not empty requests}">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover bg-white align-middle">
                            <thead class="table-dark">
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Loại</th>
                                    <th>Tiêu đề</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${requests}">
                                    <tr>
                                        <td>${r.requestCode}</td>
                                        <td>${r.requestType}</td>
                                        <td>${r.title}</td>
                                        <td>
                                            <span class="badge
                                                  ${r.status == 'PENDING' ? 'bg-warning' :
                                                    r.status == 'APPROVED' ? 'bg-success' :
                                                    r.status == 'REJECTED' ? 'bg-danger' :
                                                    'bg-secondary'}">
                                                      ${r.status}
                                                  </span>
                                            </td>
                                            <td>${r.createdDate}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/customer/dashboard"
                           class="btn btn-outline-secondary rounded-pill px-4">
                            <i class="bi bi-arrow-left me-1"></i> Quay lại
                        </a>
                    </div>

                </div>
            </div>

            <jsp:include page="common/footer.jsp" />

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>
    </html>
