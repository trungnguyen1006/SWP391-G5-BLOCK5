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

        <div class="row">
          <div class="col-12 mt-4">
            <div class="card border-0 rounded shadow">
              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-center bg-white mb-0">
                    <thead>
                    <tr>
                      <th class="border-bottom p-3" style="min-width: 50px;">ID</th>
                      <th class="border-bottom p-3" style="min-width: 180px;">Username</th>
                      <th class="border-bottom p-3">Full Name</th>
                      <th class="border-bottom p-3">Email</th>
                      <th class="border-bottom p-3" style="min-width: 150px;">Created Date</th>
                      <th class="border-bottom p-3" style="min-width: 100px;">Status</th>
                      <th class="border-bottom p-3" style="min-width: 100px;">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="user" items="${userList}">
                      <tr>
                        <th class="p-3">${user.userId}</th>
                        <td class="p-3">${user.username}</td>
                        <td class="p-3">${user.fullName}</td>
                        <td class="p-3">${user.email}</td>
                        <td class="p-3">${user.createdDate}</td>
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
