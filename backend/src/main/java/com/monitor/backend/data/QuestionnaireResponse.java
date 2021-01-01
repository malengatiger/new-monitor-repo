package com.monitor.backend.data;

import org.springframework.data.annotation.Id;

import java.util.List;

public class QuestionnaireResponse {
    /*
    private String  _partitionKey;
                                 @Id private String  _id; 
                                 private String  questionnaireResponseId; 
                                 private String  questionnaireId;
                                 private User  user;
                                 private List<Section>  sections;
     */
    private String  _partitionKey;
    @Id
    private String  _id;
    private String  questionnaireResponseId;
    private String  questionnaireId;
    private User  user;
    private List<Section> sections;

    public QuestionnaireResponse() {
    }

    public QuestionnaireResponse(String _partitionKey, String _id, String questionnaireResponseId, String questionnaireId, User user, List<Section> sections) {
        this._partitionKey = _partitionKey;
        this._id = _id;
        this.questionnaireResponseId = questionnaireResponseId;
        this.questionnaireId = questionnaireId;
        this.user = user;
        this.sections = sections;
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

    public String getQuestionnaireResponseId() {
        return questionnaireResponseId;
    }

    public void setQuestionnaireResponseId(String questionnaireResponseId) {
        this.questionnaireResponseId = questionnaireResponseId;
    }

    public String getQuestionnaireId() {
        return questionnaireId;
    }

    public void setQuestionnaireId(String questionnaireId) {
        this.questionnaireId = questionnaireId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<Section> getSections() {
        return sections;
    }

    public void setSections(List<Section> sections) {
        this.sections = sections;
    }
}
