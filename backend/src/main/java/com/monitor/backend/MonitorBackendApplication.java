package com.monitor.backend;

import com.monitor.backend.controllers.DataController;
import com.monitor.backend.controllers.ListController;
import com.monitor.backend.data.Project;
import com.monitor.backend.data.User;
import com.monitor.backend.models.*;
import com.monitor.backend.services.DataService;
import com.monitor.backend.services.ListService;
import com.monitor.backend.services.MessageService;
import com.monitor.backend.utils.Emoji;
import com.monitor.backend.utils.MongoGenerator;
import com.monitor.backend.utils.RateLimitInterceptor;
import com.sun.org.apache.xerces.internal.parsers.SecurityConfiguration;
import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.Bucket4j;
import io.github.bucket4j.Refill;
import io.micrometer.core.instrument.Counter;
import org.jetbrains.annotations.NotNull;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.Banner;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;


import java.io.PrintStream;
import java.lang.reflect.Method;
import java.time.Duration;
import java.util.*;
import java.util.logging.Logger;

@SpringBootApplication
@EnableScheduling
@EnableCaching
@EnableAutoConfiguration
@EnableMongoRepositories(basePackages = {"com.monitor.backend.models"})
public class MonitorBackendApplication implements ApplicationListener<ApplicationReadyEvent>, CommandLineRunner, WebMvcConfigurer {

    public static final Logger LOGGER = Logger.getLogger(MonitorBackendApplication.class.getName());
    private Counter SecurityConfigurationBuilder;

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

    @Autowired
    private MessageService messageService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProjectRepository projectRepository;


    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE   + Emoji.RED_APPLE + Emoji.KEY
                + " addInterceptors: set up Rate Limiting " + Emoji.KEY);

        Refill refill = Refill.greedy(10, Duration.ofMinutes(1));
        Bandwidth limit = Bandwidth.classic(10, refill).withInitialTokens(1);

        Bucket bucket = Bucket4j.builder().addLimit(limit).build();
        registry.addInterceptor(new RateLimitInterceptor(bucket, 1)).addPathPatterns(".*");

        Refill refill2 = Refill.greedy(10, Duration.ofMinutes(1));
        Bandwidth limit2 = Bandwidth.classic(10, refill2);

        Bucket bucket2 = Bucket4j.builder().addLimit(limit2).build();
        registry.addInterceptor(new RateLimitInterceptor(bucket2, 1))
                .addPathPatterns("/ping");
    }

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        LOGGER.info("\uD83D\uDC2C \uD83D\uDC2C \uD83D\uDD36 \uD83D\uDD36 corsConfigurer setting up CORS! \uD83D\uDD36 \uD83D\uDC2C ");

        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(@NotNull CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOrigins("*")
                        .allowedHeaders("*");

                LOGGER.info("\uD83D\uDC2C \uD83D\uDC2C \uD83D\uDD36 \uD83D\uDD36 corsConfigurer CORS mapping set");
            }
        };
    }

    @Override
    public void onApplicationEvent(ApplicationReadyEvent applicationReadyEvent) {
        LOGGER.info("\uD83D\uDC2C \uD83D\uDC2C ApplicationReadyEvent fired! \uD83D\uDC2C "
                .concat(applicationReadyEvent.getApplicationContext().getDisplayName().concat(" \uD83D\uDC2C")));

        try {
            LOGGER.info(Emoji.BURGER.concat(Emoji.BURGER) +
                    " monitorMaxDistanceInMetres: 500 " );
            dataService.initializeFirebase();

            LOGGER.info(Emoji.PRETZEL.concat(Emoji.PRETZEL) + " -------- PRINT SERVICE METHODS AVAILABLE --------- ");
            printServiceMethods(listService.getClass().getMethods(),
                    Emoji.PEAR, "ListService method: ", Emoji.RED_DOT);
            LOGGER.info(Emoji.PEAR + " -------- end of ListService methods ");

            printServiceMethods(dataService.getClass().getMethods(),
                    Emoji.PEACH, "DataService method: ", Emoji.FLOWER_YELLOW);
            LOGGER.info(Emoji.PEACH + " -------- end of DataService methods ");

            printServiceMethods(messageService.getClass().getMethods(), Emoji.BLUE_THINGY, "MessageService method: ", Emoji.BLUE_THINGY);
            LOGGER.info(Emoji.BLUE_THINGY + " -------- end of MessageService methods ");

            printServiceMethods(dataController.getClass().getMethods(), Emoji.BLUE_BIRD, "DataController method: ", Emoji.BLUE_BIRD);
            LOGGER.info(Emoji.BLUE_BIRD + " -------- end of DataController methods ");

            printServiceMethods(listController.getClass().getMethods(), Emoji.YELLOW_BIRD, "ListController method: ", Emoji.YELLOW_BIRD);
            LOGGER.info(Emoji.YELLOW_BIRD + " -------- end of ListController methods ");

            LOGGER.info(Emoji.FERN + " -------- end of Generator methods ");

            List<User> users = (List<User>) userRepository.findAll(Sort.by("organizationId"));

            for (User user : users) {
                LOGGER.info(Emoji.PIG + Emoji.PIG + Emoji.PIG + Emoji.PIG +
                        " User: " + user.getName() + " " + Emoji.FERN
                        + " " + user.getEmail()+ " " + Emoji.YELLOW_DIAMOND + " " + user.getUserType()
                         + " " + Emoji.RED_TRIANGLE + " " + user.getOrganizationName());
            }
            List<com.monitor.backend.data.Project> projects = (List<com.monitor.backend.data.Project>) projectRepository.findAll(Sort.by("organizationName"));

            for (Project project : projects) {
                LOGGER.info(Emoji.WINE + Emoji.WINE + Emoji.WINE + Emoji.WINE +
                        " Project: " + project.getName() + " " + Emoji.FERN
                        + " " + project.getOrganizationName()+ " " + Emoji.YELLOW_DIAMOND
                        + " " + Emoji.RED_TRIANGLE );
            }

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

    @Autowired
    CountryRepository countryRepository;

    @Autowired
    MongoGenerator mongoGenerator;

    @Override
    public void run(String... args) throws Exception {
        LOGGER.info(Emoji.FERN + Emoji.FERN + Emoji.FERN + " CommandLineRunner:run -------- Not doing much for now .... ");


    }
}
