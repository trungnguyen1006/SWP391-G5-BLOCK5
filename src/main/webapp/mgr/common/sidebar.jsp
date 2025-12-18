<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav id="sidebar" class="sidebar-wrapper">
    <div class="sidebar-content" data-simplebar style="height: calc(100% - 60px);">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/mgr/dashboard" style="font-size: 20px; font-weight: bold; color: #333;">
                CMS
            </a>
        </div>

        <ul class="sidebar-menu pt-3">
            <li><a href="${pageContext.request.contextPath}/mgr/dashboard"><i class="uil uil-dashboard me-2 d-inline-block"></i>Dashboard</a></li>

            <li class="sidebar-dropdown">
                <a href="javascript:void(0)"><i class="uil uil-building me-2 d-inline-block"></i>Site Management</a>
                <div class="sidebar-submenu">
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/mgr/sites">Site List</a></li>
                        <li><a href="${pageContext.request.contextPath}/mgr/add-site">Add Site</a></li>
                    </ul>
                </div>
            </li>

            <li class="sidebar-dropdown">
                <a href="javascript:void(0)"><i class="uil uil-warehouse me-2 d-inline-block"></i>Warehouse Management</a>
                <div class="sidebar-submenu">
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/mgr/warehouses">Warehouse List</a></li>
                        <li><a href="${pageContext.request.contextPath}/mgr/add-warehouse">Add Warehouse</a></li>
                    </ul>
                </div>
            </li>

            <li class="sidebar-dropdown">
                <a href="javascript:void(0)"><i class="uil uil-cog me-2 d-inline-block"></i>Machine Management</a>
                <div class="sidebar-submenu">
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/mgr/machines">Machine List</a></li>
                        <li><a href="${pageContext.request.contextPath}/mgr/add-machine">Add Machine</a></li>
                        <li><a href="${pageContext.request.contextPath}/mgr/add-machine-model">Add Machine Model</a></li>
                    </ul>
                </div>
            </li>

            <li class="sidebar-dropdown">
                <a href="javascript:void(0)">
                    <i class="uil uil-file-alt me-2 d-inline-block"></i>
                    Request Management
                </a>
                <div class="sidebar-submenu">
                    <ul>
                        <li>
                            <a href="${pageContext.request.contextPath}/mgr/maintenance-requests">
                                Request List
                            </a>
                        </li>
                    </ul>
                </div>
            </li>


        </ul>
    </div>
</nav>
