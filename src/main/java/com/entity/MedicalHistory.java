package com.entity;

public class MedicalHistory {
    private int id;
    private int userId;
    private String patientName;
    private int appointmentId;
    private int admissionId;
    private String eventType;   // APPOINTMENT, ADMISSION, PRESCRIPTION, LAB, DISCHARGE, PAYMENT, NOTE
    private String description;
    private String eventDate;

    public MedicalHistory() {}

    public MedicalHistory(int userId, String patientName, int appointmentId, int admissionId,
                          String eventType, String description) {
        this.userId = userId;
        this.patientName = patientName;
        this.appointmentId = appointmentId;
        this.admissionId = admissionId;
        this.eventType = eventType;
        this.description = description;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public int getAdmissionId() { return admissionId; }
    public void setAdmissionId(int admissionId) { this.admissionId = admissionId; }

    public String getEventType() { return eventType; }
    public void setEventType(String eventType) { this.eventType = eventType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getEventDate() { return eventDate; }
    public void setEventDate(String eventDate) { this.eventDate = eventDate; }
}
