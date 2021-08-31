package com.monitor.backend.models;

import com.monitor.backend.data.FieldMonitorSchedule;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface FieldMonitorScheduleRepository extends PagingAndSortingRepository<FieldMonitorSchedule, String> {

    List<FieldMonitorSchedule> findByProjectId(String projectId);
    List<FieldMonitorSchedule> findByOrganizationId(String organizationId);
    List<FieldMonitorSchedule> findByFieldMonitorId(String userId);
    List<FieldMonitorSchedule> findByAdminId(String userId);

}
