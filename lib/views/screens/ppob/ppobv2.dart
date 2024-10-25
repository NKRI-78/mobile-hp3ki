import 'dart:async';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/screens/ppob/paket_data/paket_data.dart';
import 'package:hp3ki/views/screens/ppob/pln/listrik.dart';
import 'package:hp3ki/views/screens/ppob/pulsa/voucher_by_prefix.dart';
import 'package:flutter/material.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/box_shadow.dart';

class PPOBV2Screen extends StatefulWidget {
  const PPOBV2Screen({ Key? key }) : super(key: key);

  @override
  State<PPOBV2Screen> createState() => _PPOBV2ScreenState();
}

class _PPOBV2ScreenState extends State<PPOBV2Screen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  late TextEditingController phoneNumberC;
  late TextEditingController plnC;

  Timer? debounce;

  String icon = "";
  String type = "";
  
  int selectedChannel = 0;
  int selectedChannelPln = 0;

  int selectedPulse = -1;
  int selectedEmoney = -1;
      
  List<Map<String, dynamic>> ppobs = [
    {
      "id": 1,
      "name": "Pulsa",
      "image": "assets/images/icons/ic-pulsa.png"
    },
    {
      "id": 2,
      "name": "Paket Data",
      "image": "assets/images/icons/ic-paketdata.png"
    },
    {
      "id": 3,
      "name": "Listrik",
      "image": "assets/images/icons/ic-pln.png"
    },
  ];

  @override 
  void initState() {
    super.initState();

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
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorResources.white,
      body: SafeArea(
        child: buildBodyContent(context)
      )
    );
  }

  Widget buildBodyContent(context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {

        return Stack(
          clipBehavior: Clip.none,
          children: [

            CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [

                const CustomAppBar(title: 'PPOB').buildSliverAppBar(context),

                SliverPadding(
                  padding: const EdgeInsets.only(
                    top: 60.0, 
                    bottom: 20.0
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([

                      GridView.builder(
                        primary: false,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3/2,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0
                        ),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ppobs.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                                  
                                  Container(
                                    height: 85.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF1F1F1),
                                      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                      boxShadow: boxShadow
                                    ),
                                    width: 150.0,
                                    child: Material(
                                      color: const Color(0xffF1F1F1),
                                      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                      child: InkWell(
                                        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                        onTap: () {
                                          switch (ppobs[i]["id"]) {
                                            case 1: 
                                            NS.push(context, const PulsaScreen());
                                            break;
                                            case 2: 
                                            NS.push(context, const PaketDataScreen());
                                            break;
                                            case 3: 
                                            NS.push(context, const ListrikScreen());
                                            break;
                                            default:
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 10.0
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(ppobs[i]["name"],
                                                textAlign: TextAlign.center,
                                                style: poppinsRegular.copyWith(
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) 
                                      ),
                                    ),
                                  ),
                                                  
                                  Positioned(
                                    top: -25.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        switch (ppobs[i]["id"]) {
                                          case 1: 
                                          NS.push(context, const PulsaScreen());
                                          break;
                                          case 2: 
                                          NS.push(context, const PaketDataScreen());
                                          break;
                                          case 3: 
                                          NS.push(context, const ListrikScreen());
                                          break;
                                          default:
                                        }
                                      },
                                      child: Image.asset(
                                        ppobs[i]["image"],
                                        width: 60.0,
                                        height: 60.0,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    )
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                      )

                    ])
                  ),
                )
              ],
            ),

        ],
      );
    },
    );
  }
}