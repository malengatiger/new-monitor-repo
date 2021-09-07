import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
import 'package:fluttertoast/fluttertoast.dart';

import 'functions.dart';


const FREQUENCY_IN_SECONDS = 3;
const TOPIC_GENERAL = 'generalTopic';
const PERSONAL_TOPIC_PREFIX = 'personal_',
    MESSAGE_TYPE_SCAN = 'SCAN',
    MESSAGE_TYPE_WALK_REQUEST = 'WALK_REQUEST',
    MESSAGE_TYPE_WALK_REQUEST_RESPONSE = 'WALK_REQUEST_RESPONSE',
    MESSAGE_TYPE_WALK_RESPONSE_ACCEPTANCE = 'WALK_RESPONSE_ACCEPTANCE',
    MESSAGE_TYPE_WALK_RESPONSE_DECLINATION = 'WALK_RESPONSE_DECLINATION ',
    MESSAGE_TYPE_PERSONAL_BROADCAST = 'PERSONAL_BROADCAST',
    MESSAGE_TYPE_EMERGENCY = 'EMERGENCY',
    MESSAGE_TYPE_CANCELLATION = 'CANCELLATION',
    MESSAGE_TYPE_EMERGENCY_RESPONSE = 'EMERGENCY_RESPONSE',
    MESSAGE_TYPE_EMERGENCY_OVER = 'EMERGENCY_OVER',
    MESSAGE_TYPE_SHAKE = 'DEVICE_SHAKE',
    MESSAGE_TYPE_SHAKE_RESPONSE = 'DEVICE_SHAKE_RESPONSE',
    MESSAGE_TYPE_USER_LOCATION = 'USER_LOCATION',
    MESSAGE_TYPE_BROADCAST_TO_ALL = 'BROADCAST_TO_ALL';

//todo - hide FCM API key in .env
const FCM_API_KEY =
    'AAAALCpokDI:APA91bFk3QqOq59dA1NBLumjEDhWLyX7yPhgpUq1oodFQ91sRzX_HSC2xkAzGGv27LiGqnwf841Ogc0EovJSN0jbGKAvgxX5Dc8evbk6cisMESFKLw97vsx1CA0S7kW_ZfFnetWzXslk';

// GeoRange georange = GeoRange();

Color getColor(String stringColor) {
  late Color color;
  switch (stringColor) {
    case 'white':
      color = Colors.lime[700]!;
      break;
    case 'yellow':
      color = Colors.yellow;
      break;
    case 'red':
      color = Colors.red;
      break;
    case 'pink':
      color = Colors.pink;
      break;
    case 'amber':
      color = Colors.amber;
      break;
    case 'blue':
      color = Colors.blue;
      break;
    case 'indigo':
      color = Colors.indigo;
      break;
    case 'orange':
      color = Colors.orange;
      break;
    case 'grey':
      color = Colors.grey[600]!;
      break;
    case 'teal':
      color = Colors.teal;
      break;
    case 'green':
      color = Colors.green;
      break;
    case 'indigo':
      color = Colors.indigo;
      break;
    default:
      color = Colors.black;
      break;
  }
  return color;
}

int count = 0;
Future getCurrentPosition() async {
  const mm = '🥦 🥦 🥦 Generic Function: _getCurrentLocation ';
  pp('$mm .......... get current location ....');
  int count = 0;
  try {
    var granted = await Geolocator.requestPermission();
    var _currentPosition = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 10));

    pp('$mm .......... get current location .... found: ${_currentPosition.toJson()}');
    return _currentPosition;
  } catch (e) {
    pp('$mm .......... get current location fell down, count: $count :::::: $e ....');
    count++;
    if (count < 4) {
      return await getCurrentPosition();
    }

    throw e;
  }
}

// String getGeoHash({required double latitude, required double longitude}) {
//   String encoded = georange.encode(latitude, longitude);
//   return encoded;
// }

String getAddress(Placemark placeMark) {
  String address = ''
      '${placeMark.street == null ? '' : '${placeMark.street}'} '
      '${placeMark.subLocality == null ? '' : '${placeMark.subLocality}'} '
      // '${placeMark.thoroughfare == null ? '' : '${placeMark.thoroughfare}'} '
      '${placeMark.locality == null ? '' : '${placeMark.locality}'} '
      '${placeMark.administrativeArea == null ? '' : '${placeMark.administrativeArea}'} '
      '${placeMark.postalCode == null ? '' : '${placeMark.postalCode}'} ';
  return address;
}

