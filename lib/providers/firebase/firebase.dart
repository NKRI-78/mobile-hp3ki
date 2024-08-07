import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hp3ki/views/screens/calendar/calendar.dart';
import 'package:hp3ki/views/screens/news/detail.dart';
import 'package:hp3ki/views/screens/notification/detail.dart';
import 'package:soundpool/soundpool.dart';

import 'package:hp3ki/data/repository/firebase/firebase.dart';

import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/utils/helper.dart';

import 'package:hp3ki/services/notification.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/services/services.dart';

import 'package:hp3ki/views/screens/home/home.dart';
import 'package:hp3ki/views/screens/feed/post_detail.dart';

enum InitFCMStatus { loading, loaded, error, idle }

class FirebaseProvider with ChangeNotifier {
  final FirebaseRepo fr;

  FirebaseProvider({
    required this.fr,
  });

  InitFCMStatus _initFCMStatus = InitFCMStatus.idle;
  InitFCMStatus get initFCMStatus => _initFCMStatus;

  final soundpool = Soundpool.fromOptions(
    options: SoundpoolOptions.kDefault,
  );
  
  void setStateInitFCMStatus(InitFCMStatus initFCMStatus) {
    _initFCMStatus = initFCMStatus;
    Future.delayed(Duration.zero, () =>  notifyListeners());
  }

  Future<void> setupInteractedMessage(BuildContext context) async {

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null) {
        handleMessage(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(message);
    });

  }

  Future<void> handleMessage(message) async {

    // NEWS
    if(message.data["click_action"] == "news") {
      NS.push(navigatorKey.currentContext!, 
        NewsDetailScreen(newsId: message.data["news_id"])
      );
    }

    // SOS
    if(message.data["click_action"] == "sos") {
      NS.push(
        navigatorKey.currentContext!,
        DetailInboxScreen(
          inboxId: message.data["inbox_id"], 
          type: message.data["inbox_type"]
        )
      );    
    }

    // EVENT
    if(message.data["click_action"] == "event") {
      NS.push(navigatorKey.currentContext!,
        const CalendarScreen()
      );
    }

    // FORUM
    if(message.data["click_action"] == "like") {
      NS.push(navigatorKey.currentContext!,
        const DashboardScreen(index: 2)
      );
    }

    if(message.data["click_action"] == "comment-like") {
      NS.push(navigatorKey.currentContext!,
        const DashboardScreen(index: 2)
      );
    }

    if(message.data["click_action"] == "create-comment") {       
      NS.pushUntil(navigatorKey.currentContext!, 
        PostDetailScreen(
          data: {
            "forum_id": message.data["forum_id"],
            "comment_id": message.data["comment_id"],
            "reply_id": "-",
            "from": "notification-comment",
          },
        )
      );
    }

    if(message.data["click_action"] == "create-reply") {
      NS.pushUntil(navigatorKey.currentContext!, 
        PostDetailScreen(
          data: {
            "forum_id": message.data["forum_id"],
            "comment_id": message.data["comment_id"],
            "reply_id": message.data["reply_id"],
            "from": "notification-reply",
          },
        )
      );
    }

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
      setStateInitFCMStatus(InitFCMStatus.error);
    } catch(e) {
      debugPrint(e.toString());
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

      // if(data["type"] == "upgrade"){
      //   context.read<ProfileProvider>().getProfile(context);
      // }

    });
  }

  double get getCurrentLat => SharedPrefs.getLat();  
  double get getCurrentLng => SharedPrefs.getLng();  
}