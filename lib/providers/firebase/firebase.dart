import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:soundpool/soundpool.dart';
import 'package:rxdart/rxdart.dart';

import 'package:hp3ki/providers/profile/profile.dart';

import 'package:hp3ki/data/repository/firebase/firebase.dart';

import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/shared_preferences.dart';

import 'package:hp3ki/services/database.dart';
import 'package:hp3ki/services/notification.dart';

import 'package:hp3ki/utils/helper.dart';

enum InitFCMStatus { loading, loaded, error, idle }

class FirebaseProvider with ChangeNotifier {
  final FirebaseRepo fr;

  FirebaseProvider({
    required this.fr,
  });

  InitFCMStatus _initFCMStatus = InitFCMStatus.idle;
  InitFCMStatus get initFCMStatus => _initFCMStatus;

  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();
  final soundpool = Soundpool.fromOptions(
    options: SoundpoolOptions.kDefault,
  );

  
  void setStateInitFCMStatus(InitFCMStatus initFCMStatus) {
    _initFCMStatus = initFCMStatus;
    Future.delayed(Duration.zero, () =>  notifyListeners());
  }

  static Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
    
    Map<String, dynamic> data = message.data;

    if(data != {}) {
      if(data["type"] != null) {
        await DBHelper.setAccountActive("accounts", 
          data: {
            "id": 1,
            "status": "approval",
            "createdAt": DateTime.now().toIso8601String()
          }
        );
      }
    }

    Soundpool soundpool = Soundpool.fromOptions(
      options: SoundpoolOptions.kDefault,
    );
    int soundId = await rootBundle.load("assets/sounds/notification.mp3").then((ByteData soundData) {
      return soundpool.load(soundData);
    });
    await soundpool.play(soundId);
  }

  Future<void> setupInteractedMessage(BuildContext context) async {
    await FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {


    });
  }

  Future<void> initFcm(BuildContext context) async {
    setStateInitFCMStatus(InitFCMStatus.loading);
    try {
      await fr.initFcm(
        token: await FirebaseMessaging.instance.getToken() ?? "-", 
        userId: SharedPrefs.getUserId(),
        lat: getCurrentLat.toString(),
        lng: getCurrentLng.toString(),
      );
      setStateInitFCMStatus(InitFCMStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
      // CustomDialog.showUnexpectedError(context, errorCode: 'FBR01');
      setStateInitFCMStatus(InitFCMStatus.error);
    } catch(e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      // CustomDialog.showUnexpectedError(context, errorCode: 'FBP01');
      setStateInitFCMStatus(InitFCMStatus.error);
    }
  }

  void listenNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;
      Map<String, dynamic> data = message.data;
      int soundId = await rootBundle.load("assets/sounds/notification.mp3").then((ByteData soundData) {
        return soundpool.load(soundData);
      });
      await soundpool.play(soundId);
      NotificationService.showNotification(
        id: Helper.createUniqueId(),
        title: notification.title,
        body: notification.body,
        payload: data,
      );
      if(data["type"] == "upgrade"){
        context.read<ProfileProvider>().getProfile(context);
      }
    });
  }

  double get getCurrentLat => SharedPrefs.getLat();  
  double get getCurrentLng => SharedPrefs.getLng();  
}