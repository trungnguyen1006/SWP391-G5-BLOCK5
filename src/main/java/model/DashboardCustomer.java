/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Administrator
 */
public class DashboardCustomer {

    private int totalContractsSigned;
    private int totalTickets;
    private int totalApprovedTickets;
    private int totalRejectedTickets;

    public DashboardCustomer() {
    }

    public int getTotalContractsSigned() {
        return totalContractsSigned;
    }

    public void setTotalContractsSigned(int totalContractsSigned) {
        this.totalContractsSigned = totalContractsSigned;
    }

    public int getTotalTickets() {
        return totalTickets;
    }

    public void setTotalTickets(int totalTickets) {
        this.totalTickets = totalTickets;
    }

    public int getTotalApprovedTickets() {
        return totalApprovedTickets;
    }

    public void setTotalApprovedTickets(int totalApprovedTickets) {
        this.totalApprovedTickets = totalApprovedTickets;
    }

    public int getTotalRejectedTickets() {
        return totalRejectedTickets;
    }

    public void setTotalRejectedTickets(int totalRejectedTickets) {
        this.totalRejectedTickets = totalRejectedTickets;
    }
}

