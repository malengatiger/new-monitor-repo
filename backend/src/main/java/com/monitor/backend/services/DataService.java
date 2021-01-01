package com.monitor.backend.services;


import ch.hsr.geohash.GeoHash;
import com.google.api.core.ApiFuture;
import com.google.api.gax.core.CredentialsProvider;
import com.google.api.gax.core.FixedCredentialsProvider;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.auth.oauth2.ServiceAccountCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.UserRecord;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonParser;
import com.monitor.backend.data.*;
import com.monitor.backend.models.*;
import com.monitor.backend.utils.Emoji;
import org.joda.time.DateTime;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import static com.mongodb.client.model.Filters.eq;
import static org.springframework.boot.autoconfigure.condition.ConditionOutcome.match;

@Service
public class DataService {
    public static final Logger LOGGER = LoggerFactory.getLogger(DataService.class.getSimpleName());
    private static final Gson G = new GsonBuilder().setPrettyPrinting().create();

    public DataService() {
        LOGGER.info("\uD83C\uDF4F \uD83C\uDF4F DataService constructed \uD83C\uDF4F");
    }

//    @Value("${databaseUrl}")
    private static final String databaseUrl = "https://monitor-2021.firebaseio.com";
    @Autowired
    private Environment env;
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
    @Autowired
    ProjectPositionRepository projectPositionRepository;


    private boolean isInitialized = false;

    public void initializeFirebase() throws Exception {
        String fbConfig = env.getProperty("FIREBASE_CONFIG");
        CredentialsProvider credentialsProvider = null;
        LOGGER.info("\uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD  " +
                "DataService: initializeFirebase: \uD83C\uDF4E  fbConfig: " + fbConfig);
        FirebaseApp app;

        try {
            if (!isInitialized) {
                LOGGER.info("\uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD  " +
                        "DataService: initializeFirebase: ... \uD83C\uDF4F" +
                        ".... \uD83D\uDC99 \uD83D\uDC99 \uD83D\uDC99 \uD83D\uDC99 monitor FIREBASE URL: "
                        + Emoji.HEART_PURPLE + " " + databaseUrl + " " + Emoji.HEART_BLUE + Emoji.HEART_BLUE);
                if ( fbConfig != null) {
                    credentialsProvider
                            = FixedCredentialsProvider.create(
                            ServiceAccountCredentials.fromStream(new ByteArrayInputStream(fbConfig.getBytes())));
                    LOGGER.info("\uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD " +
                            "credentialsProvider gives us:  \uD83C\uDF4E  "
                            + credentialsProvider.getCredentials().toString() + " \uD83C\uDFBD \uD83C\uDFBD" );
                }
                FirebaseOptions prodOptions;
                if (credentialsProvider != null) {
                    prodOptions = new FirebaseOptions.Builder()
                            .setCredentials((GoogleCredentials) credentialsProvider.getCredentials())
                            .setDatabaseUrl(databaseUrl)
                            .build();

                    app = FirebaseApp.initializeApp(prodOptions);
                    isInitialized = true;

                    LOGGER.info(Emoji.HEART_BLUE + Emoji.HEART_BLUE + "Firebase has been set up and initialized. " +
                            "\uD83D\uDC99 URL: " + app.getOptions().getDatabaseUrl() + " " + Emoji.HAPPY+ Emoji.HAPPY+ Emoji.HAPPY+ Emoji.HAPPY);
                    LOGGER.info(Emoji.HEART_BLUE + Emoji.HEART_BLUE + "Firebase has been set up and initialized. " +
                            "\uD83E\uDD66 Name: " + app.getName() + " " +  Emoji.HEART_ORANGE + Emoji.HEART_ORANGE);

                }



            } else {
                LOGGER.info("\uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD  DataService: initializeFirebase: ... \uD83C\uDF4F" +
                        ".... \uD83D\uDC99 \uD83D\uDC99 isInitialized: " + true + " .... what the fuck? .... \uD83D\uDC99 \uD83D\uDC99 "
                        + Emoji.HEART_PURPLE + Emoji.HEART_BLUE + Emoji.HEART_BLUE);
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
    public User updateUser(User user) {
        userRepository.save(user);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("User updated on database: "
                + user.getName() + " id: "
                + user.getUserId()));
        return user;
    }

    public User addUser(User user) {
       User mUser =  userRepository.save(user);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("User added to database: "
                + user.getName() + " id: "
                + user.getUserId()));
        return mUser;
    }

    public void addPhoto(Photo photo) throws Exception {
        if (photo.getPhotoId() == null) {
            photo.setPhotoId(UUID.randomUUID().toString());
        }
        photoRepository.save(photo);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Photo added: " + photo.get_id()));
        photo.get_id();
    }
    public void addVideo(Video video) throws Exception {
        if (video.getVideoId() == null) {
            video.setVideoId(UUID.randomUUID().toString());
        }
        videoRepository.save(video);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Video added: " + video.get_id()));
        video.get_id();
    }
    public void addCondition(Condition condition) throws Exception {
        conditionRepository.save(condition);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Condition added: " + condition.get_id()));
        condition.get_id();
    }

    public ProjectPosition addProjectPosition(ProjectPosition projectPosition) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("addProjectPosition: "
                .concat(Emoji.FLOWER_YELLOW)));

