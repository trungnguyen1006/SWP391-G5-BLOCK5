/* =========================================================
SAMPLE DATA (idempotent-ish): Roles/Permissions/Users/...
Chạy sau khi CREATE TABLE xong
========================================================= */

START TRANSACTION;

-- 1) Roles
INSERT INTO Roles (RoleName, IsActive) VALUES
                                           ('ADMIN', 1),
                                           ('MANAGER', 1),
                                           ('SALE', 1),
                                           ('SUPPORT', 1),
                                           ('CUSTOMER', 1)
    ON DUPLICATE KEY UPDATE IsActive = VALUES(IsActive);

-- 2) Permissions (bạn có thể thêm/bớt tùy hệ thống)
INSERT INTO Permissions (PermissionCode, PermissionName, IsActive) VALUES
                                                                       ('DASHBOARD_VIEW', 'View dashboard', 1),

                                                                       ('MACHINE_VIEW', 'View machines', 1),
                                                                       ('MACHINE_ADD', 'Add machine', 1),
                                                                       ('MACHINE_UPDATE', 'Update machine', 1),
                                                                       ('MACHINE_DELETE', 'Delete machine', 1),

                                                                       ('CONTRACT_VIEW', 'View contracts', 1),
                                                                       ('CONTRACT_CREATE', 'Create contract', 1),
                                                                       ('CONTRACT_UPDATE', 'Update contract', 1),
                                                                       ('CONTRACT_APPROVE', 'Approve contract', 1),

                                                                       ('STOCK_VIEW', 'View stock transactions', 1),
                                                                       ('STOCK_IMPORT', 'Import stock', 1),
                                                                       ('STOCK_EXPORT', 'Export stock', 1),

                                                                       ('SUPPORT_VIEW', 'View support requests', 1),
                                                                       ('SUPPORT_CREATE', 'Create support request', 1),
                                                                       ('SUPPORT_ASSIGN', 'Assign support request', 1),

                                                                       ('MAINTENANCE_VIEW', 'View maintenance tickets', 1),
                                                                       ('MAINTENANCE_CREATE', 'Create maintenance ticket', 1),
                                                                       ('MAINTENANCE_UPDATE', 'Update maintenance ticket', 1),

                                                                       ('NOTIFY_VIEW', 'View notifications', 1),
                                                                       ('AUDIT_VIEW', 'View audit logs', 1)
    ON DUPLICATE KEY UPDATE
                         PermissionName = VALUES(PermissionName),
                         IsActive = VALUES(IsActive);

-- 3) RolePermissions (map theo RoleName + PermissionCode, KHÔNG dùng id cứng)
-- ADMIN: full (demo)
INSERT IGNORE INTO RolePermissions (RoleId, PermissionId)
SELECT r.RoleId, p.PermissionId
FROM Roles r
         JOIN Permissions p
WHERE r.RoleName = 'ADMIN';

-- MANAGER
INSERT IGNORE INTO RolePermissions (RoleId, PermissionId)
SELECT r.RoleId, p.PermissionId
FROM Roles r
         JOIN Permissions p
WHERE r.RoleName = 'MANAGER'
  AND p.PermissionCode IN ('DASHBOARD_VIEW','MACHINE_VIEW','CONTRACT_VIEW','CONTRACT_APPROVE','SUPPORT_VIEW','MAINTENANCE_VIEW','AUDIT_VIEW','NOTIFY_VIEW');

-- SALE
INSERT IGNORE INTO RolePermissions (RoleId, PermissionId)
SELECT r.RoleId, p.PermissionId
FROM Roles r
         JOIN Permissions p
WHERE r.RoleName = 'SALE'
  AND p.PermissionCode IN ('DASHBOARD_VIEW','CONTRACT_VIEW','CONTRACT_CREATE','CONTRACT_UPDATE','MACHINE_VIEW','STOCK_VIEW','NOTIFY_VIEW');

-- SUPPORT
INSERT IGNORE INTO RolePermissions (RoleId, PermissionId)
SELECT r.RoleId, p.PermissionId
FROM Roles r
         JOIN Permissions p
WHERE r.RoleName = 'SUPPORT'
  AND p.PermissionCode IN ('DASHBOARD_VIEW','SUPPORT_VIEW','SUPPORT_ASSIGN','MAINTENANCE_VIEW','MAINTENANCE_CREATE','MAINTENANCE_UPDATE','MACHINE_VIEW','NOTIFY_VIEW');

