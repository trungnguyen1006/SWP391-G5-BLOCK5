/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Administrator
 */
public class DashboardStaff {
    private int totalTickets;
    private int approvedTickets;
    private int rejectedTickets;
    private int assignedTickets;

    public DashboardStaff() {
    }

    public DashboardStaff(int totalTickets, int approvedTickets, int rejectedTickets, int assignedTickets) {
        this.totalTickets = totalTickets;
        this.approvedTickets = approvedTickets;
        this.rejectedTickets = rejectedTickets;
        this.assignedTickets = assignedTickets;
    }

    public int getTotalTickets() {
        return totalTickets;
    }

    public void setTotalTickets(int totalTickets) {
        this.totalTickets = totalTickets;
    }

    public int getApprovedTickets() {
        return approvedTickets;
    }

    public void setApprovedTickets(int approvedTickets) {
        this.approvedTickets = approvedTickets;
    }

    public int getRejectedTickets() {
        return rejectedTickets;
    }

    public void setRejectedTickets(int rejectedTickets) {
        this.rejectedTickets = rejectedTickets;
    }

    public int getAssignedTickets() {
        return assignedTickets;
    }

    public void setAssignedTickets(int assignedTickets) {
        this.assignedTickets = assignedTickets;
    }
    
}