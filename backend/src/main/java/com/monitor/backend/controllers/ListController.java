package com.monitor.backend.controllers;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.monitor.backend.data.*;
import com.monitor.backend.services.ListService;
import com.monitor.backend.services.MongoDataService;
import com.monitor.backend.utils.Emoji;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Metrics;
import org.springframework.data.geo.Point;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController

public class ListController {
    public static final Logger LOGGER = LoggerFactory.getLogger(ListController.class.getSimpleName());
    private static final Gson G = new GsonBuilder().setPrettyPrinting().create();

    public ListController() {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE.concat(" ListController ready and able ".concat(Emoji.RED_APPLE))));
    }

    @Autowired
    private ListService listService;

    @GetMapping("/hello")
    public String hello() throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("saying HELLO! the backend application .... : ".concat(Emoji.FLOWER_YELLOW)));
        return Emoji.HAND2 + Emoji.HAND2 + "PROJECT MONITOR SERVICES PLATFORM says Hi, Nigga! "
                + Emoji.RED_APPLE.concat(new DateTime().toDateTimeISO().toString());
    }
    @PostMapping("/post")
    public String post() throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("testing POST on the backend application .... : ".concat(Emoji.FLOWER_YELLOW)));
        return Emoji.HAND2 + Emoji.HAND2 + "PROJECT MONITOR SERVICES PLATFORM tested POST OK!"
                + Emoji.RED_APPLE.concat(new DateTime().toDateTimeISO().toString());
    }

    @GetMapping("/findUserByEmail")
    public ResponseEntity<Object> findUserByEmail(@RequestParam String email) {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat("findUserByEmail ... email: ".concat(email)));
        try {
            if (email.isEmpty()) {
                throw new Exception("Email is missing ".concat(Emoji.NOT_OK));
            }
            User user = listService.findUserByEmail(email);
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " findUserByEmail found: " + user.getName());
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "findUserByEmail failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/getOrganizations")
    public ResponseEntity<Object> getOrganizations() {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getOrganizations ..."));
        try {
            List<Organization> orgs = listService.getOrganizations();
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Organizations found: " + orgs.size());
            return ResponseEntity.ok(orgs);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getOrganizations failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/getCommunities")
    public ResponseEntity<Object> getCommunities() {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getCommunities ..."));
        try {
            List<Community> communities = listService.getCommunities();
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Communities found: " + communities.size());
            return ResponseEntity.ok(communities);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getCommunities failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/getProjects")
    public ResponseEntity<Object> getProjects() {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat("ListController: getProjects ..."));
        try {
            List<com.monitor.backend.data.Project> projects = listService.getProjects();
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN)
                    + "ListController: Projects found: \uD83D\uDC24 " + projects.size());
            return ResponseEntity.ok(projects);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "addFieldMonitorSchedule failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }


    @Autowired
    MongoDataService mongoDataService;

    @GetMapping("/getCities")
    public ResponseEntity<Object> getCities() {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat("ListController: getCities ..."));
        try {
            List<City> cities = mongoDataService.getCities();
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN)
                    + "ListController: Cities found: \uD83D\uDC24 " + cities.size());
            return ResponseEntity.ok(cities);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getCities failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }
    @GetMapping("/getCitiesByLocation")
    public ResponseEntity<Object> getCitiesByLocation(double latitude, double longitude, int radiusInKM) {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat("ListController: ...... getCitiesByLocation ..."));
        try {
            List<City> cities = mongoDataService.getCitiesByLocation(new Point(latitude,longitude), new Distance(radiusInKM, Metrics.KILOMETERS));
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN)
                    + "ListController: getCitiesByLocation found: \uD83D\uDC24 " + cities.size());
            return ResponseEntity.ok(cities);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getCitiesByLocation failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/findCommunitiesByCountry")
    public ResponseEntity<Object> findCommunitiesByCountry(@RequestParam String countryId) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat("ListController: findCommunitiesByCountry ..."));
        try {
            List<Community> countries = listService.findCommunitiesByCountry(countryId);
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN)
                    + "ListController: findCommunitiesByCountry found: \uD83D\uDC24 " + countries.size());
            return ResponseEntity.ok(countries);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "findCommunitiesByCountry failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/getCountries")
    public ResponseEntity<Object> getCountries() throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat("ListController: findSettlementsByCountry ..."));
        try {
            List<Country> countries = listService.getCountries();
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN)
                    + "ListController: Countries found: \uD83D\uDC24 " + countries.size());
            return ResponseEntity.ok(countries);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getCountries failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/getCountryOrganizations")
    public ResponseEntity<Object> getCountryOrganizations(@RequestParam String countryId) {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getCountryOrganizations ..."));
        try {
            List<Organization> orgs = listService.getCountryOrganizations(countryId);
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Organizations found: " + orgs.size());
            return ResponseEntity.ok(orgs);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getCountryOrganizations failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/getOrganizationProjects")
    public ResponseEntity<Object> getOrganizationProjects(@RequestParam String organizationId) {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getOrganizationProjects ..."));
        try {
            List<com.monitor.backend.data.Project> projects = listService.getOrganizationProjects(organizationId);
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Projects found: " + projects.size());
            return ResponseEntity.ok(projects);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getOrganizationProjects failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/getQuestionnairesByOrganization")
    public ResponseEntity<Object> getQuestionnairesByOrganization(@RequestParam String organizationId) {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getOrganizationUsers ..."));
        try {
            List<Questionnaire> users = listService.getQuestionnairesByOrganization(organizationId);
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Questionnaires found: " + users.size());
            return ResponseEntity.ok(users);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getQuestionnairesByOrganization failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/getOrganizationUsers")
    public ResponseEntity<Object> getOrganizationUsers(@RequestParam String organizationId) {
        try {
            return ResponseEntity.ok(listService.getOrganizationUsers(organizationId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "addFieldMonitorSchedule failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/getOrganizationPhotos")
    public ResponseEntity<Object> getOrganizationPhotos(@RequestParam String organizationId) {
        try {
            return ResponseEntity.ok(listService.getOrganizationPhotos(organizationId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getOrganizationPhotos failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/getOrganizationVideos")
    public ResponseEntity<Object> getOrganizationVideos(@RequestParam String organizationId) {
        try {
            return ResponseEntity.ok(listService.getOrganizationVideos(organizationId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getOrganizationVideos failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/findProjectsByOrganization")
    public ResponseEntity<Object> findProjectsByOrganization(@RequestParam String organizationId) {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" findProjectsByOrganization ... id: ".concat(organizationId)));
        try {
            List<com.monitor.backend.data.Project> users = listService.findProjectsByOrganization(organizationId);
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " findProjectsByOrganization found: " + users.size());
            return ResponseEntity.ok(users);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "findProjectsByOrganization failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/getUsers")
    public ResponseEntity<Object> getUsers() {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getUsers ..."));
        try {
            List<User> users = listService.getUsers();
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Users found: " + users.size());
            return ResponseEntity.ok(users);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getUsers failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/findProjectsByLocation")
    public ResponseEntity<Object> findProjectsByLocation(double latitude, double longitude, double radiusInKM) {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" ...... findProjectsByLocation ..."));
        try {
            List<Project> projects = listService.findProjectsByLocation(latitude, longitude, radiusInKM);
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Nearby Projects found: " + projects.size());
            return ResponseEntity.ok(projects);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "findProjectsByLocation failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/findCitiesByLocation")
    public ResponseEntity<Object> findCitiesByLocation(double latitude, double longitude, double radiusInKM) {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" findCitiesByLocation: ... radiusInKM: " + radiusInKM + " km"));
        try {
            List<City> cities = listService.findCitiesByLocation(latitude, longitude, radiusInKM);
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " ....... findCitiesByLocation: cities found: " + cities.size());
            return ResponseEntity.ok(cities);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "findCitiesByLocation failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/findProjectPositionsByLocation")
    public ResponseEntity<Object> findProjectPositionsByLocation(double latitude, double longitude, double radiusInKM) {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" findProjectsByLocation ..."));
        try {
            List<ProjectPosition> positions = listService.findProjectPositionsByLocation(latitude, longitude, radiusInKM);
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Nearby ProjectPositions found: " + positions.size());
            return ResponseEntity.ok(positions);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "findProjectPositionsByLocation failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/getProjectConditions")
    public ResponseEntity<Object> getProjectConditions(String projectId) {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getProjectConditions ... " + projectId));
        try {
            return ResponseEntity.ok(listService.getProjectConditions(projectId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getProjectConditions failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/getProjectPositions")
    public ResponseEntity<Object> getProjectPositions(String projectId) {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getProjectPositions: " + projectId));
        try {
            return ResponseEntity.ok(listService.getProjectPositions(projectId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getProjectPositions failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }
    @GetMapping("/getOrganizationProjectPositions")
    public ResponseEntity<Object> getOrganizationProjectPositions(String organizationId) {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getOrganizationProjectPositions: " + organizationId));
        try {
            return ResponseEntity.ok(listService.getOrganizationProjectPositions(organizationId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getOrganizationProjectPositions failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/countPhotosByProject")
    public ResponseEntity<Object> countPhotosByProject(String projectId) {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("countPhotosByProject:  starting call: " + projectId));
        try {
            return ResponseEntity.ok(listService.countPhotosByProject(projectId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "countPhotosByProject failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/countPhotosByUser")
    public ResponseEntity<Object> countPhotosByUser(String userId) {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("countPhotosByUser:  starting call: " + userId));
        try {
            return ResponseEntity.ok(listService.countPhotosByUser(userId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "countPhotosByUser failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }
    }

    @GetMapping("/countVideosByProject")
    public ResponseEntity<Object> countVideosByProject(String projectId) {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("countVideosByProject:  starting call: " + projectId));
        try {
            return ResponseEntity.ok(listService.countVideosByProject(projectId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "countVideosByProject failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }


    }

    @GetMapping("/countVideosByUser")
    public ResponseEntity<Object> countVideosByUser(String userId) {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("countVideosByUser:  starting call: " + userId));
        try {
            return ResponseEntity.ok(listService.countVideosByUser(userId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "countVideosByUser failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @GetMapping("/getCountsByProject")
    public ResponseEntity<Object> getCountsByProject(String projectId) {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getCountsByProject: " + projectId));
        try {
            return ResponseEntity.ok(listService.getCountsByProject(projectId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getCountsByProject failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @GetMapping("/getCountsByUser")
    public ResponseEntity<Object> getCountsByUser(String userId) {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getCountsByUser: " + userId));
        try {
            return ResponseEntity.ok(listService.getCountsByUser(userId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getCountsByUser failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @GetMapping("/getProjectPhotos")
    public ResponseEntity<Object> getProjectPhotos(String projectId) {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getProjectPhotos: " + projectId));
        try {
            return ResponseEntity.ok(listService.getProjectPhotos(projectId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getProjectPhotos failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @GetMapping("/getUserProjectPhotos")
    public ResponseEntity<Object> getUserProjectPhotos(String userId) {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getUserProjectPhotos: " + userId));
        try {
            return ResponseEntity.ok(listService.getUserProjectPhotos(userId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getUserProjectPhotos failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @GetMapping("/getUserProjectVideos")
    public ResponseEntity<Object> getUserProjectVideos(String userId) {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getUserProjectVideos: " + userId));
        try {
            return ResponseEntity.ok(listService.getUserProjectVideos(userId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getUserProjectVideos failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }
    @GetMapping("/getProjectVideos")
    public ResponseEntity<Object> getProjectVideos(String projectId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getProjectVideos: " + projectId));
        try {
            return ResponseEntity.ok(listService.getProjectVideos(projectId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getProjectVideos failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @GetMapping("/getProjectFieldMonitorSchedules")
    public ResponseEntity<Object> getProjectFieldMonitorSchedules(String projectId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getProjectFieldMonitorSchedules: " + projectId));
        try {
            return ResponseEntity.ok(listService.getProjectFieldMonitorSchedules(projectId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getProjectFieldMonitorSchedules failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @GetMapping("/getMonitorFieldMonitorSchedules")
    public ResponseEntity<Object> getMonitorFieldMonitorSchedules(String userId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getMonitorFieldMonitorSchedules: " + userId));
        try {
            return ResponseEntity.ok(listService.getMonitorFieldMonitorSchedules(userId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getMonitorFieldMonitorSchedules failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @GetMapping("/getOrgFieldMonitorSchedules")
    public ResponseEntity<Object> getOrgFieldMonitorSchedules(String organizationId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getOrgFieldMonitorSchedules: " + organizationId));
        try {
            return ResponseEntity.ok(listService.getOrgFieldMonitorSchedules(organizationId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getOrgFieldMonitorSchedules failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @GetMapping("/getNearbyCities")
    public ResponseEntity<Object> getNearbyCities(double latitude, double longitude, double radiusInKM) {
        try {
            return ResponseEntity.ok(listService.getNearbyCities(latitude, longitude, radiusInKM));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "getNearbyCities failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

}
