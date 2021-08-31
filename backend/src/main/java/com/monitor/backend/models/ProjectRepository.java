package com.monitor.backend.models;

import com.monitor.backend.data.Project;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Point;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;


public interface ProjectRepository extends PagingAndSortingRepository<com.monitor.backend.data.Project, String> {

    List<com.monitor.backend.data.Project> findByPositionNear(Point location, Distance distance);
    List<com.monitor.backend.data.Project> findByOrganizationId(String organizationId);
    Project findByProjectId(String projectId);

}
