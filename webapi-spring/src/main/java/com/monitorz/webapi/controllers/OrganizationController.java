package com.monitorz.webapi.controllers;

import com.monitorz.webapi.EntityNotFoundException;
import com.monitorz.webapi.data.Organization;
import com.monitorz.webapi.data.repositories.OrganizationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicLong;
import java.util.logging.Level;
import java.util.logging.Logger;


@RestController

public class OrganizationController {

    static final Logger LOG = Logger.getLogger(OrganizationController.class.getSimpleName());
    static final Locale loc = Locale.getDefault();
    static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX", loc);
    private final AtomicLong counter = new AtomicLong();
    @Autowired
    OrganizationRepository repository;


    @RequestMapping("/findOrganizationsByCountry")
    public List<Organization> findOrganizationsByCountry(@RequestParam(value = "countryId") String countryId) {

        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E findOrganizationsByCountry: returning organizations \uD83C\uDF4E \uD83C\uDF4E "
                + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        List<Organization> organizations = repository.findByCountryId(countryId);
        LOG.log(Level.INFO, "\uD83C\uDF4F\uD83C\uDF4F findOrganizationsByCountry: \uD83C\uDF4F " + organizations.size() + " \uD83C\uDF4F");
        return organizations;
    }

    @RequestMapping("/findOrganizationById")
    public Organization findOrganizationById(@RequestParam(value = "id") String id) {

        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E findOrganizationById: returning user object all \uD83D\uDD35 JSONifified: \uD83C\uDF4E \uD83C\uDF4E "
                + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        Optional<Organization> user = repository.findById(id);
        return user.get();
    }

    @PostMapping(value = "/addOrganization")
    @ResponseStatus(code = HttpStatus.CREATED)
    public Organization add(@RequestBody Organization organization) {
        organization.setCreated(sdf.format(new Date()));
        Organization mOrganization = repository.save(organization);
        mOrganization.setOrganizationId(mOrganization.getId());
        mOrganization = repository.save(organization);
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E addOrganization organization added  \uD83D\uDD35  \uD83D\uDC99" + mOrganization.getOrganizationId() + " \uD83D\uDC99  "
                + mOrganization.getName() + " \uD83D\uDC99  \uD83D\uDD35 " + counter.incrementAndGet()
                + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return mOrganization;
    }

    @RequestMapping(value = "/getAllOrganizations")
    public List<Organization> getAll() {
        List<Organization> list = repository.findAll();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E getAllOrganizations found  \uD83D\uDD35 " + list.size() + " \uD83D\uDD35 "
                + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return list;
    }

    @PostMapping(value = "/updateOrganization")
    public Organization update(@RequestBody Organization updatedOrganization) throws Exception {
        Organization user = repository.findById(updatedOrganization.getId())
                .orElseThrow(() -> new Exception());
        user.setEmail(updatedOrganization.getEmail());
        user.setName(updatedOrganization.getName());
        return repository.save(user);
    }
}