String getShortAddress(Placemark placeMark) {
  String address = ''
      '${placeMark.street == null ? '' : '${placeMark.street}'} '
      '${placeMark.subLocality == null ? '' : '${placeMark.subLocality}'} '
      '${placeMark.locality == null ? '' : '${placeMark.locality}'} ';
  return address;
}

// const lorem = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, '
//     'non tempor felis. Nam rutrum rhoncus est ac venenatis.';

// pp(dynamic message) {
//   if (isInDebugMode) {
//     if (message is String) {
//       debugPrint('${DateTime.now().toIso8601String()}: $message');
//     } else {
//       print(message);
//     }
//   }
//   //🔴 this logging ignored when in release mode!
// }

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

String stripHTMLTags(String string) {
  var s1 = string.replaceAll('<b>', '');
  var tag = '</b>';
  var s2 = s1.replaceAll('$tag', ' ');
  var s3 = s2.replaceAll('<div style="font-size:0.9em">', '');
  var s4 = s3.replaceAll('</div>', ' ');

  return s4;
}

bool get isInDebugMode {
  bool _inDebugMode = false;
  if (kDebugMode) {
    _inDebugMode = true;
  }

  return _inDebugMode;
}

bool get isInReleaseMode {
  bool _inReleaseMode = false;

  if (kReleaseMode) {
    _inReleaseMode = true;
  }
  return _inReleaseMode;
}

bool get isInProfileMode {
  bool _inProfileMode = false;
  if (kProfileMode) {
    _inProfileMode = true;
  }

  return _inProfileMode;
}

var random = Random(DateTime.now().millisecondsSinceEpoch);
const _fakePhotoUrls = [
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp18.jpeg?alt=media&token=ace62f6d-4acb-4c74-88e1-53aa4d6d8109',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp9.jpeg?alt=media&token=4ef97bb8-7665-4184-95e8-e0b4d7e5fd82',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp8.jpeg?alt=media&token=cd08c88a-b728-4694-a34e-ff2ec46762c6',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp7.jpeg?alt=media&token=3bab5f5a-615b-4d98-bfe0-c831d446d496',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp1.jpeg?alt=media&token=9ae5485f-1bc8-4d84-bb9c-754f5b164447',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp12.jpeg?alt=media&token=55c41b0d-ddb6-4aaa-af43-30b15ecb9894',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp13.jpeg?alt=media&token=5432c782-8dc1-4e78-aa52-f3a2ea822803',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp14.jpeg?alt=media&token=0c4817ba-66a9-41ee-afd2-479e72ef5c6c',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp15.jpeg?alt=media&token=92f525ef-a050-41c3-bd80-b5a015d31a47',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp16.jpeg?alt=media&token=cdd62b46-f624-4d84-889a-19f05ee77d9d',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp2.jpeg?alt=media&token=c9bbf9a8-b91d-4442-812a-627cc38b487f',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp3.jpeg?alt=media&token=231c115c-f736-4bf7-b47b-0104b85583a6',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp4.jpeg?alt=media&token=893196e6-05e1-4f7b-8751-c8d6bfdf2313',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp5.jpeg?alt=media&token=ec7e1738-d9ae-4042-bbf0-5c324493feaa',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fp6.jpeg?alt=media&token=c0b9f254-bba7-4106-a73a-e95fe58cc9eb',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa01.jpeg?alt=media&token=fae7eb2d-f60f-419c-8956-15e22fd6ca85',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa02.jpeg?alt=media&token=9b002e94-bb43-4bb8-8491-0cf1514380ac',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa03.jpeg?alt=media&token=0194660e-6cb6-49f4-b99f-9b3ff9ca3bb8',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa04.jpeg?alt=media&token=1ecb5276-dfc9-42d5-9487-53b6889a388d',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa06.jpeg?alt=media&token=0a306563-a4c1-4eb6-8d69-74bb65bfbd97',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa07.jpeg?alt=media&token=85ca51d2-1355-4d3d-97e9-f818b6e0bbb7',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa08.jpeg?alt=media&token=4faa2060-cc18-4429-a6b0-4c79085e1b4d',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa09.jpeg?alt=media&token=b31da317-23dd-46ab-944c-660d6aa406d7',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa10.jpeg?alt=media&token=6e068d77-e3a0-4540-942d-e957d77d338a',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa11.jpeg?alt=media&token=72237c86-e073-4293-ae7f-cddf06983446',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa12.jpeg?alt=media&token=aa5e6090-054b-4e3c-b46c-ad40e8330766',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa13.jpeg?alt=media&token=a3f1db42-9474-49fe-b90b-2aa4508783df',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa14.jpeg?alt=media&token=c88f8c71-3d9d-48e4-b4f3-8699c747c8b7',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa15.jpeg?alt=media&token=dad902ce-7771-4d4f-b3b2-07582321543e',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa16.jpeg?alt=media&token=f96b2497-22e5-4bd9-9984-4fdda7d615b6',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fa17.jpeg?alt=media&token=c209d284-1165-4b2a-9a47-08b8b59e6dfd',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fb01.jpeg?alt=media&token=912bfddc-f6bf-4d5d-8709-74a2e52755a2',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fb02.jpeg?alt=media&token=99e75616-2db1-45a6-889b-a0a07bea12e2',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fb03.jpeg?alt=media&token=a251406a-2fb0-466c-a59d-f2befce7e696',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fb05.jpeg?alt=media&token=6a474a67-7944-4311-92f2-19498e808b0a',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fb06.jpeg?alt=media&token=83f52438-c8b0-4ed6-9c72-1fd4fcae7f25',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fb08.jpeg?alt=media&token=6a1a13f7-f6c8-4252-8b48-26331ddc3306',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fb09.jpeg?alt=media&token=0fb68a4b-7377-42b4-875c-59e78352dc03',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fb10.jpeg?alt=media&token=46034bf2-9db6-42f4-b83c-5b1cd09f8a05',
  'https://firebasestorage.googleapis.com/v0/b/money-platform-2021.appspot.com/o/students%2Fb11.jpeg?alt=media&token=455a772a-a23c-4691-99ce-1304e5c736a5',
];

