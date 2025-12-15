/* =========================================================
CMS - Machine Management - Contract Management
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
1) Master data: Customers
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




