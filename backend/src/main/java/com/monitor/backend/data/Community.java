package com.monitor.backend.data;

import org.springframework.data.annotation.Id;

import java.util.List;

public class Community {
    /*

     */
    private String _partitionKey;
    @Id
    private String _id;
    private String name;
    private String communityId;
    private String countryId;
    private int population;
    private String countryName;
    private List<Position> polygon;
    private List<Photo> photos;
    private List<Video> videos;
    private List<City> nearestCities;

    public Community() {
    }

    public Community(String _partitionKey, String _id, String name, String communityId, String countryId, int population, String countryName, List<Position> polygon, List<Photo> photos, List<Video> videos, List<City> nearestCities) {
        this._partitionKey = _partitionKey;
        this._id = _id;
        this.name = name;
        this.communityId = communityId;
        this.countryId = countryId;
        this.population = population;
        this.countryName = countryName;
        this.polygon = polygon;
        this.photos = photos;
        this.videos = videos;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCommunityId() {
        return communityId;
    }

    public void setCommunityId(String communityId) {
        this.communityId = communityId;
    }

    public String getCountryId() {
        return countryId;
    }

    public void setCountryId(String countryId) {
        this.countryId = countryId;
    }

    public int getPopulation() {
        return population;
    }

    public void setPopulation(int population) {
        this.population = population;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public List<Position> getPolygon() {
        return polygon;
    }

    public void setPolygon(List<Position> polygon) {
        this.polygon = polygon;
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

    public List<City> getNearestCities() {
        return nearestCities;
    }

    public void setNearestCities(List<City> nearestCities) {
        this.nearestCities = nearestCities;
    }
}
