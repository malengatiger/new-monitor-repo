package com.monitor.backend.controllers;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.monitor.backend.data.*;
import com.monitor.backend.services.MongoDataService;
import com.monitor.backend.utils.Emoji;
import com.monitor.backend.models.*;
import com.monitor.backend.services.ListService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
    public List<com.monitor.backend.data.Project> getProjects() throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat("ListController: getProjects ..."));
        List<com.monitor.backend.data.Project> projects =  listService.getProjects();
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN)
                + "ListController: Projects found: \uD83D\uDC24 " + projects.size());
        return projects;
    }


    @Autowired
    MongoDataService mongoDataService;

    @GetMapping("/getCities")
    public List<City> getCities() throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat("ListController: getCities ..."));
        List<City> cities =  mongoDataService.getCities();
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN)
                + "ListController: Cities found: \uD83D\uDC24 " + cities.size());
        return cities;
    }

    @GetMapping("/findCommunitiesByCountry")
    public List<Community> findCommunitiesByCountry(@RequestParam String countryId) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat("ListController: findCommunitiesByCountry ..."));
        List<Community> countries =  listService.findCommunitiesByCountry(countryId);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN)
                + "ListController: findCommunitiesByCountry found: \uD83D\uDC24 " + countries.size());
        return countries;
    }

    @GetMapping("/getCountries")
    public List<Country> getCountries() throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat("ListController: findSettlementsByCountry ..."));
        List<Country> countries =  listService.getCountries();
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN)
                + "ListController: Countries found: \uD83D\uDC24 " + countries.size());
        return countries;
    }
    @GetMapping("/getCountryOrganizations")
    public List<Organization> getCountryOrganizations(@RequestParam  String countryId) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getCountryOrganizations ..."));
        List<Organization> orgs = listService.getCountryOrganizations(countryId);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Organizations found: " + orgs.size());
        return orgs;
    }

    @GetMapping("/getOrganizationProjects")
    public List<com.monitor.backend.data.Project> getOrganizationProjects(@RequestParam  String organizationId) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getOrganizationProjects ..."));
        List<com.monitor.backend.data.Project> projects = listService.getOrganizationProjects(organizationId);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Projects found: " + projects.size());
        return projects;
    }

    @GetMapping("/getQuestionnairesByOrganization")
    public List<Questionnaire> getQuestionnairesByOrganization(@RequestParam  String organizationId) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getOrganizationUsers ..."));
        List<Questionnaire>  users = listService.getQuestionnairesByOrganization(organizationId);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Questionnaires found: " + users.size());
        return users;
    }

    @GetMapping("/getOrganizationUsers")
    public List<User> getOrganizationUsers(@RequestParam  String organizationId) throws Exception {
        return listService.getOrganizationUsers(organizationId);
    }
    @GetMapping("/getOrganizationPhotos")
    public List<Photo> getOrganizationPhotos(@RequestParam  String organizationId) throws Exception {
        return listService.getOrganizationPhotos(organizationId);
    }
    @GetMapping("/getOrganizationVideos")
    public List<Video> getOrganizationVideos(@RequestParam  String organizationId) throws Exception {
        return listService.getOrganizationVideos(organizationId);
    }

    @GetMapping("/findProjectsByOrganization")
    public List<com.monitor.backend.data.Project> findProjectsByOrganization(@RequestParam  String organizationId) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" findProjectsByOrganization ... id: ".concat(organizationId)));
        List<com.monitor.backend.data.Project>  users = listService.findProjectsByOrganization(organizationId);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " findProjectsByOrganization found: " + users.size());
        return users;
    }
    @GetMapping("/getUsers")
    public List<User> getUsers() throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getUsers ..."));
        List<User>  users = listService.getUsers();
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Users found: " + users.size());
        return users;
    }

    @GetMapping("/findProjectsByLocation")
    public List<com.monitor.backend.data.Project> findProjectsByLocation(double latitude, double longitude, double radiusInKM) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" findProjectsByLocation ..."));
        List<Project> projects =  listService.findProjectsByLocation(latitude, longitude, radiusInKM);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Nearby Projects found: " + projects.size());
        return projects;
    }
    @GetMapping("/findCitiesByLocation")
    public List<City> findCitiesByLocation(double latitude, double longitude, double radiusInKM) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" findCitiesByLocation ..."));
        List<City> cities =  listService.findCitiesByLocation(latitude, longitude, radiusInKM);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Nearby cities found: " + cities.size());
        return cities;
    }
    @GetMapping("/findProjectPositionsByLocation")
    public List<ProjectPosition> findProjectPositionsByLocation(double latitude, double longitude, double radiusInKM) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" findProjectsByLocation ..."));
        List<ProjectPosition> positions =  listService.findProjectPositionsByLocation(latitude, longitude, radiusInKM);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + " Nearby ProjectPositions found: " + positions.size());
        return positions;
    }
    @GetMapping("/getProjectConditions")
    public List<Condition> getProjectConditions(String projectId) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getProjectConditions ... " + projectId));
        return listService.getProjectConditions(projectId);
    }
    @GetMapping("/getProjectPositions")
    public List<ProjectPosition> getProjectPositions(String projectId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getProjectPositions: " + projectId));
        return listService.getProjectPositions(projectId);
    }
    @GetMapping("/countPhotosByProject")
    public int countPhotosByProject(String projectId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("countPhotosByProject:  starting call: " + projectId));
        return listService.countPhotosByProject(projectId);
    }
    @GetMapping("/countPhotosByUser")
    public int countPhotosByUser(String userId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("countPhotosByUser:  starting call: " + userId));
        return listService.countPhotosByUser(userId);
    }

    @GetMapping("/countVideosByProject")
    public int countVideosByProject(String projectId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("countVideosByProject:  starting call: " + projectId));
        return listService.countVideosByProject(projectId);
    }
    @GetMapping("/countVideosByUser")
    public int countVideosByUser(String userId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("countVideosByUser:  starting call: " + userId));
        return listService.countVideosByUser(userId);
    }
    @GetMapping("/getCountsByProject")
    public ProjectCount getCountsByProject(String projectId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getCountsByProject: " + projectId));
        return listService.getCountsByProject(projectId);
    }
    @GetMapping("/getCountsByUser")
    public UserCount getCountsByUser(String userId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getCountsByUser: " + userId));
        return listService.getCountsByUser(userId);
    }
    //getUserProjectPhotos
    @GetMapping("/getProjectPhotos")
    public List<Photo> getProjectPhotos(String projectId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getProjectPhotos: " + projectId));
        return listService.getProjectPhotos(projectId);
    }
    @GetMapping("/getUserProjectPhotos")
    public List<Photo> getUserProjectPhotos(String userId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getUserProjectPhotos: " + userId));
        return listService.getUserProjectPhotos(userId);
    }
    @GetMapping("/getUserProjectVideos")
    public List<Video> getUserProjectVideos(String userId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getUserProjectVideos: " + userId));
        return listService.getUserProjectVideos(userId);
    }
    @GetMapping("/getProjectVideos")
    public List<Video> getProjectVideos(String projectId)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("getProjectVideos: " + projectId));
        return listService.getProjectVideos(projectId);
    }
    @GetMapping("/getNearbyCities")
    public List<City> getNearbyCities(double latitude, double longitude, double radiusInKM) throws Exception {
        return listService.getNearbyCities(latitude,longitude,radiusInKM);
    }

}
