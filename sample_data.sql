/* =========================================================
SAMPLE DATA FOR CMS SYSTEM
========================================================= */

-- Insert Permissions
INSERT INTO Permissions (PermissionCode, PermissionName) VALUES
('USER_VIEW', 'View Users'),
('USER_ADD', 'Add User'),
('USER_EDIT', 'Edit User'),
('USER_DELETE', 'Delete User'),
('MACHINE_VIEW', 'View Machines'),
('MACHINE_ADD', 'Add Machine'),
('MACHINE_EDIT', 'Edit Machine'),
('MACHINE_DELETE', 'Delete Machine'),
('CONTRACT_VIEW', 'View Contracts'),
('CONTRACT_ADD', 'Add Contract'),
('CONTRACT_EDIT', 'Edit Contract'),
('CONTRACT_APPROVE', 'Approve Contract'),
('SUPPORT_VIEW', 'View Support Requests'),
('SUPPORT_HANDLE', 'Handle Support Requests'),
('MAINTENANCE_VIEW', 'View Maintenance'),
('MAINTENANCE_HANDLE', 'Handle Maintenance'),
('REPORT_VIEW', 'View Reports'),
('AUDIT_VIEW', 'View Audit Logs');

-- Assign permissions to roles (assuming RoleId 1=Admin, 2=Manager, 3=Employee, 4=Customer)
-- Admin gets all permissions
INSERT INTO RolePermissions (RoleId, PermissionId) 
SELECT 1, PermissionId FROM Permissions;

-- Manager gets most permissions except user management
INSERT INTO RolePermissions (RoleId, PermissionId) 
SELECT 2, PermissionId FROM Permissions 
WHERE PermissionCode NOT IN ('USER_ADD', 'USER_DELETE', 'AUDIT_VIEW');

-- Employee gets basic permissions
INSERT INTO RolePermissions (RoleId, PermissionId) 
SELECT 3, PermissionId FROM Permissions 
WHERE PermissionCode IN ('MACHINE_VIEW', 'CONTRACT_VIEW', 'SUPPORT_VIEW', 'SUPPORT_HANDLE', 'MAINTENANCE_VIEW', 'MAINTENANCE_HANDLE');

-- Customer gets minimal permissions
INSERT INTO RolePermissions (RoleId, PermissionId) 
SELECT 4, PermissionId FROM Permissions 
WHERE PermissionCode IN ('SUPPORT_VIEW');

-- Insert Warehouses
INSERT INTO Warehouses (WarehouseCode, WarehouseName, Address) VALUES
('WH001', 'Main Warehouse', '123 Industrial Street, District 1, Ho Chi Minh City'),
('WH002', 'North Warehouse', '456 Factory Road, Hanoi'),
('WH003', 'Central Warehouse', '789 Storage Ave, Da Nang');

-- Insert Customers
INSERT INTO Customers (CustomerCode, CustomerName, Address, ContactName, ContactPhone, ContactEmail) VALUES
('CUST001', 'ABC Construction Co.', '100 Construction St, District 3, HCMC', 'Nguyen Van A', '0901234567', 'nguyenvana@abc.com'),
('CUST002', 'XYZ Engineering Ltd.', '200 Engineering Rd, Hanoi', 'Tran Thi B', '0912345678', 'tranthib@xyz.com'),
('CUST003', 'DEF Infrastructure', '300 Infrastructure Blvd, Da Nang', 'Le Van C', '0923456789', 'levanc@def.com');

-- Insert Sites
INSERT INTO Sites (SiteCode, SiteName, Address, CustomerId) VALUES
('SITE001', 'ABC Tower Project', '500 Nguyen Hue, District 1, HCMC', 1),
('SITE002', 'XYZ Bridge Construction', 'Highway 1A, Hanoi', 2),
('SITE003', 'DEF Shopping Mall', 'Beach Road, Da Nang', 3);

