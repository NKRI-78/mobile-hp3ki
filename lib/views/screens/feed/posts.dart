import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
// import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/data/models/feed/feeds.dart';

import 'package:intl/intl.dart';

import 'package:hp3ki/providers/feed/feed.dart';
// import 'package:hp3ki/providers/profile/profile.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

import 'package:hp3ki/views/screens/feed/widgets/post_video.dart';
import 'package:hp3ki/views/screens/feed/widgets/post_doc.dart';
import 'package:hp3ki/views/screens/feed/widgets/post_img.dart';
import 'package:hp3ki/views/screens/feed/widgets/post_link.dart';
import 'package:hp3ki/views/screens/feed/widgets/post_text.dart';
import 'package:hp3ki/views/screens/feed/post_detail.dart';

class Posts extends StatefulWidget {
  final int i;
  final List<FeedData> feedData;

  const Posts({
    Key? key,
    required this.i,
    required this.feedData,
  }) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  bool deletePostBtn = false;

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Future<void> delete(BuildContext context, String forumId) async {
    setState(() => deletePostBtn = true);
    try {
      await context.read<FeedProvider>().deleteForum(context, forumId);
      setState(() => deletePostBtn = false);
    } catch (e, stacktrace) {
      setState(() => deletePostBtn = false);
      debugPrint(stacktrace.toString());
    }
  }

