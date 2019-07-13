package com.monitorz.webapi.controllers;

import com.monitorz.webapi.data.Settlement;
import com.monitorz.webapi.data.repositories.SettlementRepository;
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
public class SettlementController {

    static final Logger LOG = Logger.getLogger(SettlementController.class.getSimpleName());
    static final Locale loc = Locale.getDefault();
    static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX", loc);
    private final AtomicLong counter = new AtomicLong();
    @Autowired
    private SettlementRepository repository;

    @RequestMapping("/findSettlementById")
    public Settlement findSettlementById(@RequestParam(value = "id") String id) {

        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E returning Settlement object all \uD83D\uDD35 JSONifified: \uD83C\uDF4E \uD83C\uDF4E " + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        Optional<Settlement> city = repository.findById(id);

        return  city.get();
    }
    @PostMapping(value = "/addSettlement")
    @ResponseStatus(code = HttpStatus.CREATED)
    public Settlement add(@RequestBody Settlement settlement) {
        settlement.setCreated(sdf.format(new Date()));
        Settlement c = repository.save(settlement);
        c.setCountryId(c.getId());
        c = repository.save(settlement);
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E addSettlementy: Settlement added  \uD83D\uDD35  \uD83D\uDC99" + c.getName() + " \uD83D\uDC99 \uD83D\uDC99  \uD83D\uDD35 " + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return c;
    }
    @GetMapping(value = "/findSettlementsByCountry")
    public List<Settlement> findSettlementsByCountry(String countryId) {
        List<Settlement> list = repository.findSettlementsByCountryId(countryId);
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E findSettlementsByCountry: found  \uD83D\uDD35 " + list.size() + " \uD83D\uDD35 " + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return list;
    }


    @PutMapping(value = "updateSettlement")
    public Settlement update(@PathVariable String id, @RequestBody Settlement settlement) throws Exception {
        Settlement c = repository.findById(id)
                .orElseThrow(() -> new Exception());

        c.setName(settlement.getName());
        c.setEmail(settlement.getEmail());
        c.setCreated(new Date().toString());

        return repository.save(c);
    }
}
