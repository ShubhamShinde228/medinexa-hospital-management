package com.entity;

public class MedicalStaff {
    private int id;
    private String fullName;
    private String email;
    private String password;
    private String licenseNo;

    public MedicalStaff() {}

    public MedicalStaff(int id, String fullName, String email, String password, String licenseNo) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.licenseNo = licenseNo;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getLicenseNo() { return licenseNo; }
    public void setLicenseNo(String licenseNo) { this.licenseNo = licenseNo; }
}
