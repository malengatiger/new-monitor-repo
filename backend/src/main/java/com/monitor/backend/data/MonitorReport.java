package com.monitor.backend.data;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

/*

 */
@Document(collection = "monitorReport")
public class MonitorReport {
    private String  _partitionKey;
    @Id
    private String  _id;
    private String  monitorReportId;
    private String  projectId;
    private User  user;
    private String rating;
    private List<Photo> photos;
    private List<Video>  videos;
    private String  description;
    private String  created;
    private Position  position;

    public MonitorReport() {
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

    public String getMonitorReportId() {
        return monitorReportId;
    }

    public void setMonitorReportId(String monitorReportId) {
        this.monitorReportId = monitorReportId;
    }

    public String getProjectId() {
        return projectId;
    }

    public void setProjectId(String projectId) {
        this.projectId = projectId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getRating() {
        return rating;
    }

    public void setRating(String rating) {
        this.rating = rating;
    }

    public List<Photo> getPhotos() {
        return photos;
    }

    public void setPhotos(List<Photo> photos) {
        this.photos = photos;
    }

    public List<Video> getVideos() {
        return videos;
    }

    public void setVideos(List<Video> videos) {
        this.videos = videos;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }

    public Position getPosition() {
        return position;
    }

    public void setPosition(Position position) {
        this.position = position;
    }
}
