package com.monitorz.webapi.data;

import java.util.List;

public class Answer {
    private String text, aNumber, created;
    private List<Content> photoUrls, videoUrls;
    private Respondent respondent;

    public Respondent getRespondent() {
        return respondent;
    }

    public void setRespondent(Respondent respondent) {
        this.respondent = respondent;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getaNumber() {
        return aNumber;
    }

    public void setaNumber(String aNumber) {
        this.aNumber = aNumber;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
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
}
