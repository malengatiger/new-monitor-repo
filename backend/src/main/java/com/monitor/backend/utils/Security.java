package com.monitor.backend.utils;

import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;

import java.util.logging.Logger;

@EnableWebSecurity
public class Security extends WebSecurityConfigurerAdapter {
    public static final Logger LOGGER = Logger.getLogger(Security.class.getName());

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        LOGGER.info(Emoji.RED_APPLE + Emoji.RED_APPLE   + Emoji.RED_APPLE + Emoji.KEY
                + " Security: configure ... " + Emoji.KEY);
        http
                .authorizeRequests()
                .anyRequest()
                .anonymous()
                .and()
                .csrf().csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse());
    }

}
