package com.monitor.backend.data;

import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "geofenceEvent")
public class GeofenceEvent {

       private String status, geofenceEventId, date, projectPositionId, projectName, userId;
       private User user;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getGeofenceEventId() {
        return geofenceEventId;
    }

    public void setGeofenceEventId(String geofenceEventId) {
        this.geofenceEventId = geofenceEventId;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getProjectPositionId() {
        return projectPositionId;
    }

    public void setProjectPositionId(String projectPositionId) {
        this.projectPositionId = projectPositionId;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
