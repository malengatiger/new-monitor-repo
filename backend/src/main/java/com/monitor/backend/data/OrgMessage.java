package com.monitor.backend.data;

public class OrgMessage {
    private String organizationId, userId, message, created;

    public OrgMessage() {
    }

    public OrgMessage(String organizationId, String userId, String message, String created) {
        this.organizationId = organizationId;
        this.userId = userId;
        this.message = message;
        this.created = created;
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
