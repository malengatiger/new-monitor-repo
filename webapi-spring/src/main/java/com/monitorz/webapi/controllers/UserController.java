package com.monitorz.webapi.controllers;

import com.monitorz.webapi.EntityNotFoundException;
import com.monitorz.webapi.data.User;
import com.monitorz.webapi.data.repositories.UserRepository;
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

public class UserController {

    static final Logger LOG = Logger.getLogger(UserController.class.getSimpleName());
    static final Locale loc = Locale.getDefault();
    static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX", loc);
    private final AtomicLong counter = new AtomicLong();
    @Autowired
    UserRepository repository;


    @RequestMapping("/findUsersByOrganization")
    public List<User> getUsersByOrg(@RequestParam(value = "organizationId") String organizationId) {

        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E findUsersByOrganization: returning users \uD83C\uDF4E \uD83C\uDF4E "
                + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        List<User> users = repository.findByOrganizationId(organizationId);
        LOG.log(Level.INFO, "\uD83C\uDF4F\uD83C\uDF4F findUsersByOrganization: \uD83C\uDF4F " + users.size() + " \uD83C\uDF4F");
        return users;
    }

    @RequestMapping("/findUserById")
    public User getUser(@RequestParam(value = "id") String id) {

        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E findUserById: returning user object all \uD83D\uDD35 JSONifified: \uD83C\uDF4E \uD83C\uDF4E "
                + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        Optional<User> user = repository.findById(id);
        return user.get();
    }

    @RequestMapping("/findUserByEmail")
    public User findUserByEmail(@RequestParam(value = "email") String email) throws Exception {
        User user = null;
        try {
            long num = counter.incrementAndGet();
            user = repository.findByEmail(email);
            LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E findUserByEmail: returning user object all \uD83D\uDD35 JSONifified: \uD83C\uDF4E \uD83C\uDF4E "
                    + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
            LOG.log(Level.INFO, user.getFirstName() + " " + user.getLastName() + " email: " + user.getEmail());
        } catch (Exception e) {
            throw new EntityNotFoundException("User not found");
        }
        return user;
    }

    @PostMapping(value = "/addUser")
    @ResponseStatus(code = HttpStatus.CREATED)
    public User add(@RequestBody User user) {
        user.setCreated(sdf.format(new Date()));
        User mUser = repository.save(user);
        mUser.setUserId(mUser.getId());
        mUser = repository.save(user);
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E addUser user added  \uD83D\uDD35  \uD83D\uDC99" + mUser.getUserId() + " \uD83D\uDC99  "
                + mUser.getUserType() + " \uD83D\uDC99  \uD83D\uDD35 " + counter.incrementAndGet()
                + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return mUser;
    }

    @RequestMapping(value = "/findAllUsers")
    public List<User> getAll() {
        List<User> list = repository.findAll();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E getAllUsers found  \uD83D\uDD35 " + list.size() + " \uD83D\uDD35 "
                + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return list;
    }

    @PostMapping(value = "/updateUser")
    public User update(@RequestBody User updatedUser) throws Exception {
        User user = repository.findById(updatedUser.getId())
                .orElseThrow(() -> new Exception());
        user.setEmail(updatedUser.getEmail());
        user.setCellphone(updatedUser.getCellphone());
        return repository.save(user);
    }
}
