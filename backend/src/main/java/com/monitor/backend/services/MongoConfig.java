package com.monitor.backend.services;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.*;
import com.monitor.backend.utils.Emoji;
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

//    @Value("${spring.data.mongodb.uri}")
//    String mongo;

    static  final String mongoString = "mongodb+srv://aubrey:ip6nF5IEdBOjEMi6@monitorcluster.nnqij.mongodb.net/monitordb?retryWrites=true&w=majority";

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
        for (Document document : client.listDatabases()) {
            LOGGER.info(Emoji.FROG + Emoji.FROG + "Database Document: " + document.toJson() + Emoji.FROG);
        }
        LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + " ClusterDescription: "
                + client.getClusterDescription().getShortDescription() + Emoji.RED_APPLE + Emoji.RED_APPLE);

        return client;


    }

    @Bean
    public MongoTemplate mongoTemplate() throws Exception {
        return new MongoTemplate(mongo(), "monitordb");
    }
}

