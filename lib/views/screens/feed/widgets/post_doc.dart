import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hp3ki/data/models/feed/feedmedia.dart';
import 'package:hp3ki/services/navigation.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:hp3ki/views/webview/webview.dart';
import 'package:path/path.dart' as b;
import 'package:dio/dio.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:path_provider/path_provider.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class PostDoc extends StatefulWidget {
  final List<FeedMedia> medias;
  final String caption;

  const PostDoc({
    Key? key,
    required this.medias,
    required this.caption,
  }) : super(key: key);

  @override
  _PostDocState createState() => _PostDocState();
}

class _PostDocState extends State<PostDoc> {
  String? type = "";
  Color? color;

  @override
  Widget build(BuildContext context) {
    switch (b.basename(widget.medias[0].path!).split('.').last) {
      case "pdf":
        setState(() {
          type = "PDF";
          color = Colors.red[300];
        });
        break;
      case "ppt":
        setState(() {
          type = "PPT";
          color = Colors.red[300];
        });
        break;
      case "pptx":
        setState(() {
          type = "PPTX";
          color = Colors.red[300];
        });
        break;
      case "txt":
        setState(() {
          type = "TXT";
          color = Colors.blueGrey[300];
        });
        break;
      case "xls":
        setState(() {
          type = "XLS";
          color = Colors.green[300];
        });
        break;
      case "xlsx":
        setState(() {
          type = "XLSX";
          color = Colors.green[300];
        });
        break;
      case "doc":
        setState(() {
          type = "DOC";
          color = ColorResources.primary;
        });
        break;
      case "docx":
        setState(() {
          type = "DOCX";
          color = ColorResources.primary;
        });
        break;
      default:
        setState(
          () {
            type = "link";
            color = ColorResources.blueDrawerPrimary;
          },
        );
    }
    return buildUI();
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                widget.caption,
                style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault),
              ),
            ),
            const SizedBox(height: 12.0),
            Container(
            height: 80.0,
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            decoration: BoxDecoration(
              color: color, 
              borderRadius: BorderRadius.circular(8.0)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  type!,
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w600,
                    color: ColorResources.white
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  child: Text(widget.medias[0].path!.split('/').last,
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: ColorResources.white
                    )
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [

                    IconButton(
                      onPressed: () async {
                        buildAskDialog(context);
                      },
                      color: ColorResources.white,
                      icon: type == "link"
                      ? const Icon(Icons.read_more)
                      : const Icon(Icons.arrow_circle_down),
                    ),

                    const SizedBox(width: 3.0),

                     type == "link" 
                     ? const SizedBox()
                     : IconButton(
                        onPressed: () async {
                          await launchUrl(Uri.parse(widget.medias[0].path!));
                        },
                        color: ColorResources.white,
                        icon: const Icon(Icons.visibility)
                      ) ,

                  ],
                ),
                
              ],
            ))
          ],
        );
      },
    );
  }

  Future<Object?> buildAskDialog(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (BuildContext context, Animation<double> double, _) {
        return Center(
            child: Material(
          color: ColorResources.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 250,
            decoration: BoxDecoration(
                color: ColorResources.white,
                borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Image.asset(
                      "assets/images/auth/Success.png",
                      width: 90.0,
                      height: 90.0,
                    )),
                Text(
                  type == "link"
                      ? "Kunjungi situs ini?"
                      : getTranslated("SAVE_DOCUMENT", context),
                  style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.w600,
                      color: ColorResources.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 30.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(child: Container()),
                          Expanded(
                            flex: 5,
                            child: CustomButton(
                                isBorderRadius: true,
                                btnColor: ColorResources.white,
                                btnTextColor: ColorResources.primary,
                                onTap: () {
                                  NS.pop(context);
                                },
                                btnTxt: getTranslated("CANCEL", context)),
                          ),
                          Expanded(child: Container()),
                          Expanded(
                            flex: 5,
                            child: CustomButton(
                                isBorderRadius: true,
                                btnColor: ColorResources.primary,
                                btnTextColor: ColorResources.white,
                                onTap: () async {
                                  final url = widget.medias[0].path ?? '';
                                  // print(url);
                                  type == "link"
                                      ? NS.push(
                                          context,
                                          WebViewScreen(
                                              url: url,
                                              title: widget.medias[0].path
                                                      ?.split('/')
                                                      .last ??
                                                  '-'))
                                      : await downloadDocument(context);
                                },
                                btnTxt: "OK"),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }
        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  Future<void> downloadDocument(BuildContext context) async {
    ProgressDialog pr = ProgressDialog(context: context);
    try {
      Dio dio = Dio();
      Directory documentsIos = await getApplicationDocumentsDirectory();
      String? saveDir = Platform.isIOS
          ? documentsIos.path
          : await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOCUMENTS);
      String url = widget.medias[0].path!;
      pr.show(
          max: 2,
          msg: getTranslated("PLEASE_WAIT", context),
          progressBgColor: ColorResources.primary);
      await dio.download(url, "$saveDir/${b.basename(widget.medias[0].path!)}");
      pr.close();
      ShowSnackbar.snackbar(
          context,
          "${getTranslated("DOCUMENT_SAVED", context)} $saveDir",
          "",
          ColorResources.success);
      Navigator.of(context, rootNavigator: true).pop();
    } on DioError catch (_) {
      Navigator.of(context, rootNavigator: true).pop();
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      Navigator.of(context, rootNavigator: true).pop();
      ShowSnackbar.snackbar(
          context,
          getTranslated("THERE_WAS_PROBLEM", context),
          "",
          ColorResources.error);
    }
  }
}
