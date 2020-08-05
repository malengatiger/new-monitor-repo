package com.monitor.backend.services;


import ch.hsr.geohash.GeoHash;
import com.google.api.core.ApiFuture;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.monitor.backend.utils.Emoji;
import com.monitor.backend.models.*;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class DataService {
    public static final Logger LOGGER = LoggerFactory.getLogger(DataService.class.getSimpleName());
    private static final Gson G = new GsonBuilder().setPrettyPrinting().create();
   private  Firestore firestore;

    public DataService() {
        LOGGER.info("\uD83C\uDF4F \uD83C\uDF4F DataService constructed \uD83C\uDF4F");
    }

    @Value("${databaseUrl}")
    private String databaseUrl;

    private boolean isInitialized = false;

    public void initializeFirebase() throws Exception {
        LOGGER.info("\uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD \uD83C\uDFBD  FirebaseService: initializeFirebase: ... \uD83C\uDF4F" +
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
                firestore = FirestoreClient.getFirestore();
                int cnt = 0;
                Iterable<CollectionReference> refs = firestore.listCollections();
                for (CollectionReference listCollection : refs) {
                    cnt++;
                    LOGGER.info(Emoji.RAIN_DROPS + Emoji.RAIN_DROPS + "Collection: #" + cnt + " \uD83D\uDC99 collection: " + listCollection.getId());
                }
                LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Number of Collections in Firestore: " + cnt).concat(" ").concat(Emoji.LEAF));

//                List<Anchor> list = getAnchors();
//                LOGGER.info(Emoji.HEART_BLUE + Emoji.HEART_BLUE +
//                        "Firebase Initialization complete; ... anchors found: " + list.size());
            }
        } catch (Exception e) {
            String msg = "Unable to initialize Firebase";
            LOGGER.info(Emoji.ERROR.concat(Emoji.ERROR).concat(msg));
            throw new Exception(msg, e);
        }


    }

    public static String getGeoHash(double latitude, double longitude) {
        String geoHash = GeoHash.geoHashStringWithCharacterPrecision(latitude,longitude, 12);
        LOGGER.info(Emoji.LEMON.concat(" GeoHash: ").concat(geoHash));
        return geoHash;
    }


    public String addUser(User user) throws Exception {
        user.setUserId(UUID.randomUUID().toString());
        firestore = FirestoreClient.getFirestore();
        ApiFuture<DocumentReference> future = firestore.collection("users").add(user);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("User added: " +  future.get().getPath()));
        return user.getUserId();
    }

    public String addMonitorReport(MonitorReport report) throws Exception {
        report.setMonitorReportId(UUID.randomUUID().toString());
        ApiFuture<DocumentReference> future = firestore.collection("monitorReports").add(report);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("MonitorReport added: " +  future.get().getPath()));
        return report.getMonitorReportId();
    }

    public String addProject(Project project) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("addProject: "
                .concat(project.getName()).concat(" ")
                .concat(Emoji.FLOWER_YELLOW)));
        project.setProjectId(UUID.randomUUID().toString());
        if (project.getPosition().getGeohash() == null) {
            String geoHash = DataService.getGeoHash(project.getPosition().getLatitude(), project.getPosition().getLongitude());
            project.getPosition().setGeohash(geoHash);
        }
        firestore = FirestoreClient.getFirestore();
        ApiFuture<DocumentReference> future = firestore.collection("projects").add(project);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Project added: " +  future.get().getPath()));
        return project.getProjectId();
    }
    public String addCity(City city) throws Exception {
        city.setCityId(UUID.randomUUID().toString());
        firestore = FirestoreClient.getFirestore();
        ApiFuture<DocumentReference> future = firestore.collection("cities").add(city);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("City added: " +  future.get().getPath()));
        return city.getCityId();
    }

    public String addCountry(Country country) throws Exception {
        country.setCountryId(UUID.randomUUID().toString());

        firestore = FirestoreClient.getFirestore();
        ApiFuture<DocumentReference> future = firestore.collection("countries").add(country);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Country added: " +  future.get().getPath()));
        return country.getCountryId();
    }
    public String addOrganization(Organization organization) throws Exception {
        organization.setOrganizationId(UUID.randomUUID().toString());
        organization.setCreated(new DateTime().toDateTimeISO().toString());

        firestore = FirestoreClient.getFirestore();
        ApiFuture<DocumentReference> future = firestore.collection("organizations").add(organization);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("Organization added: " +  future.get().getPath()));
        return organization.getOrganizationId();
    }
}
