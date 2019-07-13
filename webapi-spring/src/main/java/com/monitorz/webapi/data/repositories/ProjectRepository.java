package com.monitorz.webapi.data.repositories;

import com.monitorz.webapi.data.Project;
import org.springframework.data.mongodb.repository.MongoRepository;

import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProjectRepository extends MongoRepository<Project, String> {

    @Query(value = "{\"mainPosition\":\n" +
            "       { $nearSphere :\n" +
            "          {\n" +
            "            $geometry : {\n" +
            "               type : \"Point\" ,\n" +
            "               coordinates : [ ?0, ?1] },\n" +
            "               $maxDistance: ?2" +
            "          }\n" +
            "       }}")
    public List<Project> findByLocation(double longitude, double latitude, int radiusInKM);
}
