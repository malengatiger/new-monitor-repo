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
/*
🔶🔶🔶 Post Variables 🔶🔶🔶
PROPERTY	            TYPE	    REQUIRED	DESCRIPTION
1. SiteCode	            String (50)	Yes	        A unique code for the site currently in use. A site code is generated when adding a site in the Ozow Merchant Admin section.
2. CountryCode	        String (2)	Yes	The ISO 3166-1 alpha-2 code for the user's country. The country code will determine which banks will be displayed to the customer. Please note only South African (ZA) banks are currently supported by Ozow.
3. CurrencyCode	        String (3)	Yes	The ISO 4217 3 letter code for the transaction currency. Please note only South African Rand (ZAR) is currently supported by Ozow, so any currency conversion would have to take place before posting to the Ozow site.
4. Amount	            Decimal (9,2)	Yes	The transaction amount. The amount is in the currency specified by the currency code posted.
5. TransactionReference	String (50)	Yes	The merchant's reference for the transaction
6. BankReference	    String (20)	Yes	The reference that will be prepopulated in the "their reference" field in the customers online banking site. This will be the payment reference that appears on your transaction history.
7. Optional1
8. Optional2
9. Optional3
10. Optional4
11. Optional5	        String (50)	No	Optional fields the merchant can post for additional information they would need passed back in the response. These are also stored with the transaction details by Ozow and can be useful for filtering transactions in the merchant admin section.
12. Customer	        String (100)	No	The customers name or identifier.
13. CancelUrl	        String (150)	No	The Url that we should post the redirect result to if the customer cancels the payment, this will also be the page the customer gets redirect back to. This Url can also be set for the applicable merchant site in the merchant admin section. If a value is set in the merchant admin and sent in the post, the posted value will be redirected to if the payment is cancelled.
14. ErrorUrl	        String (150)	No
    The Url that we should post the redirect result to if an error occurred while trying to process the payment, this will also be the page the customer gets redirect back to. This Url can also be set for the applicable merchant site in the merchant admin section. . If a value is set in the merchant admin and sent in the post, the posted value will be redirected to if an error occurred while processing the payment.
15. SuccessUrl	        String (150)	No	The Url that we should post the redirect result to if the payment was successful, this will also be the page the customer gets redirect back to. This Url can also be set for the applicable merchant site in the merchant admin section. If a value is set in the merchant admin and sent in the post, the posted value will be redirected to if the payment was successful. Please note that it would not be sufficient to assume the payment was successful just because the customer was redirected back to this page, it highly recommended that you check the response fields and as well as check the transaction status using our check transaction status API call.
16. NotifyUrl	        String (150)	No	The Url that we should post the notification result to. The result will posted regardless of the outcome of the transaction. This Url can also be set for the applicable merchant site in the merchant admin section. If a value is set in the merchant admin and sent in the post, the notification result will be sent to the posted value. Find out more in the notification response section in step 2.
17. IsTest	            bool	        Yes	Send true to test your request posting and response handling. If set to true you will be redirected to a page where you can select whether you would like a successful or unsuccessful redirect response sent back. Please note that notification responses are not sent for test transactions and the online banking payment is skipped. Accepted values are true or false.
HashCheck	            String (250)	Yes	SHA512 hash used to ensure that certain fields in the message have not been already after the hash was generated. Check the generate hash section below for more details on how to generate the hash.
 */

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

    @Value("${ozowSiteCode}")
    private String ozowSiteCode;

    @Value("${ozowPrivateKey}")
    private String ozowPrivateKey;

    @Value("${countryCode}")
    private String countryCode;

    @Value("${currencyCode}")
    private String currencyCode;

    @Value("${ozowSuccessUrl}")
    private String ozowSuccessUrl;

    @Value("${ozowErrorUrl}")
    private String ozowErrorUrl;

    @Value("${ozowCancelUrl}")
    private String ozowCancelUrl;

    @Value("${ozowTokenNotifyUrl}")
    private String ozowTokenNotifyUrl;

    @Value("${ozowNotifyUrl}")
    private String ozowNotifyUrl;

    @Value("${ozowTokenDeleteNotifyUrl}")
    private String ozowTokenDeleteNotifyUrl;



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

    public OzowPaymentRequest createSampleRequest() throws Exception {

        OzowPaymentRequest request = new OzowPaymentRequest();
        request.setSiteCode(ozowSiteCode);
        request.setCountryCode(countryCode);
        request.setCurrencyCode(currencyCode);
        request.setTransactionReference("TestTran1");
        request.setAmount(333.99);
        request.setCustomer("Customer One");
        request.setSuccessUrl(ozowSuccessUrl);
        request.setCancelUrl(ozowCancelUrl);
        request.setErrorUrl(ozowErrorUrl);
        request.setNotifyUrl(ozowNotifyUrl);

        String hash = hashCheckGenerator.generateOzowHash(request);
        request.setHashCheck(hash);
        String json = G.toJson(request);

        LOGGER.info(Emoji.PEAR.concat(Emoji.PEAR).concat(Emoji.PEAR)
                .concat("Created sample ozow payment request json:: \uD83D\uDD35 " + json
                ));

        return request;
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
//        pairs.add(new BasicNameValuePair("BankReference", request.getBankReference()));
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
