package com.monitor.backend.models;

import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface UserRepository extends PagingAndSortingRepository<User, String> {

    User findByEmail(String email);
    List<User> findByOrganizationId(String organizationId);
}
