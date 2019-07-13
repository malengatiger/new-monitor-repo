package com.monitorz.webapi.controllers;

import com.monitorz.webapi.data.Content;
import com.monitorz.webapi.data.Position;
import com.monitorz.webapi.data.RatingContent;
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
    private SettlementRepository settlementRepository;

    @RequestMapping("/findSettlementById")
    public Settlement findSettlementById(@RequestParam(value = "id") String id) {

        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E returning Settlement object all \uD83D\uDD35 JSONifified: \uD83C\uDF4E \uD83C\uDF4E " + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        Optional<Settlement> city = settlementRepository.findById(id);

        return  city.get();
    }
    @RequestMapping("/addPointToPolygon")
    public Settlement addPointToPolygon(@RequestParam(value = "settlementId") String settlementId,
                                        @RequestParam(value = "latitude") double latitude,
                                        @RequestParam(value = "longitude") double longitude) {

        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E addPointToPolygon:t  \uD83C\uDF4E \uD83C\uDF4E " + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        Optional<Settlement> settlementOpt = settlementRepository.findById(settlementId);
        Settlement settlement = settlementOpt.get();
        Position position = new Position(latitude,longitude);
        settlement.getPolygon().add(position);
        settlementRepository.save(settlement);
        LOG.log(Level.INFO, ": \uD83C\uDF30 \uD83C\uDF30 polygon point added");
        return  settlement;
    }
    @RequestMapping("/addSettlementPhoto")
    public Settlement addPhoto(@RequestParam(value = "settlementId") String settlementId,
                                        @RequestParam(value = "content") Content content) {

        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E addSettlementPhoto:  \uD83C\uDF4E \uD83C\uDF4E " + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        Optional<Settlement> settlementOpt = settlementRepository.findById(settlementId);
        Settlement settlement = settlementOpt.get();
        settlement.getPhotoUrls().add(content);
        settlementRepository.save(settlement);
        LOG.log(Level.INFO, ": \uD83C\uDF30 \uD83C\uDF30 photo added");
        return  settlement;
    }
    @RequestMapping("/addSettlementVideo")
    public Settlement addVideo(@RequestParam(value = "settlementId") String settlementId,
                               @RequestParam(value = "content") Content content) {

        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E addSettlementVideo:  \uD83C\uDF4E \uD83C\uDF4E " + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        Optional<Settlement> settlementOpt = settlementRepository.findById(settlementId);
        Settlement settlement = settlementOpt.get();
        settlement.getVideoUrls().add(content);
        settlementRepository.save(settlement);
        LOG.log(Level.INFO, ": \uD83C\uDF30 \uD83C\uDF30 video added");
        return  settlement;
    }
    @RequestMapping("/addSettlementRating")
    public Settlement addRating(@RequestParam(value = "settlementId") String settlementId,
                               @RequestParam(value = "content") RatingContent content) {

        long num = counter.incrementAndGet();
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E addSettlementRating:  \uD83C\uDF4E \uD83C\uDF4E " + num + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");

        Optional<Settlement> settlementOpt = settlementRepository.findById(settlementId);
        Settlement settlement = settlementOpt.get();
        settlement.getRatings().add(content);
        settlementRepository.save(settlement);
        LOG.log(Level.INFO, ": \uD83C\uDF30 \uD83C\uDF30 rating added");

        return  settlement;
    }
    @PostMapping(value = "/addSettlement")
    @ResponseStatus(code = HttpStatus.CREATED)
    public Settlement add(@RequestBody Settlement settlement) {
        settlement.setCreated(sdf.format(new Date()));
        Settlement c = settlementRepository.save(settlement);
        c.setCountryId(c.getId());
        c = settlementRepository.save(settlement);
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E addSettlement: Settlement added  \uD83D\uDD35  \uD83D\uDC99" + c.getName() + " \uD83D\uDC99 \uD83D\uDC99  \uD83D\uDD35 " + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return c;
    }
    @GetMapping(value = "/findSettlementsByCountry")
    public List<Settlement> findSettlementsByCountry(String countryId) {
        List<Settlement> list = settlementRepository.findSettlementsByCountryId(countryId);
        LOG.log(Level.INFO, "\uD83C\uDF4E \uD83C\uDF4E findSettlementsByCountry: found  \uD83D\uDD35 " + list.size() + " \uD83D\uDD35 " + counter.incrementAndGet() + " requests thus far \uD83D\uDD06\uD83D\uDD06\uD83D\uDD06  \uD83D\uDC9B");
        return list;
    }


    @PutMapping(value = "updateSettlement")
    public Settlement update(@PathVariable String id, @RequestBody Settlement settlement) throws Exception {
        Settlement c = settlementRepository.findById(id)
                .orElseThrow(() -> new Exception());

        c.setName(settlement.getName());
        c.setEmail(settlement.getEmail());
        c.setCreated(new Date().toString());

        return settlementRepository.save(c);
    }
}