-- Insert Machine Models
INSERT INTO MachineModels (ModelCode, ModelName, Brand, Category, Specs) VALUES
('EXC001', 'Excavator CAT 320D', 'Caterpillar', 'Excavator', '{"weight": "20000kg", "engine": "C6.6", "bucket_capacity": "1.2m3"}'),
('CRA001', 'Mobile Crane XCMG QY50K', 'XCMG', 'Crane', '{"max_lift": "50000kg", "boom_length": "60m", "engine": "WP10.340E32"}'),
('BUL001', 'Bulldozer CAT D6T', 'Caterpillar', 'Bulldozer', '{"weight": "18500kg", "blade_capacity": "4.2m3", "engine": "C9"}'),
('LOA001', 'Wheel Loader CAT 950M', 'Caterpillar', 'Loader', '{"weight": "17000kg", "bucket_capacity": "3.0m3", "engine": "C7.1"}');

-- Insert Machine Units
INSERT INTO MachineUnits (ModelId, SerialNumber, CurrentStatus, CurrentWarehouseId) VALUES
(1, 'EXC001-001', 'IN_STOCK', 1),
(1, 'EXC001-002', 'IN_STOCK', 1),
(1, 'EXC001-003', 'IN_STOCK', 2),
(2, 'CRA001-001', 'IN_STOCK', 1),
(2, 'CRA001-002', 'IN_STOCK', 2),
(3, 'BUL001-001', 'IN_STOCK', 1),
(3, 'BUL001-002', 'IN_STOCK', 3),
(4, 'LOA001-001', 'IN_STOCK', 1),
(4, 'LOA001-002', 'IN_STOCK', 2),
(4, 'LOA001-003', 'IN_STOCK', 3);

-- Insert Employees (assuming some users are employees)
INSERT INTO Employees (UserId, EmployeeCode, Department, Title) VALUES
(1, 'EMP001', 'Administration', 'System Administrator'),
(2, 'EMP002', 'Sales', 'Sales Manager'),
(3, 'EMP003', 'Technical', 'Technical Support'),
(4, 'EMP004', 'Operations', 'Operations Manager');

-- Insert sample Contracts
INSERT INTO Contracts (ContractCode, CustomerId, SiteId, SaleEmployeeId, ManagerEmployeeId, Status, CreatedBy) VALUES
('CON001', 1, 1, 2, 4, 'DRAFT', 2),
('CON002', 2, 2, 2, 4, 'APPROVED', 2),
('CON003', 3, 3, 2, 4, 'ACTIVE', 2);

-- Insert Contract Items
INSERT INTO ContractItems (ContractId, UnitId, Price, Deposit) VALUES
(1, 1, 50000000.00, 10000000.00),
(1, 4, 30000000.00, 6000000.00),
(2, 2, 50000000.00, 10000000.00),
(2, 5, 80000000.00, 16000000.00),
(3, 3, 50000000.00, 10000000.00),
(3, 6, 45000000.00, 9000000.00);

-- Insert sample Support Requests
INSERT INTO SupportRequests (RequestCode, CustomerId, UnitId, ContractId, Title, Content, CreatedByUserId) VALUES
('REQ001', 1, 1, 1, 'Excavator hydraulic issue', 'The hydraulic system is not working properly', 1),
('REQ002', 2, 2, 2, 'Crane boom malfunction', 'The boom is not extending correctly', 1),
('REQ003', 3, 3, 3, 'Bulldozer engine problem', 'Engine is overheating frequently', 1);

-- Insert sample Maintenance Tickets
INSERT INTO MaintenanceTickets (TicketCode, UnitId, RequestId, Description, CreatedByEmployeeId) VALUES
('MT001', 1, 1, 'Check and repair hydraulic system', 3),
('MT002', 2, 2, 'Inspect and fix boom extension mechanism', 3),
('MT003', 3, 3, 'Diagnose engine overheating issue', 3);

-- Insert sample Notifications
INSERT INTO Notifications (ToUserId, Title, Content, SentBy) VALUES
(1, 'New Support Request', 'A new support request REQ001 has been created', 2),
(2, 'Contract Approved', 'Contract CON002 has been approved', 4),
(3, 'Maintenance Assigned', 'Maintenance ticket MT001 has been assigned to you', 4);

-- Insert sample Audit Logs
INSERT INTO AuditLogs (UserId, Action, EntityName, EntityId, Detail) VALUES
(1, 'CONTRACT_CREATE', 'Contracts', '1', 'Created new contract CON001'),
(2, 'MACHINE_UPDATE', 'MachineUnits', '1', 'Updated machine status to ALLOCATED'),
(4, 'CONTRACT_APPROVE', 'Contracts', '2', 'Approved contract CON002');