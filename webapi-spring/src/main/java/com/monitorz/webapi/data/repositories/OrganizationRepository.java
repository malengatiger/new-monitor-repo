package com.monitorz.webapi.data.repositories;

import com.monitorz.webapi.data.Organization;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrganizationRepository extends MongoRepository<Organization, String> {

    List<Organization> findByCountryId(String countryId);
}
