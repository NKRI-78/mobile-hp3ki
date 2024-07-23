import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hp3ki/maps/src/place_picker.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/providers/checkin/checkin.dart';
import 'package:hp3ki/providers/location/location.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';

class CreateCheckInScreen extends StatefulWidget {
  const CreateCheckInScreen({Key? key}) : super(key: key);

  @override
  _CreateCheckInScreenState createState() => _CreateCheckInScreenState();
}

class _CreateCheckInScreenState extends State<CreateCheckInScreen> {

  Completer<GoogleMapController> mapsController = Completer();
  
  late TextEditingController captionC;
  late TextEditingController descC;
  late TextEditingController dateC;
  late TextEditingController datetimeStartC;
  late TextEditingController datetimeEndC;

  late FocusNode captionFn;
  late FocusNode descFn;
  late FocusNode dateFn;
  late FocusNode datetimeStartFn;
  late FocusNode datetimeEndFn;

  int current = 0;
  String from = "";
  List<Marker> markers = [];

  Future<void> createCheckIn(BuildContext context) async {
    String? caption = captionC.text.trim();
    String? desc = descC.text.trim();
    String? date = dateC.text.trim();
    String? start = datetimeStartC.text.trim();
    String? end = datetimeEndC.text.trim();

    if(caption.isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated('CAPTION_IS_REQUIRED', context), "", ColorResources.error);
      return;
    }
    if(desc.isEmpty) {
      ShowSnackbar.snackbar(context, 'Deskripsi harus diisi.', "", ColorResources.error);
      return;
    }
    if(date.isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated('DATE_IS_REQUIRED', context), "", ColorResources.error);
      return;
    }
    if(start.isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated('DATE_TIME_START_IS_REQUIRED', context), "", ColorResources.error);
      return;
    }
    if(end.isEmpty) {
      ShowSnackbar.snackbar(context, getTranslated('DATE_TIME_END_IS_REQUIRED', context), "", ColorResources.error);  
      return; 
    }
    
    await context.read<CheckInProvider>().createCheckIn(
      context,
      caption,
      date,
      start,
      end,
      desc,
    );
  }

  @override 
  void initState() {
    super.initState();

    captionC = TextEditingController();
    captionFn = FocusNode();

    descC = TextEditingController();
    descFn = FocusNode();

    dateC = TextEditingController();
    dateFn = FocusNode();

    datetimeStartC = TextEditingController();
    datetimeStartFn = FocusNode();

    datetimeEndC = TextEditingController();
    datetimeEndFn = FocusNode();
  }

  @override 
  void dispose() {

    captionC.dispose();
    captionFn.dispose();

    descC.dispose();
    descFn.dispose();

    dateC.dispose();
    dateFn.dispose();

    datetimeStartC.dispose();
    datetimeStartFn.dispose();

    datetimeEndC.dispose();
    datetimeEndFn.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          CustomAppBar(title: getTranslated("CREATE_CHECK_IN", context)).buildAppBar(context),
          buildBodyContent()    
        ],
      )
    );
  }

  Container buildBodyContent() {
    return Container(
      margin: const EdgeInsets.only(
        left: 10.0, 
        right: 10.0, 
        top: 25.0, 
        bottom: 25.0
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        buildCaptionSection(),
        buildDescSection(),
        buildDateSection(),
        buildTimeSection(),
        buildLocationLabel(),
        buildLocationSection(),
        const SizedBox( height: 20.0 ),
        buildCreateButton()
        ],  
      )
    );
  }

  Container buildCaptionSection() {
    return Container(
          margin: const EdgeInsets.only(
            left: Dimensions.marginSizeDefault, 
            right: Dimensions.marginSizeDefault,
            bottom: Dimensions.marginSizeSmall
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10.0,
                children: [
                  const Icon(
                    Icons.title, 
                    color: ColorResources.primary, 
                  ),
                  Text(getTranslated('CAPTION', context), 
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall
                    )
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  color: ColorResources.white
                ),
                child: TextFormField(
                  controller: captionC,
                  decoration: InputDecoration(
                    hintText: getTranslated('CAPTION', context),
                    hintStyle: poppinsRegular.copyWith(
                      color: ColorResources.grey
                    ),
                    fillColor: ColorResources.white,
                    focusedBorder: const  OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLength: 50,
                  style: poppinsRegular
                ),
              ),
            ],
          ),
        );
  }

  Container buildDescSection() {
    return Container(
          margin: const EdgeInsets.only(
            left: Dimensions.marginSizeDefault, 
            right: Dimensions.marginSizeDefault,
            bottom: Dimensions.marginSizeSmall
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10.0,
                children: [
                  const Icon(
                    Icons.description, 
                    color: ColorResources.primary, 
                  ),
                  Text('Deskripsi', 
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall
                    )
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  color: ColorResources.white
                ),
                child: TextFormField(
                  controller: descC,
                  decoration: InputDecoration(
                    hintText: 'Deskripsi',
                    hintStyle: poppinsRegular.copyWith(
                      color: ColorResources.grey
                    ),
                    fillColor: ColorResources.white,
                    focusedBorder: const  OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLength: 100,
                  maxLines: 3,
                  style: poppinsRegular
                ),
              ),
            ],
          ),
        );
  }

  Container buildDateSection() {
    return Container(
          margin: const EdgeInsets.only(
            left: Dimensions.marginSizeDefault, 
            right: Dimensions.marginSizeDefault,
            bottom: Dimensions.marginSizeSmall
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Wrap(
                spacing: 10.0,
                children: [
                  const Icon(
                    Icons.date_range, 
                    color: ColorResources.primary, 
                  ),
                  Text(getTranslated('SET_DATE', context), 
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall
                  ))
                ],
              ),
              
              const SizedBox(height: 5.0),
              
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorResources.white,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: DateTimePicker(
                  type: DateTimePickerType.date,
                  dateMask: 'd MMM, yyyy',
                  controller: dateC,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall
                  ),
                  dateHintText: getTranslated('SET_DATE', context),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: const Icon(Icons.event),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                    hintText: getTranslated('SET_DATE', context),
                    hintStyle: poppinsRegular.copyWith(
                      color: ColorResources.hintColor,
                      fontSize: Dimensions.fontSizeSmall
                    ),
                    counterText: "",
                    isDense: true,
                    focusedBorder: const  OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5
                      ),
                    ),
                  ),
                  dateLabelText: getTranslated('DATE', context),
                  onChanged: (val) {},
                  validator: (val) {
                    return null;
                  },
                  onSaved: (val) => {}
                ) 
              ),
            ],
          ), 
        );
  }

  Container buildTimeSection() {
    return Container(
          margin: const EdgeInsets.only(bottom: Dimensions.marginSizeSmall),
          child: Row(
            children: [

              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: Dimensions.marginSizeDefault,
                    right: Dimensions.marginSizeDefault
                  ),
                  child:  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 10.0,
                              children: [
                                const SizedBox(
                                  child: Icon(
                                    Icons.date_range, 
                                    color: ColorResources.primary,
                                  ),
                                ),
                                Text(getTranslated('SET_TIME_START', context), 
                                  style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  )
                                )
                              ],
                            ),
                            const SizedBox(height: 5.0),                              
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorResources.white,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: DateTimePicker(
                                type: DateTimePickerType.time,
                                dateMask: 'd MMM, yyyy',
                                controller: datetimeStartC,
                                style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall
                                ),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                icon: const Icon(Icons.event),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0, 
                                    horizontal: 15.0
                                  ),
                                  hintText: getTranslated('SET_TIME_START', context),
                                  hintStyle: poppinsRegular.copyWith(
                                    color: ColorResources.hintColor,
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                  counterText: "",
                                  isDense: true,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5
                                    ),
                                  ),
                                ),
                                dateLabelText: getTranslated('DATE', context),
                                onChanged: (val) {},
                                validator: (val) {
                                  return null;
                                },
                                onSaved: (val) => {}
                              ) 
                            ),
                          ],
                        )
                      ),
                    ],
                  ), 
                ),
              ),

              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: Dimensions.marginSizeDefault,
                    right: Dimensions.marginSizeDefault
                  ),
                  child:  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 10.0,
                              children: [
                                const Icon(
                                  Icons.date_range, 
                                  color: ColorResources.primary,
                                ),
                                Text(getTranslated('SET_TIME_END', context), 
                                  style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall
                                  )
                                )
                              ],
                            ),
                            const SizedBox(height: 5.0),                              
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorResources.white,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: DateTimePicker(
                                type: DateTimePickerType.time,
                                dateMask: 'd MMM, yyyy',
                                controller: datetimeEndC,
                                style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall
                                ),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                icon: const Icon(Icons.event),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                                  hintText: getTranslated('SET_TIME_END', context),
                                  hintStyle: poppinsRegular.copyWith(
                                    color: ColorResources.hintColor,
                                    fontSize: Dimensions.fontSizeSmall
                                  ),
                                  counterText: "",
                                  isDense: true,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5
                                    ),
                                  ),
                                ),
                                dateLabelText: getTranslated('DATE', context),
                                onChanged: (val) {},
                                validator: (val) {
                                  return null;
                                },
                                onSaved: (val) => {}
                              ) 
                            ),
                          ],
                        )
                      ),
                    ],
                  ), 
                ),
              )

            ],
          ),
        );
  }

  Consumer<LocationProvider> buildLocationLabel() {
    return Consumer<LocationProvider>(
          builder: (BuildContext context, LocationProvider locationProvider, Widget? child) {
            return Container(
              margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault, right: Dimensions.marginSizeDefault, bottom: Dimensions.marginSizeSmall),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 10.0,
                    children: [
                      const Icon(
                        Icons.location_city, 
                        color: ColorResources.primary, 
                      ),
                      const SizedBox(width: 5.0),
                      Text(getTranslated('LOCATION', context), 
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall
                        )
                      )
                    ],
                  ),
                  const Expanded(
                    child: SizedBox.shrink()
                  ),
                  GestureDetector(
                    onTap: () { 
                      NS.push(context, PlacePicker(
                        apiKey: AppConstants.apiKeyGmaps,
                        useCurrentLocation: true,
                        onPlacePicked: (result) async {
                          context.read<LocationProvider>().updateCurrentPositionCheckIn(context, result);
                        },
                        autocompleteLanguage: "id",
                      ));
                    },
                    child: Text(getTranslated("SET_LOCATION", context),
                      style: poppinsRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: ColorResources.blue
                      )
                    )
                  ),
                ],
              ),
            ); 
          },
        );
  }

  Consumer<LocationProvider> buildLocationSection() {
    return Consumer<LocationProvider>(
        builder: (BuildContext context, LocationProvider locationProvider, Widget? child) {
          markers.add(Marker(
            markerId: const MarkerId("currentPosition"),
            position: LatLng(locationProvider.getCurrentLatCheckIn, locationProvider.getCurrentLngCheckIn),
            icon: BitmapDescriptor.defaultMarker,
          ));
          return Container(  
            width: double.infinity,
            height: 200.0,
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Stack( 
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                  myLocationEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(locationProvider.getCurrentLatCheckIn, locationProvider.getCurrentLngCheckIn),
                    zoom: 15.0,
                  ),
                  markers: Set.from(markers),
                  onMapCreated: (GoogleMapController controller) {
                    mapsController.complete(controller);
                    locationProvider.googleMapCCheckIn = controller;
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 10.0, 
                      right: 40.0, 
                      left: 10.0
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: ColorResources.white
                    ),
                    width: 210.0,
                    height: 90.0,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Text(locationProvider.getCurrentNameAddressCheckIn,
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: ColorResources.black,
                        )
                      ),
                    ),
                  ),
                )
              ]
            )
          );
        },
      );
  }

  Container buildCreateButton() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeLarge, 
        vertical: Dimensions.marginSizeSmall
      ),
      child: CustomButton(
        onTap: () => createCheckIn(context),
        isLoading: context.watch<CheckInProvider>().checkInStatusCreate == CheckInStatusCreate.loading 
        ? true 
        : false,
        customText: true,
        text: Text(getTranslated('CREATE_CHECKIN', context),
          style: poppinsRegular.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: ColorResources.white
          ),
        ),
        btnColor: ColorResources.primary,
        isBorderRadius: true,
        sizeBorderRadius: 10.0,
        isBoxShadow: true,
      )
    );
  }
}