package com.monitor.backend.services;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

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

    public User findUserByEmail(String email) throws Exception {
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("findUserByEmail ...".concat(email)));
        firestore = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = firestore.collection("users")
                .whereEqualTo("email", email)
                .limit(1)
                .get();
        User user = null;
        for (QueryDocumentSnapshot snapshot : future.get()) {
           user = G.fromJson(getJSON(snapshot.getData()),User.class);
        }
       if (user != null) {
           LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("findUserByEmail ... found: \uD83D\uDC24 " + G.toJson(user)));
       } else {
           throw new Exception(Emoji.ALIEN + "User "+email+" not found, probably not registered yet ".concat(Emoji.NOT_OK));
       }
       return user;
    }
    public List<Organization> getOrganizations() throws Exception {
        List<Organization> mList = new ArrayList<>();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizations ..."));

        firestore = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = firestore.collection("organizations")
                .orderBy("name")
                .get();
        for (QueryDocumentSnapshot snapshot : future.get()) {
            Organization organization = G.fromJson(getJSON(snapshot.getData()),Organization.class);
            mList.add(organization);
        }
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizations ... found: " + mList.size()));

        return mList;
    }
    public List<Community> getCommunities() throws Exception {
        List<Community> mList = new ArrayList<>();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getCommunities ..."));

        firestore = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = firestore.collection("communities")
                .orderBy("name")
                .get();
        for (QueryDocumentSnapshot snapshot : future.get()) {
            Community community = G.fromJson(getJSON(snapshot.getData()),Community.class);
            mList.add(community);
        }
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getCommunities ... found: " + mList.size()));

        return mList;
    }
    public List<Project> getProjects() throws Exception {
        List<Project> mList = new ArrayList<>();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("ListService: getProjects ..."));

        firestore = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = firestore.collection("projects")
                .orderBy("name")
                .get();
        for (QueryDocumentSnapshot snapshot : future.get()) {
            Project project = G.fromJson(getJSON(snapshot.getData()),Project.class);
            mList.add(project);
        }
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("ListService: getProjects ... found:" +
                " \uD83D\uDC24 " + mList.size()));

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
            Organization organization = G.fromJson(getJSON(snapshot.getData()),Organization.class);
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
            Project project = G.fromJson(getJSON(document.getData()), Project.class);
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
            City project = G.fromJson(getJSON(document.getData()), City.class);
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
            MonitorReport monitorReport = G.fromJson(getJSON(snapshot.getData()),MonitorReport.class);
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
                .whereEqualTo("organization.organizationId", organizationId)
                .get();
        for (QueryDocumentSnapshot snapshot : future.get()) {
            Project project = G.fromJson(getJSON(snapshot.getData()),Project.class);
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
            User project = G.fromJson(getJSON( snapshot.getData()),User.class);
            mList.add(project);
        }
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationUsers ... found: " + mList.size()));

        return mList;
    }

    public List<User> getUsers()  throws Exception{
        List<User> mList = new ArrayList<>();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getUsers ..."));

        firestore = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = firestore.collection("users")
                .orderBy("name")
                .get();
        for (QueryDocumentSnapshot snapshot : future.get()) {
            User project = G.fromJson(getJSON( snapshot.getData()),User.class);
            mList.add(project);
        }
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getUsers ... found: " + mList.size()));

        return mList;
    }
    public List<City> getCities()  throws Exception{
        List<City> mList = new ArrayList<>();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getCities ..."));

        firestore = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = firestore.collection("cities")
                .orderBy("name")
                .get();
        for (QueryDocumentSnapshot snapshot : future.get()) {
            City project = G.fromJson(getJSON( snapshot.getData()),City.class);
            mList.add(project);
        }
        LOGGER.info(Emoji.RED_CAR.concat(Emoji.RED_CAR).concat("getCities ... found: " + mList.size()));

        return mList;
    }
    public List<Community> findCommunitiesByCountry(String countryId)  throws Exception{
        List<Community> mList = new ArrayList<>();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("findCommunitiesByCountry ..."));

        firestore = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = firestore.collection("communities")
                .whereEqualTo("countryId", countryId)
                .orderBy("name")
                .get();
        for (QueryDocumentSnapshot snapshot : future.get()) {
            Community project = G.fromJson(getJSON( snapshot.getData()),Community.class);
            mList.add(project);
        }
        LOGGER.info(Emoji.RED_CAR.concat(Emoji.RED_CAR).concat("findCommunitiesByCountry ... found: " + mList.size()));

        return mList;
    }
    public List<Questionnaire> getQuestionnairesByOrganization(String organizationId) throws Exception {
        firestore = FirestoreClient.getFirestore();
        QuerySnapshot snapshot = firestore.collection("questionnaires")
                .whereEqualTo("organization.organizationId", organizationId)
                .get().get();
        //java.util.HashMap cannot be cast to com.google.gson.JsonElement\n\tat
        List<Questionnaire> list = new ArrayList<>();
        for (QueryDocumentSnapshot shot : snapshot.getDocuments()) {
            list.add( G.fromJson(getJSON(shot.getData()), Questionnaire.class));
        }
        return list;
    }
    public List<Project> findProjectsByOrganization(String organizationId) throws Exception {
        firestore = FirestoreClient.getFirestore();
        QuerySnapshot snapshot = firestore.collection("projects")
                .whereEqualTo("organization.organizationId", organizationId)
                .orderBy("name")
                .get().get();
        //java.util.HashMap cannot be cast to com.google.gson.JsonElement\n\tat
        List<Project> list = new ArrayList<>();
        for (QueryDocumentSnapshot shot : snapshot.getDocuments()) {
            list.add( G.fromJson(getJSON(shot.getData()), Project.class));
        }
        return list;
    }
    //
    public List<Country> getCountries()  throws Exception{
        List<Country> mList = new ArrayList<>();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getCities ..."));

        firestore = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = firestore.collection("countries")
                .orderBy("name")
                .get();
        for (QueryDocumentSnapshot snapshot : future.get()) {
            Country project = G.fromJson(getJSON( snapshot.getData()),Country.class);
            mList.add(project);
        }
        LOGGER.info(Emoji.RED_CAR.concat(Emoji.RED_CAR).concat("getCountries ... found: " + mList.size()));

        return mList;
    }

    public Country getCountryByName(String name) throws Exception {
        firestore = FirestoreClient.getFirestore();
        QuerySnapshot snapshot = firestore.collection("countries").whereEqualTo("name", name)
                .limit(1)
                .get().get();
        //java.util.HashMap cannot be cast to com.google.gson.JsonElement\n\tat
        Country country = null;
        for (QueryDocumentSnapshot shot : snapshot.getDocuments()) {
            country = G.fromJson(getJSON(shot.getData()), Country.class);
        }
        return country;
    }

    private String getJSON(Map<String, Object> hashMap) throws Exception {
        ObjectMapper objectMapper = new ObjectMapper();

        try {
            return objectMapper.writeValueAsString(hashMap);
        } catch (JsonProcessingException e) {
           throw new Exception("JSON parsing failed " + Emoji.NOT_OK);
        }
    }

}
