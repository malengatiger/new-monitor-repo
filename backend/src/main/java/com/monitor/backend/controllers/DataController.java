package com.monitor.backend.controllers;

import com.monitor.backend.models.*;
import com.monitor.backend.services.DataService;
import com.monitor.backend.services.ListService;
import com.monitor.backend.services.MongoDataService;
import com.monitor.backend.utils.Emoji;
import com.monitor.backend.utils.MongoGenerator;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.logging.Logger;

@RestController
public class DataController {
    private static final Logger LOGGER = Logger.getLogger(DataController.class.getSimpleName());

    public DataController() {
        LOGGER.info(Emoji.PANDA.concat(Emoji.PIG) +
                "DataController ready to write data ".concat(Emoji.PANDA.concat(Emoji.PANDA)));
    }

    @Autowired
    private DataService dataService;

    @Autowired
    private MongoGenerator mongoGenerator;

    @GetMapping("/ping")
    public String ping() throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("pinging the backend application .... : ".concat(Emoji.FLOWER_YELLOW)));
        return Emoji.HAND2 + Emoji.HAND2 + "  PROJECT MONITOR SERVICES PLATFORM pinged at ".concat(new DateTime().toDateTimeISO().toString());
    }

//    @GetMapping("/generateDemoData")
//    public String generateDemoData() throws Exception {
//        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("generateDemoData: ".concat(Emoji.FLOWER_YELLOW)));
//        DateTime now = new DateTime();
//
//        generator.startGeneration();
//
//        DateTime end = new DateTime();
//        long delta = end.toDate().getTime() - now.toDate().getTime();
//        return Emoji.LEAF.concat(Emoji.LEAF.concat(" Demo Data Generation completed in " + delta / 1000 + " seconds " + Emoji.RED_APPLE));
//    }

    @GetMapping("/migrateCities")
    public String migrateCities() throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("migrateCities: ".concat(Emoji.FLOWER_YELLOW)));
        DateTime now = new DateTime();

        mongoGenerator.processSouthAfricanCities();

        DateTime end = new DateTime();
        long delta = end.toDate().getTime() - now.toDate().getTime();
        return Emoji.LEAF.concat(Emoji.LEAF.concat(
                " South African City migration completed in " + delta / 1000 + " seconds "
                        + Emoji.RED_APPLE));
    }

    @GetMapping("/generateCommunities")
    public String generateCommunities() throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("generateCommunities: ".concat(Emoji.FLOWER_YELLOW)));
        mongoGenerator.generateCommunities();
        return Emoji.LEAF.concat(Emoji.LEAF.concat("Communities generated " + Emoji.RED_APPLE));
    }

    @PostMapping("/addOrganization")
    public String addOrganization(Organization organization) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding Organization: ".concat(organization.getName())));
        return dataService.addOrganization(organization);
    }

    @PostMapping("/addCountry")
    public String addCountry(Country country) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding Country: ".concat(country.getName())));
        return dataService.addCountry(country);
    }

    @GetMapping("/generateCountries")
    public String generateCountries() throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("generateCountries: Adding Countries to MongoDB ...."));
        mongoGenerator.generateCountries();
        return Emoji.RAIN_DROPS + Emoji.RAIN_DROPS + " ..... MongoGenerator:generateCountries completed";
    }
    @GetMapping("/generateOrganizations")
    public String generateOrganizations(int numberOfOrgs) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("generateOrganizations: Adding Countries to MongoDB ...."));
        mongoGenerator.generateOrganizations(numberOfOrgs);
        return Emoji.RAIN_DROPS + Emoji.RAIN_DROPS + " ..... MongoGenerator: generateOrganizations completed";
    }

    @GetMapping("/generateUsers")
    public String generateUsers(boolean eraseExistingUsers) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("generateUsers: Adding users to MongoDB ...."));
        mongoGenerator.generateUsers(eraseExistingUsers);
        return Emoji.RAIN_DROPS + Emoji.RAIN_DROPS + " ..... MongoGenerator: generateUsers completed";
    }

    @GetMapping("/generateProjects")
    public String generateProjects() throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("generateProjects: Adding users to MongoDB ...."));
        mongoGenerator.generateProjects();
        return Emoji.RAIN_DROPS + Emoji.RAIN_DROPS + " ..... MongoGenerator: generateProjects completed";
    }

    @PostMapping("/addCommunity")
    public String addCommunity(Community community) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding Community: ".concat(community.getName())));
        return dataService.addCommunity(community);
    }

    @PostMapping("/addCity")
    public String addCity(City city) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding City: ".concat(city.getName())));
        return dataService.addCity(city);
    }

    @Autowired
    MongoDataService mongoDataService;
    @PostMapping("/addProject")
    public Project addProject(Project project) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding Project: ".concat(project.getName())));
        return dataService.addProject(project);
    }
    @PostMapping("/updateProject")
    public Project updateProject(Project project) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Update Project: ".concat(project.getName())));
        return dataService.updateProject(project);
    }
    @PostMapping("/addProjectPosition")
    public ProjectPosition addProjectPosition(@RequestBody ProjectPosition projectPosition)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding Project Position: " ));
        return dataService.addProjectPosition(projectPosition);
    }


    @PostMapping("/addPhoto")
    public Photo addPhoto(@RequestBody Photo photo) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding Photo ... " + photo.getProjectName()));
         dataService.addPhoto(photo);
         return photo;
    }
    @PostMapping("/addVideo")
    public Video addVideo(@RequestBody Video video) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding Video ... " + video.getProjectName()));
         dataService.addVideo(video);
         return video;
    }
    @PostMapping("/addCondition")
    public Condition addCondition(@RequestBody Condition condition) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding Condition ... " + condition.getProjectName()));
         dataService.addCondition(condition);
         return condition;
    }

    @Autowired
    private ListService listService;


    @PostMapping("/addUser")
    public User addUser(User user) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding User: ".concat(user.getName())));
        return dataService.addUser(user);
    }
    @PostMapping("/updateUser")
    public User updateUser(User user) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding User: ".concat(user.getName())));
        return dataService.updateUser(user);
    }

}
