<%-- 
    Document   : profile
    Created on : Dec 3, 2025, 11:00:18 PM
    Author     : Administrator
--%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="model.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            Users user = (Users) session.getAttribute("user");
            if(user != null){
                DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        %>
        <div >
            <h2>User Profile</h2>
            <table border="1" cellspacing="0" cellpadding="5">

                <th>User Name</th>   
                <th>Email</th>
                <th>Full Name</th>
                <th>Status</th>
                <th>Created at</th>
                
                <tr>
                    <td><%= user.getUsername() %></td>
                    <td><%= user.getEmail() != null ? user.getEmail() : "" %></td>
                    <td><%= user.getFullName() %></td>
                    <td><%= user.isActive() ? "Đang hoạt động" : "Không hoạt động" %></td>
                    <td><%= user.getCreatedDate() != null ? dtf.format(user.getCreatedDate()) : "" %></td>
                                      
                </tr>

            </table>
        </div>
        <%
            } else {
        %>
        <p>User not found.</p>
        <%
            }
        %>
    </body>
</html>