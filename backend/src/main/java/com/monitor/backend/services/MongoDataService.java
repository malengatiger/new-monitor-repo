package com.monitor.backend.services;

import com.monitor.backend.data.City;
import com.monitor.backend.models.CityRepository;
import com.monitor.backend.utils.Emoji;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.GeoResult;
import org.springframework.data.geo.GeoResults;
import org.springframework.data.geo.Point;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;


@Service
public class MongoDataService {
    private static final Logger LOGGER = Logger.getLogger(MongoDataService.class.getSimpleName());

    @Autowired
    CityRepository cityRepository;

    public List<City> getCities() {
        return (List<City>) cityRepository.findAll();
    }

    public List<City> getCitiesByLocation(Point location, Distance distance) {
        GeoResults<City> cities = cityRepository.findByPositionNear(location,distance);
        LOGGER.info(Emoji.DICE + "Found " + cities.getContent().size()
                + " cities by location; radiusInKM = " + distance.getValue());
        List<City> list = new ArrayList<>();
        for (GeoResult<City> city : cities) {
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + city.getContent().getName() + ", " + city.getContent().getProvinceName() + " "
                    + Emoji.COFFEE);
            list.add(city.getContent());
        }
        return list;
    }
}
