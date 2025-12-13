package model;

import java.time.LocalDateTime;

public class MachineUnit {
    private int unitId;
    private int modelId;
    private String serialNumber;
    private String currentStatus;
    private Integer currentWarehouseId;
    private Integer currentSiteId;
    private boolean active;
    private LocalDateTime createdDate;
    
    // Additional fields for display
    private MachineModel machineModel;
    private String warehouseName;
    private String siteName;

    public MachineUnit() {}

    public MachineUnit(int unitId, int modelId, String serialNumber, String currentStatus, 
                      Integer currentWarehouseId, Integer currentSiteId, boolean active, LocalDateTime createdDate) {
        this.unitId = unitId;
        this.modelId = modelId;
        this.serialNumber = serialNumber;
        this.currentStatus = currentStatus;
        this.currentWarehouseId = currentWarehouseId;
        this.currentSiteId = currentSiteId;
        this.active = active;
        this.createdDate = createdDate;
    }

    // Getters and Setters
    public int getUnitId() {
        return unitId;
    }

    public void setUnitId(int unitId) {
        this.unitId = unitId;
    }

    public int getModelId() {
        return modelId;
    }

    public void setModelId(int modelId) {
        this.modelId = modelId;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public String getCurrentStatus() {
        return currentStatus;
    }

    public void setCurrentStatus(String currentStatus) {
        this.currentStatus = currentStatus;
    }

    public Integer getCurrentWarehouseId() {
        return currentWarehouseId;
    }

    public void setCurrentWarehouseId(Integer currentWarehouseId) {
        this.currentWarehouseId = currentWarehouseId;
    }

    public Integer getCurrentSiteId() {
        return currentSiteId;
    }

    public void setCurrentSiteId(Integer currentSiteId) {
        this.currentSiteId = currentSiteId;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public MachineModel getMachineModel() {
        return machineModel;
    }

    public void setMachineModel(MachineModel machineModel) {
        this.machineModel = machineModel;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public String getSiteName() {
        return siteName;
    }

    public void setSiteName(String siteName) {
        this.siteName = siteName;
    }
}