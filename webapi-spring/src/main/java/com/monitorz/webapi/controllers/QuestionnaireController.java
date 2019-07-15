package com.monitorz.webapi.controllers;

import com.monitorz.webapi.data.Questionnaire;
import com.monitorz.webapi.data.repositories.QuestionnaireRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
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
public class QuestionnaireController {

    static final Logger LOG = Logger.getLogger(QuestionnaireController.class.getSimpleName());
    static final Locale loc = Locale.getDefault();
    static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX", loc);
    private final AtomicLong counter = new AtomicLong();
    @Autowired
    private QuestionnaireRepository repository;

    @RequestMapping("/getQuestionnaireById")
    public Questionnaire getQuestionnaireById(@RequestParam(value = "id") String id) {

        long num = counter.incrementAndGet();

        Questionnaire qEx = new Questionnaire();
        qEx.setId(id);
        Mono<Questionnaire> qFlux = repository
                .findOne(Example.of(qEx));


        Questionnaire q = qFlux.block();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E returning Questionnaire \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B " + q.getDescription());
        return q;

    }
    @PostMapping(value = "/addQuestionnaire")
    @ResponseStatus(code = HttpStatus.CREATED)
    public Questionnaire add(@RequestBody Questionnaire questionnaire) {
        questionnaire.setCreated(sdf.format(new Date()));
        Mono<Questionnaire> c = repository.save(questionnaire);
        Questionnaire q = c.block();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E addQuestionnairey: Questionnaire added  \uD83D\uDD35  \uD83D\uDC99" + q.getTitle() + " \uD83D\uDC99 \uD83D\uDC99  \uD83D\uDD35 " + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return q;
    }
    @GetMapping(value = "/getQuestionnaires")
    public List<Questionnaire> getQuestionnaires() {
        Flux<Questionnaire> list = repository.findAll();
        List<Questionnaire> m = list.toStream().collect(Collectors.toList());
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E getQuestionnaires found  \uD83D\uDD35 " + m.size() + " \uD83D\uDD35 \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return m;
    }


    @PutMapping(value = "/updateQuestionnaire")
    public Questionnaire update(@PathVariable String id, @RequestBody Questionnaire project) throws Exception {
        Mono<Questionnaire> mc = repository.findById(id);
        Questionnaire c = mc.block();
        c.setName(project.getName());
        c.setDescription(project.getDescription());
        c.setOrganizationId(project.getOrganizationId());
        c.setOrganizationName(project.getOrganizationName());

        return repository.save(c).block();
    }
}
