package com.monitor.backend.controllers;

import com.monitor.backend.models.*;
import com.monitor.backend.services.DataService;
import com.monitor.backend.services.ListService;
import com.monitor.backend.services.MongoDataService;
import com.monitor.backend.utils.Emoji;
import com.monitor.backend.utils.MongoGenerator;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.logging.Logger;

@RestController
public class GeneratorController {
    private static final Logger LOGGER = Logger.getLogger(GeneratorController.class.getSimpleName());

    public GeneratorController() {
        LOGGER.info(Emoji.PANDA.concat(Emoji.PIG) +
                "GeneratorController ready to help generate demo data ".concat(Emoji.PANDA.concat(Emoji.PANDA)));
    }

    @Autowired
    private DataService dataService;

    @Autowired
    private MongoGenerator mongoGenerator;

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



    @Autowired
    MongoDataService mongoDataService;

    @Autowired
    private ListService listService;



}
