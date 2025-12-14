<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="top-header">
    <div class="header-bar d-flex justify-content-between align-items-center border-bottom bg-white shadow-sm py-3 px-4">
        <!-- Logo -->
        <div class="d-flex align-items-center">
            <a href="${pageContext.request.contextPath}/customer/dashboard" class="logo-icon">
                <img src="${pageContext.request.contextPath}/assets/images/logo-icon.png" height="30" class="small" alt="Logo">
                <span class="big ms-2">
                    <img src="${pageContext.request.contextPath}/assets/images/logo-dark.png" height="24" alt="CMS">
                </span>
            </a>
        </div>

        <!-- Navigation -->
        <nav class="d-none d-lg-block">
            <ul class="list-unstyled mb-0 d-flex">
                <li class="list-inline-item me-4">
                    <a href="${pageContext.request.contextPath}/customer/machines" class="text-dark">Machine Catalog</a>
                </li>
                <li class="list-inline-item me-4">
                    <a href="${pageContext.request.contextPath}/customer/support" class="text-dark">Support</a>
                </li>
            </ul>
        </nav>

        <!-- User Menu -->
        <ul class="list-unstyled mb-0 d-flex align-items-center">
            <c:if test="${not empty sessionScope.user}">
                <li class="list-inline-item mb-0 ms-1">
                    <div class="dropdown">
                        <button type="button" class="btn btn-pills btn-soft-primary dropdown-toggle p-0" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.image}">
                                    <img src="${pageContext.request.contextPath}/${sessionScope.user.image}" class="avatar avatar-ex-small rounded-circle" alt="User">
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar avatar-ex-small rounded-circle bg-soft-primary d-flex align-items-center justify-content-center">
                                        <i class="mdi mdi-account text-white"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </button>
                        <div class="dropdown-menu dropdown-menu-end bg-white shadow border-0 mt-3 py-3" style="min-width: 200px;">
                            <a class="dropdown-item d-flex align-items-center text-dark" href="#">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.image}">
                                        <img src="${pageContext.request.contextPath}/${sessionScope.user.image}" class="avatar avatar-md-sm rounded-circle border shadow" alt="User">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="avatar avatar-md-sm rounded-circle bg-soft-primary border shadow d-flex align-items-center justify-content-center">
                                            <i class="mdi mdi-account text-white h4 mb-0"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="flex-1 ms-2">
                                    <span class="d-block mb-1">${sessionScope.user.fullName}</span>
                                    <small class="text-muted">Customer</small>
                                </div>
                            </a>
                            <div class="dropdown-divider border-top"></div>
                            <a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/profile">
                                <span class="mb-0 d-inline-block me-1"><i class="mdi mdi-account-outline"></i></span> Profile
                            </a>
                            <div class="dropdown-divider border-top"></div>
                            <a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/logout">
                                <span class="mb-0 d-inline-block me-1"><i class="mdi mdi-logout"></i></span> Logout
                            </a>
                        </div>
                    </div>
                </li>
            </c:if>
            <c:if test="${empty sessionScope.user}">
                <li class="list-inline-item mb-0">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Login</a>
                </li>
            </c:if>
        </ul>
    </div>
</header>