
import 'dart:collection';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hp3ki/providers/localization/localization.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:hp3ki/data/models/event/event.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/providers/event/event.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  _CalenderScreenState createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  ValueNotifier<List<EventData>> selectedEvents = ValueNotifier([]);
  
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  Future<void> getData() async {
    if(mounted) {
      context.read<EventProvider>().getEvent(context);      
    }
    selectedDay = focusedDay;
    selectedEvents = ValueNotifier(getEventsForDay(selectedDay));
  }

  void setInitialEvent() {
    Future.delayed(const Duration(seconds: 2),
      () {
        selectedEvents.value = getEventsForDay(selectedDay);
        setState(() { });
      },
    );
  }

  List<EventData> getEventsForDay(DateTime day) {

    Map<DateTime, List<EventData>> eventSource = { for (EventData event in context.read<EventProvider>().events) 
    DateTime.utc(
      DateTime.parse(Helper.getFormatedDate(event.date)).year,
      DateTime.parse(Helper.getFormatedDate(event.date)).month,
      DateTime.parse(Helper.getFormatedDate(event.date)).day,
    )
    : context.read<EventProvider>().events.where((el) => el.date == event.date).toList() };  

    final kEvents = LinkedHashMap<DateTime, List<EventData>>(
      equals: isSameDay,
      hashCode: Helper.getHashCode,
    )..addAll(eventSource);

    return kEvents[day] ?? [];
  }

  void onDaySelected(DateTime selectedDayParam, DateTime focusedDayParam) {
    if (!isSameDay(selectedDay, selectedDayParam)) {
      setState(() {
        selectedDay = selectedDayParam;
        focusedDay = focusedDayParam;
      });
      selectedEvents.value = getEventsForDay(selectedDayParam);
    }
  }

  @override
  void initState() {
    super.initState();

    Future.wait([
      getData(),
    ]);
    setInitialEvent();
  }

  @override 
  void dispose() {
    selectedEvents.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {    
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {

            return RefreshIndicator(
              onRefresh: () {
                return Future.sync(() {
                  setState(() {
                    getData();
                    setInitialEvent();
                  }); 
                }); 
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  buildAppBar(context),
                  context.watch<EventProvider>().eventStatus == EventStatus.loading 
                  ? buildLoadingContent()
                  : context.watch<EventProvider>().eventStatus == EventStatus.error  
                  ? buildErrorContent(context)
                  : buildContentNotEmpty()
              ],
            ),
          );
          

          },
        )
      )
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return const CustomAppBar(title: 'Calender').buildSliverAppBar(context);
  }

  SliverFillRemaining buildLoadingContent() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: SpinKitThreeBounce(
          color: ColorResources.primary,
          size: 20.0
        ),
      )
    );
  }

  SliverFillRemaining buildErrorContent(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(getTranslated("THERE_WAS_PROBLEM", context),
          style: poppinsRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault
          ),
        )
      )
    );
  }

  SliverList buildContentNotEmpty() {
    return SliverList(
      delegate: SliverChildListDelegate([
      buildCalender(),
      const SizedBox(height: 8.0),
      buildCalenderValueListener(),
  ]),
    );
  }

  Container buildCalender() {
    return Container(
        margin: const EdgeInsets.only(
          top: Dimensions.marginSizeSmall,
          left: Dimensions.marginSizeSmall,
          right: Dimensions.marginSizeSmall  
        ),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: ColorResources.white,
          boxShadow: kElevationToShadow[3]
        ),
        child: TableCalendar<EventData>(
        locale: context.watch<LocalizationProvider>().locale.languageCode,
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: focusedDay,
        daysOfWeekHeight: 20.0,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: poppinsRegular.copyWith(
            color: ColorResources.white,
            fontSize: Dimensions.fontSizeDefault
          ),
          weekendStyle: poppinsRegular.copyWith(
            color: ColorResources.white,
            fontSize: Dimensions.fontSizeDefault
          ),
          decoration: BoxDecoration(
            color: ColorResources.primary,
            borderRadius: BorderRadius.circular(60.0)
          ),
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: poppinsRegular.copyWith(
            fontSize: Dimensions.fontSizeLarge
          )
        ),
        selectedDayPredicate: (DateTime day) => isSameDay(selectedDay, day),
        calendarFormat: CalendarFormat.month,
        calendarBuilders: CalendarBuilders<EventData>(
          markerBuilder: (BuildContext context, DateTime day, List<EventData> events) {
            if(events.isNotEmpty) {
              return Positioned(
                bottom: 10.0,
                child: Container(
                  width: 7.0,
                  height: 7.0,
                  decoration: const BoxDecoration(
                    color: ColorResources.success,
                    shape: BoxShape.circle
                  ),
                ),
              );
            }
            return Container();
          },
        ),
        startingDayOfWeek: StartingDayOfWeek.monday,
        eventLoader: getEventsForDay,
        calendarStyle: const CalendarStyle(
          outsideDaysVisible: false,
        ),
        currentDay: selectedDay,
        onDaySelected: onDaySelected,
        onPageChanged: (val) {
          focusedDay = val;
        },
      ),
    );
  }

  ValueListenableBuilder<List<EventData>> buildCalenderValueListener() {
    return ValueListenableBuilder<List<EventData>>(
      valueListenable: selectedEvents,
      builder: (BuildContext context, List<EventData> events, Widget? child) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          shrinkWrap: true,
          itemCount: events.length,
          itemBuilder: (BuildContext context, int i) {
          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: ColorResources.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: kElevationToShadow[3]
            ),
            child: InkWell(
              onTap: context.watch<EventProvider>().eventStatus == EventStatus.loading 
              ? () {} 
              : () {
                buildEventDetailDialog(context, events, i);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: events[i].picture!,
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) {
                            return Container(
                              height: 100,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: ColorResources.backgroundDisabled,
                                image: DecorationImage(
                                  image: AssetImage('assets/images/icons/ic-empty.png'),
                                )
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container()
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        width: 200.0,
                        margin: const EdgeInsets.only(
                          right: 15.0
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Html(
                              data: events[i].description,
                              style: {
                                'body': Style(
                                  fontFamily: 'Poppins',
                                  maxLines: 2,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 3.0, 
                                bottom: 3.0
                              ),
                              child: const Divider(
                                height: 2.0,
                                color: ColorResources.hintColor,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(DateFormat('dd MMMM yyyy').format(DateTime.parse(Helper.getFormatedDate(events[i].date))),
                                  style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: ColorResources.primary
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Icon(
                                      Icons.alarm,
                                      size: 15.0,
                                      color: ColorResources.primary,
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text("${events[i].start} - ${events[i].end}",
                                      style: poppinsRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: ColorResources.primary
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          );
        },
      );
    },
  );
  }

  void buildEventDetailDialog(BuildContext context, List<EventData> events, int i) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
    
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: events[i].picture!,
                      fit: BoxFit.fill,
                      errorWidget: (BuildContext context, String url, dynamic error) {
                        return Container(
                          width: double.infinity,
                          height: 180.0,
                          decoration: BoxDecoration(
                            color: ColorResources.backgroundDisabled,
                            borderRadius: BorderRadius.circular(6.0),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/icons/ic-empty.png')
                            )
                          ),
                        );
                      },
                    ),
                  ),
    
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(getTranslated("START", context),
                              style: poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.w600
                              )
                            ),
                            const SizedBox(width: 5.0),
                            Text(events[i].start!.trim().isNotEmpty ? events[i].start! : "...",
                              style: poppinsRegular.copyWith(
                                color: ColorResources.black,
                                fontSize: Dimensions.fontSizeDefault,
                              )
                            ),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(getTranslated("END", context),
                              style: poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.w600
                              )
                            ),
                            const SizedBox(width: 5.0),
                            Text(events[i].end!.trim().isNotEmpty ? events[i].end! : "...",
                              style: poppinsRegular.copyWith(
                                color: ColorResources.black,
                                fontSize: Dimensions.fontSizeDefault,
                              )
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(getTranslated("TITLE", context),
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600
                          )
                        ),
                        const SizedBox(height: 10.0),
                        Text(events[i].title!.trim(),
                          style: poppinsRegular.copyWith(
                            color: ColorResources.black,
                            fontSize: Dimensions.fontSizeDefault,
                          )
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10.0),
                  
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(getTranslated("DESCRIPTION", context),
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600
                          )
                        ),
                        Html(
                          data: events[i].description,
                          shrinkWrap: true,
                          style: {
                            'body': Style(
                              margin: Margins.zero,
                              fontFamily: 'Poppins',
                            ),
                          },
                        ),
                      ],
                    ),
                  ),
    
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(getTranslated("LOCATION", context),
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600
                          )
                        ),
                        const SizedBox(height: 6.0),
                        Text(events[i].location ?? "...",
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(getTranslated("DATE", context),
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600
                          )
                        ),
                        const SizedBox(height: 6.0),
                        Text(Helper.formatDate(DateTime.parse(Helper.getFormatedDate(events[i].date))),
                          style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault
                          ),
                        ),
                      ],
                    ),
                  ),
    
                  Container(
                    margin: const EdgeInsets.only(
                      top: Dimensions.marginSizeSmall,
                      bottom: Dimensions.marginSizeSmall
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
    
                        Expanded(
                          child: CustomButton(
                            onTap: () {
                              NS.pop();
                            }, 
                            height: 35.0,
                            isBorder: false,
                            isBorderRadius: true,
                            btnColor: ColorResources.error,
                            btnTxt: getTranslated("CANCEL", context)
                          )
                        ),
    
                        const SizedBox(width: 8.0),
    
                        Expanded(
                          child: CustomButton(
                            onTap: events[i].joined == true 
                            ? () { }
                            : () async {
                              setState(() {
                                getData();
                              });
                              await context.read<EventProvider>().joinEvent(
                                context, 
                                eventId: events[i].id.toString(),
                              );
                            }, 
                            height: 35.0,
                            isBorder: false,
                            isBorderRadius: true,
                            isLoading: context.watch<EventProvider>().eventJoinStatus == EventJoinStatus.loading 
                              ? true 
                              : false,
                            btnColor: events[i].joined == true 
                              ? ColorResources.backgroundDisabled : ColorResources.success,
                            btnTxt: events[i].joined == true ? "Tergabung" : "Gabung",
                          )
                        )
    
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      );
    },
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
    );
  }
}
