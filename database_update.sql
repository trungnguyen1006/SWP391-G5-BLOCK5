/* =========================================================
EXTEND DB FOR: CMS - Machine (Serial) - Contract Approval
Support Request - Maintenance - Notification - Audit
MySQL / InnoDB
========================================================= */

-- (A) OPTIONAL: nếu bạn CHƯA chạy thì mới chạy (nếu đã có Phone/Image thì bỏ qua)
ALTER TABLE Users
ADD COLUMN Phone VARCHAR(15),
ADD COLUMN Image VARCHAR(255);

-- (B) OPTIONAL: metadata update
ALTER TABLE Users
ADD COLUMN UpdatedDate DATETIME NULL,
ADD COLUMN UpdatedBy INT NULL,
ADD CONSTRAINT FK_Users_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES Users(UserId);

/* =========================================================
1) RBAC: Permission -> RolePermissions (validate permission)
========================================================= */
CREATE TABLE Permissions (
    PermissionId INT AUTO_INCREMENT PRIMARY KEY,
    PermissionCode VARCHAR(100) UNIQUE NOT NULL,   -- e.g. MACHINE_ADD, CONTRACT_APPROVE
    PermissionName VARCHAR(200) NOT NULL,
    IsActive TINYINT(1) DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE RolePermissions (
    RoleId INT NOT NULL,
    PermissionId INT NOT NULL,
    PRIMARY KEY (RoleId, PermissionId),
    FOREIGN KEY (RoleId) REFERENCES Roles(RoleId),
    FOREIGN KEY (PermissionId) REFERENCES Permissions(PermissionId)
) ENGINE=InnoDB;

/* =========================================================
2) Master data: Customers / Employees
========================================================= */
CREATE TABLE Customers (
    CustomerId INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT UNIQUE NULL, -- nếu customer có account login
    CustomerCode VARCHAR(50) UNIQUE NOT NULL,
    CustomerName VARCHAR(200) NOT NULL,
    Address VARCHAR(255) NULL,
    ContactName VARCHAR(200) NULL,
    ContactPhone VARCHAR(30) NULL,
    ContactEmail VARCHAR(100) NULL,
    IsActive TINYINT(1) DEFAULT 1,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
) ENGINE=InnoDB;

CREATE TABLE Employees (
    EmployeeId INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT UNIQUE NOT NULL, -- sale/support/manager/admin là employee
    EmployeeCode VARCHAR(50) UNIQUE NOT NULL,
    Department VARCHAR(100) NULL,
    Title VARCHAR(100) NULL,
    IsActive TINYINT(1) DEFAULT 1,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
) ENGINE=InnoDB;

/* =========================================================
3) Location: Warehouses / Sites (công trình)
========================================================= */
CREATE TABLE Warehouses (
    WarehouseId INT AUTO_INCREMENT PRIMARY KEY,
    WarehouseCode VARCHAR(50) UNIQUE NOT NULL,
    WarehouseName VARCHAR(200) NOT NULL,
    Address VARCHAR(255) NULL,
    IsActive TINYINT(1) DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE Sites (
    SiteId INT AUTO_INCREMENT PRIMARY KEY,
    SiteCode VARCHAR(50) UNIQUE NOT NULL,
    SiteName VARCHAR(200) NOT NULL,
    Address VARCHAR(255) NULL,
    CustomerId INT NULL,
    IsActive TINYINT(1) DEFAULT 1,
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
) ENGINE=InnoDB;

/* =========================================================
4) Machines: Model + Unit(Serial) + history
========================================================= */
CREATE TABLE MachineModels (
    ModelId INT AUTO_INCREMENT PRIMARY KEY,
    ModelCode VARCHAR(50) UNIQUE NOT NULL,
    ModelName VARCHAR(200) NOT NULL,
    Brand VARCHAR(100) NULL,
    Category VARCHAR(100) NULL,
    Specs JSON NULL,
    IsActive TINYINT(1) DEFAULT 1,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE MachineUnits (
    UnitId INT AUTO_INCREMENT PRIMARY KEY,
    ModelId INT NOT NULL,
    SerialNumber VARCHAR(100) UNIQUE NOT NULL,
    CurrentStatus ENUM('IN_STOCK','ALLOCATED','ON_SITE','MAINTENANCE','BROKEN','LOST','RETIRED')
        NOT NULL DEFAULT 'IN_STOCK',
    CurrentWarehouseId INT NULL,
    CurrentSiteId INT NULL,
    IsActive TINYINT(1) DEFAULT 1,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ModelId) REFERENCES MachineModels(ModelId),
    FOREIGN KEY (CurrentWarehouseId) REFERENCES Warehouses(WarehouseId),
    FOREIGN KEY (CurrentSiteId) REFERENCES Sites(SiteId),
    INDEX idx_unit_model (ModelId),
    INDEX idx_unit_status (CurrentStatus),
    INDEX idx_unit_wh (CurrentWarehouseId),
    INDEX idx_unit_site (CurrentSiteId)
) ENGINE=InnoDB;

CREATE TABLE MachineStatusHistories (
    HistoryId BIGINT AUTO_INCREMENT PRIMARY KEY,
    UnitId INT NOT NULL,
    OldStatus VARCHAR(30) NULL,
    NewStatus VARCHAR(30) NOT NULL,
    OldWarehouseId INT NULL,
    NewWarehouseId INT NULL,
    OldSiteId INT NULL,
    NewSiteId INT NULL,
    Note VARCHAR(500) NULL,
    ChangedBy INT NULL,
    ChangedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UnitId) REFERENCES MachineUnits(UnitId),
    FOREIGN KEY (OldWarehouseId) REFERENCES Warehouses(WarehouseId),
    FOREIGN KEY (NewWarehouseId) REFERENCES Warehouses(WarehouseId),
    FOREIGN KEY (OldSiteId) REFERENCES Sites(SiteId),
    FOREIGN KEY (NewSiteId) REFERENCES Sites(SiteId),
    FOREIGN KEY (ChangedBy) REFERENCES Users(UserId),
    INDEX idx_mhist_unit (UnitId, ChangedDate)
) ENGINE=InnoDB;

/* =========================================================
5) Contracts (handover/invoice) + items by serial + approvals
========================================================= */
CREATE TABLE Contracts (
    ContractId INT AUTO_INCREMENT PRIMARY KEY,
    ContractCode VARCHAR(50) UNIQUE NOT NULL,
    CustomerId INT NOT NULL,
    SiteId INT NULL,
    SaleEmployeeId INT NULL,
    ManagerEmployeeId INT NULL,
    SignedDate DATE NULL,
    StartDate DATE NULL,
    EndDate DATE NULL,
    Status ENUM('DRAFT','PENDING_APPROVAL','APPROVED','REJECTED','ACTIVE','CLOSED','CANCELLED')
        NOT NULL DEFAULT 'DRAFT',
    Note VARCHAR(500) NULL,
    CreatedBy INT NOT NULL,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
    FOREIGN KEY (SiteId) REFERENCES Sites(SiteId),
    FOREIGN KEY (SaleEmployeeId) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (ManagerEmployeeId) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserId),
    INDEX idx_contract_customer (CustomerId),
    INDEX idx_contract_status (Status)
) ENGINE=InnoDB;

