package com.monitor.backend.data;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "answers")
public class Answer {
    /*

     */
    private String _partitionKey;
    @Id
    private String _id;
    private String text;
    private double number;
    private List<String> photoUrls;
    private List<String> videoUrls;

    public Answer() {
    }

    public Answer(String _partitionKey, String _id, String text, double number, List<String> photoUrls, List<String> videoUrls) {
        this._partitionKey = _partitionKey;
        this._id = _id;
        this.text = text;
        this.number = number;
        this.photoUrls = photoUrls;
        this.videoUrls = videoUrls;
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

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public double getNumber() {
        return number;
    }

    public void setNumber(double number) {
        this.number = number;
    }

    public List<String> getPhotoUrls() {
        return photoUrls;
    }

    public void setPhotoUrls(List<String> photoUrls) {
        this.photoUrls = photoUrls;
    }

    public List<String> getVideoUrls() {
        return videoUrls;
    }

    public void setVideoUrls(List<String> videoUrls) {
        this.videoUrls = videoUrls;
    }
}
