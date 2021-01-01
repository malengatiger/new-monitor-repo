package com.monitor.backend.data;

public class Type {
    public static final String FIELD_MONITOR = "FIELD_MONITOR";
    public static final String ORG_ADMINISTRATOR = "ORG_ADMINISTRATOR";
    public static final String ORG_EXECUTIVE = "FIELD_MONITOR";
    public static final String NETWORK_ADMINISTRATOR = "NETWORK_ADMINISTRATOR";

    public enum Rating {
        EXCELLENT, GOOD, AVERAGE, BAD, TERRIBLE
    }
    public enum UserType {
        ORG_ADMINISTRATOR, OFFICIAL, EXECUTIVE, FIELD_MONITOR, ORGANIZATION_USER, NETWORK_ADMINISTRATOR
    }
    public enum QuestionType {
        SINGLE_ANSWER, MULTIPLE_CHOICE, SINGLE_CHOICE, OPTIONAL
    }

}
