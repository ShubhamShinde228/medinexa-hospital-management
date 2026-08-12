package com.entity;

public class DoctorSlot {
    private int id;
    private int doctorId;
    private String slotDate;
    private String slotTime;
    private boolean isBooked;
    private int appointmentId;
    private String createdAt;

    // Doctor name for display (joined)
    private String doctorName;

    public DoctorSlot() {}

    public DoctorSlot(int doctorId, String slotDate, String slotTime) {
        this.doctorId = doctorId;
        this.slotDate = slotDate;
        this.slotTime = slotTime;
        this.isBooked = false;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public String getSlotDate() { return slotDate; }
    public void setSlotDate(String slotDate) { this.slotDate = slotDate; }

    public String getSlotTime() { return slotTime; }
    public void setSlotTime(String slotTime) { this.slotTime = slotTime; }

    public boolean isBooked() { return isBooked; }
    public void setBooked(boolean booked) { isBooked = booked; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }
}
