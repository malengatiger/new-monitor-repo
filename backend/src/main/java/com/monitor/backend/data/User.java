package com.monitor.backend.data;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "user")
public class User {
    String _partitionKey;
    @Id
    String _id;
    String name, gender;
    String email;
    String cellphone;
    String userId;
    String organizationId;
    String organizationName;
    String created, fcmRegistration;
    String userType;
    String password;
    Position position;

    public User() {
    }

    public User(String name, String email, String cellphone, String userId,
                String organizationId, String organizationName, String created,
                String fcmRegistration, String userType, String password, Position position, String gender) {
        this.name = name;
        this.email = email;
        this.cellphone = cellphone;
        this.userId = userId;
        this.organizationId = organizationId;
        this.organizationName = organizationName;
        this.created = created;
        this.fcmRegistration = fcmRegistration;
        this.userType = userType;
        this.password = password;
        this.position = position;
        this.gender = gender;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Position getPosition() {
        return position;
    }

    public void setPosition(Position position) {
        this.position = position;
    }

    public String getFcmRegistration() {
        return fcmRegistration;
    }

    public void setFcmRegistration(String fcmRegistration) {
        this.fcmRegistration = fcmRegistration;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCellphone() {
        return cellphone;
    }

    public void setCellphone(String cellphone) {
        this.cellphone = cellphone;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getOrganizationId() {
        return organizationId;
    }

    public void setOrganizationId(String organizationId) {
        this.organizationId = organizationId;
    }

    public String getOrganizationName() {
        return organizationName;
    }

    public void setOrganizationName(String organizationName) {
        this.organizationName = organizationName;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
