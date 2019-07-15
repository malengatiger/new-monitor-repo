package com.monitorz.webapi.data.repositories;

import com.monitorz.webapi.data.Organization;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrganizationRepository extends ReactiveMongoRepository<Organization, String> {

    List<Organization> findByCountryId(String countryId);
}
