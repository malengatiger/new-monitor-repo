package com.monitor.backend.utils;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.firebase.auth.ExportedUserRecord;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.ListUsersPage;
import com.google.firebase.cloud.FirestoreClient;
import com.google.gson.Gson;
import com.monitor.backend.models.*;
import com.monitor.backend.services.DataService;
import com.monitor.backend.services.ListService;
import org.joda.time.DateTime;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Random;
import java.util.logging.Logger;

@Service
public class Generator {
    private static final Logger LOGGER = Logger.getLogger(Generator.class.getSimpleName());

    public Generator() {
        LOGGER.info(Emoji.FERN.concat(Emoji.FERN) + "Generator is up and good ".concat(Emoji.FERN));
    }
    @Autowired
    private DataService dataService;
    private static final double latitudeSandton = -26.10499958, longitudeSandton = 28.052499;
    private static final double latitudeHarties = -25.739830374, longitudeHarties = 27.892996428;
    private static final double latitudeLanseria = -25.934042, longitudeLanseria = 27.929928;

    private static final double latitudeRandburg = 	-26.093611, longitudeRandburg  = 28.006390;
    private static final double latitudeRosebank = -26.140499438, longitudeRosebank  = 28.037666516;
    private static final double latitudeJHB = -26.195246, longitudeJHB  = 28.034088;

