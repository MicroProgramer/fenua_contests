import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FCM {
  static int _messageCount = 0;
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static var _serverKey =
      'AAAA670ddTA:APA91bGTc55OegoofmSBevIeNKuYP5CohZ44zubxYchQY61AEe7uNx9ixN0v1akBk1g60Sm-3iHqJOurMeF2m6B5Xyw3FtP2xUFB48fHKBzp0R0vwCoIHK4DRSUycWYHPFUi6aszOzW5';

  static String _constructFCMPayload(String? token) {
    _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#$_messageCount) was created via FCM!',
      },
    });
  }
  static Future<void> sendPushMessage(String _token) async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$_serverKey',
        },
        body: _constructFCMPayload(_token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  static Future<String?> generateToken() async {


    if (Platform.isIOS){

      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        return null;
      }
    }
    return await _firebaseMessaging.getToken();
  }

  static Future<String> sendMessageSingle(String notificationTitle, String notificationBody, String token) async {
    var _headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$_serverKey',
    };
    var _body = jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': '$notificationBody',
          'title': '$notificationTitle'
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': token,
      },
    );

    http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: _headers,
      body: _body,
    );

    return response.body;
  }
  static Future<String> sendMessageMulti(String notificationTitle, String notificationBody, List<String> tokens) async {
    var _headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$_serverKey',
    };
    var _body = jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': '$notificationBody',
          'title': '$notificationTitle'
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'registration_ids': tokens,
      },
    );

    print(_body);

    http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: _headers,
      body: _body,
    );

    return response.body;
  }

}