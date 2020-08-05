package com.monitor.backend.services;


import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.monitor.backend.utils.Emoji;
import com.monitor.backend.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ListService {
    public static final Logger LOGGER = LoggerFactory.getLogger(ListService.class.getSimpleName());
    private static final Gson G = new GsonBuilder().setPrettyPrinting().create();
   private  Firestore firestore;

    public ListService() {
        LOGGER.info(Emoji.HEART_BLUE.concat(Emoji.HEART_BLUE) + " ListService constructed \uD83C\uDF4F");
    }

    static final  double lat = 0.0144927536231884; // degrees latitude per mile
    static final  double lon = 0.0181818181818182; // degrees longitude per mile

    public List<Organization> getOrganizations() throws Exception {
        List<Organization> mList = new ArrayList<>();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizations ..."));

        firestore = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = firestore.collection("organizations")
                .orderBy("name")
                .get();
        for (QueryDocumentSnapshot snapshot : future.get()) {
            Organization organization = G.fromJson((JsonElement) snapshot.getData(),Organization.class);
            mList.add(organization);
        }
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizations ... found: " + mList.size()));

        return mList;
    }

    public List<Organization> getCountryOrganizations(String countryId) throws Exception {
        List<Organization> mList = new ArrayList<>();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizations ..."));
        firestore = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = firestore.collection("organizations")
                .whereEqualTo("countryId", countryId)
                .orderBy("name")
                .get();
        for (QueryDocumentSnapshot snapshot : future.get()) {
            Organization organization = G.fromJson((JsonElement) snapshot.getData(),Organization.class);
            mList.add(organization);
        }
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizations ... found: " + mList.size()));

        return mList;
    }

    public List<Project> getNearbyProjects(double latitude, double longitude, double radiusInMiles) throws Exception{
        double lowerLat = latitude - lat * radiusInMiles;
        double lowerLon = longitude - lon * radiusInMiles;

        double upperLat = latitude + lat * radiusInMiles;
        double upperLon = longitude + lon * radiusInMiles;

        String lower = DataService.getGeoHash(lowerLat, lowerLon);
        String  upper = DataService.getGeoHash(upperLat, upperLon);
        List<Project> mList = new ArrayList<>();
        firestore = FirestoreClient.getFirestore();
        QuerySnapshot snapshot = firestore.collection("projects").whereGreaterThanOrEqualTo("position.geohash", lower)
                .whereLessThanOrEqualTo("position.geohash", upper).get().get();
        for (QueryDocumentSnapshot document : snapshot.getDocuments()) {
            Project project = G.fromJson((JsonElement) document.getData(), Project.class);
            mList.add(project);
        }
        LOGGER.info(Emoji.HEART_ORANGE.concat(Emoji.HEART_BLUE).concat("Nearby Projects found: " + mList.size()));
        return mList;
    }

    public List<City> getNearbyCities(double latitude, double longitude, double radiusInMiles) throws Exception{
        double lowerLat = latitude - lat * radiusInMiles;
        double lowerLon = longitude - lon * radiusInMiles;

        double upperLat = latitude + lat * radiusInMiles;
        double upperLon = longitude + lon * radiusInMiles;

        String lower = DataService.getGeoHash(lowerLat, lowerLon);
        String  upper = DataService.getGeoHash(upperLat, upperLon);
        List<City> mList = new ArrayList<>();
        firestore = FirestoreClient.getFirestore();

        QuerySnapshot snapshot = firestore.collection("cities").whereGreaterThanOrEqualTo("position.geohash", lower)
                .whereLessThanOrEqualTo("position.geohash", upper).get().get();
        for (QueryDocumentSnapshot document : snapshot.getDocuments()) {
            City project = G.fromJson((JsonElement) document.getData(), City.class);
            mList.add(project);
        }
        LOGGER.info(Emoji.HEART_ORANGE.concat(Emoji.HEART_BLUE).concat("Nearby Cities found: " + mList.size()));
        return mList;
    }

    public List<MonitorReport> getMonitorReports(String projectId)  throws Exception{
        List<MonitorReport> mList = new ArrayList<>();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getMonitorReports ..."));

        firestore = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = firestore.collection("monitorReports")
                .whereEqualTo("projectId", projectId)
                .get();
        for (QueryDocumentSnapshot snapshot : future.get()) {
            MonitorReport monitorReport = G.fromJson((JsonElement) snapshot.getData(),MonitorReport.class);
            mList.add(monitorReport);
        }
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getMonitorReports ... found: " + mList.size()));

        return mList;
    }

    public List<Project> getOrganizationProjects(String organizationId)  throws Exception{
        List<Project> mList = new ArrayList<>();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationReports ..."));

        firestore = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = firestore.collection("projects")
                .whereEqualTo("organizationId", organizationId)
                .get();
        for (QueryDocumentSnapshot snapshot : future.get()) {
            Project project = G.fromJson((JsonElement) snapshot.getData(),Project.class);
            mList.add(project);
        }
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationProjects ... found: " + mList.size()));

        return mList;
    }

    public List<User> getOrganizationUsers(String organizationId)  throws Exception{
        List<User> mList = new ArrayList<>();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationUsers ..."));

        firestore = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = firestore.collection("users")
                .whereEqualTo("organizationId", organizationId)
                .orderBy("name")
                .get();
        for (QueryDocumentSnapshot snapshot : future.get()) {
            User project = G.fromJson((JsonElement) snapshot.getData(),User.class);
            mList.add(project);
        }
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationUsers ... found: " + mList.size()));

        return mList;
    }

    public List<User> getUsers()  throws Exception{
        List<User> mList = new ArrayList<>();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationUsers ..."));

        firestore = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = firestore.collection("users")
                .orderBy("name")
                .get();
        for (QueryDocumentSnapshot snapshot : future.get()) {
            User project = G.fromJson((JsonElement) snapshot.getData(),User.class);
            mList.add(project);
        }
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationUsers ... found: " + mList.size()));

        return mList;
    }

}
