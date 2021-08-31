package com.monitor.backend.data;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "condition")
public class Condition {
    private String _partitionKey;
    @Id
    private String _id;
    private String projectId, organizationId;
    private String projectName;
    private Position projectPosition;
    private int rating;
    private String caption;
    private String userId;
    private String userName;
    private String created;

    public Condition() {
    }

    public Condition(String _partitionKey, String _id, String organizationId, String projectId, String projectName, Position projectPosition, int rating, String caption, String userId,
                     String userName, String created) {
        this._partitionKey = _partitionKey;
        this._id = _id;
        this.projectId = projectId;
        this.projectName = projectName;
        this.projectPosition = projectPosition;
        this.rating = rating;
        this.caption = caption;
        this.userId = userId;
        this.userName = userName;
        this.created = created;
        this.organizationId = organizationId;
    }

    public String getOrganizationId() {
        return organizationId;
    }

    public void setOrganizationId(String organizationId) {
        this.organizationId = organizationId;
    }

    public String get_partitionKey() {
        return _partitionKey;
    }

    public void set_partitionKey(String _partitionKey) {
        this._partitionKey = _partitionKey;
    }

    public String get_id() {
        return _id;
    }

    public void set_id(String _id) {
        this._id = _id;
    }

    public String getProjectId() {
        return projectId;
    }

    public void setProjectId(String projectId) {
        this.projectId = projectId;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public Position getProjectPosition() {
        return projectPosition;
    }

    public void setProjectPosition(Position projectPosition) {
        this.projectPosition = projectPosition;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }
}
