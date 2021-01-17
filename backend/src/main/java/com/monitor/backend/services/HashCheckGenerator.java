package com.monitor.backend.services;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.monitor.backend.data.OzowPaymentRequest;
import com.monitor.backend.utils.Emoji;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.xml.bind.DatatypeConverter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.text.DecimalFormat;
import java.util.concurrent.atomic.AtomicReference;

@Service
public class HashCheckGenerator {
    public HashCheckGenerator() {
        LOGGER.info(Emoji.BASKET_BALL.concat(Emoji.BASKET_BALL.concat("HashCheckGenerator up and ready")));
    }

    public static final Logger LOGGER = LoggerFactory.getLogger(HashCheckGenerator.class.getSimpleName());
    private static final Gson G = new GsonBuilder().setPrettyPrinting().create();

    @Value("${ozowPrivateKey}")
    private String privateKey;

    public String generateOzowHash(OzowPaymentRequest request) throws Exception {

        AtomicReference<StringBuilder> sb = new AtomicReference<>(new StringBuilder());
        sb.get().append(request.getSiteCode());
        sb.get().append(request.getCountryCode());
        sb.get().append(request.getCurrencyCode());
        sb.get().append(request.getAmount());
        sb.get().append(request.getTransactionReference());
        sb.get().append(request.getBankReference());
        //        if (request.getTokenNotificationUrl() != null) {
//            sb.append(request.getTokenNotificationUrl());
//        }
//        if (request.getOptional1() != null) {
//            sb.append(request.getOptional1());
//        }
//        if (request.getOptional2() != null) {
//            sb.append(request.getOptional2());
//        }
//        if (request.getOptional3() != null) {
//            sb.append(request.getOptional3());
//        }
//        if (request.getOptional4() != null) {
//            sb.append(request.getOptional4());
//        }
//        if (request.getOptional5() != null) {
//            sb.append(request.getOptional5());
//        }
        sb.get().append(request.getCustomer());
        sb.get().append(request.getCancelUrl());
        sb.get().append(request.getErrorUrl());
        sb.get().append(request.getSuccessUrl());
        sb.get().append(request.getNotifyUrl());
        sb.get().append(request.isTest());
        sb.get().append(privateKey);

        String toHash = sb.toString().toLowerCase();
        System.out.println(Emoji.FLOWER_YELLOW + ".... String to Hash: ".concat(toHash));

        return generateOzowHash(toHash);
    }


    public static final DecimalFormat DECIMAL_FORMAT = new DecimalFormat("#0.00");


    public static String generateOzowHash(String stringToHash) throws Exception {

        MessageDigest digest = MessageDigest.getInstance("SHA-512");
        digest.update(stringToHash.getBytes(StandardCharsets.UTF_8));
        byte[] messageDigest = digest.digest();
        StringBuilder hexString = new StringBuilder();
        for (byte b : messageDigest) {
            StringBuilder h = new StringBuilder(Integer.toHexString(0xFF & b));
            while (h.length() < 2)
                h.insert(0, "0");
            hexString.append(h);
        }
        String result = hexString.toString().toLowerCase();
        System.out.println("\uD83D\uDD35 \uD83D\uDD35 Hashed String: ".concat(result));
        return result;
    }


}
