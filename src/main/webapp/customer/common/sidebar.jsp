<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav id="sidebar" class="sidebar-wrapper">
    <div class="sidebar-content" data-simplebar style="height: calc(100% - 60px);">
        <div class="sidebar-brand">
            <a href="${pageContext.request.contextPath}/customer/dashboard"
               style="font-size: 20px; font-weight: bold; color: #333;">
                CMS
            </a>
        </div>

        <ul class="sidebar-menu pt-3">

            <!-- Dashboard -->
            <li>
                <a href="${pageContext.request.contextPath}/customer/dashboard">
                    <i class="uil uil-dashboard me-2 d-inline-block"></i>Dashboard
                </a>
            </li>

            <!-- Contracts -->
            <li class="sidebar-dropdown">
                <a href="javascript:void(0)">
                    <i class="uil uil-file-contract me-2 d-inline-block"></i>My Contracts
                </a>
                <div class="sidebar-submenu">
                    <ul>
                        <li>
                            <a href="${pageContext.request.contextPath}/customer/contracts">
                                View Contracts
                            </a>
                        </li>
                    </ul>
                </div>
            </li>

            <!-- Machines -->
            <li class="sidebar-dropdown">
                <a href="javascript:void(0)">
                    <i class="uil uil-cog me-2 d-inline-block"></i>Machines
                </a>
                <div class="sidebar-submenu">
                    <ul>
                        <li>
                            <a href="${pageContext.request.contextPath}/customer/machines">
                                View Machines
                            </a>
                        </li>
                    </ul>
                </div>
            </li>

            <!-- 🔥 Maintenance Requests -->
            <li class="sidebar-dropdown">
                <a href="javascript:void(0)">
                    <i class="uil uil-wrench me-2 d-inline-block"></i>Maintenance Requests
                </a>
                <div class="sidebar-submenu">
                    <ul>
                        <li>
                            <a href="${pageContext.request.contextPath}/customer/requests">
                                My Requests
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/customer/sendrequest">
                                Send New Request
                            </a>
                        </li>
                    </ul>
                </div>
            </li>

        </ul>
    </div>
</nav>
