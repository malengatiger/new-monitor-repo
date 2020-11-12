package com.monitor.backend.models;

import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface CommunityRepository extends PagingAndSortingRepository<Community, String> {

    List<Community> findByCountryId(String countryId);
}