-- CUSTOMER
INSERT IGNORE INTO RolePermissions (RoleId, PermissionId)
SELECT r.RoleId, p.PermissionId
FROM Roles r
         JOIN Permissions p
WHERE r.RoleName = 'CUSTOMER'
  AND p.PermissionCode IN ('SUPPORT_CREATE','NOTIFY_VIEW');

-- 4) Users (password chỉ là demo; thực tế phải hash)
INSERT INTO Users (Username, Password, Email, FullName, Phone, Image, IsActive)
VALUES
    ('admin',   '123456', 'admin@cms.local',   'System Admin',   '0900000001', NULL, 1),
    ('manager', '123456', 'manager@cms.local', 'Branch Manager', '0900000002', NULL, 1),
    ('sale01',  '123456', 'sale01@cms.local',  'Sales Staff 01', '0900000003', NULL, 1),
    ('support01','123456','support01@cms.local','Support Staff 01','0900000004',NULL, 1),
    ('cust01',  '123456', 'cust01@cms.local',  'Customer A',     '0900000101', NULL, 1)
    ON DUPLICATE KEY UPDATE
                         FullName = VALUES(FullName),
                         Phone = VALUES(Phone),
                         IsActive = VALUES(IsActive);

-- 5) UserRoles (assign role theo RoleName)
INSERT IGNORE INTO UserRoles (UserId, RoleId)
SELECT u.UserId, r.RoleId FROM Users u JOIN Roles r
WHERE u.Username='admin' AND r.RoleName='ADMIN';

INSERT IGNORE INTO UserRoles (UserId, RoleId)
SELECT u.UserId, r.RoleId FROM Users u JOIN Roles r
WHERE u.Username='manager' AND r.RoleName='MANAGER';

INSERT IGNORE INTO UserRoles (UserId, RoleId)
SELECT u.UserId, r.RoleId FROM Users u JOIN Roles r
WHERE u.Username='sale01' AND r.RoleName='SALE';

INSERT IGNORE INTO UserRoles (UserId, RoleId)
SELECT u.UserId, r.RoleId FROM Users u JOIN Roles r
WHERE u.Username='support01' AND r.RoleName='SUPPORT';

INSERT IGNORE INTO UserRoles (UserId, RoleId)
SELECT u.UserId, r.RoleId FROM Users u JOIN Roles r
WHERE u.Username='cust01' AND r.RoleName='CUSTOMER';

-- 6) Employees (admin/manager/sale/support)
INSERT INTO Employees (UserId, EmployeeCode, Department, Title, IsActive)
SELECT u.UserId, 'EMP-ADM-001', 'IT', 'Admin', 1 FROM Users u
WHERE u.Username='admin'
    ON DUPLICATE KEY UPDATE Department=VALUES(Department), Title=VALUES(Title), IsActive=VALUES(IsActive);

INSERT INTO Employees (UserId, EmployeeCode, Department, Title, IsActive)
SELECT u.UserId, 'EMP-MGR-001', 'Management', 'Manager', 1 FROM Users u
WHERE u.Username='manager'
    ON DUPLICATE KEY UPDATE Department=VALUES(Department), Title=VALUES(Title), IsActive=VALUES(IsActive);

INSERT INTO Employees (UserId, EmployeeCode, Department, Title, IsActive)
SELECT u.UserId, 'EMP-SAL-001', 'Sales', 'Sales', 1 FROM Users u
WHERE u.Username='sale01'
    ON DUPLICATE KEY UPDATE Department=VALUES(Department), Title=VALUES(Title), IsActive=VALUES(IsActive);

INSERT INTO Employees (UserId, EmployeeCode, Department, Title, IsActive)
SELECT u.UserId, 'EMP-SUP-001', 'Support', 'Support', 1 FROM Users u
WHERE u.Username='support01'
    ON DUPLICATE KEY UPDATE Department=VALUES(Department), Title=VALUES(Title), IsActive=VALUES(IsActive);

-- 7) Customers (gắn với user cust01)
INSERT INTO Customers (UserId, CustomerCode, CustomerName, Address, ContactName, ContactPhone, ContactEmail, IsActive)
SELECT u.UserId, 'CUST-001', 'Customer A Co.,Ltd', 'Hanoi, Vietnam', 'Customer A', '0900000101', 'cust01@cms.local', 1
FROM Users u WHERE u.Username='cust01'
    ON DUPLICATE KEY UPDATE CustomerName=VALUES(CustomerName), Address=VALUES(Address), IsActive=VALUES(IsActive);

