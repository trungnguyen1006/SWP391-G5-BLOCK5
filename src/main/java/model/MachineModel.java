package model;

import java.time.LocalDateTime;

public class MachineModel {
    private int modelId;
    private String modelCode;
    private String modelName;
    private String brand;
    private String category;
    private String specs;
    private boolean active;
    private LocalDateTime createdDate;

    public MachineModel() {}

    public MachineModel(int modelId, String modelCode, String modelName, String brand, String category, String specs, boolean active, LocalDateTime createdDate) {
        this.modelId = modelId;
        this.modelCode = modelCode;
        this.modelName = modelName;
        this.brand = brand;
        this.category = category;
        this.specs = specs;
        this.active = active;
        this.createdDate = createdDate;
    }

    // Getters and Setters
    public int getModelId() {
        return modelId;
    }

    public void setModelId(int modelId) {
        this.modelId = modelId;
    }

    public String getModelCode() {
        return modelCode;
    }

    public void setModelCode(String modelCode) {
        this.modelCode = modelCode;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSpecs() {
        return specs;
    }

    public void setSpecs(String specs) {
        this.specs = specs;
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
}