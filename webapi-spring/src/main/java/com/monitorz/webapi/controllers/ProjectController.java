package com.monitorz.webapi.controllers;

import com.monitorz.webapi.data.City;
import com.monitorz.webapi.data.Project;
import com.monitorz.webapi.data.repositories.ProjectRepository;
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
public class ProjectController {

    static final Logger LOG = Logger.getLogger(ProjectController.class.getSimpleName());
    static final Locale loc = Locale.getDefault();
    static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX", loc);
    private final AtomicLong counter = new AtomicLong();
    @Autowired
    private ProjectRepository repository;

    int cnt = 0;
    @RequestMapping("/findProjectsByLocation")
    public List<Project> findProjectsByLocation(@RequestParam(value = "latitude") double latitude, @RequestParam(value = "longitude") double longitude,
                                           @RequestParam(value = "radiusInKM") int radiusInKM) {
        int rad = radiusInKM * 1000;
        List<Project> projects = repository.findByLocation(longitude,latitude,rad);
        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E findProjectsByLocation: returning projects: "+projects.size()+ " radius: " + radiusInKM + " kilometres  \uD83C\uDF4E \uD83C\uDF4E "
                + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        cnt = 0;
        projects.forEach((project) -> {
            cnt++;
            LOG.log(Level.INFO, "\uD83E\uDD6C\uD83E\uDD6C #" + cnt + " " + project.getName() + ", \uD83E\uDDE9 " + project.getDescription());
        });
        return  projects;
    }
    @RequestMapping("/getProjectById")
    public Project getProjectById(@RequestParam(value = "id") String id) {

        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E returning Project object all \uD83D\uDD35 JSONifified: \uD83C\uDF4E \uD83C\uDF4E " + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        Optional<Project> city = repository.findById(id);

        return  city.get();
    }
    @PostMapping(value = "/addProject")
    @ResponseStatus(code = HttpStatus.CREATED)
    public Project add(@RequestBody Project project) {
        project.setCreated(sdf.format(new Date()));
        Project c = repository.save(project);
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E addProjecty: Project added  \uD83D\uDD35  \uD83D\uDC99" + c.getName() + " \uD83D\uDC99 \uD83D\uDC99  \uD83D\uDD35 " + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return c;
    }
    @GetMapping(value = "/getProjects")
    public List<Project> getAllProjects() {
        List<Project> list = repository.findAll();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E getProjects found  \uD83D\uDD35 " + list.size() + " \uD83D\uDD35 " + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return list;
    }

//    @GetMapping(value = "/{id}")
//    public Project getOne(@PathVariable String id) throws Exception {
//        return repository.findById(id)
//                .orElseThrow(() -> new Exception("Project not found"));
//    }
//    @PutMapping(value = "/update/{id}")
//    public Project update(@PathVariable String id, @RequestBody Project project) throws Exception {
//        Project c = repository.findById(id)
//                .orElseThrow(() -> new Exception());
//        c.setName(project.getName());
//
//        return repository.save(c);
//    }
}
