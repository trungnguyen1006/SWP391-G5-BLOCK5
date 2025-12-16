<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav id="sidebar" class="sidebar-wrapper">
    <div class="sidebar-content" data-simplebar style="height: calc(100% - 60px);">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/employee/dashboard">
                <img src="${pageContext.request.contextPath}/assets/images/logo-dark.png" height="24" class="logo-light-mode" alt="">
                <img src="${pageContext.request.contextPath}/assets/images/logo-light.png" height="24" class="logo-dark-mode" alt="">
            </a>
        </div>

        <ul class="sidebar-menu pt-3">
            <li><a href="${pageContext.request.contextPath}/employee/dashboard"><i class="uil uil-dashboard me-2 d-inline-block"></i>Dashboard</a></li>

            <li class="sidebar-dropdown">
                <a href="javascript:void(0)"><i class="uil uil-file-contract me-2 d-inline-block"></i>Contract Management</a>
                <div class="sidebar-submenu">
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/employee/contracts">Contract List</a></li>
                        <li><a href="${pageContext.request.contextPath}/employee/add-contract">Create Contract</a></li>
                    </ul>
                </div>
            </li>

        </ul>
    </div>
</nav>
