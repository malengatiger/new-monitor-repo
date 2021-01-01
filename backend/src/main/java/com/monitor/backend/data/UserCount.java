package com.monitor.backend.data;

public class UserCount {
    /*
    data class UserCount(var userId: String,  var photos: Int = 0, var videos: Int = 0, var projects:Int = 0) {
}

     */
    private String userId;
    private int photos;
    private int videos;
    private int projects;

    public UserCount() {
    }

    public UserCount(String userId, int photos, int videos, int projects) {
        this.userId = userId;
        this.photos = photos;
        this.videos = videos;
        this.projects = projects;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public int getPhotos() {
        return photos;
    }

    public void setPhotos(int photos) {
        this.photos = photos;
    }

    public int getVideos() {
        return videos;
    }

    public void setVideos(int videos) {
        this.videos = videos;
    }

    public int getProjects() {
        return projects;
    }

    public void setProjects(int projects) {
        this.projects = projects;
    }
}
