/* =========================================================
FULL DB EXTENSION: CMS - Machine (Serial) - Contract Approval
Support Request - Maintenance - Notification - Audit
MySQL / InnoDB
========================================================= */

-- (0) Core tables: Users / Roles / UserRoles
CREATE TABLE Users (
                       UserId INT AUTO_INCREMENT PRIMARY KEY,
                       Username VARCHAR(50) UNIQUE NOT NULL,
                       Password VARCHAR(255) NOT NULL,
                       Email VARCHAR(100) UNIQUE NOT NULL,
                       FullName VARCHAR(100),
                       IsActive TINYINT(1) DEFAULT 1,
                       CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
                       Phone VARCHAR(15),
                       Image VARCHAR(255),
                       UpdatedDate DATETIME NULL,
                       UpdatedBy INT NULL,
                       CONSTRAINT FK_Users_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES Users(UserId)
) ENGINE=InnoDB;

CREATE TABLE Roles (
                       RoleId INT AUTO_INCREMENT PRIMARY KEY,
                       RoleName VARCHAR(50) UNIQUE NOT NULL,
                       IsActive TINYINT(1) DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE UserRoles (
                           UserId INT NOT NULL,
                           RoleId INT NOT NULL,
                           PRIMARY KEY (UserId, RoleId),
                           CONSTRAINT FK_UserRoles_User FOREIGN KEY (UserId) REFERENCES Users(UserId),
                           CONSTRAINT FK_UserRoles_Role FOREIGN KEY (RoleId) REFERENCES Roles(RoleId)
) ENGINE=InnoDB;

/* =========================================================
1) RBAC: Permissions -> RolePermissions
========================================================= */
CREATE TABLE Permissions (
                             PermissionId INT AUTO_INCREMENT PRIMARY KEY,
                             PermissionCode VARCHAR(100) UNIQUE NOT NULL,
                             PermissionName VARCHAR(200) NOT NULL,
                             IsActive TINYINT(1) DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE RolePermissions (
                                 RoleId INT NOT NULL,
                                 PermissionId INT NOT NULL,
                                 PRIMARY KEY (RoleId, PermissionId),
                                 CONSTRAINT FK_RolePermissions_Role FOREIGN KEY (RoleId) REFERENCES Roles(RoleId),
                                 CONSTRAINT FK_RolePermissions_Permission FOREIGN KEY (PermissionId) REFERENCES Permissions(PermissionId)
) ENGINE=InnoDB;

/* =========================================================
2) Master data: Customers / Employees
========================================================= */
CREATE TABLE Customers (
                           CustomerId INT AUTO_INCREMENT PRIMARY KEY,
                           UserId INT UNIQUE NULL,
                           CustomerCode VARCHAR(50) UNIQUE NOT NULL,
                           CustomerName VARCHAR(200) NOT NULL,
                           Address VARCHAR(255) NULL,
                           ContactName VARCHAR(200) NULL,
                           ContactPhone VARCHAR(30) NULL,
                           ContactEmail VARCHAR(100) NULL,
                           IsActive TINYINT(1) DEFAULT 1,
                           CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
                           CONSTRAINT FK_Customers_User FOREIGN KEY (UserId) REFERENCES Users(UserId)
) ENGINE=InnoDB;

CREATE TABLE Employees (
                           EmployeeId INT AUTO_INCREMENT PRIMARY KEY,
                           UserId INT UNIQUE NOT NULL,
                           EmployeeCode VARCHAR(50) UNIQUE NOT NULL,
                           Department VARCHAR(100) NULL,
                           Title VARCHAR(100) NULL,
                           IsActive TINYINT(1) DEFAULT 1,
                           CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
                           CONSTRAINT FK_Employees_User FOREIGN KEY (UserId) REFERENCES Users(UserId)
) ENGINE=InnoDB;

/* =========================================================
3) Location: Warehouses / Sites
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
                       CONSTRAINT FK_Sites_Customer FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
) ENGINE=InnoDB;

/* =========================================================
4) Machines: Model + Unit(Serial) + History
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
                              CONSTRAINT FK_MachineUnits_Model FOREIGN KEY (ModelId) REFERENCES MachineModels(ModelId),
                              CONSTRAINT FK_MachineUnits_Warehouse FOREIGN KEY (CurrentWarehouseId) REFERENCES Warehouses(WarehouseId),
                              CONSTRAINT FK_MachineUnits_Site FOREIGN KEY (CurrentSiteId) REFERENCES Sites(SiteId),
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
                                        CONSTRAINT FK_MHist_Unit FOREIGN KEY (UnitId) REFERENCES MachineUnits(UnitId),
                                        CONSTRAINT FK_MHist_OldWH FOREIGN KEY (OldWarehouseId) REFERENCES Warehouses(WarehouseId),
                                        CONSTRAINT FK_MHist_NewWH FOREIGN KEY (NewWarehouseId) REFERENCES Warehouses(WarehouseId),
                                        CONSTRAINT FK_MHist_OldSite FOREIGN KEY (OldSiteId) REFERENCES Sites(SiteId),
                                        CONSTRAINT FK_MHist_NewSite FOREIGN KEY (NewSiteId) REFERENCES Sites(SiteId),
                                        CONSTRAINT FK_MHist_ChangedBy FOREIGN KEY (ChangedBy) REFERENCES Users(UserId),
                                        INDEX idx_mhist_unit (UnitId, ChangedDate)
) ENGINE=InnoDB;

/* =========================================================
5) Contracts + Items by Serial + Approvals + Status History
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
                           CONSTRAINT FK_Contracts_Customer FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
                           CONSTRAINT FK_Contracts_Site FOREIGN KEY (SiteId) REFERENCES Sites(SiteId),
                           CONSTRAINT FK_Contracts_SaleEmp FOREIGN KEY (SaleEmployeeId) REFERENCES Employees(EmployeeId),
                           CONSTRAINT FK_Contracts_ManagerEmp FOREIGN KEY (ManagerEmployeeId) REFERENCES Employees(EmployeeId),
                           CONSTRAINT FK_Contracts_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserId),
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
                               CONSTRAINT FK_CItems_Contract FOREIGN KEY (ContractId) REFERENCES Contracts(ContractId),
                               CONSTRAINT FK_CItems_Unit FOREIGN KEY (UnitId) REFERENCES MachineUnits(UnitId),
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
                                   CONSTRAINT FK_CAppr_Contract FOREIGN KEY (ContractId) REFERENCES Contracts(ContractId),
                                   CONSTRAINT FK_CAppr_ManagerEmp FOREIGN KEY (ManagerEmployeeId) REFERENCES Employees(EmployeeId),
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
                                         CONSTRAINT FK_CHist_Contract FOREIGN KEY (ContractId) REFERENCES Contracts(ContractId),
                                         CONSTRAINT FK_CHist_ChangedBy FOREIGN KEY (ChangedBy) REFERENCES Users(UserId),
                                         INDEX idx_chist_contract (ContractId, ChangedDate)
) ENGINE=InnoDB;

/* =========================================================
6) Stock Transactions + Items
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
                                   CONSTRAINT FK_ST_FromWH FOREIGN KEY (FromWarehouseId) REFERENCES Warehouses(WarehouseId),
                                   CONSTRAINT FK_ST_ToWH FOREIGN KEY (ToWarehouseId) REFERENCES Warehouses(WarehouseId),
                                   CONSTRAINT FK_ST_FromSite FOREIGN KEY (FromSiteId) REFERENCES Sites(SiteId),
                                   CONSTRAINT FK_ST_ToSite FOREIGN KEY (ToSiteId) REFERENCES Sites(SiteId),
                                   CONSTRAINT FK_ST_Contract FOREIGN KEY (RelatedContractId) REFERENCES Contracts(ContractId),
                                   CONSTRAINT FK_ST_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserId),
                                   INDEX idx_tx_type_date (TransactionType, TransactionDate)
) ENGINE=InnoDB;

CREATE TABLE StockTransactionItems (
                                       TransactionItemId INT AUTO_INCREMENT PRIMARY KEY,
                                       TransactionId INT NOT NULL,
                                       UnitId INT NOT NULL,
                                       CONSTRAINT FK_STI_Tx FOREIGN KEY (TransactionId) REFERENCES StockTransactions(TransactionId),
                                       CONSTRAINT FK_STI_Unit FOREIGN KEY (UnitId) REFERENCES MachineUnits(UnitId),
                                       UNIQUE KEY uq_tx_unit (TransactionId, UnitId),
                                       INDEX idx_txi_unit (UnitId)
) ENGINE=InnoDB;

/* =========================================================
7) Support Requests + Attachments + Notes + Escalations
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
                                 CONSTRAINT FK_SR_Customer FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
                                 CONSTRAINT FK_SR_Unit FOREIGN KEY (UnitId) REFERENCES MachineUnits(UnitId),
                                 CONSTRAINT FK_SR_Contract FOREIGN KEY (ContractId) REFERENCES Contracts(ContractId),
                                 CONSTRAINT FK_SR_Site FOREIGN KEY (SiteId) REFERENCES Sites(SiteId),
                                 CONSTRAINT FK_SR_Assignee FOREIGN KEY (AssignedToEmployeeId) REFERENCES Employees(EmployeeId),
                                 CONSTRAINT FK_SR_CreatedBy FOREIGN KEY (CreatedByUserId) REFERENCES Users(UserId),
                                 INDEX idx_req_status (Status),
                                 INDEX idx_req_customer (CustomerId),
                                 INDEX idx_req_assignee (AssignedToEmployeeId)
) ENGINE=InnoDB;

CREATE TABLE SupportAttachments (
                                    AttachmentId BIGINT AUTO_INCREMENT PRIMARY KEY,
                                    RequestId INT NOT NULL,
                                    FileUrl VARCHAR(500) NOT NULL,
                                    FileName VARCHAR(255) NULL,
                                    UploadedBy INT NULL,
                                    UploadedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
                                    CONSTRAINT FK_SA_Request FOREIGN KEY (RequestId) REFERENCES SupportRequests(RequestId),
                                    CONSTRAINT FK_SA_UploadedBy FOREIGN KEY (UploadedBy) REFERENCES Users(UserId),
                                    INDEX idx_att_req (RequestId, UploadedDate)
) ENGINE=InnoDB;

CREATE TABLE SupportNotes (
                              NoteId BIGINT AUTO_INCREMENT PRIMARY KEY,
                              RequestId INT NOT NULL,
                              NoteText TEXT NOT NULL,
                              CreatedBy INT NULL,
                              CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
                              CONSTRAINT FK_SN_Request FOREIGN KEY (RequestId) REFERENCES SupportRequests(RequestId),
                              CONSTRAINT FK_SN_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserId),
                              INDEX idx_note_req (RequestId, CreatedDate)
) ENGINE=InnoDB;

CREATE TABLE SupportEscalations (
                                    EscalationId BIGINT AUTO_INCREMENT PRIMARY KEY,
                                    RequestId INT NOT NULL,
                                    FromEmployeeId INT NULL,
                                    ToManagerEmployeeId INT NOT NULL,
                                    Reason VARCHAR(500) NULL,
                                    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
                                    CONSTRAINT FK_SE_Request FOREIGN KEY (RequestId) REFERENCES SupportRequests(RequestId),
                                    CONSTRAINT FK_SE_FromEmp FOREIGN KEY (FromEmployeeId) REFERENCES Employees(EmployeeId),
                                    CONSTRAINT FK_SE_ToMgrEmp FOREIGN KEY (ToManagerEmployeeId) REFERENCES Employees(EmployeeId),
                                    INDEX idx_esc_req (RequestId, CreatedDate)
) ENGINE=InnoDB;

/* =========================================================
8) Maintenance Tickets + Status History + Report
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
                                    CONSTRAINT FK_MT_Unit FOREIGN KEY (UnitId) REFERENCES MachineUnits(UnitId),
                                    CONSTRAINT FK_MT_Request FOREIGN KEY (RequestId) REFERENCES SupportRequests(RequestId),
                                    CONSTRAINT FK_MT_CreatedByEmp FOREIGN KEY (CreatedByEmployeeId) REFERENCES Employees(EmployeeId),
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
                                            CONSTRAINT FK_MTH_Ticket FOREIGN KEY (TicketId) REFERENCES MaintenanceTickets(TicketId),
                                            CONSTRAINT FK_MTH_ChangedByEmp FOREIGN KEY (ChangedByEmployeeId) REFERENCES Employees(EmployeeId),
                                            INDEX idx_mth_ticket (TicketId, ChangedDate)
) ENGINE=InnoDB;

CREATE TABLE TechnicalSupportReports (
                                         ReportId INT AUTO_INCREMENT PRIMARY KEY,
                                         TicketId INT NOT NULL,
                                         ReportUrl VARCHAR(500) NOT NULL,
                                         CreatedByEmployeeId INT NOT NULL,
                                         CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
                                         CONSTRAINT FK_TSR_Ticket FOREIGN KEY (TicketId) REFERENCES MaintenanceTickets(TicketId),
                                         CONSTRAINT FK_TSR_CreatedByEmp FOREIGN KEY (CreatedByEmployeeId) REFERENCES Employees(EmployeeId),
                                         INDEX idx_rep_ticket (TicketId, CreatedDate)
) ENGINE=InnoDB;

/* =========================================================
9) Notifications + Audit Logs
========================================================= */
CREATE TABLE Notifications (
                               NotificationId BIGINT AUTO_INCREMENT PRIMARY KEY,
                               ToUserId INT NOT NULL,
                               Title VARCHAR(200) NOT NULL,
                               Content TEXT NOT NULL,
                               IsRead TINYINT(1) DEFAULT 0,
                               SentBy INT NULL,
                               SentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
                               CONSTRAINT FK_Notify_ToUser FOREIGN KEY (ToUserId) REFERENCES Users(UserId),
                               CONSTRAINT FK_Notify_SentBy FOREIGN KEY (SentBy) REFERENCES Users(UserId),
                               INDEX idx_notify_user (ToUserId, IsRead, SentDate)
) ENGINE=InnoDB;

CREATE TABLE AuditLogs (
                           AuditId BIGINT AUTO_INCREMENT PRIMARY KEY,
                           UserId INT NULL,
                           Action VARCHAR(100) NOT NULL,
                           EntityName VARCHAR(100) NULL,
                           EntityId VARCHAR(50) NULL,
                           Detail TEXT NULL,
                           CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
                           CONSTRAINT FK_Audit_User FOREIGN KEY (UserId) REFERENCES Users(UserId),
                           INDEX idx_audit_user_date (UserId, CreatedDate)
) ENGINE=InnoDB;
