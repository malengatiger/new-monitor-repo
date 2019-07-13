package com.monitorz.webapi.data.repositories;

import com.monitorz.webapi.data.City;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CityRepository extends MongoRepository<City, String> {

    List<City> findByCountryId(String countryId);
    @Query(value = "{\"position\":\n" +
            "       { $nearSphere :\n" +
            "          {\n" +
            "            $geometry : {\n" +
            "               type : \"Point\" ,\n" +
            "               coordinates : [ ?0, ?1] },\n" +
            "               $maxDistance: ?2" +
            "          }\n" +
            "       }}")
    List<City> findByLocation(double longitude, double latitude, int radiusInKM);

    List<City> findByPosition(double longitude, double latitude, int radiusInKM);
}

/*
var METERS_PER_MILE = 1609.34
db.restaurants.find({ location: { $nearSphere: { $geometry: { type: "Point", coordinates: [ -73.93414657, 40.82302903 ] }, $maxDistance: 5 * METERS_PER_MILE } } })
 */
