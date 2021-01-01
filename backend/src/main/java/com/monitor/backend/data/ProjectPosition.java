package com.monitor.backend.data;

public class ProjectPosition {

    private String projectId;
    private Position position;
    private String projectName;
    private String caption;
    private String created;

    public ProjectPosition() {
    }

    public ProjectPosition(String projectId, Position position, String projectName, String caption, String created) {
        this.projectId = projectId;
        this.position = position;
        this.projectName = projectName;
        this.caption = caption;
        this.created = created;
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
