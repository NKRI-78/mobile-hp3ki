import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/providers/checkin/checkin.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/constant.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

import 'package:hp3ki/views/basewidgets/appbar/custom.dart';

class CheckInDetailScreen extends StatefulWidget {
  final int index;

  const CheckInDetailScreen({Key? key, required this.index}) : super(key: key);

  @override
  _CheckInDetailScreenState createState() => _CheckInDetailScreenState();
}

class _CheckInDetailScreenState extends State<CheckInDetailScreen> {

  Future<void> getData() async {
    if(mounted) {
      context.read<CheckInProvider>().getCheckInDetail(context, widget.index);
    }
  }

  @override 
  void initState() {
    super.initState();

    Future.microtask(() => getData());
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: ColorResources.backgroundDisabled,
      body: buildBodyContent(),  
    );
  }

  AppBar buildAppBar() {
    return CustomAppBar(
      title: context.read<CheckInProvider>().checkInStatusDetail == CheckInStatusDetail.loading 
        ? '(...) ' 
        : context.read<CheckInProvider>().checkInStatusDetail == CheckInStatusDetail.error 
        ? '(...) '
        : '(${context.watch<CheckInProvider>().checkInDetailTotalUser}) ' + getTranslated('DETAIL_CHECKIN', context),
    ).buildAppBar(context);
  }

  Column buildBodyContent() {
    return Column(
      children: [
        Consumer<CheckInProvider>(
          builder: (BuildContext context, CheckInProvider checkInProvider, Widget? child) {
            if(checkInProvider.checkInStatusDetail == CheckInStatusDetail.loading) {
              return const Expanded(
                child: Center(
                  child: SpinKitThreeBounce(
                    size: 20.0,
                    color: ColorResources.primary,
                  )
                ),
              );
            }

            if(checkInProvider.checkInStatusDetail == CheckInStatusDetail.empty) {
              return Expanded(
                child: Center(
                  child: Text(getTranslated('NO_ONE_JOINED', context), 
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge
                    ),
                  )
                ),
              );
            }

            if(checkInProvider.checkInStatusDetail == CheckInStatusDetail.error) {
              return Expanded(
                child: Center(
                  child: Text('Ada yang bermasalah.', 
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge
                    ),
                  )
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: checkInProvider.checkInDetail.length,
                itemBuilder: (BuildContext context, int i) {
                  String? avatar = checkInProvider.checkInDetail[i].avatar;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10.0),
                      tileColor: ColorResources.white,
                      onTap: () {},
                      dense: true,
                      leading: SizedBox(
                        width: 45.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: avatar!.isNotEmpty 
                            ? avatar 
                            : AppConstants.avatarError,
                            fit: BoxFit.fitWidth,
                            placeholder: (BuildContext context, String url) {
                              return const CircleAvatar(
                                backgroundColor: ColorResources.transparent,
                                backgroundImage: AssetImage("assets/images/logo/logo.png")
                              );
                            },
                            errorWidget: (BuildContext context, String url, dynamic error) {
                              return const CircleAvatar(
                                backgroundColor: ColorResources.transparent,
                                backgroundImage: AssetImage("assets/images/logo/logo.png")
                              );
                            },
                          ),
                        ),
                      ),
                      title: Text(checkInProvider.checkInStatusDetail == CheckInStatusDetail.loading 
                      ? "..." 
                      : checkInProvider.checkInStatusDetail == CheckInStatusDetail.error 
                      ? "..." 
                      : checkInProvider.checkInDetail[i].name ?? "...",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault
                        ),
                      ),
                    ),
                  ); 
                },
              ),
            );
          },
        )           
      ],
    );
  }
}