        ProjectPosition m = projectPositionRepository.save(projectPosition);
        LOGGER.info(Emoji.YELLOW_BIRD + Emoji.YELLOW_BIRD +
                "ProjectPosition added to: " + m.getProjectName()
                + " " + Emoji.RAIN_DROPS);
        List<ProjectPosition> positions =  projectPositionRepository
                .findByProjectId(projectPosition.getProjectId());

        Project project = projectRepository.findByProjectId(projectPosition.getProjectId());
        if (project.getPosition() == null) {
            if (!positions.isEmpty()) {
                project.setPosition(positions.get(0).getPosition());
                projectRepository.save(project);
                LOGGER.info(Emoji.YELLOW_BIRD + Emoji.YELLOW_BIRD +
                        "Project updated with position: " + project.getName()
                         + " " + Emoji.RAIN_DROPS);
            }
        }



        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF)
                .concat("ProjectPosition added: " + projectPosition.getProjectId()));
        return m;
    }


    public com.monitor.backend.data.Project addProject(com.monitor.backend.data.Project project) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("addProject: "
                .concat(project.getName()).concat(" ")
                .concat(Emoji.FLOWER_YELLOW)));

        com.monitor.backend.data.Project m =projectRepository.save(project);

        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF)
                .concat("Project added: " + project.getProjectId()));
        return m;
    }
    public com.monitor.backend.data.Project updateProject(com.monitor.backend.data.Project project) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("updateProject: "
                .concat(project.getName()).concat(" ")
                .concat(Emoji.FLOWER_YELLOW)));

        Project m =projectRepository.save(project);

        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF)
                .concat("Project added: " + project.getProjectId()));
        return m;
    }

    public City addCity(City city) throws Exception {
        city.setCityId(UUID.randomUUID().toString());
        City c = cityRepository.save(city);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF)
                .concat("City added to database : " +  city.getCityId()));
        return c;
    }

    public Community addCommunity(Community community) throws Exception {
        community.setCommunityId(UUID.randomUUID().toString());
        Community cm = communityRepository.save(community);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF)
                .concat("Community: \uD83C\uDF3C "
                        + community.getName()
                + " added to database: \uD83D\uDC24 "
                        + community.getCommunityId()));
        return cm;
    }

    public Country addCountry(Country country) throws Exception {
        country.setCountryId(UUID.randomUUID().toString());

        Country m = countryRepository.save(country);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF)
                .concat("Country added: " + country.getCountryId()));
        return m;
    }

    public Organization addOrganization(Organization organization) throws Exception {
        organization.setOrganizationId(UUID.randomUUID().toString());
        organization.setCreated(new DateTime().toDateTimeISO().toString());

        Organization org = organizationRepository.save(organization);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF)
                .concat("Organization added: " + organization.getOrganizationId()));
        return org;
    }

    public User createUser(User user) throws Exception {
        FirebaseAuth firebaseAuth = FirebaseAuth.getInstance();
        UserRecord.CreateRequest createRequest = new UserRecord.CreateRequest();
        createRequest.setEmail(user.getEmail());
        createRequest.setDisplayName(user.getName());
        createRequest.setPassword(user.getPassword());
        ApiFuture<UserRecord> userRecord = firebaseAuth.createUserAsync(createRequest);
        String uid = userRecord.get().getUid();
        user.setUserId(uid);
        LOGGER.info(Emoji.HEART_ORANGE + Emoji.HEART_ORANGE
                + "Firebase user auth record created: "
                .concat(" \uD83E\uDDE1 ").concat(user.getName()
                        .concat(" \uD83E\uDDE1 ").concat(user.getEmail())
                        .concat(" \uD83E\uDDE1 ").concat(uid)));


        addUser(user);

        return user;

    }
}
