package com.monitor.backend.utils;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.firebase.auth.ExportedUserRecord;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.ListUsersPage;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.IndexOptions;
import com.mongodb.client.model.Indexes;
import com.monitor.backend.data.*;
import com.monitor.backend.models.*;
import com.monitor.backend.services.DataService;
import com.monitor.backend.services.ListService;
import org.bson.Document;
import org.joda.time.DateTime;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.FileReader;
import java.util.*;
import java.util.logging.Logger;


@Service
public class MongoGenerator {
    private static final Logger LOGGER = Logger.getLogger(MongoGenerator.class.getSimpleName());
    private static final Gson G = new GsonBuilder().setPrettyPrinting().create();

    public MongoGenerator() {
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + "MongoGenerator is up and good ".concat(Emoji.DOLPHIN));
    }

    @Autowired
    private CountryRepository countryRepository;
    @Autowired
    private CityRepository cityRepository;

    private static final double latitudeSandton = -26.10499958, longitudeSandton = 28.052499;
    private static final double latitudeHarties = -25.739830374, longitudeHarties = 27.892996428;
    private static final double latitudeLanseria = -25.934042, longitudeLanseria = 27.929928;

    private static final double latitudeRandburg = -26.093611, longitudeRandburg = 28.006390;
    private static final double latitudeRosebank = -26.140499438, longitudeRosebank = 28.037666516;
    private static final double latitudeJHB = -26.195246, longitudeJHB = 28.034088;

    public void generate() throws Exception {
        LOGGER.info(Emoji.DICE + Emoji.DICE + " -------- Generating countries .... ");
        List<Country> countries = new ArrayList<>();
        List<Double> cords = new ArrayList<>();
        cords.add(longitudeHarties);
        cords.add(latitudeHarties);
        Country c1 = new Country("PUBLIC", null,
                UUID.randomUUID().toString(), "South Africa", "ZAR",
                new com.monitor.backend.data.Position("Point", cords));
        Country c2 = new Country("PUBLIC", null,
                UUID.randomUUID().toString(), "Zimbabwe", "ZIM",
                new com.monitor.backend.data.Position("Point", cords));

        if (countryRepository == null) {
            throw new Exception("CountryRepository is NULL");
        }

        Country southAfrica = countryRepository.insert(c1);
        Country zimbabwe = countryRepository.insert(c2);

        countries.add(southAfrica);
        countries.add(zimbabwe);

        for (Country country : countries) {
            LOGGER.info(Emoji.DICE + Emoji.DICE + " -------- Country: "
                    + country.getName() + " " + Emoji.RED_APPLE);
        }

        deleteAuthUsers();
        processSouthAfricanCities();
        generateOrganizations(8);
        generateCommunities();

        LOGGER.info(Emoji.DICE + Emoji.DICE + Emoji.DICE + Emoji.DICE +
                " ........ Generation completed!! "
                + Emoji.RED_APPLE);
    }

    @Autowired
    private ListService listService;

    public void processSouthAfricanCities() throws Exception {
        createUniqueCityIndex();
        List<Country> countries = countryRepository.findAll();
        for (Country country : countries) {
            if (country.getName().contains("South Africa")) {
                migrateCities(country);
            }
        }

    }

    @Autowired
    MongoClient mongoClient;

    public void migrateCities(Country country) throws Exception {
        LOGGER.info(Emoji.FLOWER_RED + Emoji.FLOWER_RED + Emoji.FLOWER_RED + Emoji.FLOWER_RED
                + " Migrating cities for country: "
                .concat(country.getName())
                .concat(" starting at: " + new DateTime().toDateTimeISO().toString()));

        DateTime start = new DateTime();
        if (cityRepository == null) {
            throw new Exception("cityRepository is missing!! " + Emoji.NOT_OK + Emoji.ERROR);
        }

        List<City> mCities = new ArrayList<>();
        JSONParser parser = new JSONParser();
        try {
            Object obj = parser.parse(new FileReader("cities.json"));
            JSONObject jsonObject = (JSONObject) obj;
            for (Object o : jsonObject.keySet()) {
                Double latitude;
                Double longitude;
                String key = (String) o;
                JSONObject object = (JSONObject) jsonObject.get(key);
                String cityName = (String) object.get("name");
                String province = (String) object.get("provinceName");
                try {
                    try {
                        latitude = (Double) object.get("latitude");
                    } catch (Exception e) {
                        latitude = (Long) object.get("latitude") * 1.0;

                    }
                    try {
                        longitude = (Double) object.get("longitude");
                    } catch (Exception e) {
                        longitude = (Long) object.get("longitude") * 1.0;

                    }

                    if (cityName != null && !cityName.isEmpty() && province != null) {
                        List<Double> cords = new ArrayList<>();
                        if (latitude == null || longitude == null) {
                            throw new Exception("Coordinate is null");
                        }
                        cords.add(longitude);
                        cords.add(latitude);
                        City city = new City("PUBLIC", null, cityName.trim(),
                                UUID.randomUUID().toString(), country.getCountryId(), province,
                                new Position("Point", cords));
                        mCities.add(city);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }


            HashMap<String, City> cityMap = new HashMap<>();
            for (City city : mCities) {
                cityMap.put(city.getName() + city.getProvinceName(), city);
            }
            mCities.clear();
            mCities.addAll(cityMap.values());
            LOGGER.info(Emoji.FERN + Emoji.FERN + Emoji.FERN
                    + "....... Beginning to load " + mCities.size() + " cities to database .....");
            writeBatches(mCities);
            createCityIndexes();
            DateTime end = new DateTime();
            long ms = end.toDate().getTime() - start.toDate().getTime();
            long seconds = ms / 1000;
            long minutes = seconds / 60;

            LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + " Cities migrated: " + cnt + " " + Emoji.RED_APPLE +
                    Emoji.DICE + " minutes elapsed: " + minutes + " " + Emoji.DICE);
            LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + " Cities migrated: " + cnt + " " + Emoji.RED_APPLE +
                    Emoji.DICE + " seconds elapsed: " + seconds + " " + Emoji.DICE + " completed at: " + new DateTime().toDateTimeISO().toString());


        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void createUniqueCityIndex() {
        LOGGER.info(Emoji.FOOTBALL + Emoji.FOOTBALL + "Creating unique index to catch name duplication within province");
        MongoDatabase db = mongoClient.getDatabase("monitordb");
        MongoCollection<Document> dbCollection = db.getCollection("city");

        String result = dbCollection.createIndex(Indexes.ascending("name", "provinceName"), new IndexOptions().unique(true));

        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " City unique index : city name + provinceName - should be created on city collection: " +
                Emoji.RED_APPLE + result);
    }

    private void createCityIndexes() {
        //add index
        MongoDatabase db = mongoClient.getDatabase("monitordb");
        MongoCollection<Document> dbCollection = db.getCollection("city");
        String result = dbCollection.createIndex(Indexes.geo2dsphere("position"));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " City 2dSphere index should be created on city collection: " +
                Emoji.RED_APPLE + result);
        String result2 = dbCollection.createIndex(Indexes.ascending("name"));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " City name index should be created on city collection: " +
                Emoji.RED_APPLE + result2);
        String result3 = dbCollection.createIndex(Indexes.ascending("cityId"));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " City cityId index should be created on city collection: " +
                Emoji.RED_APPLE + result3);
    }

    private void createProjectPositionIndexes() {
        //add index
        MongoDatabase db = mongoClient.getDatabase("monitordb");
        MongoCollection<Document> dbCollection = db.getCollection("projectPosition");
        String result = dbCollection.createIndex(Indexes.geo2dsphere("position"));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " projectPosition 2dSphere index should be created on projectPosition collection: " +
                Emoji.RED_APPLE + result);

        String result2 = dbCollection.createIndex(Indexes.ascending("projectId"));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " projectId index should be created on projectPosition collection: " +
                Emoji.RED_APPLE + result2);

    }

    private void createPhotoIndexes() {
        //add index
        MongoDatabase db = mongoClient.getDatabase("monitordb");
        MongoCollection<Document> dbCollection = db.getCollection("photo");
        String result = dbCollection.createIndex(Indexes.geo2dsphere("projectPosition"));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " photo 2dSphere index should be created on photo collection: " +
                Emoji.RED_APPLE + result);

        String result2 = dbCollection.createIndex(Indexes.ascending("projectId"));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " projectId index should be created on photo collection: " +
                Emoji.RED_APPLE + result2);

    }

    private void createVideoIndexes() {
        //add index
        MongoDatabase db = mongoClient.getDatabase("monitordb");
        MongoCollection<Document> dbCollection = db.getCollection("video");
        String result = dbCollection.createIndex(Indexes.geo2dsphere("projectPosition"));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " photo 2dSphere index should be created on video collection: " +
                Emoji.RED_APPLE + result);

        String result2 = dbCollection.createIndex(Indexes.ascending("projectId"));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " projectId index should be created on video collection: " +
                Emoji.RED_APPLE + result2);

    }

    private static final int BATCH_SIZE = 600;

    private int cnt = 0;

    private void writeBatches(List<City> mCities) {
        int rem = mCities.size() % BATCH_SIZE;
        int pages = mCities.size() / BATCH_SIZE;
        if (rem > 0) {
            pages++;
        }
        int index = 0;
        cnt = 0;
        for (int i = 0; i < pages; i++) {

            List<City> mBatch = new ArrayList<>();
            for (int j = 0; j < BATCH_SIZE; j++) {
                try {
                    mBatch.add(mCities.get(index));
                    index++;

                } catch (Exception e) {
                }
            }
            try {
                List<City> mList = (List<City>) cityRepository.saveAll(mBatch);
                LOGGER.info(Emoji.PEAR + Emoji.PEAR + Emoji.PEAR + Emoji.FERN + Emoji.FERN
                        + Emoji.PEAR + "...... Written to mongo:" +
                        Emoji.RED_APPLE + " CITY BATCH #" + i
                        + " batch size: " + mList.size());
                cnt += mList.size();

            } catch (Exception e) {
                e.printStackTrace();
                LOGGER.info(Emoji.NOT_OK + " City addition fell down hard, BATCH #" + i);
            }
        }


    }


    @Autowired
    OrganizationRepository organizationRepository;
    @Autowired
    ProjectRepository projectRepository;

    @Autowired
    ProjectPositionRepository projectPositionRepository;

    private void createOrganizationIndexes() {
        //add index
        MongoDatabase db = mongoClient.getDatabase("monitordb");
        MongoCollection<Document> dbCollection = db.getCollection("organization");

        String result2 = dbCollection.createIndex(Indexes.ascending("name"),
                new IndexOptions().unique(true));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " Org unique name index should be created on org collection: " +
                Emoji.RED_APPLE + result2);

    }

    private void createProjectIndexes() {
        //add index
        MongoDatabase db = mongoClient.getDatabase("monitordb");
        MongoCollection<Document> dbCollection = db.getCollection("project");

        String result2 = dbCollection.createIndex(Indexes.ascending("organizationId", "name"),
                new IndexOptions().unique(true));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " Project unique name index should be created on Project collection: " +
                Emoji.RED_APPLE + result2);

        String result = dbCollection.createIndex(Indexes.geo2dsphere("position"));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " Project 2dSphere index should be created on project collection: " +
                Emoji.RED_APPLE + result);
    }

    private void createUserIndexes() {
        //add index
        MongoDatabase db = mongoClient.getDatabase("monitordb");
        MongoCollection<Document> dbCollection = db.getCollection("user");

        String result2 = dbCollection.createIndex(Indexes.ascending("email"),
                new IndexOptions().unique(true));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " user unique email index should be created on user collection: " +
                Emoji.RED_APPLE + result2);

        String result = dbCollection.createIndex(Indexes.ascending("cellphone"));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " user cellphone index should be created on user collection: " +
                Emoji.RED_APPLE + result);
    }

    private void createCommunityIndexes() {
        //add index
        MongoDatabase db = mongoClient.getDatabase("monitordb");
        MongoCollection<Document> dbCollection = db.getCollection("community");

        String result2 = dbCollection.createIndex(Indexes.ascending("name", "countryId"),
                new IndexOptions().unique(true));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " user unique name index should be created on community collection: " +
                Emoji.RED_APPLE + result2);

        String result = dbCollection.createIndex(Indexes.ascending("countryId"));
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + Emoji.LEAF + Emoji.LEAF +
                " user countryId index should be created on community collection: " +
                Emoji.RED_APPLE + result);
    }

    public void generateOrganizations(int numberOfOrgs) throws Exception {
        setFirstNames();
        setLastNames();
        setOrgNames();
        setCommunityNames();
        setProjectNames();
        createOrganizationIndexes();
        List<Country> countries = countryRepository.findAll();
        List<Organization> organizations = new ArrayList<>();
        //Generate orgs for South Africa
        Country country = countries.get(0);
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("generateOrganizations: "
                .concat(country.getName()).concat(" ")
                .concat(Emoji.FLOWER_YELLOW)));

        HashMap<String, String> hMap = new HashMap<>();
        while (hMap.keySet().size() < numberOfOrgs) {
            String name = getRandomOrgName();
            if (!hMap.containsKey(name)) {
                hMap.put(name, name);
            }
        }
        Collection<String> orgNames = hMap.values();
        for (String name : orgNames) {
            Organization org1 = new Organization("PUBLIC", null, name, country.getName(),
                    Objects.requireNonNull(country.getCountryId()), UUID.randomUUID().toString(),
                    new DateTime().toDateTimeISO().toString());
            Organization id1 = organizationRepository.save(org1);
            organizations.add(id1);
            LOGGER.info(Emoji.RAINBOW.concat(Emoji.RAINBOW.concat("Organization has been generated ".concat(org1.getName()
                    .concat(" ").concat(Emoji.RED_APPLE)))));
        }

        LOGGER.info(Emoji.LEAF + Emoji.LEAF + "Organizations generated: " + organizations.size());
        generateProjects();
        generateUsers(true);
        generateFieldMonitorSchedules();
    }

    private static final double monitorMaxDistanceInMetres = 500.0;

    @Autowired
    private FieldMonitorScheduleRepository fieldMonitorScheduleRepository;


    public void generateFieldMonitorSchedules() {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS +
                Emoji.RAIN_DROPS.concat(" generateFieldMonitorSchedules ...")));

        Iterator<Organization> iterOrg= organizationRepository.findAll().iterator();

        Iterator<ProjectPosition> iterProj = projectPositionRepository.findAll().iterator();
        List<Organization> orgs = new ArrayList<>();

        while (iterOrg.hasNext()) {
            Organization u = iterOrg.next();
            orgs.add(u);
        }
        for (Organization org : orgs) {
            LOGGER.info("\n\n" + Emoji.BROCCOLI + Emoji.BROCCOLI + Emoji.BROCCOLI + Emoji.BROCCOLI + Emoji.RED_APPLE +"Organization Schedules: " + org.getName());
            List<User> users = userRepository.findByOrganizationId(org.getOrganizationId());
            List<Project> projects = projectRepository.findByOrganizationId(org.getOrganizationId());
            LOGGER.info(Emoji.BROCCOLI + Emoji.BROCCOLI + Emoji.PRETZEL + org.getName() + " Users: " + users.size());
            LOGGER.info(Emoji.BROCCOLI + Emoji.BROCCOLI + Emoji.PRETZEL +org.getName() + " Projects: " + projects.size());
            for (User u : users) {
                for (Project p : projects) {
                    FieldMonitorSchedule schedule = new FieldMonitorSchedule();
                    schedule.setAdminId(null);
                    schedule.setFieldMonitorId(u.getUserId());
                    schedule.setDate(new DateTime().toDateTimeISO().toString());
                    schedule.setFieldMonitorScheduleId(UUID.randomUUID().toString());
                    schedule.setOrganizationId(u.getOrganizationId());
                    schedule.setOrganizationName(u.getOrganizationName());
                    schedule.setFieldMonitorName(u.getName());
                    schedule.setPerDay(3);
                    schedule.setProjectId(p.getProjectId());
                    schedule.setProjectName(p.getName());
                    fieldMonitorScheduleRepository.save(schedule);
                    LOGGER.info(Emoji.BROCCOLI + Emoji.BROCCOLI
                            + "fieldMonitorSchedule added, " +Emoji.RED_APPLE+ " fieldMonitor: " + u.getName() + " - "
                            + " project: " + p.getName());
                }
            }
        }

    }

    public void generateProjects() {
        setLocations();
        List<Organization> organizations = (List<Organization>) organizationRepository.findAll();
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS + Emoji.RAIN_DROPS.concat(" Generating projects ...")));

        createProjectIndexes();
        createProjectPositionIndexes();
        createPhotoIndexes();
        createVideoIndexes();

        for (ProjectLocation loc : projectLocations) {
            //assign this project location to a random organization
            int index = random.nextInt(organizations.size() - 1);
            Organization organization = organizations.get(index);
            List<Double> coordinates = new ArrayList<>();
            coordinates.add(loc.longitude);
            coordinates.add(loc.latitude);


            Position pos = new Position("Point", coordinates);

            Project p0 = new Project(organization.getOrganizationId(), null,
                    UUID.randomUUID().toString(),
                    loc.name,
                    Objects.requireNonNull(organization.getOrganizationId()),
                    testProjectDesc,
                    organization.getName(),
                    monitorMaxDistanceInMetres,
                    new DateTime().toDateTimeISO().toString(), new ArrayList<>());

            List<City> list = listService.findCitiesByLocation(loc.latitude, loc.longitude, 5);
            p0.setNearestCities(list);
            projectRepository.save(p0);

            ProjectPosition pPos = new ProjectPosition(
                    UUID.randomUUID().toString(),
                    Objects.requireNonNull(p0.getProjectId()),
                    pos,
                    p0.getName(),
                    "tbd",
                    new DateTime().toDateTimeISO().toString(), null, new ArrayList<>());

            List<City> list1 = listService.findCitiesByLocation(loc.latitude, loc.longitude, 5);
            pPos.setNearestCities(list1);
            projectPositionRepository.save(pPos);

            LOGGER.info(" \uD83E\uDD6C \uD83E\uDD6C \uD83E\uDD6C " +
                    "Project added, project: \uD83C\uDF4E " + p0.getName() + "\t \uD83C\uDF4E " + p0.getOrganizationName());
        }

        LOGGER.info("\uD83C\uDF3F\uD83C\uDF3F\uD83C\uDF3F\uD83C\uDF3F ORGANIZATIONS on database ....");
        for (Organization organization : organizations) {
            LOGGER.info("\uD83C\uDF3F\uD83C\uDF3F\uD83C\uDF3F " +
                    "Organization: " + organization.getName());
        }


    }

    @Autowired
    UserRepository userRepository;

    @Autowired
    CommunityRepository communityRepository;

    @Autowired
    DataService dataService;

    private String getRandomCellphone() {

        return String.valueOf(random.nextInt(9)) +
                random.nextInt(9) +
                random.nextInt(9) +
                random.nextInt(9) +
                random.nextInt(9) +
                random.nextInt(9) +
                random.nextInt(9) +
                random.nextInt(9) +
                random.nextInt(9) +
                random.nextInt(9);
    }

    public void generateUsers(boolean eraseExistingUsers) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS + Emoji.RAIN_DROPS.concat(" Generating Users ...")));
        List<Organization> organizations = (List<Organization>) organizationRepository.findAll();
        if (eraseExistingUsers) {
            deleteAuthUsers();
        }
        setFirstNames();
        setLastNames();
        setCommunityNames();
        setOrgNames();
        createUserIndexes();
        int cnt = 0;

        for (Organization organization : organizations) {
            for (int i = 0; i < 5; i++) {
                String name = getRandomFirstName() + " " + getRandomLastName();
                if (i == 0) {
                    buildUser(organization, name, "org", Type.USER_TYPE_ORG_ADMINISTRATOR);
                    cnt++;
                }

                if (i == 1 || i == 2 || i == 3) {
                    buildUser(organization, name, "monitor", Type.USER_TYPE_FIELD_MONITOR);
                    cnt++;
                }

                if (i == 4) {
                    buildUser(organization, name, "exec", Type.USER_TYPE_EXECUTIVE);
                    cnt++;
                }
            }
        }
        LOGGER.info(Emoji.PEAR + Emoji.PEAR + Emoji.PEAR + " Users added : " + cnt);
    }

    private void buildUser(Organization org, String userName, String prefix, String userType) throws Exception {

        String email = buildEmail(prefix);
        User u = new User();
        u.setName(getRandomFirstName() + " " + getRandomLastName());
        u.setOrganizationId(org.getOrganizationId());
        u.setOrganizationName(org.getName());
        u.setCellphone(getRandomCellphone());
        u.setEmail(email);
        u.setCreated(new DateTime().toDateTimeISO().toString());
        u.setUserType(userType);
        u.setName(userName);
        u.setUserId(UUID.randomUUID().toString());
        u.setPassword("pass123");

        String uid = dataService.createUser(u);
        u.setUserId(uid);
        u.setPassword(null);
        User result2 = userRepository.save(u);

        LOGGER.info(Emoji.FERN + Emoji.FERN +
                " User saved on MongoDB and Firebase auth: "
                + G.toJson(result2) + Emoji.FERN + Emoji.FERN + u.getName());

    }

    public String buildEmail(String prefix) {
        String s1 = alphabet[random.nextInt(alphabet.length)];
        String s2 = alphabet[random.nextInt(alphabet.length)];
        String s3 = alphabet[random.nextInt(alphabet.length)];
        return prefix.toLowerCase() + "." + s1.toLowerCase() + s2.toLowerCase() + s3.toLowerCase()
                + "@monitor.com".toLowerCase();
    }

    private final String[] alphabet = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
            "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};

    public void generateCommunities() throws Exception {

        createCommunityIndexes();
        List<Country> countries = countryRepository.findAll();
        Country country = null;
        for (Country country1 : countries) {
            if (country1.getName().contains("South Africa")) {
                country = country1;
            }
        }
        if (country == null) {
            throw new Exception("South Africa is not here, Bud!");
        }
        setCommunityNames();
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS + Emoji.RAIN_DROPS
                .concat(" Generating " + communities.size() + " Communities ...")));
        for (String name : communities) {
            Community c = new Community(country.getCountryId(), null, name, "id",
                    Objects.requireNonNull(country.getCountryId()), getPopulation(),
                    country.getName(),
                    new ArrayList<>(), new ArrayList<>(), new ArrayList<>(), new ArrayList<>());
            Community sComm = communityRepository.save(c);
            LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS + Emoji.RAIN_DROPS
                    .concat(" Community Generated " + Emoji.LEMON + Emoji.LEMON +
                            sComm.getName() + " " + Emoji.LEMON + " on mongodb database "
                            + Emoji.RED_APPLE + Emoji.RED_APPLE + Emoji.RED_APPLE)));
        }
    }

    public static final String testProjectDesc = "This is the description of a truly transformational project that will change the lives of thousands of people." +
            " The infrastructure built will enhance quality of life and provide opportunities for entrepreneurs and job seekers";

    private int getPopulation() {
        int x = random.nextInt(100);
        return x == 0 ? 100000 : x * 20000;
    }

    private final List<String> firstNames = new ArrayList<>();
    private final List<String> lastNames = new ArrayList<>();
    private final List<String> organizationNames = new ArrayList<>();
    private final List<String> communities = new ArrayList<>();
    private final List<String> projectNames = new ArrayList<>();

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

    //orgadmin1596705856490@monitor.com
    private void setOrgNames() {
        organizationNames.clear();
        organizationNames.add("Madibeng Municipality");
        organizationNames.add("Sithole RoadBuilders Ltd");
        organizationNames.add("KK Projects Inc.");
        organizationNames.add("Gauteng Housing Agency");
        organizationNames.add("Construction Monitors Pty Ltd");
        organizationNames.add("Construction Surveillance Agency");
        organizationNames.add("Peterson Construction Ltd");
        organizationNames.add("Nelson PK Infrastructure Ltd");
        organizationNames.add("Community Project Monitors Ltd");
        organizationNames.add("Afro Management & Monitoring Pty Ltd");
        organizationNames.add("Roberts InfraCon Lt");
        organizationNames.add("Rental Housing Monitoring");
    }

    private void setCommunityNames() {
        communities.clear();
        communities.add("Freedom Corner");
        communities.add("Marhumbi Community");
        communities.add("Victory Community Settlement");
        communities.add("Informal Dreams Community");
        communities.add("Jerusalema Groove");

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
        firstNames.add("Mokone");
        firstNames.add("Letlotlo");
        firstNames.add("Kgabi");
        firstNames.add("Malenga");
        firstNames.add("Msapa");
        firstNames.add("Musa");
        firstNames.add("Rogers");
        firstNames.add("Portia");
        firstNames.add("Sylvester");
        firstNames.add("David");
        firstNames.add("Nokwanda");
        firstNames.add("Nozipho");
        firstNames.add("Mantoa");
        firstNames.add("Dennis");
        firstNames.add("Vusi");
        firstNames.add("Kenneth");
        firstNames.add("Nana");
        firstNames.add("Vuyelwa");
        firstNames.add("Vuyo");
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
        lastNames.add("Khumalo");
        lastNames.add("Pieterse");
        lastNames.add("Makhatini");
        lastNames.add("Ndlovu");
        lastNames.add("Masemola");
        lastNames.add("Sono");
        lastNames.add("Hlungwane");
        lastNames.add("Makhubela");
        lastNames.add("Mthombeni");
    }

    private void setProjectNames() {
        projectNames.clear();
        projectNames.add("Road Renovation Project");
        projectNames.add("New Road Project");
        projectNames.add("Sanitation Plant Project");
        projectNames.add("School Renovation Project");
        projectNames.add("New School Project");
        projectNames.add("Community Centre Construction");
        projectNames.add("Sport Facility Construction");

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
                if (exportedUserRecord.getDisplayName() != null) {
                    LOGGER.info(Emoji.OK.concat(Emoji.RED_APPLE) + "Successfully deleted user: "
                            .concat(exportedUserRecord.getDisplayName()));
                }
            }
        }
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

    private final List<ProjectLocation> projectLocations = new ArrayList<>();

    private void setLocations() {
        ProjectLocation loc1 = new ProjectLocation(latitudeLanseria, longitudeLanseria, "Lanseria Road Upgrades");
        projectLocations.add(loc1);
        ProjectLocation loc2 = new ProjectLocation(latitudeHarties, longitudeHarties, "HartebeestPoort Shopping Centre");
        projectLocations.add(loc2);
        ProjectLocation loc3 = new ProjectLocation(latitudeJHB, longitudeJHB, "Johannesburg Road ProjectX");
        projectLocations.add(loc3);
        ProjectLocation loc4 = new ProjectLocation(latitudeRandburg, longitudeRandburg, "Randburg Road Upgrades");
        projectLocations.add(loc4);
        ProjectLocation loc5 = new ProjectLocation(latitudeRosebank, longitudeRosebank, "Rosebank Education Complex");
        projectLocations.add(loc5);
        ProjectLocation loc6 = new ProjectLocation(latitudeSandton, longitudeSandton, "Sandton Sanitation Project");
        projectLocations.add(loc6);
        ProjectLocation loc7 = new ProjectLocation(-25.731340, 28.218370, "Pretoria Road Upgrades");
        projectLocations.add(loc7);
        ProjectLocation loc8 = new ProjectLocation(-26.033, 27.983, "Fourways University Construction");
        projectLocations.add(loc8);
        ProjectLocation loc9 = new ProjectLocation(-25.98953, 28.12843, "Midrand Engineering Project");
        projectLocations.add(loc9);
        ProjectLocation loc10 = new ProjectLocation(-26.1844, 27.70203, "Randfontein Road Upgrades");
        projectLocations.add(loc10);
        ProjectLocation loc11 = new ProjectLocation(-26.08577, 27.77515, "Krugersdorp Water & Sanitation Project");
        projectLocations.add(loc11);
        ProjectLocation loc12 = new ProjectLocation(-25.9964, 28.2268, "Tembisa Education Complex");
        projectLocations.add(loc12);
        ProjectLocation loc13 = new ProjectLocation(-25.773, 28.068, "Atteridgeville Road Engineering Project");
        projectLocations.add(loc13);
        ProjectLocation loc14 = new ProjectLocation(-25.77560, 27.85987, "Oberon Water & Sanitation Project");
        projectLocations.add(loc14);
        ProjectLocation loc15 = new ProjectLocation(-25.7605543, 27.8525863, "Kingfisher Drive Road Upgrade");
        projectLocations.add(loc15);
        ProjectLocation loc16 = new ProjectLocation(-25.934042, 27.929928, "Lanseria Electrical SubStation");
        projectLocations.add(loc16);
        ProjectLocation loc17 = new ProjectLocation(-26.26611, 27.865833, "Soweto Water & Sanitation");
        projectLocations.add(loc17);
        ProjectLocation loc18 = new ProjectLocation(-25.93312, 28.01213, "Diepsloot Education Complex");
        projectLocations.add(loc18);
        ProjectLocation loc19 = new ProjectLocation(-26.483333, 27.866667, "Orange Farm Water Works");
        projectLocations.add(loc19);
        ProjectLocation loc20 = new ProjectLocation(-25.762438, 27.854500, "Pecanwood Crescent Dam Works");
        projectLocations.add(loc20);
        ProjectLocation loc21 = new ProjectLocation(-25.756321, 27.854125, "Pecanwood Boat Club Renovations");
        projectLocations.add(loc21);

        LOGGER.info(Emoji.RAINBOW + Emoji.RAINBOW +
                "Test Project Locations have been set: " + projectLocations.size());
    }

    private static class ProjectLocation {
        double latitude, longitude;
        String name;

        public ProjectLocation(double latitude, double longitude, String name) {
            this.latitude = latitude;
            this.longitude = longitude;
            this.name = name;
        }
    }

}