CREATE TABLE ContractItems (
    ContractItemId INT AUTO_INCREMENT PRIMARY KEY,
    ContractId INT NOT NULL,
    UnitId INT NOT NULL,
    DeliveryDate DATE NULL,
    ReturnDueDate DATE NULL,
    Price DECIMAL(18,2) NULL,
    Deposit DECIMAL(18,2) NULL,
    Note VARCHAR(255) NULL,
    FOREIGN KEY (ContractId) REFERENCES Contracts(ContractId),
    FOREIGN KEY (UnitId) REFERENCES MachineUnits(UnitId),
    UNIQUE KEY uq_contract_unit (ContractId, UnitId),
    INDEX idx_citem_contract (ContractId),
    INDEX idx_citem_unit (UnitId)
) ENGINE=InnoDB;

CREATE TABLE ContractApprovals (
    ApprovalId INT AUTO_INCREMENT PRIMARY KEY,
    ContractId INT NOT NULL,
    ManagerEmployeeId INT NOT NULL,
    Action ENUM('SUBMIT','APPROVE','REJECT') NOT NULL,
    Comment VARCHAR(500) NULL,
    ActionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ContractId) REFERENCES Contracts(ContractId),
    FOREIGN KEY (ManagerEmployeeId) REFERENCES Employees(EmployeeId),
    INDEX idx_cappr_contract (ContractId, ActionDate)
) ENGINE=InnoDB;

