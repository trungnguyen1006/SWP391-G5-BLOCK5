# Contract PDF Export Feature

**Status:** ✅ IMPLEMENTED

---

## Overview

Employees can now export contracts as PDF documents. The PDF includes all contract details, machine information, pricing, and deposit amounts.

---

## Implementation Details

### 1. Dependencies Added

**File:** `pom.xml`

Added iText 7 library for PDF generation:
```xml
<dependency>
    <groupId>com.itextpdf</groupId>
    <artifactId>itext7-core</artifactId>
    <version>7.2.5</version>
    <type>pom</type>
</dependency>
```

### 2. New Servlet

**File:** `src/main/java/controller/contract/ExportContractPdfServlet.java`

**URL Mapping:** `/employee/export-contract-pdf`

**Parameters:**
- `contractId` (required): The ID of the contract to export

**Functionality:**
- Validates user session (employee only)
- Retrieves contract details from database
- Generates PDF with Vietnamese formatting
- Returns PDF as downloadable file

**PDF Content:**
- Contract code and title
- Contract information (customer, site, dates, status)
- Machine list with details (serial number, model, brand, delivery date, return date, price, deposit)
- Total amounts (price and deposit)
- Notes (if any)
- Footer with disclaimer

### 3. Updated JSP

**File:** `src/main/webapp/employee/contract/view-contract-detail.jsp`

Added "Xuất PDF" (Export PDF) button in the Actions sidebar:
- Button appears at the top of the actions section
- Opens PDF in new tab/window
- Uses blue info button style

---

## Usage

1. Employee navigates to contract detail page
2. Clicks "Xuất PDF" button
3. PDF downloads automatically with filename: `Contract_[ContractCode].pdf`

---

## PDF Format

### Header
- Title: "HỢP ĐỒNG THUÊ MÁY" (Machine Rental Contract)
- Contract Code

### Contract Information Table
- Khách Hàng (Customer)
- Địa Điểm (Site)
- Ngày Bắt Đầu (Start Date)
- Ngày Kết Thúc (End Date)
- Trạng Thái (Status)
- Ngày Ký (Signed Date)

### Machine List Table
| Số Seri | Model | Thương Hiệu | Ngày Giao | Ngày Trả | Giá Thuê | Tiền Cọc |
|---------|-------|-------------|-----------|----------|----------|----------|
| Serial Number | Model Name | Brand | Delivery Date | Return Date | Price | Deposit |

**Total Row:** Shows sum of prices and deposits

### Additional Sections
- Notes (if present)
- Footer disclaimer

---

## Features

✅ Vietnamese language support
✅ Currency formatting (Vietnamese Dong - ₫)
✅ Professional table layout
✅ Automatic filename generation
✅ Session validation
✅ Error handling
✅ Responsive design

---

## Error Handling

- **No Contract ID:** Returns 400 Bad Request
- **Invalid Contract ID:** Returns 400 Bad Request
- **Contract Not Found:** Returns 404 Not Found
- **Not Logged In:** Redirects to login page
- **PDF Generation Error:** Returns 500 Internal Server Error

---

## Security

- ✅ Session validation required
- ✅ Only employees can access
- ✅ Contract ID validation
- ✅ No sensitive data exposure

---

## Files Modified

1. `pom.xml` - Added iText dependency
2. `src/main/java/controller/contract/ExportContractPdfServlet.java` - New servlet
3. `src/main/webapp/employee/contract/view-contract-detail.jsp` - Added export button

---

## Testing Checklist

- [ ] Employee can view contract detail page
- [ ] "Xuất PDF" button is visible
- [ ] Clicking button downloads PDF
- [ ] PDF filename is correct
- [ ] PDF contains all contract information
- [ ] PDF contains all machines
- [ ] Currency formatting is correct
- [ ] Vietnamese characters display correctly
- [ ] PDF opens in new tab/window
- [ ] Non-logged-in users cannot access
- [ ] Invalid contract ID shows error

---

## Future Enhancements

- Add company logo to PDF header
- Add digital signature support
- Add QR code for contract verification
- Add email delivery option
- Add batch export for multiple contracts
- Add custom template support
- Add watermark for draft contracts

