package com.monitorz.webapi;

import com.mongodb.reactivestreams.client.MongoClient;
import com.mongodb.reactivestreams.client.MongoClients;
import com.monitorz.webapi.data.repositories.*;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.config.AbstractReactiveMongoConfiguration;
import org.springframework.data.mongodb.core.ReactiveMongoTemplate;
import org.springframework.data.mongodb.repository.config.EnableReactiveMongoRepositories;

@Configuration
@EnableReactiveMongoRepositories(basePackageClasses = {UserRepository.class, CityRepository.class, CountryRepository.class,
        OrganizationRepository.class, ProjectRepository.class, QuestionnaireRepository.class,
        RespondentRepository.class, SettlementRepository.class})
public class AppConfig extends AbstractReactiveMongoConfiguration {
    @Bean
    public MongoClient mongoClient() {
        MongoClient client = MongoClients.create(Constants.CONN_URI);
        return client;
    }

    @Override
    protected String getDatabaseName() {
        return "monitordb";
    }

    @Override
    public MongoClient reactiveMongoClient() {
        MongoClient client = MongoClients.create(Constants.CONN_URI);
        return client;
    }

    @Bean
    public ReactiveMongoTemplate reactiveMongoTemplate() {
        ReactiveMongoTemplate template = new ReactiveMongoTemplate(reactiveMongoClient(), getDatabaseName());
        return template;
    }
}
