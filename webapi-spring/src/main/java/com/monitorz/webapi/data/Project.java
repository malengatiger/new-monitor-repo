package com.monitorz.webapi.data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Data;

import java.util.List;

@Data
@Document(collection = "projects")
public class Project {
    @Id
    private String id;
    private String projectId;
    private String name, description, organizationId, created;
    String organizationName;
    List<City> nearestCities;
    List<Position> positions;
    List<Content> photoUrls, videoUrls;
    List<RatingContent> ratings;
    List<Settlement> settlements;
    Position mainPosition;

    public Position getMainPosition() {
        return mainPosition;
    }

    public void setMainPosition(Position mainPosition) {
        this.mainPosition = mainPosition;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getOrganizationId() {
        return organizationId;
    }

    public void setOrganizationId(String organizationId) {
        this.organizationId = organizationId;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }

    public String getOrganizationName() {
        return organizationName;
    }

    public void setOrganizationName(String organizationName) {
        this.organizationName = organizationName;
    }

    public List<City> getNearestCities() {
        return nearestCities;
    }

    public void setNearestCities(List<City> nearestCities) {
        this.nearestCities = nearestCities;
    }

    public List<Position> getPositions() {
        return positions;
    }

    public void setPositions(List<Position> positions) {
        this.positions = positions;
    }

    public List<Content> getPhotoUrls() {
        return photoUrls;
    }

    public void setPhotoUrls(List<Content> photoUrls) {
        this.photoUrls = photoUrls;
    }

    public List<Content> getVideoUrls() {
        return videoUrls;
    }

    public void setVideoUrls(List<Content> videoUrls) {
        this.videoUrls = videoUrls;
    }

    public List<RatingContent> getRatings() {
        return ratings;
    }

    public void setRatings(List<RatingContent> ratings) {
        this.ratings = ratings;
    }

    public List<Settlement> getSettlements() {
        return settlements;
    }

    public void setSettlements(List<Settlement> settlements) {
        this.settlements = settlements;
    }
}
