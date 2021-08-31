package com.monitor.backend.data;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "city")
public class City {

    private String  _partitionKey;
    @Id
    private String  _id;
    private String  name;
    private String  cityId;
    private String  countryId;
    private String  provinceName;
    private Position  position;

    public City() {
    }

    public City(String _partitionKey, String _id, String name, String cityId, String countryId, String provinceName, Position position) {
        this._partitionKey = _partitionKey;
        this._id = _id;
        this.name = name;
        this.cityId = cityId;
        this.countryId = countryId;
        this.provinceName = provinceName;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCityId() {
        return cityId;
    }

    public void setCityId(String cityId) {
        this.cityId = cityId;
    }

    public String getCountryId() {
        return countryId;
    }

    public void setCountryId(String countryId) {
        this.countryId = countryId;
    }

    public String getProvinceName() {
        return provinceName;
    }

    public void setProvinceName(String provinceName) {
        this.provinceName = provinceName;
    }

    public Position getPosition() {
        return position;
    }

    public void setPosition(Position position) {
        this.position = position;
    }
}
