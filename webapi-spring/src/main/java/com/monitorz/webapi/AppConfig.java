package com.monitorz.webapi;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoDatabase;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.MongoDbFactory;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.SimpleMongoDbFactory;

import java.util.logging.Level;
import java.util.logging.Logger;

@Configuration
public class AppConfig  {
    static final Logger LOG = Logger.getLogger(AppConfig.class.getSimpleName());

    public @Bean
    MongoDbFactory mongoDbFactory() throws Exception {
        MongoClientURI uri = new MongoClientURI(Constants.CONN_URI);
        MongoClient mongoClient = new MongoClient(uri);
        MongoDatabase database = mongoClient.getDatabase("monitordb");
        LOG.log(Level.INFO, "\uD83C\uDF4F \uD83C\uDF4F AppConfig:  \uD83C\uDF4E \uD83C\uDF4E \uD83C\uDF4E \uD83C\uDF4E " +
                "MongoClient set up. \uD83E\uDD6C\uD83E\uDD6C database: " + database.getName() + " \uD83E\uDD6C\uD83E\uDD6C");
        return new SimpleMongoDbFactory(mongoClient, "monitordb");
    }

    public @Bean
    MongoTemplate mongoTemplate() throws Exception {

        MongoTemplate mongoTemplate = new MongoTemplate(mongoDbFactory());
        LOG.log(Level.INFO, "\uD83C\uDF4B \uD83C\uDF4B AppConfig:  \uD83C\uDF4E \uD83C\uDF4E \uD83C\uDF4E \uD83C\uDF4E " +
                "MongoTemplate database: \uD83C\uDFC8 " + mongoTemplate.getDb().getName() + " \uD83C\uDFC8\uD83C\uDFC8");

        return mongoTemplate;

    }

}
