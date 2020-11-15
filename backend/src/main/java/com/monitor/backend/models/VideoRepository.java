package com.monitor.backend.models;

import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface VideoRepository extends PagingAndSortingRepository<Video, String> {

    List<Video> findByProjectId(String projectId);

}
