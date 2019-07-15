package com.monitorz.webapi;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.concurrent.atomic.AtomicLong;
import java.util.logging.Level;
import java.util.logging.Logger;
//thisIsSuchShit03x
@SpringBootApplication
public class WebAPIApplication  {

	static final Logger LOG = Logger.getLogger(WebAPIApplication.class.getSimpleName());
	public static void main(String[] args) {
		LOG.log(Level.INFO, "\uD83D\uDD35\uD83D\uDD35\uD83D\uDD35 SpringBoot for Monitor starting .. \uD83C\uDF4E \uD83C\uDF4E");
		SpringApplication.run(WebAPIApplication.class, args);
		LOG.log(Level.INFO, "\uD83D\uDD35\uD83D\uDD35\uD83D\uDD35 SpringBoot for \uD83E\uDD6C\uD83E\uDD6C Monitor has started .. \uD83C\uDF4E \uD83C\uDF4E");
		LOG.log(Level.INFO, "\uD83D\uDC9B\uD83D\uDC9B\uD83D\uDC9B Monitor Web API \uD83E\uDD6C\uD83E\uDD6C (Spring Boot, MongoDB) \uD83E\uDD6C\uD83E\uDD6C seems to be up and running \uD83C\uDF4E \uD83C\uDF4E "+new Date().toString() +" \uD83C\uDF4E \uD83C\uDF4E "
		+ " \uD83C\uDF4F \uD83C\uDF4F \uD83C\uDF4F ");

	}


	@RestController
	public class PingController {

		private final AtomicLong counter = new AtomicLong();

		@RequestMapping("/ping")
		public String ping() {

			long num = counter.incrementAndGet();
			LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E returning user object all \uD83D\uDD35 JSONifified: \uD83C\uDF4E \uD83C\uDF4E " + num);
			return "\uD83C\uDF4E \uD83C\uDF4E \uD83C\uDF4E \uD83C\uDF4E Monitor Web API: \uD83E\uDDE9 \uD83E\uDDE9 Ping response ...  " +
					"\uD83E\uDDE9 \uD83E\uDDE9 " + num + " \uD83C\uDF4E \uD83C\uDF4E returned. Ola!  \uD83E\uDDE9 \uD83E\uDDE9  \uD83E\uDDE9 \uD83E\uDDE9";
		}

	}

}
/*
@EnableReactiveMongoRepositories
public class MongoReactiveApplication
  extends AbstractReactiveMongoConfiguration {

    @Bean
    public MongoClient mongoClient() {
        return MongoClients.create();
    }

    @Override
    protected String getDatabaseName() {
        return "reactive";
    }
}
 */


