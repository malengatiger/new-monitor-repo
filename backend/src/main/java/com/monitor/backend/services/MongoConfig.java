package com.monitor.backend.services;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.*;
import com.mongodb.client.model.changestream.ChangeStreamDocument;
import com.monitor.backend.models.Photo;
import com.monitor.backend.models.Project;
import com.monitor.backend.models.Video;
import com.monitor.backend.utils.Emoji;
import com.monitor.backend.utils.MongoGenerator;
import org.bson.Document;
import org.bson.codecs.configuration.CodecRegistry;
import org.bson.codecs.pojo.PojoCodecProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.core.MongoTemplate;

import java.util.logging.Logger;

import static org.bson.codecs.configuration.CodecRegistries.fromProviders;
import static org.bson.codecs.configuration.CodecRegistries.fromRegistries;

@Configuration
public class MongoConfig {
    private static final Logger LOGGER = Logger.getLogger(MongoConfig.class.getSimpleName());

    @Value("${spring.data.mongodb.uri}")
    String mongo;

    @Bean
    public MongoClient mongo() {
        LOGGER.info(Emoji.PANDA + Emoji.PANDA + "Connection string: " + Emoji.RED_APPLE + mongo);
        ConnectionString connectionString = new ConnectionString( mongo);
//        MongoClientSettings mongoClientSettings = MongoClientSettings.builder()
//                .applyConnectionString(connectionString)
//                .build();

        LOGGER.info(Emoji.CROISSANT + Emoji.CROISSANT + "MongoClientSettings have been set");
        CodecRegistry pojoCodecRegistry = fromRegistries(MongoClientSettings.getDefaultCodecRegistry(),
                fromProviders(PojoCodecProvider.builder().automatic(true).build()));

        MongoClientSettings settings = MongoClientSettings.builder()
                .applyConnectionString(connectionString)
                .codecRegistry(pojoCodecRegistry)
                .build();

        MongoClient client = MongoClients.create(settings);
        for (Document document : client.listDatabases()) {
            LOGGER.info(Emoji.FROG + Emoji.FROG + "Database Document: " + document.toJson() + Emoji.FROG);
        }
        LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + " ClusterDescription: "
                + client.getClusterDescription().getShortDescription() + Emoji.RED_APPLE + Emoji.RED_APPLE);

//        MongoDatabase db = client.getDatabase("monitordb");

//        com.mongodb.client.MongoCollection<Project> projects = db.getCollection("project", Project.class);
//        ChangeStreamIterable<Project> changeStream = projects.watch();
//        for (ChangeStreamDocument<Project> projectChangeStreamDocument : changeStream) {
//            Project proj = projectChangeStreamDocument.getFullDocument();
//            if (proj != null) {
//                LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + " Project ChangeStream fired! : " + proj.getName());
//            }
//        }
//
//        com.mongodb.client.MongoCollection<Photo> photos = db.getCollection("photo", Photo.class);
//        ChangeStreamIterable<Photo> photosChangeStream = photos.watch();
//        for (ChangeStreamDocument<Photo> mChangeStream : photosChangeStream) {
//            Photo photo = mChangeStream.getFullDocument();
//            if (photo != null) {
//                LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + " Photo ChangeStream fired! : " + photo.getProjectName());
//            }
//        }
//        com.mongodb.client.MongoCollection<Video> videos = db.getCollection("video", Video.class);
//        ChangeStreamIterable<Video> videoChangeStream = videos.watch();
//        for (ChangeStreamDocument<Video> mChangeStream : videoChangeStream) {
//            Video video = mChangeStream.getFullDocument();
//            if (video != null) {
//                LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + " Video ChangeStream fired! : " + video.getProjectName());
//            }
//        }


        return client;


    }

    @Bean
    public MongoTemplate mongoTemplate() throws Exception {
        return new MongoTemplate(mongo(), "monitordb");
    }
}