CREATE TABLE ContractStatusHistories (
    HistoryId BIGINT AUTO_INCREMENT PRIMARY KEY,
    ContractId INT NOT NULL,
    OldStatus VARCHAR(30) NULL,
    NewStatus VARCHAR(30) NOT NULL,
    Note VARCHAR(500) NULL,
    ChangedBy INT NULL,
    ChangedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ContractId) REFERENCES Contracts(ContractId),
    FOREIGN KEY (ChangedBy) REFERENCES Users(UserId),
    INDEX idx_chist_contract (ContractId, ChangedDate)
) ENGINE=InnoDB;

/* =========================================================
6) Stock Transactions (import/export/return/transfer)
dùng để: add contract -> xuất máy; update/delete contract -> trả máy về kho
========================================================= */
CREATE TABLE StockTransactions (
    TransactionId INT AUTO_INCREMENT PRIMARY KEY,
    TransactionCode VARCHAR(50) UNIQUE NOT NULL,
    TransactionType ENUM('IMPORT','EXPORT','TRANSFER','RETURN','ADJUST') NOT NULL,
    TransactionDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FromWarehouseId INT NULL,
    ToWarehouseId INT NULL,
    FromSiteId INT NULL,
    ToSiteId INT NULL,
    RelatedContractId INT NULL,
    Note VARCHAR(500) NULL,
    CreatedBy INT NOT NULL,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (FromWarehouseId) REFERENCES Warehouses(WarehouseId),
    FOREIGN KEY (ToWarehouseId) REFERENCES Warehouses(WarehouseId),
    FOREIGN KEY (FromSiteId) REFERENCES Sites(SiteId),
    FOREIGN KEY (ToSiteId) REFERENCES Sites(SiteId),
    FOREIGN KEY (RelatedContractId) REFERENCES Contracts(ContractId),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserId),
    INDEX idx_tx_type_date (TransactionType, TransactionDate)
) ENGINE=InnoDB;

CREATE TABLE StockTransactionItems (
    TransactionItemId INT AUTO_INCREMENT PRIMARY KEY,
    TransactionId INT NOT NULL,
    UnitId INT NOT NULL,
    FOREIGN KEY (TransactionId) REFERENCES StockTransactions(TransactionId),
    FOREIGN KEY (UnitId) REFERENCES MachineUnits(UnitId),
    UNIQUE KEY uq_tx_unit (TransactionId, UnitId),
    INDEX idx_txi_unit (UnitId)
) ENGINE=InnoDB;

/* =========================================================
7) Support Request (customer) + attachments + notes + escalation
========================================================= */
CREATE TABLE SupportRequests (
    RequestId INT AUTO_INCREMENT PRIMARY KEY,
    RequestCode VARCHAR(50) UNIQUE NOT NULL,
    CustomerId INT NOT NULL,
    UnitId INT NULL,
    ContractId INT NULL,
    SiteId INT NULL,
    Title VARCHAR(200) NOT NULL,
    Content TEXT NULL,
    Status ENUM('NEW','IN_PROGRESS','PENDING_MANAGER','APPROVED','REJECTED','DONE','CANCELLED')
        NOT NULL DEFAULT 'NEW',
    AssignedToEmployeeId INT NULL,
    CreatedByUserId INT NOT NULL,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedDate DATETIME NULL,
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
    FOREIGN KEY (UnitId) REFERENCES MachineUnits(UnitId),
    FOREIGN KEY (ContractId) REFERENCES Contracts(ContractId),
    FOREIGN KEY (SiteId) REFERENCES Sites(SiteId),
    FOREIGN KEY (AssignedToEmployeeId) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (CreatedByUserId) REFERENCES Users(UserId),
    INDEX idx_req_status (Status),
    INDEX idx_req_customer (CustomerId),
    INDEX idx_req_assignee (AssignedToEmployeeId)
) ENGINE=InnoDB;

CREATE TABLE SupportAttachments (
    AttachmentId BIGINT AUTO_INCREMENT PRIMARY KEY,
    RequestId INT NOT NULL,
    FileUrl VARCHAR(500) NOT NULL,     -- ảnh lỗi/path/url
    FileName VARCHAR(255) NULL,
    UploadedBy INT NULL,
    UploadedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (RequestId) REFERENCES SupportRequests(RequestId),
    FOREIGN KEY (UploadedBy) REFERENCES Users(UserId),
    INDEX idx_att_req (RequestId, UploadedDate)
) ENGINE=InnoDB;

