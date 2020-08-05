package com.monitor.backend;

import com.monitor.backend.controllers.DataController;
import com.monitor.backend.controllers.ListController;
import com.monitor.backend.services.DataService;
import com.monitor.backend.services.ListService;
import com.monitor.backend.utils.Emoji;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.Banner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.core.env.Environment;
import org.springframework.scheduling.annotation.EnableScheduling;

import java.io.PrintStream;
import java.lang.reflect.Method;
import java.util.Calendar;
import java.util.logging.Logger;

@SpringBootApplication
@EnableScheduling
public class MonitorBackendApplication implements ApplicationListener<ApplicationReadyEvent> {

    public static final Logger LOGGER = Logger.getLogger(MonitorBackendApplication.class.getName());

    public static void main(String[] args) {
        LOGGER.info("\uD83D\uDE21 \uD83D\uDE21 \uD83D\uDE21 \uD83D\uDE21 MonitorBackendApplication Starting ...");
        SpringApplication app = new SpringApplication(MonitorBackendApplication.class);
        app.setLogStartupInfo(true);
        app.setBanner(new Banner() {
            @Override
            public void printBanner(Environment environment,
                                    Class<?> sourceClass,
                                    PrintStream out) {
                out.println(getBanner());
            }
        });

        app.run(args);
        Calendar cal = Calendar.getInstance();
        int res = cal.getActualMaximum(Calendar.DATE);
        LOGGER.info(Emoji.SKULL.concat(Emoji.SKULL) + "Today's Date = " + cal.getTime());

        LOGGER.info(Emoji.SKULL.concat(Emoji.SKULL) +
                "Last Date of the current month = " + res + Emoji.SKULL.concat(Emoji.SKULL));
        LOGGER.info(Emoji.PANDA.concat(Emoji.PANDA).concat(Emoji.PANDA) +
                " Monitor Backend started OK! ".concat(Emoji.HAND2.concat(Emoji.HAND2))
                + " All services up and running.");
        LOGGER.info("\uD83C\uDF38 \uD83C\uDF38 \uD83C\uDF38  MonitorBackendApplication Ready and willing ... "
                .concat(Emoji.RED_APPLE));

    }

    @Autowired
    private ListService listService;

    @Autowired
    private DataService dataService;

    @Autowired
    private DataController dataController;

    @Autowired
    private ListController listController;

    @Override
    public void onApplicationEvent(ApplicationReadyEvent applicationReadyEvent) {
        LOGGER.info("\uD83D\uDC2C \uD83D\uDC2C ApplicationReadyEvent fired! \uD83D\uDC2C "
                .concat(applicationReadyEvent.getApplicationContext().getDisplayName().concat(" \uD83D\uDC2C")));

        try {
            dataService.initializeFirebase();

            LOGGER.info(Emoji.PRETZEL.concat(Emoji.PRETZEL) + " -------- PRINT SERVICE METHODS AVAILABLE --------- ");
            printServiceMethods(listService.getClass().getMethods(),
                    Emoji.PEAR, "ListService method: ", Emoji.RED_DOT);
            LOGGER.info(Emoji.PEAR + " -------- end of ListService methods ");

            printServiceMethods(dataService.getClass().getMethods(),
                    Emoji.PEACH, "DataService method: ", Emoji.FLOWER_YELLOW);
            LOGGER.info(Emoji.PEACH + " -------- end of DataService methods ");

            printServiceMethods(listService.getClass().getMethods(), Emoji.BLUE_THINGY, "ListService method: ", Emoji.BLUE_THINGY);
            LOGGER.info(Emoji.BLUE_THINGY + " -------- end of ListService methods ");

            printServiceMethods(dataController.getClass().getMethods(), Emoji.BLUE_BIRD, "DataController method: ", Emoji.BLUE_BIRD);
            LOGGER.info(Emoji.BLUE_BIRD + " -------- end of DataController methods ");

            printServiceMethods(listController.getClass().getMethods(), Emoji.YELLOW_BIRD, "ListController method: ", Emoji.YELLOW_BIRD);
            LOGGER.info(Emoji.YELLOW_BIRD + " -------- end of ListController methods ");


        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private void printServiceMethods(Method[] methods, String emoji, String className, String endEmoji) {
        for (Method method : methods) {
            if (!method.getName().equalsIgnoreCase("wait") &&
                    !method.getName().equalsIgnoreCase("equals") &&
                    !method.getName().equalsIgnoreCase("getClass") &&
                    !method.getName().equalsIgnoreCase("toString") &&
                    !method.getName().equalsIgnoreCase("notify") &&
                    !method.getName().equalsIgnoreCase("notifyAll") &&
                    !method.getName().equalsIgnoreCase("hashCode")) {
                LOGGER.info(emoji.concat(emoji).concat(className.concat(" " + emoji)
                        .concat(method.getName())).concat(" " + endEmoji));
            }
            //ignore
        }
    }

    private static String getBanner() {
        return "#################################################################\n" +
                "#### " + Emoji.HEART_BLUE + "PROJECT MONITOR SERVICES PLATFORM " + Emoji.HEART_BLUE + "                ####\n" +
                "#### ".concat(Emoji.FLOWER_RED).concat(" ").concat(new DateTime().toDateTimeISO().toString().concat("                       ####\n")) +
                "#################################################################\n";
    }

}