-- 8) Warehouses
INSERT INTO Warehouses (WarehouseCode, WarehouseName, Address, IsActive) VALUES
                                                                             ('WH-001', 'Main Warehouse', 'Hanoi', 1),
                                                                             ('WH-002', 'Spare Warehouse', 'HCM', 1)
    ON DUPLICATE KEY UPDATE WarehouseName=VALUES(WarehouseName), Address=VALUES(Address), IsActive=VALUES(IsActive);

-- 9) Sites (công trình) thuộc Customer A
INSERT INTO Sites (SiteCode, SiteName, Address, CustomerId, IsActive)
SELECT 'SITE-001', 'Site A1', 'Hanoi - District 1', c.CustomerId, 1
FROM Customers c WHERE c.CustomerCode='CUST-001'
    ON DUPLICATE KEY UPDATE SiteName=VALUES(SiteName), Address=VALUES(Address), IsActive=VALUES(IsActive);

-- 10) MachineModels
INSERT INTO MachineModels (ModelCode, ModelName, Brand, Category, Specs, IsActive)
VALUES
    ('MDL-EXC-01', 'Excavator Model X', 'CAT', 'EXCAVATOR', JSON_OBJECT('power','110kW','weight','20t'), 1),
    ('MDL-GEN-01', 'Generator Model G', 'Honda', 'GENERATOR', JSON_OBJECT('power','5kW','fuel','gasoline'), 1)
    ON DUPLICATE KEY UPDATE ModelName=VALUES(ModelName), Brand=VALUES(Brand), Category=VALUES(Category), Specs=VALUES(Specs), IsActive=VALUES(IsActive);

-- 11) MachineUnits (đặt ở WH-001)
INSERT INTO MachineUnits (ModelId, SerialNumber, CurrentStatus, CurrentWarehouseId, CurrentSiteId, IsActive)
SELECT m.ModelId, 'SN-EXC-0001', 'IN_STOCK', w.WarehouseId, NULL, 1
FROM MachineModels m, Warehouses w
WHERE m.ModelCode='MDL-EXC-01' AND w.WarehouseCode='WH-001'
    ON DUPLICATE KEY UPDATE CurrentStatus=VALUES(CurrentStatus), CurrentWarehouseId=VALUES(CurrentWarehouseId), IsActive=VALUES(IsActive);

INSERT INTO MachineUnits (ModelId, SerialNumber, CurrentStatus, CurrentWarehouseId, CurrentSiteId, IsActive)
SELECT m.ModelId, 'SN-GEN-0001', 'IN_STOCK', w.WarehouseId, NULL, 1
FROM MachineModels m, Warehouses w
WHERE m.ModelCode='MDL-GEN-01' AND w.WarehouseCode='WH-001'
    ON DUPLICATE KEY UPDATE CurrentStatus=VALUES(CurrentStatus), CurrentWarehouseId=VALUES(CurrentWarehouseId), IsActive=VALUES(IsActive);

-- 12) Contract (Customer A, Site A1, Sale = sale01, Manager = manager, CreatedBy = admin)
INSERT INTO Contracts (
    ContractCode, CustomerId, SiteId, SaleEmployeeId, ManagerEmployeeId,
    SignedDate, StartDate, EndDate, Status, Note, CreatedBy
)
SELECT
    'CT-001',
    c.CustomerId,
    s.SiteId,
    eSale.EmployeeId,
    eMgr.EmployeeId,
    CURDATE(), CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY),
    'PENDING_APPROVAL',
    'Demo contract',
    uAdmin.UserId
FROM Customers c
         JOIN Sites s ON s.SiteCode='SITE-001' AND s.CustomerId=c.CustomerId
         JOIN Users uSale ON uSale.Username='sale01'
         JOIN Employees eSale ON eSale.UserId=uSale.UserId
         JOIN Users uMgr ON uMgr.Username='manager'
         JOIN Employees eMgr ON eMgr.UserId=uMgr.UserId
         JOIN Users uAdmin ON uAdmin.Username='admin'
WHERE c.CustomerCode='CUST-001'
    ON DUPLICATE KEY UPDATE Status=VALUES(Status), Note=VALUES(Note);

