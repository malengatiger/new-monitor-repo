package com.monitorz.webapi.controllers;

import com.monitorz.webapi.data.Country;
import com.monitorz.webapi.data.repositories.CountryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.atomic.AtomicLong;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;


@RestController
public class CountryController {

    static final Logger LOG = Logger.getLogger(CountryController.class.getSimpleName());
    static final Locale loc = Locale.getDefault();
    static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX", loc);
    private final AtomicLong counter = new AtomicLong();
    @Autowired
    private CountryRepository repository;

    @RequestMapping("/getCountryById")
    public Country getCountryById(@RequestParam(value = "id") String id) {
        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E returning country object all \uD83D\uDD35 JSONifified: \uD83C\uDF4E \uD83C\uDF4E " + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        Mono<Country> country = repository.findById(id);
        return  country.block();
    }
    @PostMapping(value = "/addCountry")
    @ResponseStatus(code = HttpStatus.CREATED)
    public Country add(@RequestBody Country country) {
        Country mCountry = repository.save(country).block();
        mCountry.setCountryId(mCountry.getId());
        mCountry = repository.save(country).block();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E addCountry: country added  \uD83D\uDD35  \uD83D\uDC99" + mCountry.getName() + " \uD83D\uDC99  " + mCountry.getCountryCode() + " \uD83D\uDC99  \uD83D\uDD35 " + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return mCountry;
    }
    @GetMapping(value = "/getCountries")
    public List<Country> getAll() {
        List<Country> list = repository.findAll().toStream().collect(Collectors.toList());
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E getCountries found  \uD83D\uDD35 " + list.size() + " \uD83D\uDD35 " + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return list;
    }

    @PutMapping(value = "/updateCountry")
    public Country update(@PathVariable String id, @RequestBody Country updatedUser) throws Exception {
        Country country = repository.findById(id).block();
        country.setName(updatedUser.getName());
        country.setCountryCode(updatedUser.getCountryCode());
        return repository.save(country).block();
    }
}
