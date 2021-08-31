package com.monitor.backend.data;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "videos")
public class Video {
    private String  _partitionKey;
    @Id
    private String  _id;
    private String  projectId;
    private String  projectName;
    private String  videoId;
    private String  organizationId;
    private Position  projectPosition;
    private double  distanceFromProjectPosition;
    private String  url;
    private String  thumbnailUrl;
    private String  caption;
    private String  userId;
    private String  userName;
    private String  created;

    public Video() {
    }

    public Video(String _partitionKey, String _id, String projectId, String projectName, String videoId, String organizationId, Position projectPosition, double distanceFromProjectPosition, String url, String thumbnailUrl, String caption, String userId, String userName, String created) {
        this._partitionKey = _partitionKey;
        this._id = _id;
        this.projectId = projectId;
        this.projectName = projectName;
        this.videoId = videoId;
        this.organizationId = organizationId;
        this.projectPosition = projectPosition;
        this.distanceFromProjectPosition = distanceFromProjectPosition;
        this.url = url;
        this.thumbnailUrl = thumbnailUrl;
        this.caption = caption;
        this.userId = userId;
        this.userName = userName;
        this.created = created;
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

    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public String getOrganizationId() {
        return organizationId;
    }

    public void setOrganizationId(String organizationId) {
        this.organizationId = organizationId;
    }

    public Position getProjectPosition() {
        return projectPosition;
    }

    public void setProjectPosition(Position projectPosition) {
        this.projectPosition = projectPosition;
    }

    public double getDistanceFromProjectPosition() {
        return distanceFromProjectPosition;
    }

    public void setDistanceFromProjectPosition(double distanceFromProjectPosition) {
        this.distanceFromProjectPosition = distanceFromProjectPosition;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
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
