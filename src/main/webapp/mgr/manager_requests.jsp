<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý yêu cầu sửa chữa</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    </head>

    <body class="bg-light">

        <div class="container mt-5">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="mb-0">
                    <i class="bi bi-clipboard-check"></i>
                    Danh sách yêu cầu chờ duyệt
                </h3>

            </div>

            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle"></i>
                    ${sessionScope.success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>

            <div class="card shadow-sm border-0">
                <div class="card-body p-0">

                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-primary">
                            <tr>
                                <th>Mã yêu cầu</th>
                                <th>Tiêu đề</th>
                                <th>Trạng thái</th>
                                <th>Ngày gửi</th>
                                <th class="text-center">Hành động</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach items="${requests}" var="r">
                                <tr>
                                    <td class="fw-semibold">${r.requestCode}</td>

                                    <td>${r.title}</td>

                                    <td>
                                        <span class="badge bg-warning text-dark">
                                            ${r.status}
                                        </span>
                                    </td>

                                    <td>
                                        <fmt:formatDate value="${r.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>

                                    <td class="text-center">
                                        <form action="${pageContext.request.contextPath}/mgr/approve-request"
                                              method="post" class="d-inline">

                                            <input type="hidden" name="requestId" value="${r.requestId}"/>

                                            <button name="action" value="APPROVE"
                                                    class="btn btn-success btn-sm me-1">
                                                <i class="bi bi-check-circle"></i> APPROVE
                                            </button>

                                            <button name="action" value="REJECT"
                                                    class="btn btn-danger btn-sm"
                                                    onclick="return confirm('Bạn có chắc muốn từ chối yêu cầu này?')">
                                                <i class="bi bi-x-circle"></i> REJECT
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>


                            <c:if test="${empty requests}">
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-4">
                                        <i class="bi bi-inbox fs-3"></i>
                                        <br/>
                                        Không có yêu cầu nào cần duyệt
                                    </td>
                                </tr>
                            </c:if>

                        </tbody>
                    </table>

                </div>
            </div>

        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
