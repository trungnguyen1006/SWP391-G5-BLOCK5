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
            <div class="search-bar p-0 d-none d-md-block ms-2">
                <div id="search" class="menu-search mb-0">
                    <form role="search" method="get" id="searchform" class="searchform">
                        <div>
                            <input type="text" class="form-control border rounded-pill" name="s" id="s" placeholder="Search...">
                            <input type="submit" id="searchsubmit" value="Search">
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <ul class="list-unstyled mb-0">

            <li class="list-inline-item mb-0 ms-1">
                <a href="javascript:void(0)" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRight" aria-controls="offcanvasRight">
                    <div class="btn btn-icon btn-pills btn-soft-primary"><i data-feather="settings" class="fea icon-sm"></i></div>
                </a>
            </li>



            <li class="list-inline-item mb-0 ms-1">
                <div class="dropdown dropdown-primary">
                    <button type="button" class="btn btn-pills btn-soft-primary dropdown-toggle p-0" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <img src="${not empty sessionScope.user.image ? pageContext.request.contextPath.concat('/uploads/').concat(sessionScope.user.image) : pageContext.request.contextPath.concat('/assets/images/default-avatar.svg')}" class="avatar avatar-ex-small rounded-circle" alt="Avatar">
                    </button>
                    <div class="dropdown-menu dd-menu dropdown-menu-end bg-white shadow border-0 mt-3 py-3" style="min-width: 200px;">
                        <a class="dropdown-item d-flex align-items-center text-dark" href="#">
                            <img src="${not empty sessionScope.user.image ? pageContext.request.contextPath.concat('/uploads/').concat(sessionScope.user.image) : pageContext.request.contextPath.concat('/assets/images/default-avatar.svg')}" class="avatar avatar-md-sm rounded-circle border shadow" alt="Avatar">
                            <div class="flex-1 ms-2">
                                <span class="d-block mb-1">${sessionScope.user.fullName}</span>
                                <small class="text-muted">Administrator</small>
                            </div>
                        </a>
                        <a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/profile"><span class="mb-0 d-inline-block me-1"><i class="uil uil-user align-middle h6"></i></span> View Profile</a>
                        <a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/change-password"><span class="mb-0 d-inline-block me-1"><i class="uil uil-lock-alt align-middle h6"></i></span> Update Password</a>
                        <div class="dropdown-divider border-top"></div>
                        <a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/logout"><span class="mb-0 d-inline-block me-1"><i class="uil uil-sign-out-alt align-middle h6"></i></span> Logout</a>
                    </div>
                </div>
            </li>
        </ul>
    </div>
</div>
