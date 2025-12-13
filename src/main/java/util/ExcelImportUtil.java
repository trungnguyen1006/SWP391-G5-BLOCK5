package util;

import model.MachineUnit;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class ExcelImportUtil {

    public static List<MachineUnit> importMachinesFromExcel(InputStream inputStream) throws IOException {
        List<MachineUnit> units = new ArrayList<>();
        
        try (Workbook workbook = new XSSFWorkbook(inputStream)) {
            Sheet sheet = workbook.getSheetAt(0);
            
            // Skip header row (row 0)
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                
                try {
                    MachineUnit unit = new MachineUnit();
                    
                    // Column 0: Model ID
                    Cell modelIdCell = row.getCell(0);
                    if (modelIdCell != null && modelIdCell.getCellType() == CellType.NUMERIC) {
                        unit.setModelId((int) modelIdCell.getNumericCellValue());
                    } else {
                        continue; // Skip row if no model ID
                    }
                    
                    // Column 1: Serial Number
                    Cell serialCell = row.getCell(1);
                    if (serialCell != null) {
                        String serialNumber = getCellValueAsString(serialCell);
                        if (serialNumber != null && !serialNumber.trim().isEmpty()) {
                            unit.setSerialNumber(serialNumber.trim());
                        } else {
                            continue; // Skip row if no serial number
                        }
                    } else {
                        continue;
                    }
                    
                    // Column 2: Status (optional, default to IN_STOCK)
                    Cell statusCell = row.getCell(2);
                    if (statusCell != null) {
                        String status = getCellValueAsString(statusCell);
                        unit.setCurrentStatus(status != null && !status.trim().isEmpty() ? status.trim() : "IN_STOCK");
                    } else {
                        unit.setCurrentStatus("IN_STOCK");
                    }
                    
                    // Column 3: Warehouse ID (optional)
                    Cell warehouseCell = row.getCell(3);
                    if (warehouseCell != null && warehouseCell.getCellType() == CellType.NUMERIC) {
                        unit.setCurrentWarehouseId((int) warehouseCell.getNumericCellValue());
                    }
                    
                    unit.setActive(true);
                    units.add(unit);
                    
                } catch (Exception e) {
                    // Skip invalid rows
                    System.err.println("Error processing row " + (i + 1) + ": " + e.getMessage());
                }
            }
        }
        
        return units;
    }
    
    private static String getCellValueAsString(Cell cell) {
        if (cell == null) return null;
        
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue().toString();
                } else {
                    // Convert numeric to string, remove decimal if it's a whole number
                    double numValue = cell.getNumericCellValue();
                    if (numValue == (long) numValue) {
                        return String.valueOf((long) numValue);
                    } else {
                        return String.valueOf(numValue);
                    }
                }
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                return cell.getCellFormula();
            default:
                return null;
        }
    }
}