package com.monitorz.webapi;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.logging.Level;
import java.util.logging.Logger;

@Component
public class PreWork implements CommandLineRunner {
    private static Logger LOG = Logger.getLogger(PreWork.class.getSimpleName());

    @Override
    public void run(String... args) throws Exception {
        LOG.log(Level.INFO, "\uD83D\uDD35\uD83D\uDD35\uD83D\uDD35 If we had work to do, this is where it would start ... \uD83C\uDF4E \uD83C\uDF4E\uD83C\uDF4E \uD83C\uDF4E");
//        MongoClientURI uri = new MongoClientURI(Constants.CONN_URI);
//        MongoClient mongoClient = new MongoClient(uri);
//        MongoDatabase database = mongoClient.getDatabase("monitordb");
//        LOG.log(Level.INFO, "\uD83C\uDF4F \uD83C\uDF4F AppConfig:  \uD83C\uDF4E \uD83C\uDF4E \uD83C\uDF4E \uD83C\uDF4E " +
//                "MongoClient set up. \uD83E\uDD6C\uD83E\uDD6C database: " + database.getName() + " \uD83E\uDD6C\uD83E\uDD6C");
//        MongoCollection<Document> collection = database.getCollection("users");

//        try {
//            ChangeStreamPublisher<Document> publisher = collection.watch();
//            publisher.
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }

    }
}
