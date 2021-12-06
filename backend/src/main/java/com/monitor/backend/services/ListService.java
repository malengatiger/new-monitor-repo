package com.monitor.backend.services;


import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mongodb.client.MongoClient;
import com.monitor.backend.data.Project;
import com.monitor.backend.models.*;
import com.monitor.backend.utils.Emoji;
import lombok.val;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.geo.*;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.monitor.backend.data.*;

@Service
public class ListService {
    public static final Logger LOGGER = LoggerFactory.getLogger(ListService.class.getSimpleName());
    private static final Gson G = new GsonBuilder().setPrettyPrinting().create();
    @Autowired
    GeofenceEventRepository geofenceEventRepository;
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

    @Autowired
    FieldMonitorScheduleRepository fieldMonitorScheduleRepository;

    public ListService() {
        LOGGER.info(Emoji.HEART_BLUE.concat(Emoji.HEART_BLUE) + " ListService constructed \uD83C\uDF4F");
    }

    static final double lat = 0.0144927536231884; // degrees latitude per mile
    static final double lon = 0.0181818181818182; // degrees longitude per mile

    public User findUserByEmail(String email) throws Exception {
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("findUserByEmail ...".concat(email)));

        User user = userRepository.findByEmail(email);

        if (user != null) {
            LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("findUserByEmail ... found: \uD83D\uDC24 " + G.toJson(user)));
        } else {
            throw new Exception(Emoji.ALIEN + "User " + email + " not found, probably not registered yet ".concat(Emoji.NOT_OK));
        }
        return user;
    }
    public List<FieldMonitorSchedule> getProjectFieldMonitorSchedules(String projectId)  {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("getProjectFieldMonitorSchedules: "
                .concat(Emoji.FLOWER_YELLOW)));

        List<FieldMonitorSchedule> m = fieldMonitorScheduleRepository.findByProjectId(projectId);

        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("getProjectFieldMonitorSchedules found: " + m.size()));
        return m;
    }
    public List<FieldMonitorSchedule> getOrgFieldMonitorSchedules(String organizationId)  {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("getOrgFieldMonitorSchedules: "
                .concat(Emoji.FLOWER_YELLOW)));

        List<FieldMonitorSchedule> m = fieldMonitorScheduleRepository.findByOrganizationId(organizationId);

        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("getOrgFieldMonitorSchedules found: " + m.size()));
        return m;
    }
    public List<FieldMonitorSchedule> getMonitorFieldMonitorSchedules(String userId)  {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("getMonitorFieldMonitorSchedules: "
                .concat(Emoji.FLOWER_YELLOW)));

        List<FieldMonitorSchedule> m = fieldMonitorScheduleRepository.findByFieldMonitorId(userId);

        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("getMonitorFieldMonitorSchedules found: " + m.size()));
        return m;
    }
    public List<FieldMonitorSchedule> getAdminFieldMonitorSchedules(String userId)  {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("getOrgFieldMonitorSchedules: "
                .concat(Emoji.FLOWER_YELLOW)));

        List<FieldMonitorSchedule> m = fieldMonitorScheduleRepository.findByAdminId(userId);

        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("getOrgFieldMonitorSchedules found: " + m.size()));
        return m;
    }

    public List<Organization> getOrganizations()  {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizations ..."));
        List<Organization> mList = (List<Organization>) organizationRepository.findAll();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizations ... found: " + mList.size()));
        return mList;
    }

    public List<Community> getCommunities()  {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getCommunities ..."));
        List<Community> mList = (List<Community>) communityRepository.findAll();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getCommunities ... found: " + mList.size()));

        return mList;
    }

    public List<com.monitor.backend.data.Project> getProjects()  {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("ListService: getProjects ..."));
        List<com.monitor.backend.data.Project> mList = (List<com.monitor.backend.data.Project>) projectRepository.findAll();

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("ListService: getProjects ... found:" +
                " \uD83D\uDC24 " + mList.size()));

        return mList;
    }


    public List<Organization> getCountryOrganizations(String countryId)  {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizations ..."));
        List<Organization> mList = organizationRepository.findByCountryId(countryId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizations ... found: " + mList.size()));

        return mList;
    }

    public List<Photo> getProjectPhotos(String projectId)  {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getProjectPhotos ..."));
        List<Photo> mList = photoRepository.findByProjectId(projectId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getProjectPhotos ... found: " + mList.size()));

        return mList;
    }
    public List<Photo> getUserProjectPhotos(String userId)  {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getUserProjectPhotos ...userId: " + userId));
        List<Photo> mList = photoRepository.findByUserId(userId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getUserProjectPhotos ... found: " + mList.size()));

        return mList;
    }
    public List<Video> getUserProjectVideos(String userId)  {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getUserProjectVideos...userId: " + userId));
        List<Video> mList = videoRepository.findByUserId(userId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getUserProjectVideos ... found: " + mList.size()));

        return mList;
    }

    public List<Video> getProjectVideos(String projectId)  {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getProjectVideos ..."));
        List<Video> mList = videoRepository.findByProjectId(projectId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getProjectVideos ... found: " + mList.size()));

        return mList;
    }

    public List<Condition> getProjectConditions(String projectId)  {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getProjectConditions ..."));
        List<Condition> mList = conditionRepository.findByProjectId(projectId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getProjectConditions ... found: " + mList.size()));

        return mList;
    }

    @Autowired
    ProjectPositionRepository projectPositionRepository;

    public List<com.monitor.backend.data.Project> findProjectsByLocation(double latitude, double longitude, double radiusInKM)  {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" findProjectsByLocation ..."));
        Point point = new Point(longitude, latitude);
        Distance distance = new Distance(radiusInKM, Metrics.KILOMETERS);
        List<com.monitor.backend.data.ProjectPosition> projects = projectPositionRepository.findByPositionNear(point, distance);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN).concat(Emoji.DOLPHIN)
                + " Nearby Projects found: " + projects.size() + " : " + Emoji.RED_APPLE + " radius: " + radiusInKM);
        List<com.monitor.backend.data.Project> fList = new ArrayList<>();
        for (com.monitor.backend.data.ProjectPosition projectPosition : projects) {
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + projectPosition.getProjectName() + ", "
                    + Emoji.COFFEE);
            Project p = projectRepository.findByProjectId(projectPosition.getProjectId());
            fList.add(p);
        }
        LOGGER.info(Emoji.HEART_ORANGE.concat(Emoji.HEART_ORANGE).concat(
                "findProjectsByLocation: Nearby Projects found: " + projects.size() + " \uD83C\uDF3F"));
        return fList;
    }

    public List<City> findCitiesByLocation(double latitude, double longitude, double radiusInKM)  {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" findCitiesByLocation ... radiusInKM: " + radiusInKM));
        Point point = new Point(longitude, latitude);
        Distance distance = new Distance(radiusInKM, Metrics.KILOMETERS);
        GeoResults<City> cities = cityRepository.findByPositionNear(point, distance);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN).concat(Emoji.DOLPHIN)
                + " Nearby Cities found: "+ Emoji.RED_APPLE + Emoji.RED_APPLE + cities.getContent().size() + " : "
                + Emoji.RED_APPLE+ Emoji.RED_APPLE + " radiusInKM: " + radiusInKM);
        List<City> list = new ArrayList<>();
        int cnt = 0;
        for (GeoResult<City> city : cities) {
            cnt++;
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN + Emoji.RED_APPLE + Emoji.RED_APPLE)
                    + "#" + cnt + " - " + city.getContent().getName() + ", " + Emoji.DOLPHIN
                    + city.getContent().getProvinceName() + " "
                    + Emoji.COFFEE);
            list.add(city.getContent());

        }
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN + Emoji.RED_APPLE + Emoji.RED_APPLE) + "Total cities found: " + list.size());
        return list;
    }

    @Autowired
    MongoClient mongoClient;

    public int countPhotosByProject(String projectId) {

        int cnt = photoRepository.findByProjectId(projectId).size();
        LOGGER.info(Emoji.HEART_ORANGE.concat(Emoji.HEART_ORANGE)
                + " countPhotosByProject, \uD83C\uDF3F found: " + cnt);
        return cnt;
    }

    public ProjectCount getCountsByProject(String projectId) {

        int photos = photoRepository.findByProjectId(projectId).size();
        int videos = videoRepository.findByProjectId(projectId).size();
        val pc = new ProjectCount(projectId, photos, videos, 0);

        LOGGER.info(Emoji.HEART_ORANGE.concat(Emoji.HEART_ORANGE)
                + " getCountsByProject, \uD83C\uDF3F found: " + G.toJson(pc));
        return pc;
    }
    public UserCount getCountsByUser(String userId) {

        List<Photo> photos = photoRepository.findByUserId(userId);
        List<Video> videos = videoRepository.findByUserId(userId);

        HashMap<String,String> map = new HashMap<>();
        for (Photo photo : photos) {
            map.put(photo.getProjectId(), photo.getProjectId());
        }
        for (Video video : videos) {
            map.put(video.getProjectId(), video.getProjectId());
        }

        val pc = new UserCount(userId, photos.size(), videos.size(), map.size());

        LOGGER.info(Emoji.HEART_ORANGE.concat(Emoji.HEART_ORANGE)
                + " getCountsByUser, \uD83C\uDF3F found: " + G.toJson(pc));
        return pc;
    }

    public int countVideosByProject(String projectId) {

        int cnt = videoRepository.findByProjectId(projectId).size();
        LOGGER.info(Emoji.HEART_ORANGE.concat(Emoji.HEART_ORANGE)
                + " countVideosByProject, \uD83C\uDF3F found: " + cnt);
        return cnt;
    }

    public int countPhotosByUser(String userId) {

        int cnt = photoRepository.findByUserId(userId).size();
        LOGGER.info(Emoji.HEART_ORANGE.concat(Emoji.HEART_ORANGE)
                + " countPhotosByUser, \uD83C\uDF3F found: " + cnt);
        return cnt;
    }

    public int countVideosByUser(String userId) {

        int cnt = videoRepository.findByUserId(userId).size();
        LOGGER.info(Emoji.HEART_ORANGE.concat(Emoji.HEART_ORANGE)
                + " countVideosByUser, \uD83C\uDF3F found: " + cnt);
        return cnt;
    }

    public List<ProjectPosition> findProjectPositionsByLocation(double latitude, double longitude, double radiusInKM)  {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" findProjectPositionsByLocation ..."));
        Point point = new Point(longitude, latitude);
        Distance distance = new Distance(radiusInKM, Metrics.KILOMETERS);
        List<ProjectPosition> positions = projectPositionRepository.findByPositionNear(point, distance);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN).concat(Emoji.DOLPHIN)
                + " Nearby Projects found: " + positions.size() + " : " + Emoji.RED_APPLE + " radius: " + radiusInKM);

        LOGGER.info(Emoji.HEART_ORANGE.concat(Emoji.HEART_ORANGE).concat(
                "findProjectsByLocation: Nearby ProjectPositions found: " + positions.size() + " \uD83C\uDF3F"));
        return positions;
    }

    public List<ProjectPosition> getProjectPositions(String projectId)  {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("getProjectPositions: "
                .concat(Emoji.FLOWER_YELLOW)));

        List<ProjectPosition> m = projectPositionRepository.findByProjectId(projectId);

        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("ProjectPositions found: " + m.size()));
        return m;
    }
    public List<ProjectPosition> getOrganizationProjectPositions(String organizationId)  {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("getOrganizationProjectPositions: "
                .concat(Emoji.FLOWER_YELLOW)));

        List<Project> projects = projectRepository.findByOrganizationId(organizationId);
        List<ProjectPosition> mList = new ArrayList<>();
        for (Project project : projects) {
            List<ProjectPosition> m = projectPositionRepository.findByProjectId(project.getProjectId());
            mList.addAll(m);
        }



        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("OrgProjectPositions found: " + mList.size()));
        return mList;
    }
    public List<GeofenceEvent> getGeofenceEventsByUser(String userId)  {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("getGeofenceEventsByUser: "
                .concat(Emoji.FLOWER_YELLOW)));

        List<GeofenceEvent> events = geofenceEventRepository.findByUserId(userId);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("GeofenceEvents found: " + events.size()));
        return events;
    }
    public List<GeofenceEvent> getGeofenceEventsByProjectPosition(String projectPositionId)  {
        LOGGER.info(Emoji.RAIN_DROPS.concat(Emoji.RAIN_DROPS).concat("getGeofenceEventsByProjectPosition: "
                .concat(Emoji.FLOWER_YELLOW)));

        List<GeofenceEvent> events = geofenceEventRepository.findByProjectPositionId(projectPositionId);
        LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("GeofenceEvents found: " + events.size()));
        return events;
    }

    public List<City> getNearbyCities(double latitude, double longitude, double radiusInKM)  {

        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" getNearbyCities ..."));
        Point point = new Point(longitude, latitude);
        Distance distance = new Distance(radiusInKM, Metrics.KILOMETERS);
        GeoResults<City> cities = cityRepository.findByPositionNear(point, distance);
        LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN).concat(Emoji.DOLPHIN)
                + " Nearby Cities found: " + cities.getContent().size() + " : " + Emoji.RED_APPLE + " radius: " + radiusInKM);
        List<City> list = new ArrayList<>();
        for (GeoResult<City> city : cities) {
            LOGGER.info(Emoji.DOLPHIN.concat(Emoji.DOLPHIN) + city.getContent().getName() + ", " + city.getContent().getProvinceName() + " "
                    + Emoji.COFFEE);
            list.add(city.getContent());
        }
        return list;
    }

    public List<com.monitor.backend.data.Project> getOrganizationProjects(String organizationId)  {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationReports ..."));
        List<com.monitor.backend.data.Project> mList = projectRepository.findByOrganizationId(organizationId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationProjects ... found: " + mList.size()));

        return mList;
    }

    public List<User> getOrganizationUsers(String organizationId)  {

        List<User> mList = userRepository.findByOrganizationId(organizationId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationUsers ... found: " + mList.size()));

        return mList;
    }
    public List<Photo> getOrganizationPhotos(String organizationId)  {

        List<Photo> mList = photoRepository.findByOrganizationId(organizationId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationPhotos ... found: " + mList.size()));

        return mList;
    }
    public List<Video> getOrganizationVideos(String organizationId)  {

        List<Video> mList = videoRepository.findByOrganizationId(organizationId);
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getOrganizationVideos ... found: " + mList.size()));

        return mList;
    }
    public List<User> getUsers()  {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getUsers ..."));
        List<User> mList = (List<User>) userRepository.findAll();
        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getUsers ... found: " + mList.size()));

        return mList;
    }

    public List<City> getCities()  {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getCities ..."));

        List<City> mList = (List<City>) cityRepository.findAll();
        LOGGER.info(Emoji.RED_CAR.concat(Emoji.RED_CAR).concat("getCities ... found: " + mList.size()));

        return mList;
    }

    public List<Community> findCommunitiesByCountry(String countryId)  {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("findCommunitiesByCountry ..."));

        List<Community> mList = communityRepository.findByCountryId(countryId);
        LOGGER.info(Emoji.RED_CAR.concat(Emoji.RED_CAR).concat("findCommunitiesByCountry ... found: " + mList.size()));

        return mList;
    }

    public List<Questionnaire> getQuestionnairesByOrganization(String organizationId)  {

        List<Questionnaire> list = questionnaireRepository.findByOrganizationId(organizationId);
        return list;
    }

    public List<com.monitor.backend.data.Project> findProjectsByOrganization(String organizationId)  {

        List<Project> list = projectRepository.findByOrganizationId(organizationId);
        return list;
    }

    //
    public List<Country> getCountries()  {

        LOGGER.info(Emoji.GLOBE.concat(Emoji.GLOBE).concat("getCountries ..."));

        List<Country> mList = countryRepository.findAll();
        LOGGER.info(Emoji.RED_CAR.concat(Emoji.RED_CAR).concat("getCountries ... found: " + mList.size()));

        return mList;
    }


}
