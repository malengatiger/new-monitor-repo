package com.monitor.backend.utils;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.firebase.auth.ExportedUserRecord;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.ListUsersPage;
import com.google.firebase.cloud.FirestoreClient;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.IndexOptions;
import com.mongodb.client.model.Indexes;
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

    public void generateCountries() throws Exception {
        LOGGER.info(Emoji.DICE + Emoji.DICE + " -------- Generating countries .... ");
        List<Country> countries = new ArrayList<>();
        List<Double> cords = new ArrayList<>();
        cords.add(longitudeHarties);
        cords.add(latitudeHarties);
        Country c1 = new Country("PUBLIC",null,
                UUID.randomUUID().toString(), "South Africa", "ZAR",
                new Position("Point", cords));
        Country c2 = new Country("PUBLIC",null,
                UUID.randomUUID().toString(), "Zimbabwe", "ZIM",
                new Position("Point", cords));

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
        generateOrganizations();
        generateCommunities();
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
                Double latitude = null;
                Double longitude = null;
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
                        City city = new City("PUBLIC",null, cityName.trim(), UUID.randomUUID().toString(), country, province,
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

    /*
    db.members.createIndex( { groupNumber: 1, lastname: 1, firstname: 1 }, { unique: true } )
     */
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
                LOGGER.info("\n\n\n" + Emoji.PEAR + Emoji.PEAR + Emoji.PEAR + Emoji.FERN + Emoji.FERN
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

        String result2 = dbCollection.createIndex(Indexes.ascending("organization.organizationId","name"),
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

    public void generateOrganizations() throws Exception {
        setFirstNames();
        setLastNames();
        setOrgNames();
        setCommunityNames();
        createOrganizationIndexes();
        List<Country> countries = countryRepository.findAll();
        List<Organization> organizations = new ArrayList<>();
        //Generate orgs for South Africa
        Country country = countries.get(0);
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("generateOrganizations: "
                .concat(country.getName()).concat(" ")
                .concat(Emoji.FLOWER_YELLOW)));

        HashMap<String, String> hMap = new HashMap<>();
        while (hMap.keySet().size() < 4) {
            String name = getRandomOrgName();
            if (!hMap.containsKey(name)) {
                hMap.put(name, name);
            }
        }
        Collection<String> fNames = hMap.values();
        for (String name : fNames) {
            Organization org1 = new Organization("PUBLIC",null,name, country.getName(),
                    Objects.requireNonNull(country.getCountryId()), UUID.randomUUID().toString(),
                    new DateTime().toDateTimeISO().toString());
            Organization id1 = organizationRepository.save(org1);
            organizations.add(id1);
            LOGGER.info(Emoji.RAINBOW.concat(Emoji.RAINBOW.concat("Organization has been generated ".concat(org1.getName()
                    .concat(" ").concat(Emoji.RED_APPLE)))));
        }

        LOGGER.info(Emoji.LEAF + Emoji.LEAF + "Organizations generated: " + organizations.size());
        generateProjects(organizations);
    }

    public void generateProjects(List<Organization> organizations) throws Exception {

        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS + Emoji.RAIN_DROPS.concat(" Generating projects ...")));

        createProjectIndexes();
        for (Organization organization : organizations) {
            addProjects(organization);
        }
        generateUsers(organizations);
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
    public void generateUsers(List<Organization> organizations) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS + Emoji.RAIN_DROPS.concat(" Generating Users ...")));
        createUserIndexes();
        int cnt = 0;
        for (Organization organization : organizations) {
            for (int i = 0; i < 4; i++) {
                String name = getRandomFirstName() + " " + getRandomLastName();
                if (i == 0) {
                    User user = new User(organization.getOrganizationId(),null,name, buildEmail("orgadmin"),
                            getRandomCellphone(), "userId", Objects.requireNonNull(organization.getOrganizationId()),
                            organization.getName(), new DateTime().toDateTimeISO().toString(), UserType.ORGANIZATION_USER);
                    userRepository.save(user);
                    //add user to Firebase
                    dataService.createUser(user, "pass123");
                    LOGGER.info(Emoji.FERN + Emoji.FERN + " User saved on MongoDB and Firebase auth " + Emoji.FERN + Emoji.FERN + name);
                    cnt++;
                }

                if (i == 1 || i == 2) {
                    User user = new User(organization.getOrganizationId(),null,name, buildEmail("monitor"),
                            getRandomCellphone(), "userId", Objects.requireNonNull(organization.getOrganizationId()),
                            organization.getName(), new DateTime().toDateTimeISO().toString(), UserType.MONITOR);
                    userRepository.save(user);
                    dataService.createUser(user, "pass123");
                    LOGGER.info(Emoji.FERN + Emoji.FERN + " User saved on MongoDB and Firebase auth " + Emoji.FERN + Emoji.FERN + name);
                    cnt++;
                }

                if (i == 3) {
                    User user = new User(organization.getOrganizationId(),null,name, buildEmail("executive"),
                            getRandomCellphone(), "userId", Objects.requireNonNull(organization.getOrganizationId()),
                            organization.getName(), new DateTime().toDateTimeISO().toString(), UserType.EXECUTIVE);
                    userRepository.save(user);
                    dataService.createUser(user, "pass123");
                    LOGGER.info(Emoji.FERN + Emoji.FERN + " User saved on MongoDB and Firebase auth " + Emoji.FERN + Emoji.FERN + name);
                    cnt++;
                }
            }
        }
        LOGGER.info(Emoji.PEAR + Emoji.PEAR + Emoji.PEAR + " Users added : " + cnt);
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
                .concat(" Generating "+communities.size()+" Communities ...")));
        for (String name : communities) {
            Community c = new Community(country.getCountryId(),null, name,"id",
                    Objects.requireNonNull(country.getCountryId()),getPopulation(),
                    country.getName(),
                    new ArrayList<>(),new ArrayList<>(),new ArrayList<>(),new ArrayList<>());
            Community sComm = communityRepository.save(c);
            LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS + Emoji.RAIN_DROPS
                    .concat(" Community Generated "+sComm.getName()+" on mongodb database "
                    + Emoji.RED_APPLE)));
        }
    }

    public static final String testProjectDesc = "This is the description of a truly transformational project that will change the lives of thousands of people." +
            " The infrastructure built will enhance quality of life and provide opportunities for entrepreneurs and job seekers";

    private int getPopulation() {
        int x = random.nextInt(100);
        return x == 0 ? 100000 : x * 20000;
    }

    private void addProjects(Organization organization) throws Exception {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("addProjects ...: "
                .concat(organization.getName()).concat(" ")
                .concat(Emoji.FLOWER_YELLOW)));
        List<Double> cords = new ArrayList<>();

        cords.add(longitudeLanseria);
        cords.add(latitudeLanseria);
        Project p0 = new Project(organization.getOrganizationId(),null, UUID.randomUUID().toString(),"Lanseria Project H", Objects.requireNonNull(organization.getOrganizationId()),
                testProjectDesc, new DateTime().toDateTimeISO().toString(), new ArrayList<>(),
                new Position("Point", cords));
        projectRepository.save(p0);

        cords.clear();
        cords.add(longitudeSandton);
        cords.add(latitudeSandton);
        Project p1 = new Project(organization.getOrganizationId(),null, UUID.randomUUID().toString(),
                "Sandton Project #" + 1, Objects.requireNonNull(organization.getOrganizationId()),
                testProjectDesc, new DateTime().toDateTimeISO().toString(), new ArrayList<>(),
                new Position("Point", cords));
        projectRepository.save(p1);

        cords.clear();
        cords.add(longitudeHarties);
        cords.add(latitudeHarties);
        Project p2 = new Project(organization.getOrganizationId(),null, UUID.randomUUID().toString(),
                "Harties Project BuildIt", Objects.requireNonNull(organization.getOrganizationId()),
                testProjectDesc, new DateTime().toDateTimeISO().toString(), new ArrayList<>(),
                new Position("Point", cords));
        projectRepository.save(p2);

        cords.clear();
        cords.add(longitudeJHB);
        cords.add(latitudeJHB);
        Project p3 = new Project(organization.getOrganizationId(),null, UUID.randomUUID().toString(),
                "Johannesburg Project X", Objects.requireNonNull(organization.getOrganizationId()),
                testProjectDesc, new DateTime().toDateTimeISO().toString(), new ArrayList<>(),
                new Position("Point", cords));
        projectRepository.save(p3);

    }

    private final List<String> firstNames = new ArrayList<>();
    private final List<String> lastNames = new ArrayList<>();
    private final List<String> organizationNames = new ArrayList<>();
    private final List<String> communities = new ArrayList<>();
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

}
