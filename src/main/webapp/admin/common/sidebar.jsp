<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav id="sidebar" class="sidebar-wrapper">
    <div class="sidebar-content" data-simplebar style="height: calc(100% - 60px);">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/admin/dashboard" style="font-size: 20px; font-weight: bold; color: #333;">
                CMS
            </a>
        </div>

        <ul class="sidebar-menu pt-3">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="uil uil-dashboard me-2 d-inline-block"></i>Dashboard</a></li>

            <li class="sidebar-dropdown">
                <a href="javascript:void(0)"><i class="uil uil-user me-2 d-inline-block"></i>User Management</a>
                <div class="sidebar-submenu">
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/admin/user-list">User List</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/add-user">Add User</a></li>
                    </ul>
                </div>
            </li>

            <li class="sidebar-dropdown">
                <a href="javascript:void(0)"><i class="uil uil-shield me-2 d-inline-block"></i>Role Management</a>
                <div class="sidebar-submenu">
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/admin/role-list">Role List</a></li>
                    </ul>
                </div>
            </li>

        </ul>
    </div>
</nav>
