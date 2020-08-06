package com.monitor.backend.controllers;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.monitor.backend.utils.Emoji;
import com.monitor.backend.models.*;
import com.monitor.backend.services.ListService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
    @GetMapping("/findUserByEmail")
    public User findUserByEmail(@RequestParam  String email) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat("findUserByEmail ... email: ".concat(email)));
        if (email.isEmpty()) {
            throw new Exception("Email is missing ".concat(Emoji.NOT_OK).concat(Emoji.NOT_OK));
        }
        User user = listService.findUserByEmail(email);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " findUserByEmail found: " + user.getName());
        return user;
    }
    //user.1596685142563@monitor.com
    @GetMapping("/getOrganizations")
    public List<Organization> getOrganizations() throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getOrganizations ..."));
        List<Organization> orgs =  listService.getOrganizations();
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Organizations found: " + orgs.size());
        return orgs;
    }
    @GetMapping("/getCommunities")
    public List<Community> getCommunities() throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getCommunities ..."));
        List<Community> communities =  listService.getCommunities();
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Communities found: " + communities.size());
        return communities;
    }
    @GetMapping("/getProjects")
    public List<Project> getProjects() throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat("ListController: getProjects ..."));
        List<Project> projects =  listService.getProjects();
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN)
                + "ListController: Projects found: \uD83D\uDC24 " + projects.size());
        return projects;
    }
    @GetMapping("/getCities")
    public List<City> getCities() throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat("ListController: getProjects ..."));
        List<City> cities =  listService.getCities();
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN)
                + "ListController: Cities found: \uD83D\uDC24 " + cities.size());
        return cities;
    }
    @GetMapping("/getCountries")
    public List<Country> getCountries() throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat("ListController: getCountries ..."));
        List<Country> countries =  listService.getCountries();
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN)
                + "ListController: Countries found: \uD83D\uDC24 " + countries.size());
        return countries;
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
