package com.monitor.backend.models;

import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface PhotoRepository extends PagingAndSortingRepository<Photo, String> {

    List<Photo> findByProjectId(String projectId);

}