var _map = HashMap<String, String>();

String getFakePhotoUrl() {
  var index = random.nextInt(_fakePhotoUrls.length - 1);
  var fakeUrl = _fakePhotoUrls.elementAt(index);
  if (_map.containsKey(fakeUrl)) {
    return getFakePhotoUrl();
  } else {
    _map[fakeUrl] = fakeUrl;
    return fakeUrl;
  }
}

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  pp('🍐 🍐 🍐 🍐 🍐 PrettyPrint: $pretty 🍐🍐');
  return pretty;
}

showCustomToast(
    {required String message,
      required BuildContext context,
      required Widget widget,
      Color? backgroundColor,
      TextStyle? textStyle,
      Duration? duration,
      double? padding,
      ToastGravity? toastGravity}) {
  FToast fToast = FToast();
  const mm = 'FunctionsAndShit: 💀 💀 💀 💀 💀 : ';
  try {
    fToast.init(context);
  } catch (e) {
    pp('$mm FToast may already be initialized');
  }
  Widget toastContainer = Container(
    width: 320,
    padding: EdgeInsets.symmetric(
        horizontal: padding == null ? 12.0 : padding,
        vertical: padding == null ? 12.0 : padding),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      color: backgroundColor == null ? Colors.white : backgroundColor,
    ),
    child: widget
  );

  try {
    fToast.showToast(
      child: toastContainer,
      gravity: toastGravity == null ? ToastGravity.CENTER : toastGravity,
      toastDuration: duration == null ? Duration(seconds: 3) : duration,
    );
  } catch (e) {
    pp('$mm 👿👿👿👿👿 we have a small TOAST problem, Boss! - 👿 $e');
  }
}

showToast(
    {required String message,
    required BuildContext context,
    Color? backgroundColor,
    TextStyle? textStyle,
    Duration? duration,
    double? padding,
    ToastGravity? toastGravity}) {
  FToast fToast = FToast();
  const mm = 'FunctionsAndShit: 💀 💀 💀 💀 💀 : ';
  try {
    fToast.init(context);
  } catch (e) {
    pp('$mm FToast may already be initialized');
  }
  Widget toastContainer = Container(
    width: 320,
    padding: EdgeInsets.symmetric(
        horizontal: padding == null ? 12.0 : padding,
        vertical: padding == null ? 12.0 : padding),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      color: backgroundColor == null ? Colors.white : backgroundColor,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            '$message',
            textAlign: TextAlign.center,
            style: textStyle == null ? Styles.blackSmall : textStyle,
          ),
        ),
      ],
    ),
  );

  try {
    fToast.showToast(
      child: toastContainer,
      gravity: toastGravity == null ? ToastGravity.CENTER : toastGravity,
      toastDuration: duration == null ? Duration(seconds: 3) : duration,
    );
  } catch (e) {
    pp('$mm 👿👿👿👿👿 we have a small TOAST problem, Boss! - 👿 $e');
  }
}
