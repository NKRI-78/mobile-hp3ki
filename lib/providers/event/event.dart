import 'package:flutter/material.dart';
import 'package:hp3ki/data/models/event/event.dart';
import 'package:hp3ki/data/repository/event/event.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';

enum EventStatus { idle, loading, loaded, error, empty }

enum EventJoinStatus { idle, loading, loaded, error, empty }

enum EventPresentStatus { idle, loading, loaded, error, empty }

enum EventDetailStatus { idle, loading, loaded, error, empty }

class EventProvider with ChangeNotifier {
  final EventRepo er;

  EventProvider({required this.er});

  List<EventData> _events = [];
  List<EventData> get events => [..._events];

  EventStatus _eventStatus = EventStatus.loading;
  EventStatus get eventStatus => _eventStatus;

  EventDetailStatus _eventDetailStatus = EventDetailStatus.idle;
  EventDetailStatus get eventDetailStatus => _eventDetailStatus;

  EventJoinStatus _eventJoinStatus = EventJoinStatus.idle;
  EventJoinStatus get eventJoinStatus => _eventJoinStatus;

  EventPresentStatus _eventPresentStatus = EventPresentStatus.idle;
  EventPresentStatus get eventPresentStatus => _eventPresentStatus;

  void setStateEventStatus(EventStatus eventStatus) {
    _eventStatus = eventStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateJoinEventStatus(EventJoinStatus eventJoinStatus) {
    _eventJoinStatus = eventJoinStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePresentEventStatus(EventPresentStatus eventPresentStatus) {
    _eventPresentStatus = eventPresentStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateEventDetailStatus(EventDetailStatus eventDetailStatus) {
    _eventDetailStatus = eventDetailStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> getEvent(BuildContext context) async {
    try {
      _events = [];
      List<EventData>? data =
          await er.getEvent(userId: SharedPrefs.getUserId());
      if (data!.isEmpty) {
        setStateEventStatus(EventStatus.empty);
      } else {
        _events.addAll(data);
        setStateEventStatus(EventStatus.loaded);
      }
    } on CustomException catch (e) {
      //ER01
      debugPrint(e.toString());
      setStateEventStatus(EventStatus.error);
    } catch (e, stacktrace) {
      //EP01
      debugPrint(stacktrace.toString());
      setStateEventStatus(EventStatus.error);
    }
  }

  Future<void> joinEvent(BuildContext context,
      {required String eventId}) async {
    setStateJoinEventStatus(EventJoinStatus.loading);
    try {
      await er.joinEvent(eventId: eventId, userId: SharedPrefs.getUserId());
      NS.pop();
      ShowSnackbar.snackbar(
          'Anda berhasil bergabung!', '', ColorResources.success);
      setStateJoinEventStatus(EventJoinStatus.loaded);
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(e.toString(), '', ColorResources.error);
      setStateJoinEventStatus(EventJoinStatus.error);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      ShowSnackbar.snackbar(
        'Ada sesuatu yang bermasalah.', '', ColorResources.error);
      setStateJoinEventStatus(EventJoinStatus.error);
    }
  }

  Future<void> presentEvent(BuildContext context,
      {required String eventId}) async {
    setStatePresentEventStatus(EventPresentStatus.loading);
    try {
      await er.presentEvent(context, eventId: eventId);
      setStatePresentEventStatus(EventPresentStatus.loaded);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      setStatePresentEventStatus(EventPresentStatus.error);
    }
  }
}
