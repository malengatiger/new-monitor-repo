package com.monitor.backend.models;

import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Point;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface ProjectRepository extends PagingAndSortingRepository<Project, String> {

    List<Project> findByPositionNear(Point location, Distance distance);
    List<Project> findByOrganizationId(String organizationId);
    Project findByProjectId(String projectId);

}
