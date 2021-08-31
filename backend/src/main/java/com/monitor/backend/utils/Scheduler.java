package com.monitor.backend.utils;

import com.monitor.backend.services.DataService;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.logging.Logger;

@Component
public class Scheduler {
    public static final Logger LOGGER = Logger.getLogger(Scheduler.class.getSimpleName());
    @Autowired
    private ApplicationContext context;

    @Autowired
    private DataService dataService;


    public Scheduler() {
        LOGGER.info(Emoji.YELLOW_BIRD.concat(Emoji.YELLOW_BIRD) +
                "Scheduler constructed. Waiting to be triggered ".concat(Emoji.YELLOW_BIRD));
    }

    @Scheduled(fixedRate = 1000 * 60 * 60 * 4) //4 Hours

    public void fixedRateScheduled() throws Exception {
        LOGGER.info(Emoji.PRETZEL.concat(Emoji.PRETZEL).concat(Emoji.PRETZEL) + "Fixed Rate scheduler; " +
                "\uD83C\uDF3C CALCULATE LOAN BALANCES or OTHER NECESSARY WORK: " + new DateTime().toDateTimeISO().toString()
                + " " + Emoji.RED_APPLE);

        try {

            LOGGER.info(Emoji.PRETZEL.concat(Emoji.PRETZEL).concat(Emoji.PRETZEL) +
                    "Nothing do do thus far ... ");

        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.info(Emoji.NOT_OK.concat(Emoji.NOT_OK) + "Firebase fell down");
//            e.printStackTrace();
        }
    }


}
