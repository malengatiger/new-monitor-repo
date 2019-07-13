package com.monitorz.webapi.controllers;

import com.monitorz.webapi.data.City;
import com.monitorz.webapi.data.repositories.CityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicLong;
import java.util.logging.Level;
import java.util.logging.Logger;


@RestController
public class CityController {

    static final Logger LOG = Logger.getLogger(CityController.class.getSimpleName());
    static final Locale loc = Locale.getDefault();
    static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX", loc);
    private final AtomicLong counter = new AtomicLong();


    @Autowired
    private CityRepository repository;
    @Autowired
    private  MongoTemplate mongoTemplate;

    @RequestMapping("/getCityById")
    public City getCityById(@RequestParam(value = "id") String id) {

        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E returning city object \uD83C\uDF4E \uD83C\uDF4E "
                + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        Optional<City> city = repository.findById(id);

        return  city.get();
    }
    @RequestMapping("/findCitiesByCountry")
    public List<City> findCitiesByCountry(@RequestParam(value = "countryId") String countryId) {

        long num = counter.incrementAndGet();
        List<City> cities = repository.findByCountryId(countryId);
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E returning cities: "+cities.size()+"  \uD83C\uDF4E \uD83C\uDF4E "
                + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        return  cities;
    }
    int cnt = 0;
    @RequestMapping("/findCitiesByLocation")
    public List<City> findCitiesByLocation(@RequestParam(value = "latitude") double latitude, @RequestParam(value = "longitude") double longitude,
                                           @RequestParam(value = "radiusInKM") int radiusInKM) {
        int rad = radiusInKM * 1000;
        List<City> cities = repository.findByLocation(longitude,latitude,rad);
        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E findCitiesByLocation: returning cities: "+cities.size()+ " radius: " + radiusInKM + " kilometres  \uD83C\uDF4E \uD83C\uDF4E "
                + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        cnt = 0;
        cities.forEach((city) -> {
            cnt++;
            LOG.log(Level.INFO, "\uD83E\uDD6C\uD83E\uDD6C #" + cnt + " " + city.getName() + ", \uD83E\uDDE9 " + city.getProvinceName());
        });
        return  cities;
    }

    @PostMapping(value = "/addCity")
    @ResponseStatus(code = HttpStatus.CREATED)
    public City add(@RequestBody City city) {
        City c = repository.save(city);
        c.setCityId(c.getId());
        c = repository.save(city);
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E addCountry: country added  \uD83D\uDD35  \uD83D\uDC99"
                + c.getName() + " \uD83D\uDC99  " + c.getProvinceName() + " \uD83D\uDC99  \uD83D\uDD35 " + counter.incrementAndGet()
                + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return c;
    }
    @GetMapping(value = "/getAllCities")
    public List<City> getAll() {
        List<City> list = repository.findAll();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E getAllCities: found  \uD83D\uDD35 " + list.size()
                + " \uD83D\uDD35 " + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return list;
    }


    @PutMapping(value = "/updateCity")
    public City update(@PathVariable String id, @RequestBody City city) throws Exception {
        City c = repository.findById(id)
                .orElseThrow(() -> new Exception());
        c.setName(city.getName());
        c.setPosition(city.getPosition());
        c.setProvinceName(city.getProvinceName());
        return repository.save(c);
    }
}
