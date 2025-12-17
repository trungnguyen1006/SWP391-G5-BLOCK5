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

public class MaintenanceLog {

    private int logId;
    private int requestId;
    private String status;
    private String note;
    private int updatedBy;
    private Date updatedDate;

    public MaintenanceLog() {
    }

    public MaintenanceLog(int logId, int requestId, String status, String note, int updatedBy, Date updatedDate) {
        this.logId = logId;
        this.requestId = requestId;
        this.status = status;
        this.note = note;
        this.updatedBy = updatedBy;
        this.updatedDate = updatedDate;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public int getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(int updatedBy) {
        this.updatedBy = updatedBy;
    }

    public Date getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Date updatedDate) {
        this.updatedDate = updatedDate;
    }
    

}