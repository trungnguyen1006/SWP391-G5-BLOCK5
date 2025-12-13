/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Administrator
 */
public class Dashboard {
    private int totalUser;
    private int totalEmployee;
    private int totalActive;
    private int totalDeActive;

    public Dashboard() {
    }
    
    public Dashboard(int totalUser, int totalEmployee, int totalActive, int totalDeActive) {
        this.totalUser = totalUser;
        this.totalEmployee = totalEmployee;
        this.totalActive = totalActive;
        this.totalDeActive = totalDeActive;
    }

    public int getTotalUser() {
        return totalUser;
    }

    public void setTotalUser(int totalUser) {
        this.totalUser = totalUser;
    }

    public int getTotalEmployee() {
        return totalEmployee;
    }

    public void setTotalEmployee(int totalEmployee) {
        this.totalEmployee = totalEmployee;
    }

    public int getTotalActive() {
        return totalActive;
    }

    public void setTotalActive(int totalActive) {
        this.totalActive = totalActive;
    }

    public int getTotalDeActive() {
        return totalDeActive;
    }

    public void setTotalDeActive(int totalDeActive) {
        this.totalDeActive = totalDeActive;
    }
    
    
    
    
}
