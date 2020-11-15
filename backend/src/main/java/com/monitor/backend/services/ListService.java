package com.monitor.backend.services;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.monitor.backend.models.*;
import com.monitor.backend.utils.Emoji;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Metrics;
import org.springframework.data.geo.Point;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ListService {
    public static final Logger LOGGER = LoggerFactory.getLogger(ListService.class.getSimpleName());
    private static final Gson G = new GsonBuilder().setPrettyPrinting().create();
   @Autowired
   CountryRepository countryRepository;
    @Autowired
    CityRepository cityRepository;
    @Autowired
    OrganizationRepository organizationRepository;
    @Autowired
    ProjectRepository projectRepository;
    @Autowired
    CommunityRepository communityRepository;
    @Autowired
    UserRepository userRepository;
    @Autowired
    MonitorReportRepository monitorReportRepository;
    @Autowired
    QuestionnaireRepository questionnaireRepository;
    @Autowired
    PhotoRepository photoRepository;
    @Autowired
    VideoRepository videoRepository;
    @Autowired
    ConditionRepository conditionRepository;

    public ListService() {
        LOGGER.info(Emoji.HEART_BLUE.concat(Emoji.HEART_BLUE) + " ListService constructed \uD83C\uDF4F");
    }

    static final  double lat = 0.0144927536231884; // degrees latitude per mile
    static final  double lon = 0.0181818181818182; // degrees longitude per mile

    public User findUserByEmail(String email) throws Exception {
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("findUserByEmail ...".concat(email)));

        User user = userRepository.findByEmail(email);

       if (user != null) {
           LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("findUserByEmail ... found: \uD83D\uDC24 " + G.toJson(user)));
       } else {
           throw new Exception(Emoji.ALIEN + "User "+email+" not found, probably not registered yet ".concat(Emoji.NOT_OK));
       }
       return user;
    }
    public List<Organization> getOrganizations() throws Exception {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizations ..."));
        List<Organization> mList = (List<Organization>) organizationRepository.findAll();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizations ... found: " + mList.size()));
        return mList;
    }
    public List<Community> getCommunities() throws Exception {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getCommunities ..."));
        List<Community> mList = (List<Community>) communityRepository.findAll();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getCommunities ... found: " + mList.size()));

        return mList;
    }
    public List<Project> getProjects() throws Exception {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("ListService: getProjects ..."));
        List<Project> mList = (List<Project>) projectRepository.findAll();

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("ListService: getProjects ... found:" +
                " \uD83D\uDC24 " + mList.size()));

        return mList;
    }


    public List<Organization> getCountryOrganizations(String countryId) throws Exception {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizations ..."));
        List<Organization> mList = organizationRepository.findByCountryId(countryId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizations ... found: " + mList.size()));

        return mList;
    }

    public List<Photo> getProjectPhotos(String projectId) throws Exception {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getProjectPhotos ..."));
        List<Photo> mList = photoRepository.findByProjectId(projectId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getProjectPhotos ... found: " + mList.size()));

        return mList;
    }
    public List<Video> getProjectVideos(String projectId) throws Exception {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getProjectVideos ..."));
        List<Video> mList = videoRepository.findByProjectId(projectId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getProjectVideos ... found: " + mList.size()));

        return mList;
    }
    public List<Condition> getProjectConditions(String projectId) throws Exception {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getProjectConditions ..."));
        List<Condition> mList = conditionRepository.findByProjectId(projectId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getProjectConditions ... found: " + mList.size()));

        return mList;
    }



    public List<Project> findProjectsByLocation(double latitude, double longitude, double radiusInKM) throws Exception{
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" findProjectsByLocation ..."));
        Point point = new Point(longitude, latitude);
        Distance distance = new Distance(radiusInKM, Metrics.KILOMETERS);
        List<Project> projects = projectRepository.findByPositionNear(point,distance);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN).concat(Emoji.DOLPHIN)
                + " Nearby Projects found: " + projects.size() + " : " + Emoji.RED_APPLE + " radius: " + radiusInKM);
        for (Project project : projects) {
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + project.getName() + ", "
                    + project.getOrganizationId() + " "
                    + Emoji.COFFEE);
        }
        LOGGER.info(Emoji.HEART_ORANGE.concat(Emoji.HEART_ORANGE).concat(
                "findProjectsByLocation: Nearby Projects found: " + projects.size() + " \uD83C\uDF3F"));
        return projects;
    }

    public List<City> getNearbyCities(double latitude, double longitude, double radiusInKM) throws Exception{

        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getNearbyCities ..."));
        Point point = new Point(longitude, latitude);
        Distance distance = new Distance(radiusInKM, Metrics.KILOMETERS);
        List<City> cities = cityRepository.findByPositionNear(point,distance);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN).concat(Emoji.DOLPHIN)
                + " Nearby Cities found: " + cities.size() + " : " + Emoji.RED_APPLE + " radius: " + radiusInKM);
        for (City city : cities) {
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + city.getName() + ", " + city.getProvinceName() + " "
                    + Emoji.COFFEE);
        }
        return cities;
    }

    public List<MonitorReport> getMonitorReports(String projectId)  throws Exception{

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getMonitorReports ..."));
        List<MonitorReport> mList = monitorReportRepository.findByProjectId(projectId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getMonitorReports ... found: " + mList.size()));

        return mList;
    }

    public List<Project> getOrganizationProjects(String organizationId)  throws Exception{

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationReports ..."));
        List<Project> mList = projectRepository.findByOrganizationId(organizationId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationProjects ... found: " + mList.size()));

        return mList;
    }

    public List<User> getOrganizationUsers(String organizationId)  throws Exception{

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationUsers ..."));
        List<User> mList = userRepository.findByOrganizationId(organizationId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationUsers ... found: " + mList.size()));

        return mList;
    }

    public List<User> getUsers()  throws Exception{

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getUsers ..."));
        List<User> mList = (List<User>) userRepository.findAll();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getUsers ... found: " + mList.size()));

        return mList;
    }
    public List<City> getCities()  throws Exception{

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getCities ..."));

        List<City> mList = (List<City>) cityRepository.findAll();
        LOGGER.info(Emoji.RED_CAR.concat(Emoji.RED_CAR).concat("getCities ... found: " + mList.size()));

        return mList;
    }
    public List<Community> findCommunitiesByCountry(String countryId)  throws Exception{

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("findCommunitiesByCountry ..."));

        List<Community> mList = communityRepository.findByCountryId(countryId);
        LOGGER.info(Emoji.RED_CAR.concat(Emoji.RED_CAR).concat("findCommunitiesByCountry ... found: " + mList.size()));

        return mList;
    }
    public List<Questionnaire> getQuestionnairesByOrganization(String organizationId) throws Exception {

        List<Questionnaire> list = questionnaireRepository.findByOrganizationId(organizationId);
        return list;
    }
    public List<Project> findProjectsByOrganization(String organizationId) throws Exception {

        List<Project> list = projectRepository.findByOrganizationId(organizationId);
        return list;
    }
    //
    public List<Country> getCountries()  throws Exception{

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getCountries ..."));

        List<Country> mList = countryRepository.findAll();
        LOGGER.info(Emoji.RED_CAR.concat(Emoji.RED_CAR).concat("getCountries ... found: " + mList.size()));

        return mList;
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
