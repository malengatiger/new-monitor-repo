package com.monitor.backend.services;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.*;
import com.monitor.backend.utils.Emoji;
import org.bson.Document;
import org.bson.codecs.configuration.CodecRegistry;
import org.bson.codecs.pojo.PojoCodecProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.core.MongoTemplate;

import java.util.logging.Logger;

import static org.bson.codecs.configuration.CodecRegistries.fromProviders;
import static org.bson.codecs.configuration.CodecRegistries.fromRegistries;

@EnableCaching
@Configuration
public class MongoConfig {
    private static final Logger LOGGER = Logger.getLogger(MongoConfig.class.getSimpleName());
    private static final Gson G = new GsonBuilder().setPrettyPrinting().create();

//    @Value("${spring.data.mongodb.uri}")
//    mongodb+srv://<username>:<password>@ar001.1xhdt.gcp.mongodb.net/myFirstDatabase?retryWrites=true&w=majority

    static  final String mongoString = "mongodb+srv://monitor:ThreeJacksAndAKing@ar001.1xhdt.gcp.mongodb.net/monitordb?retryWrites=true&w=majority";

    @Bean
    public MongoClient mongo() {
        LOGGER.info(Emoji.PANDA + Emoji.PANDA + "MongoDB Connection string: " + Emoji.RED_APPLE + " = " + mongoString);
        ConnectionString connectionString = new ConnectionString( mongoString);
        LOGGER.info(Emoji.PANDA + Emoji.PANDA + "MongoDB Connection userName: " + Emoji.RED_APPLE + " = " + connectionString.getUsername());

        CodecRegistry pojoCodecRegistry = fromRegistries(MongoClientSettings.getDefaultCodecRegistry(),
                fromProviders(PojoCodecProvider.builder().automatic(true).build()));

        MongoClientSettings settings = MongoClientSettings.builder()
                .applyConnectionString(connectionString)
                .codecRegistry(pojoCodecRegistry)
                .build();

        LOGGER.info(Emoji.CROISSANT + Emoji.CROISSANT + "MongoClientSettings have been set with pojoCodecRegistry");
        MongoClient client = MongoClients.create(settings);
        LOGGER.info(Emoji.CROISSANT + Emoji.CROISSANT + " " + client.listDatabases().iterator().getServerAddress() + " MongoClientSettings have been set with pojoCodecRegistry");
        for (Document document : client.listDatabases()) {
            LOGGER.info(Emoji.FROG + Emoji.FROG + "Database Document: " + document.toJson() + Emoji.FROG);
        }
        LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + " ClusterDescription: "
                + client.getClusterDescription().getShortDescription() + Emoji.RED_APPLE + Emoji.RED_APPLE);
        LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + " Database Name: "
                + client.getDatabase("monitordb").getName() + " " + Emoji.RED_APPLE + Emoji.RED_APPLE);


        return client;


    }

    @Bean
    public MongoTemplate mongoTemplate() throws Exception {
        MongoTemplate t =  new MongoTemplate(mongo(), "monitordb");
        LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + " Monitor DB Collections "+ Emoji.RED_APPLE + Emoji.RED_APPLE);
        for (String collectionName : t.getCollectionNames()) {
            LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + " Collection: "
                    + collectionName + " " + Emoji.BLUE_DOT);
           MongoCollection<Document>  col = t.getCollection(collectionName);

            LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + " Number of Documents: "
                    + col.countDocuments() + " " + Emoji.BLUE_DOT);
            ListIndexesIterable<Document> iter = col.listIndexes();
            for (Document doc : iter) {
                LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + " Index anyone?: "
                        + doc.toJson() + " " + Emoji.BLUE_DOT);
            }
        }

        return t;
    }


}