CREATE TABLE SupportNotes (
    NoteId BIGINT AUTO_INCREMENT PRIMARY KEY,
    RequestId INT NOT NULL,
    NoteText TEXT NOT NULL,
    CreatedBy INT NULL,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (RequestId) REFERENCES SupportRequests(RequestId),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserId),
    INDEX idx_note_req (RequestId, CreatedDate)
) ENGINE=InnoDB;

CREATE TABLE SupportEscalations (
    EscalationId BIGINT AUTO_INCREMENT PRIMARY KEY,
    RequestId INT NOT NULL,
    FromEmployeeId INT NULL,
    ToManagerEmployeeId INT NOT NULL,
    Reason VARCHAR(500) NULL,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (RequestId) REFERENCES SupportRequests(RequestId),
    FOREIGN KEY (FromEmployeeId) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (ToManagerEmployeeId) REFERENCES Employees(EmployeeId),
    INDEX idx_esc_req (RequestId, CreatedDate)
) ENGINE=InnoDB;

/* =========================================================
8) Maintenance / Repair Ticket + status history + report
========================================================= */
CREATE TABLE MaintenanceTickets (
    TicketId INT AUTO_INCREMENT PRIMARY KEY,
    TicketCode VARCHAR(50) UNIQUE NOT NULL,
    UnitId INT NOT NULL,
    RequestId INT NULL,
    Status ENUM('OPEN','DIAGNOSING','FIXING','NEED_PARTS','DONE','CANCELLED')
        NOT NULL DEFAULT 'OPEN',
    Description TEXT NULL,
    CreatedByEmployeeId INT NOT NULL,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UnitId) REFERENCES MachineUnits(UnitId),
    FOREIGN KEY (RequestId) REFERENCES SupportRequests(RequestId),
    FOREIGN KEY (CreatedByEmployeeId) REFERENCES Employees(EmployeeId),
    INDEX idx_mt_status (Status),
    INDEX idx_mt_unit (UnitId)
) ENGINE=InnoDB;

CREATE TABLE MaintenanceStatusHistories (
    HistoryId BIGINT AUTO_INCREMENT PRIMARY KEY,
    TicketId INT NOT NULL,
    OldStatus VARCHAR(30) NULL,
    NewStatus VARCHAR(30) NOT NULL,
    Note VARCHAR(500) NULL,
    ChangedByEmployeeId INT NULL,
    ChangedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TicketId) REFERENCES MaintenanceTickets(TicketId),
    FOREIGN KEY (ChangedByEmployeeId) REFERENCES Employees(EmployeeId),
    INDEX idx_mth_ticket (TicketId, ChangedDate)
) ENGINE=InnoDB;

CREATE TABLE TechnicalSupportReports (
    ReportId INT AUTO_INCREMENT PRIMARY KEY,
    TicketId INT NOT NULL,
    ReportUrl VARCHAR(500) NOT NULL,   -- file report (pdf/html)
    CreatedByEmployeeId INT NOT NULL,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (TicketId) REFERENCES MaintenanceTickets(TicketId),
    FOREIGN KEY (CreatedByEmployeeId) REFERENCES Employees(EmployeeId),
    INDEX idx_rep_ticket (TicketId, CreatedDate)
) ENGINE=InnoDB;

/* =========================================================
9) Notifications + Audit logs
========================================================= */
CREATE TABLE Notifications (
    NotificationId BIGINT AUTO_INCREMENT PRIMARY KEY,
    ToUserId INT NOT NULL,
    Title VARCHAR(200) NOT NULL,
    Content TEXT NOT NULL,
    IsRead TINYINT(1) DEFAULT 0,
    SentBy INT NULL,
    SentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ToUserId) REFERENCES Users(UserId),
    FOREIGN KEY (SentBy) REFERENCES Users(UserId),
    INDEX idx_notify_user (ToUserId, IsRead, SentDate)
) ENGINE=InnoDB;

CREATE TABLE AuditLogs (
    AuditId BIGINT AUTO_INCREMENT PRIMARY KEY,
    UserId INT NULL,
    Action VARCHAR(100) NOT NULL,  -- e.g. MACHINE_DELETE, CONTRACT_APPROVE
    EntityName VARCHAR(100) NULL,
    EntityId VARCHAR(50) NULL,
    Detail TEXT NULL,
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    INDEX idx_audit_user_date (UserId, CreatedDate)
) ENGINE=InnoDB;