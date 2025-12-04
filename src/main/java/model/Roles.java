package model;

public class Roles {
    private int roleId;
    private String roleName;
    private boolean isActive;

    public Roles() {}

    public Roles(int roleId, String roleName, boolean isActive) {
        this.roleId = roleId;
        this.roleName = roleName;
        this.isActive = isActive;
    }

    // GETTER - SETTER
    public int getRoleId() {
        return roleId;
    }
    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }
    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public boolean isActive() {
        return isActive;
    }
    public void setActive(boolean active) {
        isActive = active;
    }
}
