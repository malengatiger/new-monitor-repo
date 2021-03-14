package com.monitor.backend.controllers;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.monitor.backend.data.*;
import com.monitor.backend.services.*;
import com.monitor.backend.utils.Emoji;
import com.monitor.backend.utils.MongoGenerator;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.logging.Logger;


@CrossOrigin(origins = "*", allowedHeaders = "*")
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

    @Autowired
    private MessageService messageService;

    @Autowired
    OzowService ozowService;

    @GetMapping("/ping")
    public String ping() throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("pinging the backend application .... : ".concat(Emoji.FLOWER_YELLOW)));
        return Emoji.HAND2 + Emoji.HAND2 + "  PROJECT MONITOR SERVICES PLATFORM pinged at ".concat(new DateTime().toDateTimeISO().toString());
    }

    @PostMapping("/addOrganization")
    public Organization addOrganization(@RequestBody Organization organization) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat(".... Adding Organization: ".concat(organization.getName())));
        return dataService.addOrganization(organization);
    }

    @PostMapping("/addCountry")
    public Country addCountry(@RequestBody Country country) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding Country: ".concat(country.getName())));
        return dataService.addCountry(country);
    }

    @PostMapping("/addCommunity")
    public Community addCommunity(@RequestBody Community community) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding Community: ".concat(community.getName())));
        return dataService.addCommunity(community);
    }

    @PostMapping("/addCity")
    public City addCity(@RequestBody City city) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding City: ".concat(city.getName())));
        return dataService.addCity(city);
    }

    @Autowired
    MongoDataService mongoDataService;

    @PostMapping("/addProject")
    public com.monitor.backend.data.Project addProject(@RequestBody com.monitor.backend.data.Project project) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding Project: ".concat(project.getName())));
        String result = dataService.addProject(project);
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + result);
        return project;
    }

    @PostMapping("/updateProject")
    public com.monitor.backend.data.Project updateProject(@RequestBody Project project) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Update Project: ".concat(project.getName())));
        return dataService.updateProject(project);
    }

    @PostMapping("/addProjectPosition")
    public ProjectPosition addProjectPosition(@RequestBody ProjectPosition projectPosition)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding Project Position: "));
        return dataService.addProjectPosition(projectPosition);
    }


    @PostMapping("/addPhoto")
    public Photo addPhoto(@RequestBody Photo photo) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding Photo ... " + photo.getProjectName()));
        String result = dataService.addPhoto(photo);
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + result);
        return photo;
    }

    @PostMapping("/addVideo")
    public Video addVideo(@RequestBody Video video) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding Video ... " + video.getProjectName()));
        String result = dataService.addVideo(video);
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + result);
        return video;
    }

    @PostMapping("/sendOzowPaymentRequest")
    public String sendOzowPaymentRequest(@RequestBody OzowPaymentRequest paymentRequest) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("sendOzowPaymentRequest ... " + paymentRequest.getAmount()));
        String result = ozowService.sendOzowPaymentRequest(paymentRequest);
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + result);
        return result;
    }

    @PostMapping("/addCondition")
    public Condition addCondition(@RequestBody Condition condition) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding Condition ... " + condition.getProjectName()));
        String result = dataService.addCondition(condition);
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + result);
        return condition;
    }

    @PostMapping("/sendMessage")
    public OrgMessage sendMessage(@RequestBody OrgMessage orgMessage) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Sending FCM message ... " + orgMessage.getMessage()));
        OrgMessage result = dataService.addOrgMessage(orgMessage);
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + result);
        return result;
    }

    @Autowired
    private ListService listService;


    @PostMapping("/addUser")
    public User addUser(@RequestBody User user) throws FirebaseMessagingException {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat(".... Adding User: ".concat(user.getName())));
        return dataService.addUser(user);
    }

    @PostMapping("/updateUser")
    public User updateUser(@RequestBody User user) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Updating User: ".concat(user.getName())));
        return dataService.updateUser(user);
    }

    @GetMapping("/createSampleRequest")
    public OzowPaymentRequest createSampleRequest() throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Create sample Ozow payment request "));
        return ozowService.createSampleRequest();
    }

}
