package com.monitor.backend.data;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "project")
public class Project {
    String _partitionKey;
    @Id
    String _id;
    String projectId;
    String name;
    String organizationId;
    String description;
    String organizationName;
    double monitorMaxDistanceInMetres;
    String created;
    List<City> nearestCities;

    public Project() {
    }

    public Project(String _partitionKey, String _id, String projectId, String name, String organizationId, String description, String organizationName, double monitorMaxDistanceInMetres, String created, List<City> nearestCities) {
        this._partitionKey = _partitionKey;
        this._id = _id;
        this.projectId = projectId;
        this.name = name;
        this.organizationId = organizationId;
        this.description = description;
        this.organizationName = organizationName;
        this.monitorMaxDistanceInMetres = monitorMaxDistanceInMetres;
        this.created = created;
        this.nearestCities = nearestCities;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getOrganizationId() {
        return organizationId;
    }

    public void setOrganizationId(String organizationId) {
        this.organizationId = organizationId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getOrganizationName() {
        return organizationName;
    }

    public void setOrganizationName(String organizationName) {
        this.organizationName = organizationName;
    }

    public double getMonitorMaxDistanceInMetres() {
        return monitorMaxDistanceInMetres;
    }

    public void setMonitorMaxDistanceInMetres(double monitorMaxDistanceInMetres) {
        this.monitorMaxDistanceInMetres = monitorMaxDistanceInMetres;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }

    public List<City> getNearestCities() {
        return nearestCities;
    }

    public void setNearestCities(List<City> nearestCities) {
        this.nearestCities = nearestCities;
    }

}
