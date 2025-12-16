/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Administrator
 */
public class DashboardSale {
    private int totalContractsSigned;
    private int totalCustomers;
    private double totalRevenue;
    private int totalTickets;

    public DashboardSale(int totalContractsSigned, int totalCustomers, double totalRevenue, int totalTickets) {
        this.totalContractsSigned = totalContractsSigned;
        this.totalCustomers = totalCustomers;
        this.totalRevenue = totalRevenue;
        this.totalTickets = totalTickets;
    }

    public DashboardSale() {
    }

    public int getTotalContractsSigned() {
        return totalContractsSigned;
    }

    public void setTotalContractsSigned(int totalContractsSigned) {
        this.totalContractsSigned = totalContractsSigned;
    }

    public int getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public int getTotalTickets() {
        return totalTickets;
    }

    public void setTotalTickets(int totalTickets) {
        this.totalTickets = totalTickets;
    }

}