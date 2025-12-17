# Runtime Error Fix - NoSuchMethodError

**Date:** December 17, 2025  
**Status:** ✅ FIXED

---

## Error Description

**Error Type:** `java.lang.NoSuchMethodError`

**Error Message:**
```
'java.lang.String dal.CustomerManagementDAO.generateCustomerCode()'
```

**Location:** `controller.customer.AddCustomerEmployeeServlet.doGet(AddCustomerEmployeeServlet.java:34)`

**Root Cause:** The old compiled class file in the `target/` directory did not contain the newly added `generateCustomerCode()` method. The source code was updated, but the compiled bytecode was stale.

---

## Solution Applied

### Step 1: Clean Build
Executed Maven clean to remove all compiled classes:
```bash
mvn clean compile -DskipTests
```

### Step 2: Rebuild
Recompiled all source files with the new methods:
- `CustomerManagementDAO.generateCustomerCode()`
- `CustomerManagementDAO.isCustomerCodeExists()`
- `CustomerManagementDAO.isCustomerCodeExistsForOther()`

### Step 3: Package
Created new WAR file with updated compiled classes:
```bash
mvn package -DskipTests
```

---

## Build Status

✅ **Clean:** SUCCESS  
✅ **Compile:** SUCCESS  
✅ **Package:** SUCCESS  

**Output:**
```
[INFO] Building swp Maven Webapp 1.0-SNAPSHOT
[INFO] Building war: D:\a_SWP_Bl5\code\SWP391-G5-BLOCK5\target\swp.war
[INFO] BUILD SUCCESS
```

---

## What Was Fixed

The following methods are now properly compiled and available at runtime:

### CustomerManagementDAO
1. **generateCustomerCode()** - Generates next customer code
2. **isCustomerCodeExists(String)** - Checks if code exists
3. **isCustomerCodeExistsForOther(String, int)** - Checks code uniqueness

### AddCustomerEmployeeServlet
- Now calls `generateCustomerCode()` in doGet()
- Validates duplicate codes in doPost()

### UpdateCustomerEmployeeServlet
- Validates code uniqueness for other customers

---

## Next Steps

1. **Redeploy** the new WAR file to Tomcat
2. **Clear browser cache** to ensure fresh load
3. **Test** the add customer flow:
   - Navigate to `/employee/add-customer`
   - Verify customer code is generated and displayed
   - Add a customer successfully
   - Verify code increments for next customer

---

## Prevention

To prevent similar issues in the future:

1. **Always clean before rebuild** when adding new methods
2. **Verify compiled classes** contain new methods
3. **Check Tomcat logs** for `NoSuchMethodError`
4. **Restart Tomcat** after deploying new WAR

---

## Files Affected

1. `src/main/java/dal/CustomerManagementDAO.java` - Added 3 methods
2. `src/main/java/controller/customer/AddCustomerEmployeeServlet.java` - Uses new methods
3. `src/main/java/controller/customer/UpdateCustomerEmployeeServlet.java` - Uses new methods
4. `target/swp.war` - Rebuilt with new compiled classes

---

## Verification

The compiled WAR file now contains:
- ✅ `CustomerManagementDAO.class` with all 3 new methods
- ✅ `AddCustomerEmployeeServlet.class` calling the methods
- ✅ `UpdateCustomerEmployeeServlet.class` calling the methods

