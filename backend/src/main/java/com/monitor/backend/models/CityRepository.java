package com.monitor.backend.models;

import com.monitor.backend.models.City;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Point;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface CityRepository extends PagingAndSortingRepository<City, String> {

//    List<City> findByLocation(double latitude, double longitude, double radiusInKM);
// { 'location' : { '$near' : [point.x, point.y], '$maxDistance' : distance}}
    List<City> findByPositionNear(Point location, Distance distance);
}
