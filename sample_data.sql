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

-- 2) Users (password chỉ là demo; thực tế phải hash)
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

-- 3) UserRoles (assign role theo RoleName)
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

-- 4) Customers (gắn với user cust01)
-- 5) Customers (gắn với user cust01)
INSERT INTO Customers (UserId, CustomerCode, CustomerName, Address, ContactName, ContactPhone, ContactEmail, IsActive)
SELECT u.UserId, 'CUST-001', 'Customer A Co.,Ltd', 'Hanoi, Vietnam', 'Customer A', '0900000101', 'cust01@cms.local', 1
FROM Users u WHERE u.Username='cust01'
    ON DUPLICATE KEY UPDATE CustomerName=VALUES(CustomerName), Address=VALUES(Address), IsActive=VALUES(IsActive);

-- 6) Warehouses
INSERT INTO Warehouses (WarehouseCode, WarehouseName, Address, IsActive) VALUES
                                                                             ('WH-001', 'Main Warehouse', 'Hanoi', 1),
                                                                             ('WH-002', 'Spare Warehouse', 'HCM', 1)
    ON DUPLICATE KEY UPDATE WarehouseName=VALUES(WarehouseName), Address=VALUES(Address), IsActive=VALUES(IsActive);

-- 7) Sites (công trình) thuộc Customer A
INSERT INTO Sites (SiteCode, SiteName, Address, CustomerId, IsActive)
SELECT 'SITE-001', 'Site A1', 'Hanoi - District 1', c.CustomerId, 1
FROM Customers c WHERE c.CustomerCode='CUST-001'
    ON DUPLICATE KEY UPDATE SiteName=VALUES(SiteName), Address=VALUES(Address), IsActive=VALUES(IsActive);

-- 8) MachineModels
INSERT INTO MachineModels (ModelCode, ModelName, Brand, Category, Specs, IsActive)
VALUES
    ('MDL-EXC-01', 'Excavator Model X', 'CAT', 'EXCAVATOR', JSON_OBJECT('power','110kW','weight','20t'), 1),
    ('MDL-GEN-01', 'Generator Model G', 'Honda', 'GENERATOR', JSON_OBJECT('power','5kW','fuel','gasoline'), 1)
    ON DUPLICATE KEY UPDATE ModelName=VALUES(ModelName), Brand=VALUES(Brand), Category=VALUES(Category), Specs=VALUES(Specs), IsActive=VALUES(IsActive);

-- 9) MachineUnits (đặt ở WH-001)
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

-- 10) Contract (Customer A, Site A1, CreatedBy = admin)
INSERT INTO Contracts (
    ContractCode, CustomerId, SiteId, SaleEmployeeId, ManagerEmployeeId,
    SignedDate, StartDate, EndDate, Status, Note, CreatedBy
)
SELECT
    'CT-001',
    c.CustomerId,
    s.SiteId,
    NULL,
    NULL,
    CURDATE(), CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY),
    'DRAFT',
    'Demo contract',
    uAdmin.UserId
FROM Customers c
         JOIN Sites s ON s.SiteCode='SITE-001' AND s.CustomerId=c.CustomerId
         JOIN Users uAdmin ON uAdmin.Username='admin'
WHERE c.CustomerCode='CUST-001'
    ON DUPLICATE KEY UPDATE Status=VALUES(Status), Note=VALUES(Note);

-- 11) ContractItems (gắn serial)
INSERT IGNORE INTO ContractItems (ContractId, UnitId, DeliveryDate, ReturnDueDate, Price, Deposit, Note)
SELECT c.ContractId, u.UnitId, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 15000000, 2000000, 'Demo item'
FROM Contracts c
         JOIN MachineUnits u ON u.SerialNumber='SN-EXC-0001'
WHERE c.ContractCode='CT-001';



COMMIT;
