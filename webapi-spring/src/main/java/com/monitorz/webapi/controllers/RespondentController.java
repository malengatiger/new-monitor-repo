package com.monitorz.webapi.controllers;

import com.monitorz.webapi.data.Respondent;
import com.monitorz.webapi.data.repositories.RespondentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.atomic.AtomicLong;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;


@RestController
public class RespondentController {

    static final Logger LOG = Logger.getLogger(RespondentController.class.getSimpleName());
    static final Locale loc = Locale.getDefault();
    static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX", loc);
    private final AtomicLong counter = new AtomicLong();
    @Autowired
    RespondentRepository repository;

    @RequestMapping("/getRespondent")
    public Respondent getRespondent(@RequestParam(value = "id") String id) {

        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E returning user object all \uD83D\uDD35 JSONifified: \uD83C\uDF4E \uD83C\uDF4E " + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        Mono<Respondent> user = repository.findById(id);

        return  user.block();
    }
    @PostMapping(value = "/addRespondent")
    @ResponseStatus(code = HttpStatus.CREATED)
    public Respondent add(@RequestBody Respondent respondent) {
        respondent.setCreated(sdf.format(new Date()));
        Respondent mRespondent = repository.save(respondent).block();
        mRespondent.setRespondentId(mRespondent.getId());
        mRespondent = repository.save(respondent).block();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E addRespondent respondent added  \uD83D\uDD35  \uD83D\uDC99" + mRespondent.getEmail() + " \uD83D\uDC99  " + mRespondent.getGender() + " \uD83D\uDC99  \uD83D\uDD35 " + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return mRespondent;
    }
    @GetMapping(value = "/getAllRespondents")
    public List<Respondent> getAllRespondents() {
        Flux<Respondent> list = repository.findAll();
        List<Respondent> m = list.toStream().collect(Collectors.toList());;
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E getAllRespondents found  \uD83D\uDD35 " + m.size() + "  \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return m;
    }

}
