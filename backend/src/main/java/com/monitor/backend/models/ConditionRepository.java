package com.monitor.backend.models;

import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Point;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface ConditionRepository extends PagingAndSortingRepository<Condition, String> {

    List<Condition> findByProjectId(String projectId);

}
