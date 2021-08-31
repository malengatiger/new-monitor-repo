package com.monitor.backend.models;

import com.monitor.backend.data.City;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Point;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface CityRepository extends PagingAndSortingRepository<City, String> {

    List<City> findByPositionNear(Point location, Distance distance);
}
