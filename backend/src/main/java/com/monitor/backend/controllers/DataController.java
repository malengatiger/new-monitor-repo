package com.monitor.backend.controllers;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.monitor.backend.data.*;
import com.monitor.backend.services.DataService;
import com.monitor.backend.services.ListService;
import com.monitor.backend.services.MessageService;
import com.monitor.backend.services.MongoDataService;
import com.monitor.backend.utils.Emoji;
import com.monitor.backend.utils.MongoGenerator;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
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


    @GetMapping("/ping")
    public String ping() throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("pinging the backend application .... : ".concat(Emoji.FLOWER_YELLOW)));
        return Emoji.HAND2 + Emoji.HAND2 + "PROJECT MONITOR SERVICES PLATFORM pinged at ".concat(new DateTime().toDateTimeISO().toString());
    }

    @PostMapping("/addOrganization")
    public ResponseEntity<Object> addOrganization(@RequestBody Organization organization) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat(".... Adding Organization: ".concat(organization.getName())));
        try {
            return ResponseEntity.ok(dataService.addOrganization(organization));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "addOrganization failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @PostMapping("/addCountry")
    public ResponseEntity<Object> addCountry(@RequestBody Country country) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding Country: ".concat(country.getName())));
        try {
            return ResponseEntity.ok(dataService.addCountry(country));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "addCountry failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @PostMapping("/addCommunity")
    public ResponseEntity<Object> addCommunity(@RequestBody Community community) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding Community: ".concat(community.getName())));
        try {
            return ResponseEntity.ok(dataService.addCommunity(community));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "addCommunity failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @PostMapping("/addCity")
    public ResponseEntity<Object> addCity(@RequestBody City city) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding City: ".concat(city.getName())));
        try {
            City city1 = dataService.addCity(city);
            return ResponseEntity.ok(city1);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "addFieldMonitorSchedule failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @PostMapping("/addFieldMonitorSchedule")
    public ResponseEntity<Object> addFieldMonitorSchedule(@RequestBody FieldMonitorSchedule fieldMonitorSchedule) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding FieldMonitorSchedule: "
                .concat(fieldMonitorSchedule.getFieldMonitorId())));
        try {
            FieldMonitorSchedule schedule = dataService.addFieldMonitorSchedule(fieldMonitorSchedule);
            return ResponseEntity.ok(schedule);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "addFieldMonitorSchedule failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }


    @Autowired
    MongoDataService mongoDataService;

    @PostMapping("/addProject")
    public ResponseEntity<Object> addProject(@RequestBody com.monitor.backend.data.Project project) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding Project: ".concat(project.getName())));
        try {
            String result = dataService.addProject(project);
            LOGGER.info(Emoji.LEAF + Emoji.LEAF + result);
            return ResponseEntity.ok(project);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "addProject failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @PostMapping("/updateProject")
    public ResponseEntity<Object> updateProject(@RequestBody Project project) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Update Project: ".concat(project.getName())));
        try {
        return ResponseEntity.ok(dataService.updateProject(project));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "updateProject failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @PostMapping("/addProjectPosition")
    public ResponseEntity<Object> addProjectPosition(@RequestBody ProjectPosition projectPosition)
            throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding Project Position: "));
        try {
            return ResponseEntity.ok(dataService.addProjectPosition(projectPosition));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "addProjectPosition failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }


    @PostMapping("/addPhoto")
    public ResponseEntity<Object> addPhoto(@RequestBody Photo photo) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding Photo ... " + photo.getProjectName()));
        try {
            String result = dataService.addPhoto(photo);
            LOGGER.info(Emoji.LEAF + Emoji.LEAF + result);
            return ResponseEntity.ok(photo);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "addPhoto failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @PostMapping("/addVideo")
    public ResponseEntity<Object> addVideo(@RequestBody Video video) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding Video ... " + video.getProjectName()));
        try {
            String result = dataService.addVideo(video);
            LOGGER.info(Emoji.LEAF + Emoji.LEAF + result);
        return ResponseEntity.ok(video);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "addVideo failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

//    @PostMapping("/sendOzowPaymentRequest")
//    public String sendOzowPaymentRequest(@RequestBody OzowPaymentRequest paymentRequest) throws Exception {
//        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
//                .concat("sendOzowPaymentRequest ... " + paymentRequest.getAmount()));
//        String result = ozowService.sendOzowPaymentRequest(paymentRequest);
//        LOGGER.info(Emoji.LEAF + Emoji.LEAF + result);
//        return result;
//    }

    @PostMapping("/addCondition")
    public ResponseEntity<Object> addCondition(@RequestBody Condition condition) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Adding Condition ... " + condition.getProjectName()));
        try {
            String result = dataService.addCondition(condition);
            LOGGER.info(Emoji.LEAF + Emoji.LEAF + result);
            return ResponseEntity.ok(condition);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "addCondition failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @PostMapping("/sendMessage")
    public ResponseEntity<Object> sendMessage(@RequestBody OrgMessage orgMessage) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Sending FCM message ... " + orgMessage.getMessage()));
        try {
        OrgMessage result = dataService.addOrgMessage(orgMessage);
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + result);
        return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "sendMessage failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @Autowired
    private ListService listService;


    @PostMapping("/addUser")
    public ResponseEntity<Object> addUser(@RequestBody User user) throws FirebaseMessagingException {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat(".... Adding User: ".concat(user.getName())));
        try {
            return ResponseEntity.ok(dataService.addUser(user));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "addUser failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }

    @PostMapping("/updateUser")
    public ResponseEntity<Object> updateUser(@RequestBody User user) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
                .concat("Updating User: ".concat(user.getName())));
        try {
            return ResponseEntity.ok(dataService.updateUser(user));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    new CustomErrorResponse(400,
                            "updateUser failed: " + e.getMessage(),
                            new DateTime().toDateTimeISO().toString()));
        }

    }
//
//    @GetMapping("/createSampleRequest")
//    public OzowPaymentRequest createSampleRequest() throws Exception {
//        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS)
//                .concat("Create sample Ozow payment request "));
//        return ozowService.createSampleRequest();
//    }

}
