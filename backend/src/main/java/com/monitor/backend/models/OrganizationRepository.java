package com.monitor.backend.models;

import com.monitor.backend.data.Organization;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface OrganizationRepository extends PagingAndSortingRepository<Organization, String> {

    List<Organization> findByCountryId(String countryId);

}
