package com.monitor.backend.utils;

import com.monitor.backend.controllers.DataController;
import com.monitor.backend.models.Country;
import com.monitor.backend.models.Organization;
import com.monitor.backend.models.Position;
import com.monitor.backend.models.Project;
import com.monitor.backend.services.DataService;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
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
//-26.140499438 28.037666516
    public void startGeneration() throws Exception {
        setFirstNames();
        setLastNames();
        setOrgNames();

        deleteFirebase();
        generateCountries();

    }

    private void deleteFirebase() throws Exception {

    }
    private void generateCountries() throws Exception {
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
    private void generateOrganizations(List<Country> countries) throws Exception {
        List<Organization> organizations = new ArrayList<>();
        Organization org1 = new Organization(getRandomOrgName(), countries.get(0).getName(),
                "", countries.get(0).getCountryCode(), new DateTime().toDateTimeISO().toString() );
        String id1 = dataService.addOrganization(org1);
        org1.setOrganizationId(id1);
        organizations.add(org1);
        String name = getRandomOrgName();
        Organization org2 = null;
        if (!name.equalsIgnoreCase(org1.getName())) {
            org2 = new Organization(name, countries.get(0).getName(),
                    "", countries.get(0).getCountryCode(), new DateTime().toDateTimeISO().toString() );
            String id2 = dataService.addOrganization(org2);
            org2.setOrganizationId(id2);
            organizations.add(org2);
        }
        name = getRandomOrgName();
        if (org2 != null) {
            if (!name.equalsIgnoreCase(org2.getName())) {
                Organization org3 = new Organization(name, countries.get(0).getName(),
                        "", countries.get(0).getCountryCode(), new DateTime().toDateTimeISO().toString());
                String id2 = dataService.addOrganization(org3);
                org3.setOrganizationId(id2);
                organizations.add(org3);
            }
        }
        LOGGER.info(Emoji.LEAF + Emoji.LEAF + "Organizations generated: " + organizations.size());
        generateProjects(organizations);
    }
    private void generateProjects(List<Organization> organizations) throws Exception {

        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS + Emoji.RAIN_DROPS.concat(" Generating projects ...")));
        for (Organization organization : organizations) {
           addProjects(organization);
        }
    }
    private void generateUsers(List<Organization> organizations) throws Exception {

    }

    private void addProjects(Organization organization) throws Exception {
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
}
