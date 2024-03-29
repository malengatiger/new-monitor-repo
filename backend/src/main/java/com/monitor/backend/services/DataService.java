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
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.monitor.backend.data.*;
import com.monitor.backend.models.*;
import com.monitor.backend.utils.Emoji;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.util.List;
import java.util.UUID;

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
    GeofenceEventRepository geofenceEventRepository;
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
    @Autowired
    OrgMessageRepository orgMessageRepository;
    @Autowired
    MessageService messageService;
    @Autowired
    FieldMonitorScheduleRepository fieldMonitorScheduleRepository;


    private boolean isInitialized = false;

    public void initializeFirebase() throws Exception {
        String fbConfig = env.getProperty("FIREBASE_CONFIG");
        CredentialsProvider credentialsProvider = null;

        FirebaseApp app;
        try {
            if (!isInitialized) {
                LOGGER.info("\uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD  " +
                        "DataService: initializeFirebase: ... \uD83C\uDF4F" +
                        ".... \uD83D\uDC99 \uD83D\uDC99 \uD83D\uDC99 \uD83D\uDC99 monitor FIREBASE URL: "
                        + Emoji.HEART_PURPLE + " " + databaseUrl + " " + Emoji.HEART_BLUE + Emoji.HEART_BLUE);
                if (fbConfig != null) {
                    credentialsProvider
                            = FixedCredentialsProvider.create(
                            ServiceAccountCredentials.fromStream(new ByteArrayInputStream(fbConfig.getBytes())));
                    LOGGER.info("\uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD " +
                            "credentialsProvider gives us:  \uD83C\uDF4E  "
                            + credentialsProvider.getCredentials().toString() + " \uD83C\uDFBD \uD83C\uDFBD");
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
                            "\uD83D\uDC99 URL: " + app.getOptions().getDatabaseUrl() + " " + Emoji.HAPPY + Emoji.HAPPY + Emoji.HAPPY + Emoji.HAPPY);
                    LOGGER.info(Emoji.HEART_BLUE + Emoji.HEART_BLUE + "Firebase has been set up and initialized. " +
                            "\uD83E\uDD66 Name: " + app.getName() + " " + Emoji.HEART_ORANGE + Emoji.HEART_ORANGE);

                }


            } else {
                LOGGER.info("\uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD  DataService: Firebase is already initialized: ... \uD83C\uDF4F" +
                        ".... \uD83D\uDC99 \uD83D\uDC99 isInitialized: " + true + " \uD83D\uDC99 \uD83D\uDC99 "
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
        userRepository.deleteByUserId(user.getUserId());
        userRepository.save(user);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("User updated on database: "
                + user.getName() + " id: "
                + user.getUserId() + " " + user.getFcmRegistration()));
        return user;
    }

    public User addUser(User user) throws FirebaseMessagingException {
        User mUser = userRepository.save(user);
        String result = messageService.sendMessage(user);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("User added to database: "
                + user.getName() + " result: "
                + result));

        return mUser;
    }

    public String addPhoto(Photo photo) throws Exception {
        if (photo.getPhotoId() == null) {
            photo.setPhotoId(UUID.randomUUID().toString());
        }
        photoRepository.save(photo);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Photo added: " + photo.get_id()));
        return messageService.sendMessage(photo);
    }

    public String addVideo(Video video) throws Exception {
        if (video.getVideoId() == null) {
            video.setVideoId(UUID.randomUUID().toString());
        }
        videoRepository.save(video);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Video added: " + video.get_id()));
        return messageService.sendMessage(video);
    }

    public String addCondition(Condition condition) throws Exception {
        conditionRepository.save(condition);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Condition added: " + condition.get_id()));
        return messageService.sendMessage(condition);
    }

    public OrgMessage addOrgMessage(OrgMessage orgMessage) throws Exception {
        orgMessageRepository.save(orgMessage);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("OrgMessage added: " + orgMessage.getMessage()));
        String result = messageService.sendMessage(orgMessage);
        orgMessage.setResult(result);
        return orgMessage;
    }

    public FieldMonitorSchedule addFieldMonitorSchedule(FieldMonitorSchedule fieldMonitorSchedule) throws Exception {
        fieldMonitorScheduleRepository.save(fieldMonitorSchedule);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("FieldMonitorSchedule added: " + fieldMonitorSchedule.getFieldMonitorId()));
        messageService.sendMessage(fieldMonitorSchedule);

        return fieldMonitorSchedule;
    }

    public ProjectPosition addProjectPosition(ProjectPosition projectPosition) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("addProjectPosition: "
                .concat(Emoji.FLOWER_YELLOW)));

        ProjectPosition m = projectPositionRepository.save(projectPosition);
        LOGGER.info(Emoji.YELLOW_BIRD + Emoji.YELLOW_BIRD +
                "ProjectPosition added to: " + m.getProjectName()
                + " " + Emoji.RAIN_DROPS);

        return m;
    }

    public GeofenceEvent addGeofenceEvent(GeofenceEvent geofenceEvent) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("addGeofenceEvent: "
                .concat(Emoji.FLOWER_YELLOW)));

        GeofenceEvent m = geofenceEventRepository.save(geofenceEvent);
        LOGGER.info(Emoji.YELLOW_BIRD + Emoji.YELLOW_BIRD +
                "GeofenceEvent added to: " + m.getProjectName()
                + " " + Emoji.RAIN_DROPS);


        return m;
    }
    public String addProject(Project project) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("addProject: "
                .concat(project.getName()).concat(" ")
                .concat(Emoji.FLOWER_YELLOW)));

        project = projectRepository.save(project);

        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF)
                .concat("Project added: " + project.getProjectId()));
        return messageService.sendMessage(project);
    }

    public com.monitor.backend.data.Project updateProject(com.monitor.backend.data.Project project) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("updateProject: "
                .concat(project.getName()).concat(" ")
                .concat(Emoji.FLOWER_YELLOW)));

        Project m = projectRepository.save(project);

        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF)
                .concat("Project added: " + project.getProjectId()));
        return m;
    }

    public City addCity(City city) throws Exception {
        city.setCityId(UUID.randomUUID().toString());
        City c = cityRepository.save(city);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF)
                .concat("City added to database : " + city.getCityId()));
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

    public String createUser(User user) throws Exception {
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
        return uid;
    }
}