-- 13) ContractItems (gắn serial)
INSERT IGNORE INTO ContractItems (ContractId, UnitId, DeliveryDate, ReturnDueDate, Price, Deposit, Note)
SELECT c.ContractId, u.UnitId, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 15000000, 2000000, 'Demo item'
FROM Contracts c
         JOIN MachineUnits u ON u.SerialNumber='SN-EXC-0001'
WHERE c.ContractCode='CT-001';

-- 14) ContractApprovals (SUBMIT)
INSERT IGNORE INTO ContractApprovals (ContractId, ManagerEmployeeId, Action, Comment)
SELECT c.ContractId, eMgr.EmployeeId, 'SUBMIT', 'Submitted for approval'
FROM Contracts c
         JOIN Users uMgr ON uMgr.Username='manager'
         JOIN Employees eMgr ON eMgr.UserId=uMgr.UserId
WHERE c.ContractCode='CT-001';

-- 15) StockTransactions (EXPORT từ WH-001 ra SITE-001 theo contract)
INSERT INTO StockTransactions (
    TransactionCode, TransactionType, FromWarehouseId, ToSiteId, RelatedContractId, Note, CreatedBy
)
SELECT
    'TX-001',
    'EXPORT',
    w.WarehouseId,
    s.SiteId,
    c.ContractId,
    'Export machine to site for contract',
    uAdmin.UserId
FROM Warehouses w
         JOIN Sites s ON s.SiteCode='SITE-001'
         JOIN Contracts c ON c.ContractCode='CT-001'
         JOIN Users uAdmin ON uAdmin.Username='admin'
WHERE w.WarehouseCode='WH-001'
    ON DUPLICATE KEY UPDATE Note=VALUES(Note);

INSERT IGNORE INTO StockTransactionItems (TransactionId, UnitId)
SELECT tx.TransactionId, mu.UnitId
FROM StockTransactions tx
         JOIN MachineUnits mu ON mu.SerialNumber='SN-EXC-0001'
WHERE tx.TransactionCode='TX-001';

-- 16) SupportRequest (customer tạo, assigned support01)
INSERT INTO SupportRequests (
    RequestCode, CustomerId, UnitId, ContractId, SiteId, Title, Content,
    Status, AssignedToEmployeeId, CreatedByUserId
)
SELECT
    'SR-001',
    c.CustomerId,
    mu.UnitId,
    ct.ContractId,
    s.SiteId,
    'Machine noise issue',
    'Customer reported abnormal noise.',
    'NEW',
    eSup.EmployeeId,
    uCust.UserId
FROM Customers c
         JOIN Users uCust ON uCust.Username='cust01'
         JOIN MachineUnits mu ON mu.SerialNumber='SN-EXC-0001'
         JOIN Contracts ct ON ct.ContractCode='CT-001'
         JOIN Sites s ON s.SiteCode='SITE-001'
         JOIN Users uSup ON uSup.Username='support01'
         JOIN Employees eSup ON eSup.UserId=uSup.UserId
WHERE c.CustomerCode='CUST-001'
    ON DUPLICATE KEY UPDATE Status=VALUES(Status), Title=VALUES(Title);

-- 17) MaintenanceTicket (support tạo)
INSERT INTO MaintenanceTickets (
    TicketCode, UnitId, RequestId, Status, Description, CreatedByEmployeeId
)
SELECT
    'MT-001',
    mu.UnitId,
    sr.RequestId,
    'OPEN',
    'Check machine noise and perform diagnosis.',
    eSup.EmployeeId
FROM MachineUnits mu
         JOIN SupportRequests sr ON sr.RequestCode='SR-001'
         JOIN Users uSup ON uSup.Username='support01'
         JOIN Employees eSup ON eSup.UserId=uSup.UserId
WHERE mu.SerialNumber='SN-EXC-0001'
    ON DUPLICATE KEY UPDATE Status=VALUES(Status), Description=VALUES(Description);

-- 18) Notification + Audit log (demo)
INSERT INTO Notifications (ToUserId, Title, Content, IsRead, SentBy)
SELECT uMgr.UserId, 'Contract pending approval', 'Contract CT-001 is waiting for your approval.', 0, uAdmin.UserId
FROM Users uMgr, Users uAdmin
WHERE uMgr.Username='manager' AND uAdmin.Username='admin';

INSERT INTO AuditLogs (UserId, Action, EntityName, EntityId, Detail)
SELECT uAdmin.UserId, 'CONTRACT_CREATE', 'Contracts', 'CT-001', 'Created demo contract CT-001'
FROM Users uAdmin
WHERE uAdmin.Username='admin';

COMMIT;
