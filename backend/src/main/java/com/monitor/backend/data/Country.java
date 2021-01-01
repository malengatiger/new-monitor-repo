package com.monitor.backend.data;

import org.springframework.data.annotation.Id;

public class Country {
    private String _partitionKey;
    @Id
    private String _id;
    private String  countryId;
    private String name;
    private String countryCode;
    private Position position;

    public Country() {
    }

    public Country(String _partitionKey, String _id, String countryId, String name, String countryCode, Position position) {
        this._partitionKey = _partitionKey;
        this._id = _id;
        this.countryId = countryId;
        this.name = name;
        this.countryCode = countryCode;
        this.position = position;
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

    public String getCountryId() {
        return countryId;
    }

    public void setCountryId(String countryId) {
        this.countryId = countryId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public Position getPosition() {
        return position;
    }

    public void setPosition(Position position) {
        this.position = position;
    }
}
