import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../functions.dart';

class OzowPaymentRequest {
  String? siteCode,
      countryCode,
      currencyCode,
      transactionReference,
      bankReference,
      customer,
      cancelUrl,
      errorUrl,
      successUrl,
      notifyUrl,
      hashCheck;
  bool? isTest;
  double? amount;

  OzowPaymentRequest({
    required this.siteCode,
    required this.countryCode,
    required this.transactionReference,
    required this.currencyCode,
    required this.bankReference,
    required this.errorUrl,
    required this.isTest,
    required this.hashCheck,
    required this.notifyUrl,
    required this.successUrl,
    required this.amount,
    required this.cancelUrl,
    required this.customer,
  });

  OzowPaymentRequest.fromJson(Map data) {
    this.siteCode = data['siteCode'];
    this.countryCode = data['countryCode'];
    this.currencyCode = data['currencyCode'];
    this.transactionReference = data['transactionReference'];
    this.errorUrl = data['errorUrl'];
    this.customer = data['customer'];
    this.bankReference = data['bankReference'];

    this.cancelUrl = data['cancelUrl'];
    this.successUrl = data['successUrl'];
    this.cancelUrl = data['cancelUrl'];
    this.notifyUrl = data['notifyUrl'];

    this.amount = data['amount'];
    this.hashCheck = data['hashCheck'];
    this.isTest = data['isTest'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'siteCode': siteCode,
      'countryCode': countryCode,
      'currencyCode': currencyCode,
      'transactionReference': transactionReference,
      'bankReference': bankReference,
      'cancelUrl': cancelUrl,
      'errorUrl': errorUrl,
      'successUrl': successUrl,
      'customer': customer,
      'isTest': isTest,
      'notifyUrl': notifyUrl,
      'hashCheck': hashCheck,
      'amount': amount,
    };
    return map;
  }

  static String generateOzowHash(OzowPaymentRequest request) {
    String? privateKey = DotEnv.dotenv.env['ozowPrivateKey'];
    StringBuffer sb = StringBuffer();
    sb.write(request.siteCode);
    sb.write(request.countryCode);
    sb.write(request.currencyCode);
    sb.write(request.amount);
    sb.write(request.transactionReference);
    sb.write(request.bankReference);
    sb.write(request.cancelUrl);
    sb.write(request.errorUrl);
    sb.write(request.successUrl);
    sb.write(request.notifyUrl);
    sb.write(request.isTest);
    sb.write(privateKey);

    String toHash = sb.toString().toLowerCase();
    pp("🌺 🌺 generateOzowHash: ....  String: $toHash");
    //todo - process
    var bytes = utf8.encode(toHash);
    Digest sha512Result = sha512.convert(bytes);
    String hash = sha512Result.toString();
    pp("🌺 🌺 generateOzowHash: ....  Hash: $hash");
    return hash;
  }

  static Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  static Future postPaymentRequest(OzowPaymentRequest request) async {
    var mUrl = DotEnv.dotenv.env['ozowUrl'];
    pp('\n\n🏈 🏈 🏈 🏈 🏈 OzowPaymentRequest Post:  🔆 🔆 🔆 🔆 calling : 💙  $mUrl  💙 ');

    var mBag = json.encode(request);

    pp('🏈 🏈 Bag after json decode call, check properties of mBag:  🏈 🏈 $mBag');
    var start = DateTime.now();
    var client = new http.Client();
    var resp = await client
        .post(
          Uri.parse(mUrl!),
          body: mBag,
          headers: headers,
        )
        .whenComplete(() {});

    pp('🏈 🏈 Response from call:  🏈 🏈 ${resp.body}');

    if (resp.statusCode == 200) {
      pp('❤️️❤️ PaymentRequest .... : 💙💙 statusCode: 👌👌👌 ${resp.statusCode} 👌👌👌 💙 for $mUrl');
    } else {
      pp('👿👿👿 PaymentRequest .... : 🔆 statusCode: 👿👿👿 ${resp.statusCode} 🔆🔆🔆 for $mUrl');
      throw Exception(
          '🚨 🚨 Status Code 🚨 ${resp.statusCode} 🚨 ${resp.body}');
    }
    var end = DateTime.now();
    pp('❤️❤️ 💙PaymentRequest ### 🔆 elapsed: ${end.difference(start).inSeconds} seconds 🔆 \n\n');

    // try {
    //   var mJson = json.decode(resp.body);
    //   pp('❤️❤️ 💙PaymentRequest ,,,,,,,,,,,,,,,,,,, do we get here?');
    //   return mJson;
    // } catch (e) {
    //   pp("👿👿👿👿👿👿👿 json.decode failed, returning response body");
    //   return resp.body;
    // }
    return resp.body;
  }
}
