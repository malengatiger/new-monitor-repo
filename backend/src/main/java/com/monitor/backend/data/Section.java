package com.monitor.backend.data;

import java.util.List;

public class Section {
    private int  sectionNumber;
    private String  title, sectionId;
    private String  description;
    private List<Question> questions;

    public Section() {
    }

    public Section(String sectionId, int sectionNumber, String title, String description, List<Question> questions) {
        this.sectionNumber = sectionNumber;
        this.title = title;
        this.description = description;
        this.questions = questions;
    }

    public String getSectionId() {
        return sectionId;
    }

    public void setSectionId(String sectionId) {
        this.sectionId = sectionId;
    }

    public int getSectionNumber() {
        return sectionNumber;
    }

    public void setSectionNumber(int sectionNumber) {
        this.sectionNumber = sectionNumber;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Question> getQuestions() {
        return questions;
    }

    public void setQuestions(List<Question> questions) {
        this.questions = questions;
    }
}
