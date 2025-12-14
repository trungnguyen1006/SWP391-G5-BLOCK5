package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class Contract {
    private int contractId;
    private String contractCode;
    private int customerId;
    private Integer siteId;
    private Integer saleEmployeeId;
    private Integer managerEmployeeId;
    private LocalDate signedDate;
    private LocalDate startDate;
    private LocalDate endDate;
    private String status;
    private String note;
    private int createdBy;
    private LocalDateTime createdDate;
    
    // Additional fields for display
    private String customerName;
    private String siteName;
    private String saleEmployeeName;
    private String managerEmployeeName;
    private List<ContractItem> contractItems;
    private BigDecimal totalAmount;
    private BigDecimal totalDeposit;

    public Contract() {}

    // Getters and Setters
    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public String getContractCode() {
        return contractCode;
    }

    public void setContractCode(String contractCode) {
        this.contractCode = contractCode;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public Integer getSiteId() {
        return siteId;
    }

    public void setSiteId(Integer siteId) {
        this.siteId = siteId;
    }

    public Integer getSaleEmployeeId() {
        return saleEmployeeId;
    }

    public void setSaleEmployeeId(Integer saleEmployeeId) {
        this.saleEmployeeId = saleEmployeeId;
    }

    public Integer getManagerEmployeeId() {
        return managerEmployeeId;
    }

    public void setManagerEmployeeId(Integer managerEmployeeId) {
        this.managerEmployeeId = managerEmployeeId;
    }

    public LocalDate getSignedDate() {
        return signedDate;
    }

    public void setSignedDate(LocalDate signedDate) {
        this.signedDate = signedDate;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
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

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getSiteName() {
        return siteName;
    }

    public void setSiteName(String siteName) {
        this.siteName = siteName;
    }

    public String getSaleEmployeeName() {
        return saleEmployeeName;
    }

    public void setSaleEmployeeName(String saleEmployeeName) {
        this.saleEmployeeName = saleEmployeeName;
    }

    public String getManagerEmployeeName() {
        return managerEmployeeName;
    }

    public void setManagerEmployeeName(String managerEmployeeName) {
        this.managerEmployeeName = managerEmployeeName;
    }

    public List<ContractItem> getContractItems() {
        return contractItems;
    }

    public void setContractItems(List<ContractItem> contractItems) {
        this.contractItems = contractItems;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getTotalDeposit() {
        return totalDeposit;
    }

    public void setTotalDeposit(BigDecimal totalDeposit) {
        this.totalDeposit = totalDeposit;
    }
}