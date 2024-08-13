import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/data/models/checkin/checkin.dart';

import 'package:hp3ki/views/basewidgets/appbar/custom.dart';
import 'package:hp3ki/views/basewidgets/loader/circular.dart';

import 'package:hp3ki/views/screens/checkin/create.dart';
import 'package:hp3ki/views/screens/checkin/detail.dart';

import 'package:hp3ki/providers/checkin/checkin.dart';
import 'package:hp3ki/providers/location/location.dart';

import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/color_resources.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  CheckInScreenState createState() => CheckInScreenState();
}

class CheckInScreenState extends State<CheckInScreen> {

  int checkInIdLoading = -1;

  Future<void> getData() async {
    if(!mounted) return;
      context.read<CheckInProvider>().getCheckIn(context);
    
    if(!mounted) return;
      context.read<LocationProvider>().getCurrentPositionCheckIn(context);
  }

  void join(String checkInId) {
    buildAskToActionDialog(
      question: 'Apakah anda mau bergabung?',
      onPress: () {
        context.read<CheckInProvider>().joinCheckIn(context, checkInId);
      },
    );
  }

  void delete(String checkInId) {
    buildAskToActionDialog(
      question: 'Hapus Check-In Ini?',
      onPress: () {
        context.read<CheckInProvider>().deleteCheckIn(context, checkInId);
      },
    );
  }

