package com.monitor.backend.models;

import com.monitor.backend.data.MonitorReport;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Point;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface MonitorReportRepository extends PagingAndSortingRepository<MonitorReport, String> {

    List<MonitorReport> findByPositionNear(Point location, Distance distance);
    List<MonitorReport> findByProjectId(String projectId);

}
