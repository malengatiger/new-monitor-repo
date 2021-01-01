package com.monitor.backend.models;

import com.monitor.backend.data.ProjectPosition;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Point;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface ProjectPositionRepository extends PagingAndSortingRepository<ProjectPosition, String> {

    List<ProjectPosition> findByPositionNear(Point location, Distance distance);
    List<ProjectPosition> findByProjectId(String projectId);

}
