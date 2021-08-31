package com.monitor.backend.data;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

/*
data class Organization(String _partitionKey;
                        @Id String _id;
                        String name;
                        String countryName;
                        String countryId;
                        String organizationId;
                        String created;
 */
@Document(collection = "organizations")
public class Organization {
  private String _partitionKey;
    @Id
   private  String _id;
    private  String name;
    private String countryName;
    private String countryId;
    private String organizationId;
    private String created;

    public Organization(String _partitionKey, String _id, String name, String countryName, String countryId, String organizationId, String created) {
        this._partitionKey = _partitionKey;
        this._id = _id;
        this.name = name;
        this.countryName = countryName;
        this.countryId = countryId;
        this.organizationId = organizationId;
        this.created = created;
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

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getCountryId() {
        return countryId;
    }

    public void setCountryId(String countryId) {
        this.countryId = countryId;
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
}
