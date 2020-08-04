package com.monitor.backend.controllers;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.monitor.backend.Emoji;
import com.monitor.backend.models.*;
import com.monitor.backend.services.ListService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class ListController {
    public static final Logger LOGGER = LoggerFactory.getLogger(ListController.class.getSimpleName());
    private static final Gson G = new GsonBuilder().setPrettyPrinting().create();

    public ListController() {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE.concat(" ListController ready and able ".concat(Emoji.RED_APPLE))));
    }

    @Autowired
    private ListService listService;

    @GetMapping("/getOrganizations")
    public List<Organization> getOrganizations() throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getOrganizations ..."));
        List<Organization> orgs =  listService.getOrganizations();
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Organizations found: " + orgs.size());
        return orgs;
    }
    @GetMapping("/getCountryOrganizations")
    public List<Organization> getCountryOrganizations(String countryId) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getCountryOrganizations ..."));
        List<Organization> orgs = listService.getCountryOrganizations(countryId);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Organizations found: " + orgs.size());
        return orgs;
    }
    @GetMapping("/getOrganizationProjects")
    public List<Project> getOrganizationProjects(String organizationId) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getOrganizationProjects ..."));
        List<Project> projects = listService.getOrganizationProjects(organizationId);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Projects found: " + projects.size());
        return projects;
    }
    @GetMapping("/getOrganizationUsers")
    public List<User> getOrganizationUsers(String organizationId) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getOrganizationUsers ..."));
        List<User>  users = listService.getOrganizationUsers(organizationId);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Users found: " + users.size());
        return users;
    }
    @GetMapping("/getUsers")
    public List<User> getUsers() throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getUsers ..."));
        List<User>  users = listService.getUsers();
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Users found: " + users.size());
        return users;
    }
    @GetMapping("/getMonitorReports")
    public List<MonitorReport> getMonitorReports(String projectId) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getMonitorReports ..."));
        List<MonitorReport> reports =  listService.getMonitorReports(projectId);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " MonitorReports found: " + reports.size());
        return reports;
    }
    @GetMapping("/getNearbyProjects")
    public List<Project> getNearbyProjects(double latitude, double longitude, double radiusInMiles) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getNearbyProjects ..."));
        List<Project> projects =  listService.getNearbyProjects(latitude, longitude, radiusInMiles);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Nearby Projects found: " + projects.size());
        return projects;
    }
    @GetMapping("/getNearbyCities")
    public List<City> getNearbyCities(double latitude, double longitude, double radiusInMiles) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getNearbyCities ..."));
        List<City> cities = listService.getNearbyCities(latitude, longitude, radiusInMiles);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Nearby Cities found: " + cities.size());
        return cities;
    }

}
