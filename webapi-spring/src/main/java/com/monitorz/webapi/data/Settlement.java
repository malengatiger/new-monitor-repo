package com.monitorz.webapi.data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Data;

import java.util.List;

@Data
@Document(collection = "settlements")
public class Settlement {
    @Id
    private String id;
    private String settlementId;
    private String name, countryId, email, countryName, created;
    private List<Population> population;
    private List<Position> polygon;
    private List<Content> photoUrls, videoUrls;
    private List<RatingContent> ratings;
    private List<City> nearestCities;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSettlementId() {
        return settlementId;
    }

    public void setSettlementId(String settlementId) {
        this.settlementId = settlementId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCountryId() {
        return countryId;
    }

    public void setCountryId(String countryId) {
        this.countryId = countryId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }

    public List<Population> getPopulation() {
        return population;
    }

    public void setPopulation(List<Population> population) {
        this.population = population;
    }

    public List<Position> getPolygon() {
        return polygon;
    }

    public void setPolygon(List<Position> polygon) {
        this.polygon = polygon;
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

    public List<City> getNearestCities() {
        return nearestCities;
    }

    public void setNearestCities(List<City> nearestCities) {
        this.nearestCities = nearestCities;
    }
}
