package com.monitor.backend.data;

public class CustomErrorResponse {
    int statusCode;
    String message, date;

    public CustomErrorResponse(int statusCode, String message, String date) {
        this.statusCode = statusCode;
        this.message = message;
        this.date = date;
    }

    public CustomErrorResponse() {
    }

    public int getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(int statusCode) {
        this.statusCode = statusCode;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
}
