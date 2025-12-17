<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Danh sách đơn bảo trì</title>
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    </head>
    <body class="bg-light">
        <jsp:include page="common/sidebar.jsp" />

        <main class="page-content bg-light">
            <jsp:include page="common/header.jsp" />
            <div class="container mt-4">
                <h3 class="mb-4">🛠️ Đơn sửa chữa / bảo hành của tôi</h3>

                <c:if test="${empty requests}">
                    <div class="alert alert-info">Bạn chưa gửi đơn nào.</div>
                </c:if>

                <c:if test="${not empty requests}">
                    <table class="table table-bordered table-hover bg-white">
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
                    </c:if>

                    <a href="${pageContext.request.contextPath}/customer/sendrequest"
                       class="btn btn-primary mt-3">
                        ➕ Gửi đơn mới
                    </a>
                </div>        
                <jsp:include page="common/footer.jsp" />

            </main>


        </body>
    </html>
