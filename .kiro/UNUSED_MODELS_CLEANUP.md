# Unused Models Cleanup

**Date:** December 17, 2025  
**Status:** ✅ COMPLETED

---

## Models Deleted

### 1. UserRoles.java
- **Location:** `src/main/java/model/UserRoles.java`
- **Reason:** Not imported or used anywhere in the codebase
- **Usage:** The UserRoles table is only accessed via SQL queries in `RoleDAO`, not through this model class
- **Status:** ✅ DELETED

### 2. ContractStatusHistory.java
- **Location:** `src/main/java/model/ContractStatusHistory.java`
- **Reason:** Not imported or used anywhere in the codebase
- **Status:** ✅ DELETED

---

## Models Retained

### Active Models (15 total)
1. **Contract.java** - Used in contract management
2. **ContractItem.java** - Used in contract items
3. **Customers.java** - Used in customer management (primary model)
4. **Customer.java** - Used as wrapper/converter in site management
5. **Dashboard.java** - Used in admin dashboard
6. **DashboardCustomer.java** - Used in customer dashboard
7. **DashboardSale.java** - Used in sales dashboard
8. **DashboardStaff.java** - Used in staff dashboard
9. **Employee.java** - Used in employee management
10. **MachineModel.java** - Used in machine model management
11. **MachineUnit.java** - Used in machine unit management
12. **Roles.java** - Used in role management
13. **Site.java** - Used in site management
14. **Users.java** - Used in user management
15. **Warehouse.java** - Used in warehouse management

---

## Compilation Status

✅ **Before Cleanup:** 0 errors (already fixed)  
✅ **After Cleanup:** 0 errors  
✅ **Build Status:** SUCCESS

---

## Notes

- The `Customer` model is still retained because it's used as a wrapper/converter in `AddSiteServlet` and `UpdateSiteServlet` to convert between `Customers` and `Customer` objects for the UI
- The `UserRoles` table is still used in the database, but the model class was unnecessary since the DAO directly queries the table
- All remaining models are actively used in the application

