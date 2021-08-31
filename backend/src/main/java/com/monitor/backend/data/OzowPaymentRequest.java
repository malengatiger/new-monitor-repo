package com.monitor.backend.data;

import org.springframework.data.mongodb.core.mapping.Document;

/*
The bank that the payment should be made to. Merchant
needs to be enabled to send through banking details (18 - 21) in
the post, for most merchants this is setup when creating the
merchant account.
Allowed values are:
• ABSA – 3284A0AD-BA78-4838-8C2B-102981286A2B
• Capitec - 913999FA-3A32-4E3D-82F0-A1DF7E9E4F7B
• FNB - 4816019C-3314-4C80-8B6B-B2CD16DCC4EC
• Nedbank - BF0561FD-4203-4A0C-9174-
CB26FCD87A60
• Standard Bank - AD7D8DA4-1723-4066-94BB6662D845E483
• Investec - 4B45BE85-B616-4BD1-9027-F8FCF8F9AF7B

     🌺  🌺 Token Payment
        If you have previously received a token for the user you only need to pass the fields below along with the post
        variables in Step 1 to initiate a tokenised payment. Only the TokenProfileId will need to appended to the
        concatenated post variables to calculate the post hash check. The token field is not used in the hash check
        calculation.
        These fields are only required if you want the user to use the token you have saved for them to complete the
        payment.
        Property Type Req. Description
        1. TokenProfileId Guid Yes The token profile identifier returned in the token response
        sent to the TokenNotificationUrl.
        2. Token String (Max) Yes The token returned in the token response sent to the
        TokenNotificationUrl.
 */
@Document(collection = "ozowPaymentRequest")
public class OzowPaymentRequest {
    private String SiteCode, CountryCode, CurrencyCode,
            TransactionReference, BankReference;
    private String Optional1, Optional2, Optional3, Optional4, Optional5, Customer;
    private String CancelUrl, ErrorUrl, SuccessUrl, NotifyUrl,
            TokenNotificationUrl, TokenDeletedNotificationUrl;
    private boolean isTest, RegisterTokenProfile;
    private double Amount;
    private String BankId, BankAccountNumber, BranchCode,
            BankAccountName, PayeeDisplayName, HashCheck;
    private String TokenProfileId, Token;

    public static final String
            ABSA = "3284A0AD-BA78-4838-8C2B-102981286A2B",
            Capitec = "913999FA-3A32-4E3D-82F0-A1DF7E9E4F7B",
            FNB = "4816019C-3314-4C80-8B6B-B2CD16DCC4EC",
            StandardBank = "AD7D8DA4-1723-4066-94BB6662D845E483",
            Investec = "4B45BE85-B616-4BD1-9027-F8FCF8F9AF7B";

    public OzowPaymentRequest() {
    }


    public String getTokenProfileId() {
        return TokenProfileId;
    }

    public void setTokenProfileId(String tokenProfileId) {
        TokenProfileId = tokenProfileId;
    }

    public String getToken() {
        return Token;
    }

    public void setToken(String token) {
        Token = token;
    }

    public String getTokenNotificationUrl() {
        return TokenNotificationUrl;
    }

    public void setTokenNotificationUrl(String tokenNotificationUrl) {
        TokenNotificationUrl = tokenNotificationUrl;
    }

    public String getTokenDeletedNotificationUrl() {
        return TokenDeletedNotificationUrl;
    }

    public void setTokenDeletedNotificationUrl(String tokenDeletedNotificationUrl) {
        TokenDeletedNotificationUrl = tokenDeletedNotificationUrl;
    }

    public boolean isRegisterTokenProfile() {
        return RegisterTokenProfile;
    }

    public void setRegisterTokenProfile(boolean registerTokenProfile) {
        RegisterTokenProfile = registerTokenProfile;
    }

    public String getSiteCode() {
        return SiteCode;
    }

    public void setSiteCode(String siteCode) {
        SiteCode = siteCode;
    }

    public String getCountryCode() {
        return CountryCode;
    }

    public void setCountryCode(String countryCode) {
        CountryCode = countryCode;
    }

    public String getCurrencyCode() {
        return CurrencyCode;
    }

    public void setCurrencyCode(String currencyCode) {
        CurrencyCode = currencyCode;
    }

    public String getTransactionReference() {
        return TransactionReference;
    }

    public void setTransactionReference(String transactionReference) {
        TransactionReference = transactionReference;
    }

    public String getBankReference() {
        return BankReference;
    }

    public void setBankReference(String bankReference) {
        BankReference = bankReference;
    }

    public String getOptional1() {
        return Optional1;
    }

    public void setOptional1(String optional1) {
        Optional1 = optional1;
    }

    public String getOptional2() {
        return Optional2;
    }

    public void setOptional2(String optional2) {
        Optional2 = optional2;
    }

    public String getOptional3() {
        return Optional3;
    }

    public void setOptional3(String optional3) {
        Optional3 = optional3;
    }

    public String getOptional4() {
        return Optional4;
    }

    public void setOptional4(String optional4) {
        Optional4 = optional4;
    }

    public String getOptional5() {
        return Optional5;
    }

    public void setOptional5(String optional5) {
        Optional5 = optional5;
    }

    public String getCustomer() {
        return Customer;
    }

    public void setCustomer(String customer) {
        Customer = customer;
    }

    public String getCancelUrl() {
        return CancelUrl;
    }

    public void setCancelUrl(String cancelUrl) {
        CancelUrl = cancelUrl;
    }

    public String getErrorUrl() {
        return ErrorUrl;
    }

    public void setErrorUrl(String errorUrl) {
        ErrorUrl = errorUrl;
    }

    public String getSuccessUrl() {
        return SuccessUrl;
    }

    public void setSuccessUrl(String successUrl) {
        SuccessUrl = successUrl;
    }

    public String getNotifyUrl() {
        return NotifyUrl;
    }

    public void setNotifyUrl(String notifyUrl) {
        NotifyUrl = notifyUrl;
    }

    public boolean isTest() {
        return isTest;
    }

    public void setTest(boolean test) {
        isTest = test;
    }

    public double getAmount() {
        return Amount;
    }

    public void setAmount(double amount) {
        Amount = amount;
    }

    public String getBankId() {
        return BankId;
    }

    public void setBankId(String bankId) throws Exception {
        if (bankId.equalsIgnoreCase(ABSA) ||
                bankId.equalsIgnoreCase(FNB) ||
                bankId.equalsIgnoreCase(StandardBank) ||
                bankId.equalsIgnoreCase(Investec) ||
                bankId.equalsIgnoreCase(Capitec)) {
            BankId = bankId;
        } else {
            throw new Exception("Invalid BankId");
        }
    }

    public String getBankAccountNumber() {
        return BankAccountNumber;
    }

    public void setBankAccountNumber(String bankAccountNumber) {
        BankAccountNumber = bankAccountNumber;
    }

    public String getBranchCode() {
        return BranchCode;
    }

    public void setBranchCode(String branchCode) {
        BranchCode = branchCode;
    }

    public String getBankAccountName() {
        return BankAccountName;
    }

    public void setBankAccountName(String bankAccountName) {
        BankAccountName = bankAccountName;
    }

    public String getPayeeDisplayName() {
        return PayeeDisplayName;
    }

    public void setPayeeDisplayName(String payeeDisplayName) {
        PayeeDisplayName = payeeDisplayName;
    }

    public String getHashCheck() {
        return HashCheck;
    }

    public void setHashCheck(String hashCheck) {
        HashCheck = hashCheck;
    }
}
