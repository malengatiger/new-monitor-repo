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
    }
}
