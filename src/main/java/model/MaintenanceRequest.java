/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
/**
 *
 * @author Administrator
 */
import java.util.Date;

public class MaintenanceRequest {

    private int requestId;
    private String requestCode;
    private String requestType;
    private int customerId;
    private Integer contractId;
    private int unitId;
    private String title;
    private String description;
    private String status;
    private int createdBy;
    private Integer approvedBy;
    private Date approvedDate;
    private Date completedDate;
    private Date createdDate;
    private boolean isDelete;

    public MaintenanceRequest(int requestId, String requestCode, String requestType, int customerId, Integer contractId, int unitId, String title, String description, String status, int createdBy, Integer approvedBy, Date approvedDate, Date completedDate, Date createdDate, boolean isDelete) {
        this.requestId = requestId;
        this.requestCode = requestCode;
        this.requestType = requestType;
        this.customerId = customerId;
        this.contractId = contractId;
        this.unitId = unitId;
        this.title = title;
        this.description = description;
        this.status = status;
        this.createdBy = createdBy;
        this.approvedBy = approvedBy;
        this.approvedDate = approvedDate;
        this.completedDate = completedDate;
        this.createdDate = createdDate;
        this.isDelete = isDelete;
    }

    public MaintenanceRequest() {
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public String getRequestCode() {
        return requestCode;
    }

    public void setRequestCode(String requestCode) {
        this.requestCode = requestCode;
    }

    public String getRequestType() {
        return requestType;
    }

    public void setRequestType(String requestType) {
        this.requestType = requestType;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public Integer getContractId() {
        return contractId;
    }

    public void setContractId(Integer contractId) {
        this.contractId = contractId;
    }

    public int getUnitId() {
        return unitId;
    }

    public void setUnitId(int unitId) {
        this.unitId = unitId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    public Date getApprovedDate() {
        return approvedDate;
    }

    public void setApprovedDate(Date approvedDate) {
        this.approvedDate = approvedDate;
    }

    public Date getCompletedDate() {
        return completedDate;
    }

    public void setCompletedDate(Date completedDate) {
        this.completedDate = completedDate;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public boolean isIsDelete() {
        return isDelete;
    }

    public void setIsDelete(boolean isDelete) {
        this.isDelete = isDelete;
    }

}
