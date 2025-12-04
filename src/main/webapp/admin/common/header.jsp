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
            <li class="list-inline-item mb-0">
                <div class="dropdown dropdown-primary">
                    <button type="button" class="btn btn-pills btn-soft-primary dropdown-toggle p-0" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><img src="${pageContext.request.contextPath}/assets/images/language/american.png" class="avatar avatar-ex-small rounded-circle p-2" alt=""></button>
                    <div class="dropdown-menu dd-menu drop-ups dropdown-menu-end bg-white shadow border-0 mt-3 p-2" data-simplebar style="height: 175px;">
                        <a href="javascript:void(0)" class="d-flex align-items-center">
                            <img src="${pageContext.request.contextPath}/assets/images/language/chinese.png" class="avatar avatar-client rounded-circle shadow" alt="">
                            <div class="flex-1 text-left ms-2 overflow-hidden">
                                <small class="text-dark mb-0">Chinese</small>
                            </div>
                        </a>

                        <a href="javascript:void(0)" class="d-flex align-items-center mt-2">
                            <img src="${pageContext.request.contextPath}/assets/images/language/european.png" class="avatar avatar-client rounded-circle shadow" alt="">
                            <div class="flex-1 text-left ms-2 overflow-hidden">
                                <small class="text-dark mb-0">European</small>
                            </div>
                        </a>

                        <a href="javascript:void(0)" class="d-flex align-items-center mt-2">
                            <img src="${pageContext.request.contextPath}/assets/images/language/indian.png" class="avatar avatar-client rounded-circle shadow" alt="">
                            <div class="flex-1 text-left ms-2 overflow-hidden">
                                <small class="text-dark mb-0">Indian</small>
                            </div>
                        </a>

                        <a href="javascript:void(0)" class="d-flex align-items-center mt-2">
                            <img src="${pageContext.request.contextPath}/assets/images/language/japanese.png" class="avatar avatar-client rounded-circle shadow" alt="">
                            <div class="flex-1 text-left ms-2 overflow-hidden">
                                <small class="text-dark mb-0">Japanese</small>
                            </div>
                        </a>

                        <a href="javascript:void(0)" class="d-flex align-items-center mt-2">
                            <img src="${pageContext.request.contextPath}/assets/images/language/russian.png" class="avatar avatar-client rounded-circle shadow" alt="">
                            <div class="flex-1 text-left ms-2 overflow-hidden">
                                <small class="text-dark mb-0">Russian</small>
                            </div>
                        </a>
                    </div>
                </div>
            </li>

            <li class="list-inline-item mb-0 ms-1">
                <a href="javascript:void(0)" data-bs-toggle="offcanvas" data-bs-target="#offcanvasRight" aria-controls="offcanvasRight">
                    <div class="btn btn-icon btn-pills btn-soft-primary"><i data-feather="settings" class="fea icon-sm"></i></div>
                </a>
            </li>

            <li class="list-inline-item mb-0 ms-1">
                <div class="dropdown dropdown-primary">
                    <button type="button" class="btn btn-icon btn-pills btn-soft-primary dropdown-toggle p-0" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i data-feather="mail" class="fea icon-sm"></i></button>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">4 <span class="visually-hidden">unread mail</span></span>

                    <div class="dropdown-menu dd-menu dropdown-menu-end bg-white shadow rounded border-0 mt-3 px-2 py-2" data-simplebar style="height: 320px; width: 300px;">
                        <a href="#" class="d-flex align-items-center justify-content-between py-2">
                            <div class="d-inline-flex position-relative overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/images/client/02.jpg" class="avatar avatar-md-sm rounded-circle shadow" alt="">
                                <small class="text-dark mb-0 d-block text-truncat ms-3">You received a new email from <b>Janalia</b> <small class="text-muted fw-normal d-inline-block">1 hour ago</small></small>
                            </div>
                        </a>

                        <a href="#" class="d-flex align-items-center justify-content-between py-2 border-top">
                            <div class="d-inline-flex position-relative overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/images/client/Codepen.svg" class="avatar avatar-md-sm rounded-circle shadow" alt="">
                                <small class="text-dark mb-0 d-block text-truncat ms-3">You received a new email from <b>codepen</b>  <small class="text-muted fw-normal d-inline-block">4 hours ago</small></small>
                            </div>
                        </a>

                        <a href="#" class="d-flex align-items-center justify-content-between py-2 border-top">
                            <div class="d-inline-flex position-relative overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/images/client/03.jpg" class="avatar avatar-md-sm rounded-circle shadow" alt="">
                                <small class="text-dark mb-0 d-block text-truncat ms-3">You received a new email from <b>Cristina</b> <small class="text-muted fw-normal d-inline-block">5 hours ago</small></small>
                            </div>
                        </a>

                        <a href="#" class="d-flex align-items-center justify-content-between py-2 border-top">
                            <div class="d-inline-flex position-relative overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/images/client/dribbble.svg" class="avatar avatar-md-sm rounded-circle shadow" alt="">
                                <small class="text-dark mb-0 d-block text-truncat ms-3">You received a new email from <b>Dribbble</b> <small class="text-muted fw-normal d-inline-block">24 hours ago</small></small>
                            </div>
                        </a>

                        <a href="#" class="d-flex align-items-center justify-content-between py-2 border-top">
                            <div class="d-inline-flex position-relative overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/images/client/06.jpg" class="avatar avatar-md-sm rounded-circle shadow" alt="">
                                <small class="text-dark mb-0 d-block text-truncat ms-3">You received a new email from <b>Donald Aghori</b> <small class="text-muted fw-normal d-inline-block">1 day ago</small></small>
                            </div>
                        </a>

                        <a href="#" class="d-flex align-items-center justify-content-between py-2 border-top">
                            <div class="d-inline-flex position-relative overflow-hidden">
                                <img src="${pageContext.request.contextPath}/assets/images/client/07.jpg" class="avatar avatar-md-sm rounded-circle shadow" alt="">
                                <small class="text-dark mb-0 d-block text-truncat ms-3">You received a new email from <b>Calvin</b> <small class="text-muted fw-normal d-inline-block">2 days ago</small></small>
                            </div>
                        </a>
                    </div>
                </div>
            </li>

            <li class="list-inline-item mb-0 ms-1">
                <div class="dropdown dropdown-primary">
                    <button type="button" class="btn btn-pills btn-soft-primary dropdown-toggle p-0" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><img src="${pageContext.request.contextPath}/assets/images/doctors/01.jpg" class="avatar avatar-ex-small rounded-circle" alt=""></button>
                    <div class="dropdown-menu dd-menu dropdown-menu-end bg-white shadow border-0 mt-3 py-3" style="min-width: 200px;">
                        <a class="dropdown-item d-flex align-items-center text-dark" href="#">
                            <img src="${pageContext.request.contextPath}/assets/images/doctors/01.jpg" class="avatar avatar-md-sm rounded-circle border shadow" alt="">
                            <div class="flex-1 ms-2">
                                <span class="d-block mb-1">${sessionScope.user.fullName}</span>
                                <small class="text-muted">Administrator</small>
                            </div>
                        </a>
                        <a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/admin/dashboard"><span class="mb-0 d-inline-block me-1"><i class="uil uil-dashboard align-middle h6"></i></span> Dashboard</a>
                        <a class="dropdown-item text-dark" href="#"><span class="mb-0 d-inline-block me-1"><i class="uil uil-setting align-middle h6"></i></span> Settings</a>
                        <div class="dropdown-divider border-top"></div>
                        <a class="dropdown-item text-dark" href="${pageContext.request.contextPath}/logout"><span class="mb-0 d-inline-block me-1"><i class="uil uil-sign-out-alt align-middle h6"></i></span> Logout</a>
                    </div>
                </div>
            </li>
        </ul>
    </div>
</div>
