package com.monitor.backend.data;

import org.springframework.data.annotation.Id;

import java.util.List;

public class Question {
    /*

     */
    private String _partitionKey;
    @Id
    private String _id;
    private String text;
    private List<Answer> answers;
    private String questionType;
    private List<String> choices;

    public Question() {
    }

    public Question(String _partitionKey, String _id, String text, List<Answer> answers, String questionType, List<String> choices) {
        this._partitionKey = _partitionKey;
        this._id = _id;
        this.text = text;
        this.answers = answers;
        this.questionType = questionType;
        this.choices = choices;
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

    public List<Answer> getAnswers() {
        return answers;
    }

    public void setAnswers(List<Answer> answers) {
        this.answers = answers;
    }

    public String getQuestionType() {
        return questionType;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public List<String> getChoices() {
        return choices;
    }

    public void setChoices(List<String> choices) {
        this.choices = choices;
    }
}
