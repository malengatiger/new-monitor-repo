package com.monitor.backend.models;

import com.monitor.backend.data.GeofenceEvent;
import com.monitor.backend.data.Project;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;


public interface GeofenceEventRepository extends PagingAndSortingRepository<GeofenceEvent, String> {

    List<GeofenceEvent> findByProjectPositionId(String projectPositionId);
    List<GeofenceEvent> findByUserId(String userId);

}
