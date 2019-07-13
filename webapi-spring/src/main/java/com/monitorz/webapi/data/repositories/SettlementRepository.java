package com.monitorz.webapi.data.repositories;

import com.monitorz.webapi.data.Settlement;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository

public interface SettlementRepository extends MongoRepository<Settlement, String> {

    @Query(value = "{\"position\":\n" +
            "       { $nearSphere :\n" +
            "          {\n" +
            "            $geometry : {\n" +
            "               type : \"Point\" ,\n" +
            "               coordinates : [ ?0, ?1] },\n" +
            "               $maxDistance: ?2" +
            "          }\n" +
            "       }}")
    List<Settlement> findByLocation(double longitude, double latitude, int radiusInKM);

    List<Settlement> findSettlementsByCountryId(String countryId);
}
