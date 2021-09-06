package com.monitor.backend.data;

import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "projectPosition")
public class ProjectPosition {

    private String projectId, projectPositionId;
    private Position position;
    private String projectName;
    private String caption;
    private String created;
    private Placemark placemark;
    private List<City> nearestCities;


    public ProjectPosition(String projectPositionId, String projectId, Position position, String projectName, String caption, String created, Placemark placemark, List<City> nearestCities) {
        this.projectId = projectId;
        this.projectPositionId = projectPositionId;
        this.position = position;
        this.projectName = projectName;
        this.caption = caption;
        this.created = created;
        this.placemark = placemark;
        this.nearestCities = nearestCities;
    }

    public ProjectPosition() {
    }

    public String getProjectPositionId() {
        return projectPositionId;
    }

    public void setProjectPositionId(String projectPositionId) {
        this.projectPositionId = projectPositionId;
    }

    public List<City> getNearestCities() {
        return nearestCities;
    }

    public void setNearestCities(List<City> nearestCities) {
        this.nearestCities = nearestCities;
    }

    public Placemark getPlacemark() {
        return placemark;
    }

    public void setPlacemark(Placemark placemark) {
        this.placemark = placemark;
    }

    public String getProjectId() {
        return projectId;
    }

    public void setProjectId(String projectId) {
        this.projectId = projectId;
    }

    public Position getPosition() {
        return position;
    }

    public void setPosition(Position position) {
        this.position = position;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }
}
