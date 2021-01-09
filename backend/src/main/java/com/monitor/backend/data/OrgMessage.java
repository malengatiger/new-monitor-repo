package com.monitor.backend.data;

public class OrgMessage {
    private String organizationId, projectId, userId, message, created, fcmRegistration;
    private String projectName, adminId, adminName;
    private String frequency, result, name;

    public OrgMessage() {
    }

    public OrgMessage(String organizationId, String projectId, String userId, String message, String created, String fcmRegistration, String projectName,
                      String adminId, String adminName, String frequency, String name) {
        this.organizationId = organizationId;
        this.projectId = projectId;
        this.userId = userId;
        this.message = message;
        this.created = created;
        this.fcmRegistration = fcmRegistration;
        this.projectName = projectName;
        this.adminId = adminId;
        this.adminName = adminName;
        this.frequency = frequency;
        this.name = name;

    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public String getAdminId() {
        return adminId;
    }

    public void setAdminId(String adminId) {
        this.adminId = adminId;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public String getFcmRegistration() {
        return fcmRegistration;
    }

    public void setFcmRegistration(String fcmRegistration) {
        this.fcmRegistration = fcmRegistration;
    }

    public String getProjectId() {
        return projectId;
    }

    public void setProjectId(String projectId) {
        this.projectId = projectId;
    }

    public String getOrganizationId() {
        return organizationId;
    }

    public void setOrganizationId(String organizationId) {
        this.organizationId = organizationId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }
}
