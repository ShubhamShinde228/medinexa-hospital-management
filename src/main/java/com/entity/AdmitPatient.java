package com.entity;

public class AdmitPatient {
    private int id;
    private String name;
    private String disease;
    private String address;
    private String admittedDate;
    private String dischargeDate;
    private double payment;
    private int doctorId;
    private String roomNumber;
    private String patientStatus;

    public AdmitPatient() {}

    public AdmitPatient(int id, String name, String disease, String address, String admittedDate, String dischargeDate, double payment) {
        this.id = id;
        this.name = name;
        this.disease = disease;
        this.address = address;
        this.admittedDate = admittedDate;
        this.dischargeDate = dischargeDate;
        this.payment = payment;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDisease() { return disease; }
    public void setDisease(String disease) { this.disease = disease; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getAdmittedDate() { return admittedDate; }
    public void setAdmittedDate(String admittedDate) { this.admittedDate = admittedDate; }
    public String getDischargeDate() { return dischargeDate; }
    public void setDischargeDate(String dischargeDate) { this.dischargeDate = dischargeDate; }
    public double getPayment() { return payment; }
    public void setPayment(double payment) { this.payment = payment; }
    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }
    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
    public String getPatientStatus() { return patientStatus; }
    public void setPatientStatus(String patientStatus) { this.patientStatus = patientStatus; }

    public void setSpecialist(String specialist) {
        // Stub for backward compatibility
    }
}