package com.entity;

public class PatientVitals {
    private int id;
    private int admissionId;
    private String patientName;
    private int pulseRate;
    private String bloodPressure;
    private double temperatureF;
    private int spo2Percentage;
    private String triageStatus; // STABLE, WARNING, CRITICAL
    private String recordedAt;

    public PatientVitals() {}

    public PatientVitals(int admissionId, String patientName, int pulseRate, String bloodPressure, double temperatureF, int spo2Percentage, String triageStatus) {
        this.admissionId = admissionId;
        this.patientName = patientName;
        this.pulseRate = pulseRate;
        this.bloodPressure = bloodPressure;
        this.temperatureF = temperatureF;
        this.spo2Percentage = spo2Percentage;
        this.triageStatus = triageStatus;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getAdmissionId() { return admissionId; }
    public void setAdmissionId(int admissionId) { this.admissionId = admissionId; }
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public int getPulseRate() { return pulseRate; }
    public void setPulseRate(int pulseRate) { this.pulseRate = pulseRate; }
    public String getBloodPressure() { return bloodPressure; }
    public void setBloodPressure(String bloodPressure) { this.bloodPressure = bloodPressure; }
    public double getTemperatureF() { return temperatureF; }
    public void setTemperatureF(double temperatureF) { this.temperatureF = temperatureF; }
    public int getSpo2Percentage() { return spo2Percentage; }
    public void setSpo2Percentage(int spo2Percentage) { this.spo2Percentage = spo2Percentage; }
    public String getTriageStatus() { return triageStatus; }
    public void setTriageStatus(String triageStatus) { this.triageStatus = triageStatus; }
    public String getRecordedAt() { return recordedAt; }
    public void setRecordedAt(String recordedAt) { this.recordedAt = recordedAt; }
}
