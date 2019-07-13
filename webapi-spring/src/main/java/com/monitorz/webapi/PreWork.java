package com.monitorz.webapi;

import com.monitorz.webapi.data.repositories.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.logging.Level;
import java.util.logging.Logger;

@Component
public class PreWork implements CommandLineRunner {
    private static Logger LOG = Logger.getLogger(PreWork.class.getSimpleName());
    UserRepository userRepository;

    public PreWork(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        LOG.log(Level.INFO, "\uD83D\uDD35\uD83D\uDD35\uD83D\uDD35 If we had work to do, this is where it would start ... \uD83C\uDF4E \uD83C\uDF4E\uD83C\uDF4E \uD83C\uDF4E");
//        MongoClientURI uri = new MongoClientURI(Constants.CONN_URI);
//        MongoClient mongoClient = new MongoClient(uri);
//        MongoDatabase database = mongoClient.getDatabase("monitordb");
//        LOG.log(Level.INFO, "\uD83C\uDF4F \uD83C\uDF4F AppConfig:  \uD83C\uDF4E \uD83C\uDF4E \uD83C\uDF4E \uD83C\uDF4E " +
//                "MongoClient set up. \uD83E\uDD6C\uD83E\uDD6C database: " + database.getName() + " \uD83E\uDD6C\uD83E\uDD6C");
//        MongoCollection<Document> collection = database.getCollection("users");
//
//        try {
//            Block<ChangeStreamDocument<Document>> printBlock = new Block<ChangeStreamDocument<Document>>() {
//                public void apply(final ChangeStreamDocument<Document> changeStreamDocument) {
//                    System.out.println(" MyService:::"+changeStreamDocument.getFullDocument());
//                    LOG.log(Level.INFO, " \uD83C\uDFC8  \uD83C\uDFC8  changes afoot? \uD83C\uDF4E \uD83C\uDF4E \uD83C\uDF4E \uD83C\uDF4E "
//                            + changeStreamDocument.getFullDocument().toJson());
//                }
//            };
//
//            // collection.watch - Establishes a Change Stream on a collection.This will identify any changes happening to the  collection.
//            collection.watch(asList(Aggregates.match(Filters.in("operationType", asList("insert", "update", "replace", "delete")))))
//                    .fullDocument(FullDocument.UPDATE_LOOKUP).forEach(printBlock);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
    }
}
