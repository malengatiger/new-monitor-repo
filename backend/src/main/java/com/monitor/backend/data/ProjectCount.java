package com.monitor.backend.data;

public class ProjectCount {
    /*
    data class UserCount(var userId: String,  var photos: Int = 0, var videos: Int = 0, var projects:Int = 0) {
}

     */
    private String projectId;
    private int photos;
    private int videos;
    private int projects;

    public ProjectCount() {
    }

    public ProjectCount(String projectId, int photos, int videos, int projects) {
        this.projectId = projectId;
        this.photos = photos;
        this.videos = videos;
        this.projects = projects;
    }

    public String getProjectId() {
        return projectId;
    }

    public void setProjectId(String projectId) {
        this.projectId = projectId;
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
