package com.monitor.backend.data;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "questionnaire")
public class Questionnaire {

    private String _partitionKey;
    @Id
    private String _id;
    private String organizationId;
    private String created;
    private String questionnaireId;
    private String title;
    private String projectId;
    private String description;
    private List<Section> sections;

    public Questionnaire() {
    }

    public Questionnaire(String _partitionKey, String _id, String organizationId, String created, String questionnaireId, String title, String projectId, String description, List<Section> sections) {
        this._partitionKey = _partitionKey;
        this._id = _id;
        this.organizationId = organizationId;
        this.created = created;
        this.questionnaireId = questionnaireId;
        this.title = title;
        this.projectId = projectId;
        this.description = description;
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

    public String getOrganizationId() {
        return organizationId;
    }

    public void setOrganizationId(String organizationId) {
        this.organizationId = organizationId;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }

    public String getQuestionnaireId() {
        return questionnaireId;
    }

    public void setQuestionnaireId(String questionnaireId) {
        this.questionnaireId = questionnaireId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getProjectId() {
        return projectId;
    }

    public void setProjectId(String projectId) {
        this.projectId = projectId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Section> getSections() {
        return sections;
    }

    public void setSections(List<Section> sections) {
        this.sections = sections;
    }
}
