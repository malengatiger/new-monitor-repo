package com.monitor.backend.services;


import ch.hsr.geohash.GeoHash;
import com.google.api.core.ApiFuture;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.UserRecord;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.monitor.backend.models.*;
import com.monitor.backend.utils.Emoji;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

@Service
public class DataService {
    public static final Logger LOGGER = LoggerFactory.getLogger(DataService.class.getSimpleName());
    private static final Gson G = new GsonBuilder().setPrettyPrinting().create();

    public DataService() {
        LOGGER.info("\uD83C\uDF4F \uD83C\uDF4F DataService constructed \uD83C\uDF4F");
    }

    @Value("${databaseUrl}")
    private String databaseUrl;
    @Autowired
    ProjectRepository projectRepository;
    @Autowired
    CityRepository cityRepository;
    @Autowired
    PhotoRepository photoRepository;
    @Autowired
    VideoRepository videoRepository;
    @Autowired
    UserRepository userRepository;
    @Autowired
    CommunityRepository communityRepository;
    @Autowired
    ConditionRepository conditionRepository;
    @Autowired
    CountryRepository countryRepository;
    @Autowired
    OrganizationRepository organizationRepository;


    private boolean isInitialized = false;

    public void initializeFirebase() throws Exception {
        LOGGER.info("\uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD  DataService: initializeFirebase: ... \uD83C\uDF4F" +
                ".... \uD83D\uDC99 \uD83D\uDC99 isInitialized: " + isInitialized + " \uD83D\uDC99 \uD83D\uDC99 FIREBASE URL: "
                + Emoji.HEART_PURPLE + " " + databaseUrl + " " + Emoji.HEART_BLUE + Emoji.HEART_BLUE);

        FirebaseApp app;
        try {
            if (!isInitialized) {
                GoogleCredentials creds = GoogleCredentials.getApplicationDefault();
                LOGGER.info(Emoji.RED_APPLE.concat(Emoji.RED_APPLE).concat(Emoji.RED_APPLE)
                        .concat("GoogleCredentials: ".concat(creds.toString()).concat(" ").concat(Emoji.FERN)));
                FirebaseOptions prodOptions = new FirebaseOptions.Builder()
                        .setCredentials(creds)
                        .setDatabaseUrl(databaseUrl)
                        .build();

                app = FirebaseApp.initializeApp(prodOptions);
                isInitialized = true;
                LOGGER.info(Emoji.HEART_BLUE + Emoji.HEART_BLUE + "Firebase has been set up and initialized. " +
                        "\uD83D\uDC99 URL: " + app.getOptions().getDatabaseUrl() + Emoji.HAPPY);
                LOGGER.info(Emoji.HEART_BLUE + Emoji.HEART_BLUE + "Firebase has been set up and initialized. " +
                        "\uD83E\uDD66 Name: " + app.getName() + Emoji.HEART_ORANGE + Emoji.HEART_GREEN);

                LOGGER.info(Emoji.HEART_ORANGE + Emoji.HEART_ORANGE + Emoji.HEART_ORANGE + Emoji.HEART_ORANGE +
                        "Firebase Database URL: " + app.getOptions().getDatabaseUrl()
                        + " " + Emoji.RED_APPLE);

            }
        } catch (Exception e) {
            String msg = "Unable to initialize Firebase";
            LOGGER.info(Emoji.ERROR.concat(Emoji.ERROR).concat(msg));
            throw new Exception(msg, e);
        }


    }

    public static String getGeoHash(double latitude, double longitude) {
        return GeoHash.geoHashStringWithCharacterPrecision(latitude, longitude, 12);
    }


    private void addUser(User user) throws Exception {
        user.setUserId(UUID.randomUUID().toString());
        userRepository.save(user);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("User added: "
                + user.getName() + " id: "
                + user.getUserId()));
    }

    public void addPhoto(Photo photo) throws Exception {
        photoRepository.save(photo);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Photo added: " + photo.get_id()));
        photo.get_id();
    }
    public void addVideo(Video video) throws Exception {
        videoRepository.save(video);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Video added: " + video.get_id()));
        video.get_id();
    }
    public void addCondition(Condition condition) throws Exception {
        conditionRepository.save(condition);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Condition added: " + condition.get_id()));
        condition.get_id();
    }

    public String addProjectPosition(String projectId, double latitude, double longitude) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("addProjectPosition: "
                .concat(Emoji.FLOWER_YELLOW)));

        Project project = projectRepository.findByProjectId(projectId);
        if (project == null) {
            throw new Exception("Project not found");
        }
        if (project.getProjectPositions() == null) {
            project.setProjectPositions(new ArrayList<>());
        }
        List<Double> coordinates = new ArrayList<>();
        coordinates.add(longitude);
        coordinates.add(latitude);

        project.getProjectPositions().add(new Position("Point", coordinates));
        projectRepository.save(project);

        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Project added: " + project.getProjectId()));
        return project.getProjectId();
    }

    public String addProject(Project project) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("addProject: "
                .concat(project.getName()).concat(" ")
                .concat(Emoji.FLOWER_YELLOW)));
        project.setProjectId(UUID.randomUUID().toString());

        projectRepository.save(project);

        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Project added: " + project.getProjectId()));
        return project.getProjectId();
    }

    public String addCity(City city) throws Exception {
        city.setCityId(UUID.randomUUID().toString());
        cityRepository.save(city);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("City added to database : " +  city.getCityId()));
        return city.getCityId();
    }

    public String addCommunity(Community community) throws Exception {
        community.setCommunityId(UUID.randomUUID().toString());
        communityRepository.save(community);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Community: \uD83C\uDF3C " + community.getName()
                + " added to database: \uD83D\uDC24 " + community.getCommunityId()));
        return community.getCommunityId();
    }

    public String addCountry(Country country) throws Exception {
        country.setCountryId(UUID.randomUUID().toString());

        countryRepository.save(country);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Country added: " + country.getCountryId()));
        return country.getCountryId();
    }

    public String addOrganization(Organization organization) throws Exception {
        organization.setOrganizationId(UUID.randomUUID().toString());
        organization.setCreated(new DateTime().toDateTimeISO().toString());

        organizationRepository.save(organization);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Organization added: " + organization.getOrganizationId()));
        return organization.getOrganizationId();
    }

    public String createUser(User user, String password) throws Exception {
        FirebaseAuth firebaseAuth = FirebaseAuth.getInstance();
        UserRecord.CreateRequest createRequest = new UserRecord.CreateRequest();
        createRequest.setEmail(user.getEmail());
        createRequest.setDisplayName(user.getName());
        createRequest.setPassword(password);
        ApiFuture<UserRecord> userRecord = firebaseAuth.createUserAsync(createRequest);
        String uid = userRecord.get().getUid();
        user.setUserId(uid);
        LOGGER.info(Emoji.HEART_ORANGE + Emoji.HEART_ORANGE + "Firebase user auth record created: "
                .concat(" \uD83E\uDDE1 ").concat(user.getName().concat(" \uD83E\uDDE1 ").concat(user.getEmail())
                        .concat(" \uD83E\uDDE1 ").concat(Objects.requireNonNull(user.getUserId()))));


        addUser(user);

        return uid;

    }
}
