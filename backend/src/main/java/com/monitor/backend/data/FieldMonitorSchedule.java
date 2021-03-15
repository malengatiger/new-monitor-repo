package com.monitor.backend.data;

public class FieldMonitorSchedule {
    private String adminId, projectId, fieldMonitorScheduleId,
            date, organizationId, fieldMonitorId;
    private String projectName, organizationName;
    private int perDay, perWeek, perMonth;

    public String getFieldMonitorScheduleId() {
        return fieldMonitorScheduleId;
    }

    public void setFieldMonitorScheduleId(String fieldMonitorScheduleId) {
        this.fieldMonitorScheduleId = fieldMonitorScheduleId;
    }

    public String getFieldMonitorId() {
        return fieldMonitorId;
    }

    public void setFieldMonitorId(String fieldMonitorId) {
        this.fieldMonitorId = fieldMonitorId;
    }

    public String getOrganizationId() {
        return organizationId;
    }

    public void setOrganizationId(String organizationId) {
        this.organizationId = organizationId;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public String getOrganizationName() {
        return organizationName;
    }

    public void setOrganizationName(String organizationName) {
        this.organizationName = organizationName;
    }

    public FieldMonitorSchedule() {
    }


    public String getAdminId() {
        return adminId;
    }

    public void setAdminId(String adminId) {
        this.adminId = adminId;
    }

    public String getProjectId() {
        return projectId;
    }

    public void setProjectId(String projectId) {
        this.projectId = projectId;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getPerDay() {
        return perDay;
    }

    public void setPerDay(int perDay) {
        this.perDay = perDay;
    }

    public int getPerWeek() {
        return perWeek;
    }

    public void setPerWeek(int perWeek) {
        this.perWeek = perWeek;
    }

    public int getPerMonth() {
        return perMonth;
    }

    public void setPerMonth(int perMonth) {
        this.perMonth = perMonth;
    }
}
