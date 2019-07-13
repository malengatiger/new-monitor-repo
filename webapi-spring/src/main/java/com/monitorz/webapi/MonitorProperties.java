package com.monitorz.webapi;

import org.springframework.boot.context.properties.ConfigurationProperties;

/*
spring.application.name=Spring Boot for Monitor Web API
spring.data.mongodb.uri=mongodb+srv://aubs:aubrey3@ar001-1xhdt.mongodb.net/monitordb?retryWrites=true
spring.data.mongodb.database=monitordb

 */
@ConfigurationProperties("monitor")
public class MonitorProperties {
    private String appName, databaseUri, databaseName;

    public String getAppName() {
        return appName;
    }

    public void setAppName(String appName) {
        this.appName = appName;
    }

    public String getDatabaseUri() {
        return databaseUri;
    }

    public void setDatabaseUri(String databaseUri) {
        this.databaseUri = databaseUri;
    }

    public String getDatabaseName() {
        return databaseName;
    }

    public void setDatabaseName(String databaseName) {
        this.databaseName = databaseName;
    }
}
