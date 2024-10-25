import 'package:flutter/material.dart';
import 'package:hp3ki/providers/location/location.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:provider/provider.dart';
import 'package:hp3ki/utils/box_shadow.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/views/screens/sos/detail.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';

class SosScreenV2 extends StatefulWidget {
  const SosScreenV2({ 
    Key? key 
  }) : super(key: key);

  @override
  State<SosScreenV2> createState() => SosScreenV2State();
}

class SosScreenV2State extends State<SosScreenV2> {
  String label = "";
  String content = "";
  String message = "";

  int selectedSos = -1;
  
  List<Map<String, dynamic>> categories = [
    {
      "id": 1,
      "name": "ACCIDENT",
      "image": "assets/images/sos/accident.png",
      "message": "Kecelakaan"
    },
    {
      "id": 2,
      "name": "THEFT",
      "image": "assets/images/sos/theft.png",
      "message": "Pencurian"
    },
    {
      "id": 3,
      "name": "WILDFIRE",
      "image": "assets/images/sos/wildfire.png",
      "message": "Kebakaran"
    },
    {
      "id": 4,
      "name": "DISASTER",
      "image": "assets/images/sos/disaster.png",
      "message": "Bencana Alam"
    },
    {
      "id": 5,
      "name": "ROBBERY",
      "image": "assets/images/sos/robbery.png",
      "message": "Perampokan"
    },
    {
      "id": 6,
      "name": "NOISE",
      "image": "assets/images/sos/noise.png",
      "message": "Kerusuhan"
    }
  ];

  Future<void> getData() async {
    if(mounted) {
      context.read<LocationProvider>().getCurrentPosition(context);
    }
  }

  @override 
  void initState() {
    super.initState();

    getData();
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {

          return Stack(
            clipBehavior: Clip.none,
            children: [

              CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  buildAppBar(context),
                  buildBodyContent(context)
                ],
              ),
              selectedSos == -1 
              ? Container() 
              : buildSubmitButton(context)
            ],
          ); 

        },
      ),
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return const CustomAppBar(title: 'SOS').buildSliverAppBar(context);
  }

  SliverList buildBodyContent(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([

        Container(
          margin: const EdgeInsets.only(
            top: Dimensions.marginSizeDefault,
            left: Dimensions.marginSizeExtraLarge,
          ),
          child: Text("Hi, ${context.read<ProfileProvider>().user?.fullname ?? "..."}",
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.bold,
              color: ColorResources.primary
            ),
          )
        ), 
        
        Container(
          margin: const EdgeInsets.only(
            bottom: Dimensions.marginSizeDefault,
            left: Dimensions.marginSizeExtraLarge,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [     
              Text(getTranslated("WHAT_WE_CAN_HELP", context),
                style: poppinsRegular.copyWith(
                  fontSize: Dimensions.fontSizeOverLarge,
                  fontWeight: FontWeight.bold,
                  color: ColorResources.black
                ),
              )
            ],
          )
        ),

        Container(
          margin: const EdgeInsets.only( 
            top: Dimensions.marginSizeLarge,
            left: Dimensions.marginSizeLarge, 
            right: Dimensions.marginSizeLarge
          ),
          child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 4.2 / 4,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
            ),
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int i) {
              return Container(
                margin: const EdgeInsets.only(
                  left: Dimensions.marginSizeSmall, 
                  right: Dimensions.marginSizeSmall
                ),
                decoration: BoxDecoration(
                  color: ColorResources.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: boxShadow
                ),
                child: Material(
                  color: ColorResources.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    onTap: () {
                      setState(() {
                        selectedSos = i;
                        label = getTranslated(categories[i]["name"], context);
                        message = categories[i]["message"];
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 130.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [

                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    width: double.infinity,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: ColorResources.primary,
                                      borderRadius: BorderRadius.circular(20.0)
                                    ),
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60.0),
                                      border: Border.all(
                                        color: ColorResources.white,
                                        width: 5.0
                                      )
                                    ),
                                    child: CircleAvatar(
                                      maxRadius: 30.0,
                                      backgroundImage: AssetImage(
                                        categories[i]["image"],
                                      ),
                                    ),
                                  ),
                                ),

                              ]
                            ),
                          ),
                                                    
                          Container(
                            margin: const EdgeInsets.only(top: 15.0),
                            alignment: Alignment.center,
                            child: Text(getTranslated( categories[i]["name"], context),
                              style: poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.bold,
                                color: selectedSos == i 
                                ? ColorResources.primary 
                                : ColorResources.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            
            }
          ),
        ),
      ]),
    );
  }

  Align buildSubmitButton(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
        margin: const EdgeInsets.only(
          left: Dimensions.marginSizeDefault,
          right: Dimensions.marginSizeDefault,
          bottom: Dimensions.marginSizeDefault
        ),
        child: CustomButton(
          customText: true,
          text: Text(
            getTranslated('CONTINUE', context),
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: ColorResources.white
            ),
          ),
          btnColor: ColorResources.primary,
          isBorderRadius: true,
          sizeBorderRadius: 10.0,
          isBoxShadow: true,
          onTap: () {
            NS.push(context, SosDetailScreen(
              label: label, 
              content: content,
              message: message,
            ));
          }, 
        )
      ),
    );
  }

}