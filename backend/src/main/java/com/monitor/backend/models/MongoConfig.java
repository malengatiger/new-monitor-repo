package com.monitor.backend.models;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.monitor.backend.utils.Emoji;
import com.monitor.backend.utils.MongoGenerator;
import org.bson.Document;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.config.AbstractMongoClientConfiguration;
import org.springframework.data.mongodb.core.MongoTemplate;

import java.util.Collection;
import java.util.Collections;
import java.util.logging.Logger;

@Configuration
public class MongoConfig {
    private static final Logger LOGGER = Logger.getLogger(MongoGenerator.class.getSimpleName());

    @Bean
    public MongoClient mongo() {
        ConnectionString connectionString = new ConnectionString(
                "mongodb+srv://aubrey:ip6nF5IEdBOjEMi6@monitorcluster.nnqij.mongodb.net/monitordb?retryWrites=true&w=majority");
        MongoClientSettings mongoClientSettings = MongoClientSettings.builder()
                .applyConnectionString(connectionString)
                .build();

        LOGGER.info(Emoji.CROISSANT + Emoji.CROISSANT + "MongoClientSettings have been set");

        MongoClient client =  MongoClients.create(mongoClientSettings);
        for (Document document : client.listDatabases()) {
            LOGGER.info(Emoji.FROG + Emoji.FROG + "Database Document: " + document.toJson() + Emoji.FROG);
        }
        LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE + " ClusterDescription: "
                + client.getClusterDescription().getShortDescription() +Emoji.RED_APPLE + Emoji.RED_APPLE );
        return client;
    }

    @Bean
    public MongoTemplate mongoTemplate() throws Exception {
        return new MongoTemplate(mongo(), "monitordb");
    }
}

