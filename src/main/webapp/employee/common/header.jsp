<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="top-header">
    <div class="header-bar d-flex justify-content-between border-bottom">
        <div class="d-flex align-items-center">
            <a href="#" class="logo-icon">
                <img src="${pageContext.request.contextPath}/assets/images/logo-icon.png" height="30" class="small" alt="">
                <span class="big">
                    <img src="${pageContext.request.contextPath}/assets/images/logo-dark.png" height="24" class="logo-light-mode" alt="">
                    <img src="${pageContext.request.contextPath}/assets/images/logo-light.png" height="24" class="logo-dark-mode" alt="">
                </span>
            </a>
            <a id="close-sidebar" class="btn btn-icon btn-pills btn-soft-primary ms-2" href="#">
                <i class="uil uil-bars"></i>
            </a>
        </div>

        <ul class="list-unstyled mb-0">
            <li class="list-inline-item mb-0 ms-1">
                <div class="dropdown dropdown-primary">
                    <button type="button" class="btn btn-pills btn-soft-primary dropdown-toggle p-0" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.image}">
                                <img src="${pageContext.request.contextPath}/${sessionScope.user.image}" class="avatar avatar-ex-small rounded-circle" alt="">
                            </c:when>
                            <c:otherwise>
                                <div class="avatar avatar-ex-small rounded-circle bg-soft-primary d-flex align-items-center justify-content-center">
                                    <i class="mdi mdi-account text-white"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </button>
                    <div class="dropdown-menu dd-menu dropdown-menu-end bg-white shadow border-0 mt-3 py-3" style="min-width: 200px;">
                        <a class="dropdown-item d-flex align-items-center text-dark" href="#">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.image}">
                                    <img src="${pageContext.request.contextPath}/${sessionScope.user.image}" class="avatar avatar-md-sm rounded-circle border shadow" alt="">
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar avatar-md-sm rounded-circle bg-soft-primary border shadow d-flex align-items-center justify-content-center">
                                        <i class="mdi mdi-account text-white h4 mb-0"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <div class="flex-1 ms-2">
                                <span class="d-block mb-1">${sessionScope.user.fullName}</span>
                                <small class="text-muted">Employee</small>
                            </div>
                        </a>
                        <a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/employee/dashboard"><span class="mb-0 d-inline-block me-1"><i class="uil uil-dashboard align-middle h6"></i></span> Dashboard</a>
                        <div class="dropdown-divider border-top"></div>
                        <a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/logout"><span class="mb-0 d-inline-block me-1"><i class="uil uil-sign-out-alt align-middle h6"></i></span> Logout</a>
                    </div>
                </div>
            </li>
        </ul>
    </div>
</div>
