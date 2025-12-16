# SITE MANAGEMENT - Implementation Guide

## Overview
Site Management module cho phép quản lý các công trình (sites) của khách hàng. Chỉ có MANAGER role mới có thể truy cập.

## Files Created

### 1. DAO Layer
- **src/main/java/dal/SiteDAO.java** - Data access layer cho Site
  - `getSitesByPage()` - Lấy danh sách site có phân trang
  - `getTotalSites()` - Lấy tổng số site
  - `getSiteById()` - Lấy site theo ID
  - `getSitesByCustomer()` - Lấy site theo customer
  - `addSite()` - Thêm site mới
  - `updateSite()` - Cập nhật site
  - `deleteSite()` - Xóa site (soft delete)
  - `isSiteCodeExists()` - Kiểm tra site code tồn tại
  - `generateSiteCode()` - Tạo site code tự động

### 2. Servlet Controllers
- **src/main/java/controller/site/ViewSiteListServlet.java** - Hiển thị danh sách site
  - URL: `/admin/sites`
  - Method: GET
  - Pagination: 10 items per page

- **src/main/java/controller/site/AddSiteServlet.java** - Thêm site mới
  - URL: `/admin/add-site`
  - Method: GET (form), POST (submit)
  - Validation: Site code, Site name required

- **src/main/java/controller/site/UpdateSiteServlet.java** - Chỉnh sửa site
  - URL: `/admin/update-site?id={siteId}`
  - Method: GET (form), POST (submit)
  - Validation: Site code, Site name required

- **src/main/java/controller/site/DeleteSiteServlet.java** - Xóa site
  - URL: `/admin/delete-site?id={siteId}`
  - Method: GET
  - Soft delete (IsActive = 0)

### 3. JSP Pages
- **src/main/webapp/admin/site/view-site-list.jsp** - Danh sách site
  - Hiển thị bảng site với pagination
  - Nút Add, Edit, Delete

- **src/main/webapp/admin/site/add-site.jsp** - Form thêm site
  - Site Code (auto-generated)
  - Site Name (required)
  - Customer (optional)
  - Address (optional)

- **src/main/webapp/admin/site/update-site.jsp** - Form chỉnh sửa site
  - Tương tự add-site.jsp nhưng có dữ liệu cũ

### 4. Updated Files
- **src/main/java/dal/CustomerDAO.java** - Mở rộng
  - `getAllCustomers()` - Lấy danh sách khách hàng

## URL Mapping

| Action | URL | Method |
|--------|-----|--------|
| View List | `/admin/sites` | GET |
| Add Form | `/admin/add-site` | GET |
| Add Submit | `/admin/add-site` | POST |
| Edit Form | `/admin/update-site?id={id}` | GET |
| Edit Submit | `/admin/update-site` | POST |
| Delete | `/admin/delete-site?id={id}` | GET |

## Database Schema
```sql
CREATE TABLE Sites (
    SiteId INT AUTO_INCREMENT PRIMARY KEY,
    SiteCode VARCHAR(50) UNIQUE NOT NULL,
    SiteName VARCHAR(200) NOT NULL,
    Address VARCHAR(255) NULL,
    CustomerId INT NULL,
    IsActive TINYINT(1) DEFAULT 1,
    CONSTRAINT FK_Sites_Customer FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);
```

## Features

### 1. List Sites
- Hiển thị danh sách site với phân trang
- Hiển thị Site Code, Site Name, Address, Customer
- Nút Edit và Delete cho mỗi site
- Success messages khi add/update/delete

### 2. Add Site
- Auto-generate Site Code
- Validate Site Code (required, unique)
- Validate Site Name (required)
- Optional Customer selection
- Optional Address

### 3. Update Site
- Load dữ liệu site cũ
- Validate Site Code (unique cho site khác)
- Validate Site Name (required)
- Update tất cả fields

### 4. Delete Site
- Soft delete (IsActive = 0)
- Confirm dialog trước khi delete
- Redirect về list sau khi delete

## Validation Rules

| Field | Rules |
|-------|-------|
| Site Code | Required, Unique, Auto-generated |
| Site Name | Required, Max 200 chars |
| Address | Optional, Max 255 chars |
| Customer | Optional |

## Error Handling

- Site code already exists
- Site not found
- Invalid input format
- Database errors (logged to console)

## Security

- Require login (check session)
- Only MANAGER role can access (need to add filter)
- CSRF protection (form-based)

## Next Steps

1. Add Role-based access control filter
2. Add audit logging (who created/updated/deleted)
3. Add bulk operations (bulk delete)
4. Add search/filter functionality
5. Add export to Excel

## Testing

### Test Cases
1. Add new site with all fields
2. Add new site with only required fields
3. Try to add duplicate site code
4. Update site
5. Delete site
6. Pagination

### Sample Data
```sql
INSERT INTO Sites (SiteCode, SiteName, Address, CustomerId, IsActive)
VALUES ('SITE0001', 'Site A1', 'Hanoi - District 1', 1, 1);
```

## Notes

- Site Code được auto-generate theo format: SITE0001, SITE0002, ...
- Soft delete được sử dụng (không xóa vật lý)
- Pagination mặc định 10 items per page
- Customer là optional (site có thể không gắn với customer)
