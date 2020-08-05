package com.monitor.backend.controllers;

import com.monitor.backend.utils.Emoji;
import com.monitor.backend.models.*;
import com.monitor.backend.services.DataService;
import com.monitor.backend.utils.Generator;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

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
    private Generator generator;

    @GetMapping("/ping")
    public String ping() throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("pinging the backend application .... : ".concat(Emoji.FLOWER_YELLOW)));
        return Emoji.HAND2 + Emoji.HAND2 + "  PROJECT MONITOR SERVICES PLATFORM pinged at ".concat(new DateTime().toDateTimeISO().toString());
    }
    @GetMapping("/generateDemoData")
    public String generateDemoData() throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("generateDemoData: ".concat(Emoji.FLOWER_YELLOW)));
        DateTime now = new DateTime();

        generator.startGeneration();

        DateTime end = new DateTime();
        long delta = end.toDate().getTime() - now.toDate().getTime();
        return Emoji.LEAF.concat(Emoji.LEAF.concat(" Demo Data Generation completed in " + delta /1000 + " seconds " + Emoji.RED_APPLE));
    }
    @PostMapping("/addOrganization")
    public String addOrganization(Organization organization) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding Organization: ".concat(organization.getName())));
       return dataService.addOrganization(organization);
    }
    @PostMapping("/addCountry")
    public String addCountry(Country country) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding Country: ".concat(country.getName())));
        return dataService.addCountry(country);
    }
    @PostMapping("/addCity")
    public String addCity(City city) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding City: ".concat(city.getName())));
        return dataService.addCity(city);
    }
    @PostMapping("/addProject")
    public String addProject(Project project) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding Project: ".concat(project.getName())));
        return dataService.addProject(project);
    }
    @PostMapping("/addMonitorReport")
    public String addMonitorReport(MonitorReport report) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding MonitorReport: ".concat(report.getUser().getOrganizationName())));
        return dataService.addMonitorReport(report);
    }
    @PostMapping("/addUser")
    public String addUser(User user) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("Adding User: ".concat(user.getName())));
        return dataService.addUser(user);
    }
}