  @override 
  void initState() {
    super.initState();

    Future.microtask(() => getData());
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
      body: RefreshIndicator(
        onRefresh: () {
          return Future.sync(() {
            context.read<CheckInProvider>().getCheckIn(context);
          });
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            buildAppBar(),
            buildBodyContent(),
          ],
        ),
      ),
      floatingActionButton: buildCreateCheckInButton(), 
    );
  }

  SliverAppBar buildAppBar() {
    return const CustomAppBar(title: 'Check-In').buildSliverAppBar(context);
  }

  Consumer<CheckInProvider> buildBodyContent() {
    return Consumer<CheckInProvider>(
      builder: (BuildContext context, CheckInProvider checkInProvider, Widget? child) {
        if(checkInProvider.checkInStatus == CheckInStatus.loading) {
          return buildLoadingContent();
        } 
        if(checkInProvider.checkInStatus == CheckInStatus.empty) {
          return buildEmptyContent(context);
        } 
        if(checkInProvider.checkInStatus == CheckInStatus.error) {
          return buildContentError(context);
        } 
        return buildContent();
      },
    );
  }

  SliverFillRemaining buildLoadingContent() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: SpinKitThreeBounce(
          size: 20.0,
          color: ColorResources.primary,
        ),
      )
    );
  }

  SliverFillRemaining buildEmptyContent(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(getTranslated("THERE_IS_NO_DATA", context),
          style: poppinsRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: ColorResources.black
          ),
        )
      )
    );
  }

  SliverFillRemaining buildContentError(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text('Ada yang bermasalah',
          style: poppinsRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: ColorResources.black
          ),
        )
      )
    );
  }

  SliverList buildContent() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Consumer<CheckInProvider>(
          builder: (BuildContext context, CheckInProvider checkInProvider, Widget? child) {      
            return ListView.separated(
              separatorBuilder: (BuildContext context, int i) {
                return Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: const Divider(
                    thickness: 0.8,
                  ),
                );
              },
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: checkInProvider.checkInData.length,
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  margin: const EdgeInsets.only(
                    left: 16.0, 
                    right: 16.0
                  ),
                  child: Card(
                    margin: const EdgeInsets.all(10.0),
                    elevation: 8.0,
                    color: checkInProvider.checkInData[i].isPass! 
                    ? Colors.grey
                    : Colors.white,
                    surfaceTintColor: checkInProvider.checkInData[i].isPass! 
                    ? Colors.grey
                    : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () => showModalInfo(checkInProvider.checkInData[i]),
                                  child: const Icon(Icons.info),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  buildLeftSide(context, checkInProvider, i),
                                  buildRightSide(checkInProvider, i),
                                  const SizedBox(width: 15.0)
                                ],
                              ),
                            ],
                          ),
                        ),
                        buildRowSection(context, checkInProvider, i),
                      ],
                    )
                  )
                );
              }
            );  
          }, 
        ),
      ])
    );
  }

  Expanded buildLeftSide(BuildContext context, CheckInProvider checkInProvider, int i) {
    return Expanded(
      flex: 7,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: Dimensions.marginSizeDefault, 
              right: Dimensions.marginSizeDefault,
              bottom: Dimensions.marginSizeExtraSmall
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 6,
                  child: Text(getTranslated("TITLE", context),
                    style: poppinsRegular.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Container()
                ),
                Expanded(
                  flex: 20,
                  child: Text(checkInProvider.checkInData[i].title ?? "...",
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  ) 
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: Dimensions.marginSizeDefault, 
              right: Dimensions.marginSizeDefault,
              bottom: Dimensions.marginSizeExtraSmall
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 6,
                  child: Text(getTranslated("PLACE", context),
                    style: poppinsRegular.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Container()
                ),
                Expanded(
                  flex: 20,
                  child: Text(checkInProvider.checkInData[i].location ?? "...",
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  )
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: Dimensions.marginSizeDefault, 
              right: Dimensions.marginSizeDefault,
              bottom: Dimensions.marginSizeExtraSmall
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 6,
                  child: Text(getTranslated('DATE', context),
                    style: poppinsRegular.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Container()
                ),
                Expanded(
                  flex: 20,
                  child: Text(Helper.formatDate(DateTime.parse(checkInProvider.checkInData[i].checkinDate?.replaceAll('/', '-') ?? DateTime.now().toString())),
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  )
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: Dimensions.marginSizeDefault, 
              right: Dimensions.marginSizeDefault,
              bottom: Dimensions.marginSizeExtraSmall
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 6,
                  child: Text(getTranslated('TIME', context),
                    style: poppinsRegular.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Container()
                ),
                Expanded(
                  flex: 20,
                  child: Text("${checkInProvider.checkInData[i].start} s/d ${checkInProvider.checkInData[i].end}",
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault
                    ),
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildRightSide(CheckInProvider checkInProvider, int i) {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildUserPicture(checkInProvider, i),
              const SizedBox(height: 5.0),
              Text(checkInProvider.checkInData[i].user?.name ?? "...",
                style: poppinsRegular.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: Dimensions.fontSizeSmall
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              )
            ],  
          ),
          const SizedBox(height: 10.0),
          SharedPrefs.getUserId() == checkInProvider.checkInData[i].user!.id
          ? buildOtherButton(
              context,
              label: 'Hapus',
              bgColor: ColorResources.error,
              onPressed: () => delete(checkInProvider.checkInData[i].id!),
            ) 
          : checkInProvider.checkInData[i].join == true
            ? buildOtherButton(context, label: 'Gabung', bgColor: ColorResources.dimGrey) 
            : buildJoinButton(checkInProvider, i),
        ],
      )  
    );
  }

  CachedNetworkImage buildUserPicture(CheckInProvider checkInProvider, int i) {
    String? avatar = checkInProvider.checkInData[i].user!.avatar;
    return CachedNetworkImage(
      imageUrl: avatar!.isNotEmpty ? avatar : AppConstants.avatarError,
      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
        return CircleAvatar(
          backgroundColor: ColorResources.backgroundDisabled,
          radius: 25.0,
          backgroundImage: imageProvider,
        );
      },
      placeholder: (BuildContext context, String placeholder) {
        return const CircleAvatar(
          backgroundColor: ColorResources.backgroundDisabled,
          radius: 25.0,
          backgroundImage: AssetImage("assets/images/logo/logo.png"),
        ); 
      },
      errorWidget: (BuildContext context, String error, dynamic _) {
        return const CircleAvatar(
          backgroundColor: ColorResources.backgroundDisabled,
          radius: 25.0,
          backgroundImage: AssetImage("assets/images/logo/logo.png"),
        ); 
      },
    );
  }

  Selector<CheckInProvider, CheckInStatusJoin> buildJoinButton(CheckInProvider checkInProvider, int i) {
    return Selector<CheckInProvider, CheckInStatusJoin>(
      builder: (BuildContext context, CheckInStatusJoin checkInStatusJoin, Widget? child) {
      return SizedBox(
        height: 60.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 3.0, 
            backgroundColor: checkInProvider.checkInData[i].isPass!
            ? Colors.grey 
            : Colors.green[300]!,
          ),
          onPressed: () => checkInProvider.checkInData[i].isPass! 
          ? () {} 
          : join(checkInProvider.checkInData[i].id!),
          child: checkInProvider.checkInData[i].id == checkInProvider.checkInDataSelected
          ? const Loader(
              color: ColorResources.white,
            ) 
          : Text(getTranslated('JOIN', context),
            style: poppinsRegular.copyWith(
              color: ColorResources.white,
              fontSize: Dimensions.fontSizeSmall
            ),
          ),
        ),
      );
    },
    selector: (BuildContext context, CheckInProvider checkInProvider) => checkInProvider.checkInStatusJoin);
  }

  SizedBox buildOtherButton(BuildContext context, {required String label, required Color bgColor, void Function()? onPressed}) {
    return SizedBox(
        height: 60.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 3.0, backgroundColor: bgColor,
          ),
          onPressed: onPressed,
          child: Text(label,
          style: poppinsRegular.copyWith(
            color: ColorResources.white,
            fontSize: Dimensions.fontSizeSmall
          ),
        ),
      ),
    );
  }

  Widget buildRowSection(BuildContext context, CheckInProvider checkInProvider, int i) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10.0, 
        left: 10.0, 
        right: 10.0, 
        bottom: 10.0
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: () {
                NS.push(context, CheckInDetailScreen(index: i));
              },
              child: Text("${getTranslated('SEE', context)} ${getTranslated('WHO_HAS_JOINED', context)} ",
                style: poppinsRegular.copyWith(
                  color: ColorResources.primary, 
                  fontStyle: FontStyle.italic,
                  fontSize: Dimensions.fontSizeDefault
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton buildCreateCheckInButton() {
    return FloatingActionButton(
      onPressed: () {
        NS.push(context, const CreateCheckInScreen());
      },
      backgroundColor: ColorResources.primary,
      elevation: 1.0,
      child: const Icon(
        Icons.add,
        color: ColorResources.white
      ),
    );
  }

  AwesomeDialog buildAskToActionDialog({required String question, required void Function()? onPress}) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      btnCancelOnPress: () {},
      btnCancelText: 'Batal',
      btnOkText: 'OK',
      btnOkOnPress: onPress,
      dialogType: DialogType.question,
      desc: question,
    )..show();
  }

  void showModalInfo(CheckInData data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[50],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        )
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Wrap(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorResources.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  boxShadow: kElevationToShadow[1],
                ),
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rincian Check-In', 
                      style: poppinsRegular.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.fontSizeLarge,
                        color: ColorResources.white
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: ColorResources.white,
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  ModalTile(
                    label: 'Pembuat',
                    text: data.user?.name,
                  ),
                  const Divider(
                    color: ColorResources.dimGrey,
                  ),
                  ModalTile(
                    label: 'Caption',
                    text: data.title,
                  ),
                  const Divider(
                    color: ColorResources.dimGrey,
                  ),
                  ModalTile(
                    label: 'Deskripsi',
                    text: data.desc,
                  ),
                  const Divider(
                    color: ColorResources.dimGrey,
                  ),
                  ModalTile(
                    label: 'Tempat',
                    text: data.location,
                  ),
                  const Divider(
                    color: ColorResources.dimGrey,
                  ),
                  ModalTile(
                    label: 'Tanggal',
                    text: Helper.formatDate(DateTime.parse(Helper.getFormatedDate(data.checkinDate))),
                  ),
                  const Divider(
                    color: ColorResources.dimGrey,
                  ),
                  ModalTile(
                    label: 'Waktu',
                    text: "${data.start} s/d ${data.end}" ,
                  ),
                  const Divider(
                    color: ColorResources.dimGrey,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ModalTile extends StatelessWidget {
  final String? label;
  final String? text;

  const ModalTile({
    super.key, required this.label, required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return ListTile(
      leading: Text(label ?? "-",
        style: poppinsRegular.copyWith(
          fontWeight: FontWeight.w600,
        )
      ),
      minLeadingWidth: screenSize.width * 0.5,
      title: Text(text ?? "..."),
    );
  }
}