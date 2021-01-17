package com.monitor.backend.services;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.monitor.backend.data.OzowPaymentRequest;
import com.monitor.backend.utils.Emoji;
import okhttp3.*;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Service
public class OzowService {
    public OzowService() {
        LOGGER.info(Emoji.CAT.concat(Emoji.CAT.concat("OzowService ready to go ".concat(Emoji.CAT))));
    }

    public static final Logger LOGGER = LoggerFactory.getLogger(OzowService.class.getSimpleName());
    private static final Gson G = new GsonBuilder().setPrettyPrinting().create();
    private final OkHttpClient client = new OkHttpClient();

    @Value("${ozowUrl}")
    private String ozowUrl;

    @Value("${ozowApiKey}")
    private String apiKey;

    @Autowired
    private HashCheckGenerator hashCheckGenerator;

    public static final MediaType JSON_MEDIA_TYPE
            = MediaType.parse("application/json; charset=utf-8");

    public String post(String url, String json) throws Exception {
        LOGGER.info(Emoji.DICE.concat(Emoji.DICE).concat(" ... Posting to: "
                .concat(url).concat(" json: ")
                .concat(json)));
        RequestBody body = RequestBody.create(json, JSON_MEDIA_TYPE);
        Request request = new Request.Builder()
                .url(url)
                .addHeader("Accept", "application/json")
                .addHeader("ApiKey", apiKey)
                .post(body)
                .build();
        try {
            Response response = client.newCall(request).execute();
            return Objects.requireNonNull(response.body()).string();
        } catch (Exception e) {
            e.printStackTrace();
            LOGGER.info("Call to "+url+" FAILED", e);
            throw new Exception("Ozow Call Failed: " + url);
        }
    }

    CloseableHttpClient httpclient = HttpClients.createDefault();
    public String sendOzowPaymentRequestNew(OzowPaymentRequest request) throws Exception {


        return "Not done yet";
    }

    public String sendOzowPaymentRequest(OzowPaymentRequest request) throws Exception {
        LOGGER.info(Emoji.PEAR.concat(Emoji.PEAR).concat(Emoji.PEAR)
                .concat("Sending ozow payment request ... ... ... check fields: \uD83D\uDD35 "
                ));

        String hash = hashCheckGenerator.generateOzowHash(request);

        LOGGER.info(Emoji.BLUE_DOT.concat(Emoji.BLUE_DOT)
                .concat("URL for request: ".concat(ozowUrl)));
        HttpPost httpPost = new HttpPost(ozowUrl);
        List<NameValuePair> pairs = new ArrayList<>();
        pairs.add(new BasicNameValuePair("SiteCode", request.getSiteCode()));
        pairs.add(new BasicNameValuePair("CountryCode", request.getCountryCode()));
        pairs.add(new BasicNameValuePair("CurrencyCode", request.getCurrencyCode()));
        pairs.add(new BasicNameValuePair("Amount", "" + request.getAmount()));
        pairs.add(new BasicNameValuePair("TransactionReference", request.getTransactionReference()));
        pairs.add(new BasicNameValuePair("BankReference", request.getBankReference()));
        pairs.add(new BasicNameValuePair("Customer", request.getCustomer()));
//
//        if (request.getOptional1() != null) {
//            pairs.add(new BasicNameValuePair("Optional1", request.getOptional1()));
//        }
//        if (request.getOptional2() != null) {
//            pairs.add(new BasicNameValuePair("Optional2", request.getOptional2()));
//        }
//        if (request.getOptional3() != null) {
//            pairs.add(new BasicNameValuePair("Optional3", request.getOptional3()));
//        }
//        if (request.getOptional4() != null) {
//            pairs.add(new BasicNameValuePair("Optional4", request.getOptional4()));
//        }
//        if (request.getOptional5() != null) {
//            pairs.add(new BasicNameValuePair("Optional5", request.getOptional5()));
//        }
//        if (request.getCustomer() != null) {
//            pairs.add(new BasicNameValuePair("Customer", request.getCustomer()));
//        }

        pairs.add(new BasicNameValuePair("CancelUrl", request.getCancelUrl()));
        pairs.add(new BasicNameValuePair("ErrorUrl", request.getErrorUrl()));
        pairs.add(new BasicNameValuePair("SuccessUrl", request.getSuccessUrl()));
        pairs.add(new BasicNameValuePair("NotifyUrl", request.getNotifyUrl()));

//        if (request.getTokenNotificationUrl() != null) {
//            pairs.add(new BasicNameValuePair("TokenNotificationUrl", request.getTokenDeletedNotificationUrl()));
//        }
        pairs.add(new BasicNameValuePair("isTest", request.isTest() ? "true": "false"));
        pairs.add(new BasicNameValuePair("HashCheck", hash));

        LOGGER.info(Emoji.CAT.concat(Emoji.CAT.concat(Emoji.CAT.concat(Emoji.CAT)).concat("Parameters sent with request")));
        for (NameValuePair pair : pairs) {
            LOGGER.info(Emoji.CAT.concat(Emoji.CAT
                    .concat("Parameter: ")
                    .concat(pair.getName().concat(" : ").concat(pair.getValue()))));
        }

        httpPost.setEntity(new UrlEncodedFormEntity(pairs));
        httpPost.addHeader("Accept", "application/json");
//        httpPost.addHeader("Content-Type", "application/json");
        httpPost.addHeader("ApiKey", apiKey);
        LOGGER.info(Emoji.CAT.concat(Emoji.CAT
                .concat(" request uri: ")
                .concat(httpPost.getRequestLine().getUri())));

        try (CloseableHttpResponse response2 = httpclient.execute(httpPost)) {
            LOGGER.info(Emoji.HEART_BLUE.concat(Emoji.HEART_BLUE.concat(Emoji.HEART_PURPLE))
                    .concat("Response StatusLine: ".concat(String.valueOf(response2.getStatusLine()))));
            if (response2.getStatusLine().getStatusCode() == 200) {
                LOGGER.info(Emoji.HAND2.concat(Emoji.HAND2).concat("Ozow responded with a SUCCESS status code = 200 "
                        .concat(Emoji.RED_APPLE).concat(response2.getStatusLine().getReasonPhrase()).concat(Emoji.BLUE_DOT)));
            }
            if (response2.getStatusLine().getStatusCode() == 302) {
                LOGGER.info(Emoji.HAND2.concat(Emoji.HAND2).concat("Ozow responded with a RE_DIRECTION status code = 302 "
                        .concat(Emoji.RED_APPLE).concat(response2.getStatusLine().getReasonPhrase()).concat(Emoji.BLUE_DOT)));
            }

            LOGGER.info(Emoji.BROCCOLI.concat(Emoji.BROCCOLI).concat(("ozow payment request; " +
                    "\uD83C\uDF3F response is: ").concat(response2.toString())));

            HttpEntity entity2 = response2.getEntity();
            final String entityString = EntityUtils.toString(entity2);
            LOGGER.info(Emoji.LEAF.concat(Emoji.LEAF).concat("entityString extracted: ".concat(entityString)));
            EntityUtils.consume(entity2);
            return entityString;
            /*
                <ul class="validation-summary-errors">
                <li>The HashCheck value has failed</li>
                </ul>

             */
        }

    }


    public void get(String url) throws Exception {

    }


}
