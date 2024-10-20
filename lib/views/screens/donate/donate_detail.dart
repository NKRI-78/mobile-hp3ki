import 'package:flutter/material.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/screens/comingsoon/comingsoon.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver_updated/gallery_saver.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/views/basewidgets/loader/circular.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';

// import 'package:hp3ki/views/screens/ppob/donate/donate_payment.dart';

import 'package:hp3ki/utils/extension.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class DonateDetailScreen extends StatefulWidget {
  final String title;
  final String amount;
  final String imageUrl;
  final DateTime date;

  const DonateDetailScreen({
    Key? key, required 
    this.title, 
    required this.amount, 
    required this.imageUrl, 
    required this.date
  }) : super(key: key);
  @override
  _DetailInfoPageState createState() => _DetailInfoPageState();
}

class _DetailInfoPageState extends State<DonateDetailScreen> {

  String? imageUrl;
  String? title;
  String? amount;
  String? titleMore;

  late ScrollController scrollC;

  bool lastStatus = true;

  void scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return scrollC.hasClients && scrollC.offset > (250 - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();

    scrollC = ScrollController();
    scrollC.addListener(scrollListener);
    
    if (widget.title.length > 24) {
      titleMore = widget.title.substring(0, 24);
    } else {
      titleMore = widget.title;
    }
  }

  @override
  void dispose() {
    scrollC.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();  
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {

        imageUrl = widget.imageUrl;
        title = widget.title;
        amount = widget.amount;

        return Scaffold(
          
          backgroundColor: ColorResources.white,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: scrollC,
            slivers: [
              buildAppBar(context),
              buildBodyContent()
            ],
          ),
        );
      },
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: ColorResources.white,
      pinned: true,
      expandedHeight: 250.0,
      leading: Container(
        margin: const EdgeInsets.all(8.0),
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color:  Colors.black54
        ),
        child: IconButton(
          color: ColorResources.white,
          onPressed: () {
            NS.pop();
          },
          icon: const Icon(Icons.arrow_back),
          iconSize: Dimensions.iconSizeDefault,
        )
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8.0),
          height: 40.0,
          width: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Colors.black54
          ),
          child: Builder(
            builder: (BuildContext context) {
              return PopupMenuButton(
                onSelected: (int i) async {
                  switch (i) {
                    case 1:
                      ProgressDialog pr = ProgressDialog(context: context);
                      try {
                        PermissionStatus statusStorage = await Permission.storage.status;
                        if(!statusStorage.isGranted) {
                          await Permission.storage.request();
                        } 
                        pr.show(
                          max: 1,
                          msg: '${getTranslated("DOWNLOADING", context)}...'
                        );
                        await GallerySaver.saveImage("${AppConstants.baseUrlImg}/${widget.imageUrl}");
                        pr.close();
                        ShowSnackbar.snackbar(getTranslated("SAVE_TO_GALLERY", context), "", ColorResources.success);
                      } catch(e, stacktrace) {
                        pr.close();
                        ShowSnackbar.snackbar(getTranslated("THERE_WAS_PROBLEM", context), "", ColorResources.error);
                        debugPrint(stacktrace.toString());
                      }
                    break;
                    default:
                  }
                },
                icon: const Icon(Icons.more_horiz),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeSmall,
                      right: Dimensions.paddingSizeSmall
                    ),
                    textStyle: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    ),
                    child: Text(getTranslated("DOWNLOAD", context),
                      style: poppinsRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: ColorResources.black
                      )
                    ),
                    value: 1,
                  ),
                ]
              );                 
            },
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CachedNetworkImage(
            //FIXME:
            // imageUrl: "${AppConstants.baseUrlImg}$imageUrl",
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            placeholder: (BuildContext context, String url)  {
              return const Loader(
                color: ColorResources.primary,
              );
            },
            errorWidget: (BuildContext context, String url, dynamic error) {
              return Center(
                child: Image.asset('assets/images/logo/logo.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                )
              );
            }
          ),
        ),
        title: AnimatedOpacity(
          opacity: isShrink ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 150),
          child: Text(
            titleMore! + "...",
            maxLines: 1,
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.w600,
              color: ColorResources.black, 
            ),
          ),
        ),
      ),
    );
  }

  SliverList buildBodyContent() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitleSection(),
              buildDonatedAmountSection(),
              const SizedBox(height: 10,),
              buildSubmitButton(),
              const SizedBox(height: 20,),
              buildFundraisingSection(),
              const SizedBox(height: 15,),
              buildVictimSection(),
            ],
          ),
        )
      ])
    );
  }

  Widget buildTitleSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 5.0),
      child: AnimatedOpacity(
        opacity: isShrink ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 250),
        child: Text(title!.toTitleCase(),
        textAlign: TextAlign.start,
          style: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeOverLarge,
            color: ColorResources.black,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget buildDonatedAmountSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            amount!,
            style: robotoRegular.copyWith(
              color: ColorResources.primary, 
              fontSize: Dimensions.fontSizeLarge,
              fontWeight: FontWeight.w600
            ),
          ),
          const SizedBox(width: 15,),
          Text(
            "${getTranslated('ACCUMULATED_FROM', context)} Rp200.000.000",
            style: robotoRegular.copyWith(
              color: ColorResources.grey, 
              fontSize: Dimensions.fontSizeDefault
            ),
          ),
        ],
      )
    );
  }

  Widget buildSubmitButton() {
    return SizedBox(
      height: 55.0,
      width: double.infinity,
      child: CustomButton(
        onTap: () => NS.push(context, const ComingSoonScreen(title: 'Pembayaran Donasi')),
        customText: true,
        text: Text(
          getTranslated('DONATE_NOW', context),
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
      )
    );
  }

  Widget buildFundraisingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(getTranslated('FUNDRAISER_INFO', context),
          style: poppinsRegular.copyWith(
            color: ColorResources.black,
            fontWeight: FontWeight.w600
          ),
        ),
        const SizedBox(height: 10,),
        Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color(0xffF2F2F2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getTranslated('FUNDRAISER', context),
                style: poppinsRegular.copyWith(
                  color: ColorResources.black.withOpacity(0.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30.0,
                    child: Text('M'),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bpk. Mike Jose',
                        style: poppinsRegular.copyWith(
                          color: ColorResources.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(getTranslated('PERSON_INCHARGE_DONATION', context),
                        style: poppinsRegular.copyWith(
                          color: ColorResources.black.withOpacity(0.5),
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                      Text(getTranslated('VERIFIED_IDENTITY', context),
                        style: poppinsRegular.copyWith(
                          color: ColorResources.black.withOpacity(0.5),
                          fontSize: Dimensions.fontSizeSmall,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildVictimSection() {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xffF2F2F2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getTranslated('VICTIM', context),
            style: poppinsRegular.copyWith(
              color: ColorResources.black.withOpacity(0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5,),
          Row(
            children: [
              const CircleAvatar(
                radius: 30.0,
                child: Text('W'),
              ),
              const SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Warga RT 07',
                    style: poppinsRegular.copyWith(
                      color: ColorResources.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(getTranslated('VERIFIED_IDENTITY', context),
                    style: poppinsRegular.copyWith(
                      color: ColorResources.black.withOpacity(0.5),
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 15,),
          Row(
            children: [
              const CircleAvatar(
                radius: 30.0,
                child: Text('B'),
              ),
              const SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kebanjiran',
                    style: poppinsRegular.copyWith(
                      color: ColorResources.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(getTranslated('PROVEN_INCIDENT', context),
                    style: poppinsRegular.copyWith(
                      color: ColorResources.black.withOpacity(0.5),
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}