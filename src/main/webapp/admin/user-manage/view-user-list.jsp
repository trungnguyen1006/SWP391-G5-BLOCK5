<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <title>User List</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Premium Bootstrap 4 Landing Page Template" />
  <meta name="keywords" content="Appointment, Booking, System, Dashboard, Health" />
  <meta name="author" content="Shreethemes" />
  <meta name="email" content="support@shreethemes.in" />
  <meta name="website" content="../../../index.html" />
  <meta name="Version" content="v1.2.0" />

  <link href="../../assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
  <link href="../../assets/css/simplebar.css" rel="stylesheet" type="text/css" />
  <link href="../../assets/css/select2.min.css" rel="stylesheet" />
  <link href="../../assets/css/materialdesignicons.min.css" rel="stylesheet" type="text/css" />
  <link href="../../assets/css/remixicon.css" rel="stylesheet" type="text/css" />
  <link href="https://unicons.iconscout.com/release/v3.0.6/css/line.css"  rel="stylesheet">
  <link href="../../assets/css/tiny-slider.css" rel="stylesheet" />
  <link href="../../assets/css/style.min.css" rel="stylesheet" type="text/css" id="theme-opt" />

</head>

<body>

<div class="page-wrapper doctris-theme toggled">
  <jsp:include page="../common/sidebar.jsp" />

  <main class="page-content bg-light">
    <jsp:include page="../common/header.jsp" />

    <div class="container-fluid">
      <div class="layout-specing">
        <div class="d-md-flex justify-content-between align-items-center">
          <h5 class="mb-0">User List</h5>

          <nav aria-label="breadcrumb" class="d-inline-block mt-4 mt-sm-0">
            <ul class="breadcrumb bg-transparent rounded mb-0 p-0">
              <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
              <li class="breadcrumb-item active" aria-current="page">Users</li>
            </ul>
          </nav>
        </div>

        <c:if test="${param.added == 'true'}">
          <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
            <strong>Success!</strong> User has been created successfully.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
        </c:if>

        <c:if test="${param.updated == 'true'}">
          <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
            <strong>Success!</strong> User has been updated successfully.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
        </c:if>

        <div class="row mt-3">
          <div class="col-12">
            <a href="${pageContext.request.contextPath}/admin/add-user" class="btn btn-primary">
              <i class="uil uil-plus me-1"></i> Add New User
            </a>
          </div>
        </div>

        <div class="row mt-3">
          <div class="col-12">
            <div class="card border-0 rounded shadow">
              <div class="card-body">
                <form method="get" action="${pageContext.request.contextPath}/admin/user-list" class="row g-3">
                  <div class="col-md-6">
                    <label for="statusFilter" class="form-label">Filter by Status</label>
                    <select class="form-select" id="statusFilter" name="status">
                      <option value="">All Users</option>
                      <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
                      <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Inactive</option>
                    </select>
                  </div>
                  <div class="col-md-6 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary">
                      <i class="uil uil-search me-1"></i> Filter
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/user-list" class="btn btn-secondary ms-2">
                      <i class="uil uil-redo me-1"></i> Reset
                    </a>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col-12 mt-4">
            <div class="card border-0 rounded shadow">
              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-center bg-white mb-0">
                    <thead>
                    <tr>
                      <th class="border-bottom p-3" style="min-width: 50px;">ID</th>
                      <th class="border-bottom p-3" style="min-width: 80px;">Avatar</th>
                      <th class="border-bottom p-3" style="min-width: 150px;">Username</th>
                      <th class="border-bottom p-3">Full Name</th>
                      <th class="border-bottom p-3">Email</th>
                      <th class="border-bottom p-3">Phone</th>
                      <th class="border-bottom p-3" style="min-width: 100px;">Status</th>
                      <th class="border-bottom p-3" style="min-width: 100px;">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="user" items="${userList}">
                      <tr>
                        <th class="p-3">${user.userId}</th>
                        <td class="p-3">
                          <c:choose>
                            <c:when test="${not empty user.image}">
                              <div style="position: relative; display: inline-block;">
                                <img src="${pageContext.request.contextPath}/uploads/${user.image}" class="avatar avatar-md-sm rounded-circle" alt="${user.fullName}" onerror="this.style.display='none'; this.parentElement.querySelector('div').style.display='flex';">
                                <div class="avatar avatar-md-sm rounded-circle bg-soft-primary d-flex align-items-center justify-content-center" style="display: none; position: absolute; top: 0; left: 0;">
                                  <i class="mdi mdi-account text-white h5 mb-0"></i>
                                </div>
                              </div>
                            </c:when>
                            <c:otherwise>
                              <div class="avatar avatar-md-sm rounded-circle bg-soft-primary d-flex align-items-center justify-content-center">
                                <i class="mdi mdi-account text-white h5 mb-0"></i>
                              </div>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td class="p-3">${user.username}</td>
                        <td class="p-3">${user.fullName}</td>
                        <td class="p-3">${user.email}</td>
                        <td class="p-3">${not empty user.phone ? user.phone : '-'}</td>
                        <td class="p-3">
                          <c:choose>
                            <c:when test="${user.active}">
                              <span class="badge bg-soft-success">Active</span>
                            </c:when>
                            <c:otherwise>
                              <span class="badge bg-soft-danger">Inactive</span>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td class="p-3">
                          <a href="${pageContext.request.contextPath}/admin/user-detail?id=${user.userId}" class="btn btn-icon btn-pills btn-soft-primary"><i data-feather="eye" class="fea icon-sm"></i></a>
                          <a href="${pageContext.request.contextPath}/admin/update-user?id=${user.userId}" class="btn btn-icon btn-pills btn-soft-success"><i data-feather="edit" class="fea icon-sm"></i></a>
                        </td>
                      </tr>
                    </c:forEach>
                    </tbody>
                  </table>
                </div>

                <c:if test="${totalPages > 1}">
                  <div class="d-flex justify-content-between align-items-center mt-4 px-3">
                    <div class="text-muted">
                      Showing page ${currentPage} of ${totalPages} (Total: ${totalUsers} users)
                    </div>
                    <nav aria-label="Page navigation">
                      <ul class="pagination mb-0">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                          <a class="page-link" href="${pageContext.request.contextPath}/admin/user-list?page=${currentPage - 1}${status != null ? '&status=' : ''}${status}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                          </a>
                        </li>

                        <c:choose>
                          <c:when test="${totalPages <= 7}">
                            <c:forEach var="i" begin="1" end="${totalPages}">
                              <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/user-list?page=${i}${status != null ? '&status=' : ''}${status}">${i}</a>
                              </li>
                            </c:forEach>
                          </c:when>
                          <c:otherwise>
                            <c:if test="${currentPage > 3}">
                              <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/user-list?page=1${status != null ? '&status=' : ''}${status}">1</a>
                              </li>
                              <c:if test="${currentPage > 4}">
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                              </c:if>
                            </c:if>

                            <c:forEach var="i" begin="${currentPage - 2 < 1 ? 1 : currentPage - 2}" 
                                       end="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}">
                              <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/user-list?page=${i}">${i}</a>
                              </li>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages - 2}">
                              <c:if test="${currentPage < totalPages - 3}">
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                              </c:if>
                              <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/user-list?page=${totalPages}">${totalPages}</a>
                              </li>
                            </c:if>
                          </c:otherwise>
                        </c:choose>

                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                          <a class="page-link" href="${pageContext.request.contextPath}/admin/user-list?page=${currentPage + 1}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                          </a>
                        </li>
                      </ul>
                    </nav>
                  </div>
                </c:if>

              </div>
            </div>
          </div>
        </div>

      </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
  </main>
</div>

<script src="../../assets/js/bootstrap.bundle.min.js"></script>
<script src="../../assets/js/simplebar.min.js"></script>
<script src="../../assets/js/feather.min.js"></script>
<script src="../../assets/js/app.js"></script>

</body>

</html>
