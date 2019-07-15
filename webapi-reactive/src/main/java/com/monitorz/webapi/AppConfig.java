package com.monitorz.webapi;

import com.mongodb.reactivestreams.client.MongoClient;
import com.mongodb.reactivestreams.client.MongoClients;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.config.AbstractReactiveMongoConfiguration;
import org.springframework.data.mongodb.core.ReactiveMongoTemplate;

@Configuration
public class AppConfig  {
//    @Bean
//    public MongoClient mongoClientx() {
//        MongoClient client = MongoClients.create(Constants.CONN_URI);
//        return client;
//    }
//
//    @Override
//    protected String getDatabaseName() {
//        return "monitordb";
//    }
//
    @Bean
    public MongoClient reactiveMongoClient() {
        MongoClient client = MongoClients.create(Constants.CONN_URI);
        return client;
    }

    @Bean
    public ReactiveMongoTemplate reactiveMongoTemplate() {
        ReactiveMongoTemplate template = new ReactiveMongoTemplate(reactiveMongoClient(), "monitordb");
        return template;
    }
}