  Widget buildUI() {
    return InkWell(
      onLongPress: () {},
      onTap: () {
        NS.push(context, PostDetailScreen(
          postId: widget.feedData[widget.i].uid!,
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(top: Dimensions.marginSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                dense: true,
                leading: CachedNetworkImage(
                  imageUrl: widget.feedData[widget.i].user!.profilePic ?? "https://p7.hiclipart.com/preview/92/319/609/computer-icons-person-clip-art-name.jpg",
                  imageBuilder:
                      (BuildContext context, ImageProvider imageProvider) {
                    return CircleAvatar(
                      backgroundColor: ColorResources.transparent,
                      backgroundImage: imageProvider,
                      radius: 20.0,
                    );
                  },
                  placeholder: (BuildContext context, _) {
                    return const CircleAvatar(
                      backgroundColor: ColorResources.black,
                      backgroundImage:
                          AssetImage('assets/images/icons/ic-person.png'),
                      radius: 20.0,
                    );
                  },
                  errorWidget: (BuildContext context, _, dynamic data) {
                    return const CircleAvatar(
                      backgroundColor: ColorResources.black,
                      backgroundImage:
                          AssetImage('assets/images/icons/ic-person.png'),
                      radius: 20.0,
                    );
                  },
                ),
                title: Text(
                  widget.feedData[widget.i].user!.fullname ?? "...",
                  style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: ColorResources.black),
                ),
                subtitle: Text(
                  DateFormat(null, getTranslated('LOCALE', context)).format(
                    widget.feedData[widget.i].createdAt!,
                  ),
                  style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: ColorResources.dimGrey),
                ),
                trailing: widget.feedData[widget.i].user!.uid ==
                        SharedPrefs.getUserId()
                    ? grantedDeletePost(context, widget.feedData[widget.i].uid!)
                    : PopupMenuButton(
                        itemBuilder: (BuildContext buildContext) {
                          return [
                            PopupMenuItem(
                                child: Text(
                                    getTranslated('BLOCK_CONTENT', context),
                                    style: poppinsRegular.copyWith(
                                        color: ColorResources.error,
                                        fontSize: Dimensions.fontSizeDefault)),
                                value: "/report-user"),
                            PopupMenuItem(
                                child: Text(
                                    getTranslated('BLOCK_USER', context),
                                    style: poppinsRegular.copyWith(
                                        color: ColorResources.error,
                                        fontSize: Dimensions.fontSizeDefault)),
                                value: "/report-user"),
                            PopupMenuItem(
                                child: Text(getTranslated('SPAM', context),
                                    style: poppinsRegular.copyWith(
                                        color: ColorResources.error,
                                        fontSize: Dimensions.fontSizeDefault)),
                                value: "/report-user"),
                            PopupMenuItem(
                                child: Text(getTranslated('NUDITY', context),
                                    style: poppinsRegular.copyWith(
                                        color: ColorResources.error,
                                        fontSize: Dimensions.fontSizeDefault)),
                                value: "/report-user"),
                            PopupMenuItem(
                                child: Text(getTranslated('FAKE_INFO', context),
                                    style: poppinsRegular.copyWith(
                                        color: ColorResources.error,
                                        fontSize: Dimensions.fontSizeDefault)),
                                value: "/report-user")
                          ];
                        },
                        onSelected: (route) {
                          if (route == "/report-user") {
                            showAnimatedDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                    child: Container(
                                        height: 150.0,
                                        padding: const EdgeInsets.all(10.0),
                                        margin: const EdgeInsets.only(
                                            top: 10.0,
                                            bottom: 10.0,
                                            left: 16.0,
                                            right: 16.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 10.0),
                                              const Icon(
                                                Icons.delete,
                                                color: ColorResources.black,
                                              ),
                                              const SizedBox(height: 10.0),
                                              Text(
                                                getTranslated(
                                                    "ARE_YOU_SURE_REPORT",
                                                    context),
                                                style: poppinsRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(height: 10.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: Text(
                                                          getTranslated(
                                                              "NO", context),
                                                          style: poppinsRegular
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeDefault))),
                                                  StatefulBuilder(builder:
                                                      (BuildContext context,
                                                          Function s) {
                                                    return ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    ColorResources
                                                                        .error),
                                                      ),
                                                      onPressed: () async {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        getTranslated(
                                                            "YES", context),
                                                        style: poppinsRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeDefault),
                                                      ),
                                                    );
                                                  })
                                                ],
                                              )
                                            ])));
                              },
                            );
                          }
                        },
                      )),
            const SizedBox(height: 5.0),
            if (widget.feedData[widget.i].forumType == 'link')
              PostLink(
                  url: widget.feedData[widget.i].media!.first.path,
                  caption: widget.feedData[widget.i].caption ?? "..."),
            if (widget.feedData[widget.i].forumType == 'text')
              PostText(widget.feedData[widget.i].caption ?? "..."),
            if (widget.feedData[widget.i].forumType == "document")
              PostDoc(
                  medias: widget.feedData[widget.i].media ?? [],
                  caption: widget.feedData[widget.i].caption!),
            if (widget.feedData[widget.i].forumType == 'image')
              PostImage(false, widget.feedData[widget.i].media ?? [],
                  widget.feedData[widget.i].caption ?? "..."),
            if (widget.feedData[widget.i].forumType == 'video')
              PostVideo(
                  media: widget.feedData[widget.i].media!.first,
                  caption: widget.feedData[widget.i].caption!),
            Container(
                margin: const EdgeInsets.only(
                    top: Dimensions.marginSizeExtraSmall,
                    bottom: Dimensions.marginSizeDefault,
                    left: Dimensions.marginSizeDefault,
                    right: Dimensions.marginSizeDefault),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                                widget.feedData[widget.i].forumLikes?.total
                                        .toString() ??
                                    "...",
                                style: poppinsRegular.copyWith(
                                    color: ColorResources.black,
                                    fontSize: Dimensions.fontSizeDefault)),
                            InkWell(
                              onTap: () {
                                final String membershipStatus =
                                    SharedPrefs.getUserMemberType().trim();
                                if (membershipStatus != "PLATINUM" ||
                                    membershipStatus == "-") {
                                  context
                                      .read<ProfileProvider>()
                                      .showNonPlatinumLimit(context);
                                } else {
                                  context.read<FeedProvider>().likeForum(
                                        context,
                                        widget.feedData[widget.i].uid!,
                                      );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(Icons.thumb_up,
                                    size: 16.0,
                                    color: widget.feedData[widget.i].forumLikes!
                                            .likes!.isNotEmpty
                                        ? ColorResources.primary
                                        : ColorResources.black),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(
                        '${widget.feedData[widget.i].forumComments?.total.toString()} ${getTranslated("COMMENT", context)}',
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault),
                      )
                    ])),
          ],
        ),
      ),
    );
  }

  Widget grantedDeletePost(BuildContext context, String forumId) {
    return PopupMenuButton(
      itemBuilder: (BuildContext buildContext) {
        return [
          PopupMenuItem(
              child: Text(getTranslated("DELETE_POST", context),
                  style: poppinsRegular.copyWith(
                      color: ColorResources.black,
                      fontSize: Dimensions.fontSizeDefault)),
              value: "/delete-post")
        ];
      },
      onSelected: (route) {
        if (route == "/delete-post") {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.topSlide,
            title: getTranslated('WARNING', context),
            dismissOnBackKeyPress: true,
            dismissOnTouchOutside: true,
            titleTextStyle: poppinsRegular.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.fontSizeExtraLarge,
                color: ColorResources.black),
            desc: getTranslated('DELETE_POST', context),
            descTextStyle: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: ColorResources.black),
            btnCancelColor: ColorResources.primary,
            btnCancelText: getTranslated('CANCEL', context),
            btnCancelOnPress: () {},
            btnOkColor: ColorResources.error,
            btnOkText: "Ok",
            btnOkOnPress: () async {
              await delete(context, forumId);
            },
          ).show();
        }
      },
    );
  }
}