    public void startGeneration() throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS + Emoji.RAIN_DROPS + Emoji.RAIN_DROPS.concat(" ... startGeneration of Demo Data ...")));
        setFirstNames();
        setLastNames();
        setOrgNames();

        deleteFirebase();
        generateCountries();

    }

    private void deleteFirebase() throws Exception {
        deleteAuthUsers();
        deleteCollections();
    }
    public void generateCountries() throws Exception {
        List<Country> countries = new ArrayList<>();
        Country c1 = new Country(null, "South Africa", "ZAR", latitudeHarties, longitudeHarties);
        Country c2 = new Country(null, "Zimbabwe", "ZIM", latitudeHarties, longitudeHarties);
        String id1 = dataService.addCountry(c1);
        String id2 = dataService.addCountry(c2);
        c1.setCountryId(id1);
        c2.setCountryId(id2);
        countries.add(c1);
        countries.add(c2);
        generateOrganizations(countries);
    }

    @Autowired
    private ListService listService;
    public void migrateCities() throws Exception {
        LOGGER.info(Emoji.FLOWER_RED + Emoji.FLOWER_RED + " Migrating cities at ".concat(" " + new DateTime().toDateTimeISO().toString()));

        DateTime start = new DateTime();
        Country country = listService.getCountryByName("South Africa");
        if (country == null) {
            throw new Exception("South Africa is missing!! " + Emoji.NOT_OK);
        }
        Gson gson = new Gson();

        JSONParser parser = new JSONParser();
        try {
            Object obj = parser.parse(new FileReader("cities.json"));

            JSONObject jsonObject = (JSONObject) obj;
            int cnt = 0;
            for (Object o : jsonObject.keySet()) {
                Double latitude = null;
                Double longitude = null;
                String key = (String)o;
                JSONObject object = (JSONObject) jsonObject.get(key);
                String cityName = (String) object.get("name");
                String province = (String)object.get("provinceName");
                try {
                    latitude = (Double) object.get("latitude");
                    longitude = (Double) object.get("longitude");
                    if (province == null) {
                        province = "Unknown";
                    }
                    if (cityName != null && !cityName.isEmpty()) {
                        City city = new City(cityName, "id", country, province,
                                new Position(latitude, longitude, DataService.getGeoHash(latitude, longitude)));
                        try {
                            dataService.addCity(city);
                            cnt++;
                            LOGGER.info(Emoji.PEAR + Emoji.PEAR + "City #" + cnt +
                                    " " + city.getName() +  " " + city.getProvinceName() + " added to database " + Emoji.RED_DOT);
                        } catch (Exception e) {
                            LOGGER.info(Emoji.NOT_OK + " City add failed: " + city.getName());
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }


            }

            DateTime end = new DateTime();
            long ms = end.toDate().getTime() - start.toDate().getTime();
            long seconds = ms / 1000;
            long minutes = seconds / 60;

            LOGGER.info(Emoji.LEAF + Emoji.LEAF  + Emoji.LEAF + Emoji.LEAF + " Cities migrated: " + cnt + " " + Emoji.RED_APPLE +
                    Emoji.DICE + " minutes elapsed: " + minutes + " " + Emoji.DICE);
            LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + " Cities migrated: " + cnt + " " + Emoji.RED_APPLE +
                    Emoji.DICE + " seconds elapsed: " + seconds + " " + Emoji.DICE + " completed at: " + new DateTime().toDateTimeISO().toString());


        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void generateOrganizations(List<Country> countries) throws Exception {
        List<Organization> organizations = new ArrayList<>();
        Country country = countries.get(0);
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("generateOrganizations: "
                .concat(country.getName()).concat(" ")
                .concat(Emoji.FLOWER_YELLOW)));
        Organization org1 = new Organization(getRandomOrgName(), country.getName(),
                Objects.requireNonNull(country.getCountryId()), country.getCountryCode(), new DateTime().toDateTimeISO().toString() );
        String id1 = dataService.addOrganization(org1);
        org1.setOrganizationId(id1);
        organizations.add(org1);
        String name = getRandomOrgName();
        Organization org2 = null;
        if (!name.equalsIgnoreCase(org1.getName())) {
            org2 = new Organization(name, countries.get(0).getName(),
                    country.getCountryId(), country.getCountryCode(), new DateTime().toDateTimeISO().toString() );
            String id2 = dataService.addOrganization(org2);
            org2.setOrganizationId(id2);
            organizations.add(org2);
        }
        name = getRandomOrgName();
        if (org2 != null) {
            if (!name.equalsIgnoreCase(org2.getName())) {
                Organization org3 = new Organization(name, country.getName(),
                        Objects.requireNonNull(country.getCountryId()), country.getCountryCode(), new DateTime().toDateTimeISO().toString());
                String id2 = dataService.addOrganization(org3);
                org3.setOrganizationId(id2);
                organizations.add(org3);
            }
        }
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + "Organizations generated: " + organizations.size());
        generateProjects(organizations);
    }
    public void generateProjects(List<Organization> organizations) throws Exception {

        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS + Emoji.RAIN_DROPS.concat(" Generating projects ...")));
        for (Organization organization : organizations) {
           addProjects(organization);
        }
        generateUsers(organizations);
    }
    public void generateUsers(List<Organization> organizations) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS + Emoji.RAIN_DROPS.concat(" Generating Users ...")));
        int cnt = 0;
        for (Organization organization : organizations) {
            for (int i = 0; i < 4; i++) {
                String name = getRandomFirstName() + " " + getRandomLastName();
                if (i == 0) {
                    User user = new User(name, "user." + System.currentTimeMillis() + "@monitor.com",
                            "099 999 9999", "userId", Objects.requireNonNull(organization.getOrganizationId()),
                            organization.getName(), new DateTime().toDateTimeISO().toString(), UserType.ORGANIZATION_USER);
                    dataService.createUser(user, "pass123");
                    cnt++;
                }

                if (i == 1 || i == 2) {
                    User user = new User(name, "user." + System.currentTimeMillis() + "@monitor.com",
                            "099 999 9999", "userId", Objects.requireNonNull(organization.getOrganizationId()),
                            organization.getName(), new DateTime().toDateTimeISO().toString(), UserType.MONITOR);
                    dataService.createUser(user, "pass123");
                    cnt++;
                }

                if (i == 3 ) {
                    User user = new User(name, "user." + System.currentTimeMillis() + "@monitor.com",
                            "099 999 9999", "userId", Objects.requireNonNull(organization.getOrganizationId()),
                            organization.getName(), new DateTime().toDateTimeISO().toString(), UserType.EXECUTIVE);
                    dataService.createUser(user, "pass123");
                    cnt++;
                }
            }
        }
        LOGGER.info(Emoji.PEAR + Emoji.PEAR + Emoji.PEAR + " Users added : " + cnt);
    }

    private void addProjects(Organization organization) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("addProjects ...: "
                .concat(organization.getName()).concat(" ")
                .concat(Emoji.FLOWER_YELLOW)));
        int choice = random.nextInt(10);
        if (choice > 5) {
            Project p0 = new Project("", "Lanseria Project H", organization,
                    "Generated Test Project", new DateTime().toDateTimeISO().toString(), new ArrayList<>(),
                    new Position(latitudeLanseria, longitudeLanseria, DataService.getGeoHash(latitudeLanseria, longitudeLanseria)));
            dataService.addProject(p0);
            Project p1 = new Project("", "Sandton Project #" + 1, organization,
                    "Generated Test Project", new DateTime().toDateTimeISO().toString(), new ArrayList<>(),
                    new Position(latitudeSandton, longitudeSandton, DataService.getGeoHash(latitudeSandton, longitudeSandton)));
            dataService.addProject(p1);
            Project p2 = new Project("", "Harties Project Zero", organization,
                    "Generated Test Project", new DateTime().toDateTimeISO().toString(), new ArrayList<>(),
                    new Position(latitudeHarties, longitudeHarties, DataService.getGeoHash(latitudeHarties, longitudeHarties)));
            dataService.addProject(p2);
            Project p3 = new Project("", "Johannesburg Project X", organization,
                    "Generated Test Project", new DateTime().toDateTimeISO().toString(), new ArrayList<>(),
                    new Position(latitudeJHB, longitudeJHB, DataService.getGeoHash(latitudeJHB, longitudeJHB)));
            dataService.addProject(p3);
        } else {
            Project p0 = new Project("", "Harties Project Z", organization,
                    "Generated Test Project", new DateTime().toDateTimeISO().toString(), new ArrayList<>(),
                    new Position(latitudeHarties, longitudeHarties, DataService.getGeoHash(latitudeHarties, longitudeHarties)));
            dataService.addProject(p0);
            Project p1 = new Project("", "Randburg Project A" + 1, organization,
                    "Generated Test Project", new DateTime().toDateTimeISO().toString(), new ArrayList<>(),
                    new Position(latitudeRandburg, longitudeRandburg, DataService.getGeoHash(latitudeRandburg, longitudeRandburg)));
            dataService.addProject(p1);
            Project p2 = new Project("", "Rosebank Project C", organization,
                    "Generated Test Project", new DateTime().toDateTimeISO().toString(), new ArrayList<>(),
                    new Position(latitudeRosebank, longitudeRosebank, DataService.getGeoHash(latitudeRosebank, longitudeRosebank)));
            dataService.addProject(p2);
            Project p3 = new Project("", "Lanseria Project Baker", organization,
                    "Generated Test Project", new DateTime().toDateTimeISO().toString(), new ArrayList<>(),
                    new Position(latitudeLanseria, longitudeLanseria, DataService.getGeoHash(latitudeLanseria, longitudeLanseria)));
            dataService.addProject(p3);
        }
    }

    private final List<Project> projects = new ArrayList<>();
    private final List<String> firstNames = new ArrayList<>();
    private final List<String> lastNames = new ArrayList<>();
    private final List<String> organizationNames = new ArrayList<>();
    private final Random random = new Random(System.currentTimeMillis());

    private String getRandomFirstName() {
        return firstNames.get(random.nextInt(firstNames.size() - 1));
    }
    private String getRandomLastName() {
        return lastNames.get(random.nextInt(lastNames.size() - 1));
    }
    private String getRandomOrgName() {
        return organizationNames.get(random.nextInt(organizationNames.size() - 1));
    }

    private void setOrgNames() {
        organizationNames.add("Housing Agency");
        organizationNames.add("Infrastructure Management");
        organizationNames.add("Project Management");
        organizationNames.add("Gauteng Housing Agency");
        organizationNames.add("Construction Monitors Pty Ltd");
        organizationNames.add("Construction Surveillance Agency");
        organizationNames.add("Peterson Management");
        organizationNames.add("Nelson Infrastructure Management");
        organizationNames.add("Community Project Monitors Ltd");
        organizationNames.add("Afro Management & Monitoring");
        organizationNames.add("Public Housing Monitoring");
        organizationNames.add("Rental Housing Monitoring");


    }
    private void setFirstNames() {
        firstNames.add("Mmaphefo");
        firstNames.add("Nomonde");
        firstNames.add("Nolwazi");
        firstNames.add("Bokgabane");
        firstNames.add("Thabiso");
        firstNames.add("Thabo");
        firstNames.add("Peter");
        firstNames.add("Nelson");
        firstNames.add("David");
        firstNames.add("Maria");
        firstNames.add("Ntozo");
        firstNames.add("Roberta");
        firstNames.add("Dineo");
        firstNames.add("Portia");
        firstNames.add("Helen");
        firstNames.add("Buti");
        firstNames.add("Craig");
        firstNames.add("David");
        firstNames.add("Cyril");
        firstNames.add("Shimange");
        firstNames.add("Bra Z");

    }
    private void setLastNames() {
        lastNames.add("Maluleke");
        lastNames.add("Baloyi");
        lastNames.add("Mthembu");
        lastNames.add("Sithole");
        lastNames.add("Rabane");
        lastNames.add("Mhinga");
        lastNames.add("Ngoasheng");
        lastNames.add("Mokone");
        lastNames.add("Mokoena");
        lastNames.add("Jones");
        lastNames.add("van der Merwe");
        lastNames.add("Nkosi");
        lastNames.add("Maringa");
        lastNames.add("Marule");
        lastNames.add("Fakude");
        lastNames.add("Maroleng");
        lastNames.add("Ntini");
        lastNames.add("Mathebula");
        lastNames.add("Buthelezi");
        lastNames.add("Zulu");
    }


    public List<ExportedUserRecord> getAuthUsers() throws Exception {
        // Start listing users from the beginning, 1000 at a time.
        List<ExportedUserRecord> mList = new ArrayList<>();
        ApiFuture<ListUsersPage> future = FirebaseAuth.getInstance().listUsersAsync(null);
        ListUsersPage page = future.get();
        while (page != null) {
            for (ExportedUserRecord user : page.getValues()) {
                LOGGER.info(Emoji.PIG.concat(Emoji.PIG) + "Auth User: " + user.getDisplayName());
                mList.add(user);
            }
            page = page.getNextPage();
        }

        return mList;
    }

    public void deleteAuthUsers() throws Exception {
        LOGGER.info(Emoji.WARNING.concat(Emoji.WARNING.concat(Emoji.WARNING)
                .concat(" DELETING ALL AUTH USERS from Firebase .... ").concat(Emoji.RED_DOT)));
        List<ExportedUserRecord> list = getAuthUsers();
        for (ExportedUserRecord exportedUserRecord : list) {
            if (!exportedUserRecord.getEmail().equalsIgnoreCase("aubrey@gmail.com")) {
                FirebaseAuth.getInstance().deleteUser(exportedUserRecord.getUid());
                LOGGER.info(Emoji.OK.concat(Emoji.RED_APPLE) + "Successfully deleted user: "
                        .concat(exportedUserRecord.getDisplayName()));
            }
        }
    }

    public void deleteCollections() throws Exception {
        LOGGER.info(Emoji.WARNING.concat(Emoji.WARNING.concat(Emoji.WARNING)
                .concat(" DELETING ALL DATA from Firestore .... ").concat(Emoji.RED_DOT)));
        Firestore fs = FirestoreClient.getFirestore();
        CollectionReference ref1 = fs.collection("countries");
        deleteCollection(ref1, 1000);
//        CollectionReference ref2 = fs.collection("cities");
//        deleteCollection(ref2, 1000);
        CollectionReference ref3 = fs.collection("organizations");
        deleteCollection(ref3, 1000);
        CollectionReference ref4 = fs.collection("projects");
        deleteCollection(ref4, 1000);
        CollectionReference ref5 = fs.collection("users");
        deleteCollection(ref5, 1000);
        CollectionReference ref6 = fs.collection("monitorReports");
        deleteCollection(ref6, 1000);

        LOGGER.info(Emoji.PEAR.concat(Emoji.PEAR.concat(Emoji.PEAR)
                .concat(" DELETED ALL DATA from Firestore .... ").concat(Emoji.RED_TRIANGLE)));
    }

    /**
     * Delete a collection in batches to avoid out-of-memory errors.
     * Batch size may be tuned based on document size (atmost 1MB) and application requirements.
     */
    private void deleteCollection(CollectionReference collection, int batchSize) {
        try {
            // retrieve a small batch of documents to avoid out-of-memory errors
            ApiFuture<QuerySnapshot> future = collection.limit(batchSize).get();
            int deleted = 0;
            // future.get() blocks on document retrieval
            List<QueryDocumentSnapshot> documents = future.get().getDocuments();
            for (QueryDocumentSnapshot document : documents) {
                document.getReference().delete();
                ++deleted;
                LOGGER.info(Emoji.RECYCLE.concat(document.getReference().getPath()
                        .concat(" deleted")));
            }
            if (deleted >= batchSize) {
                // retrieve and delete another batch
                deleteCollection(collection, batchSize);
            }
        } catch (Exception e) {
            LOGGER.info(Emoji.NOT_OK.concat(Emoji.ERROR) + "Error deleting collection : " + e.getMessage());
        }
    }

}
