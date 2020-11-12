package com.monitor.backend.services;

import com.monitor.backend.models.City;
import com.monitor.backend.models.CityRepository;
import com.monitor.backend.utils.Emoji;
import com.monitor.backend.utils.MongoGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Point;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.logging.Logger;

/*

MongoClientURI uri = new MongoClientURI(
    "mongodb+srv://aubrey:<password>@monitorcluster.nnqij.mongodb.net/<dbname>?retryWrites=true&w=majority");

MongoClient mongoClient = new MongoClient(uri);
MongoDatabase database = mongoClient.getDatabase("test");

 */
@Service
public class MongoDataService {
    private static final Logger LOGGER = Logger.getLogger(MongoGenerator.class.getSimpleName());

    @Value("${mongo}")
    private String mongo;

    @Autowired
    CityRepository cityRepository;

    public List<City> getCities() {
        return (List<City>) cityRepository.findAll();
    }
    public List<City> getCitiesByLocation(Point location, Distance distance) {
        List<City> list = cityRepository.findByPositionNear(location,distance);
        LOGGER.info(Emoji.DICE + "Found " + list.size()
                + " cities by location; radiusInKM = " + distance.getValue());
        return list;
    }
}
