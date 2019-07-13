package com.monitorz.webapi.controllers;

import com.monitorz.webapi.data.Questionnaire;
import com.monitorz.webapi.data.repositories.QuestionnaireRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicLong;
import java.util.logging.Level;
import java.util.logging.Logger;


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
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E returning Questionnaire object all \uD83D\uDD35 JSONifified: \uD83C\uDF4E \uD83C\uDF4E " + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        Optional<Questionnaire> city = repository.findById(id);

        return  city.get();
    }
    @PostMapping(value = "/addQuestionnaire")
    @ResponseStatus(code = HttpStatus.CREATED)
    public Questionnaire add(@RequestBody Questionnaire questionnaire) {
        questionnaire.setCreated(sdf.format(new Date()));
        Questionnaire c = repository.save(questionnaire);
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E addQuestionnairey: Questionnaire added  \uD83D\uDD35  \uD83D\uDC99" + c.getName() + " \uD83D\uDC99 \uD83D\uDC99  \uD83D\uDD35 " + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return c;
    }
    @GetMapping(value = "/getQuestionnaires")
    public List<Questionnaire> getQuestionnaires() {
        List<Questionnaire> list = repository.findAll();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E getQuestionnaires found  \uD83D\uDD35 " + list.size() + " \uD83D\uDD35 " + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return list;
    }


    @PutMapping(value = "/updateQuestionnaire")
    public Questionnaire update(@PathVariable String id, @RequestBody Questionnaire project) throws Exception {
        Questionnaire c = repository.findById(id)
                .orElseThrow(() -> new Exception());
        c.setName(project.getName());
        c.setDescription(project.getDescription());
        c.setOrganizationId(project.getOrganizationId());
        c.setOrganizationName(project.getOrganizationName());

        return repository.save(c);
    }
}
