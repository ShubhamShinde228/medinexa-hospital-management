package com.entity;

public class Notification {
    private int id;
    private String targetRole;  // ADMIN, DOCTOR, STAFF, USER
    private int targetId;
    private String message;
    private String link;
    private boolean isRead;
    private String createdAt;

    public Notification() {}

    public Notification(String targetRole, int targetId, String message, String link) {
        this.targetRole = targetRole;
        this.targetId = targetId;
        this.message = message;
        this.link = link;
        this.isRead = false;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTargetRole() { return targetRole; }
    public void setTargetRole(String targetRole) { this.targetRole = targetRole; }

    public int getTargetId() { return targetId; }
    public void setTargetId(int targetId) { this.targetId = targetId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getLink() { return link; }
    public void setLink(String link) { this.link = link; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
