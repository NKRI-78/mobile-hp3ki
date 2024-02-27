import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:hp3ki/data/models/feed/feedsdetail.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:readmore/readmore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/providers/feed/feed.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';

class RepliesScreen extends StatefulWidget {
  final String id;
  final String postId;
  final int i;

  const RepliesScreen({Key? key, 
    required this.id,
    required this.postId,
    required this.i,
  }) : super(key: key);

  @override
  _RepliesScreenState createState() => _RepliesScreenState();
}

class _RepliesScreenState extends State<RepliesScreen> {
  
  late TextEditingController replyC;
  late  FocusNode replyFn;

  bool isExpanded = false;

  Widget commentText(CommentElement data) {
    return ReadMoreText(
      data.comment ?? "...",
      trimLines: 2,
      colorClickableText: ColorResources.black,
      trimMode: TrimMode.Line,
      trimCollapsedText: getTranslated("READ_MORE", context),
      trimExpandedText: getTranslated("LESS", context),
      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
      moreStyle: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w600),
      lessStyle: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w600),
    );
  }

  Widget replyText(CommentReply data) {
    return ReadMoreText(
      data.reply ?? "...",
      trimLines: 2,
      colorClickableText: ColorResources.black,
      trimMode: TrimMode.Line,
      trimCollapsedText: getTranslated("READ_MORE", context),
      trimExpandedText: getTranslated("LESS", context),
      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
      moreStyle: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w600),
      lessStyle: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w600),
    );
  }

  Widget comment(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<FeedProvider>(
        builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
          if(feedProvider.forumDetailStatus == ForumDetailStatus.loading) {
            return const SizedBox(
              height: 100.0,
              child: Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primary,
                ),
              ),
            );
          }
          CommentElement data = feedProvider.forumDetailData!.forumComments!.comments![widget.i];
          return Container(
            color: ColorResources.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  color: ColorResources.black.withOpacity(0.5),
                  thickness: 0.5,
                ),
                ListTile(
                  dense: true,
                  leading: CachedNetworkImage( 
                      imageUrl: data.user!.profilePic ?? "https://p7.hiclipart.com/preview/92/319/609/computer-icons-person-clip-art-name.jpg",
                      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                        return CircleAvatar(
                          backgroundColor: ColorResources.transparent,
                          backgroundImage: imageProvider,
                          radius: 20.0,
                        );
                      },
                      placeholder: (BuildContext context, _) {
                        return const CircleAvatar(
                          backgroundColor: ColorResources.black,
                          backgroundImage: AssetImage('assets/images/icons/ic-person.png'),
                          radius: 20.0,
                        );
                      },
                      errorWidget: (BuildContext context, _, dynamic data) {
                        return const CircleAvatar(
                          backgroundColor: ColorResources.black,
                          backgroundImage: AssetImage('assets/images/icons/ic-person.png'),
                          radius: 20.0,
                        ); 
                      },
                    ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(data.user?.fullname ?? "....",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                    ]
                  ),
                ),
                const SizedBox(height: 5.0),
                Container(
                  margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      commentText(data)
                    ],
                  )
                ),
                const SizedBox(height: 5.0),
                Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                            Text(data.commentLikes!.total.toString(),
                              style: poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault
                              )
                            ),
                            InkWell(
                              onTap: () {  
                              final String membershipStatus = SharedPrefs.getUserMemberType().trim(); 
                              if(membershipStatus != "PLATINUM" || membershipStatus == "-"){
                                context.read<ProfileProvider>().showNonPlatinumLimit(context);
                              } else {
                                  feedProvider.likeComment(
                                    context,
                                    commentId: widget.id,
                                    postId: widget.postId
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(Icons.thumb_up,
                                  size: 16.0,
                                  color: data.commentLikes!.likes!.isNotEmpty 
                                  ? ColorResources.primary 
                                  : ColorResources.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text('${data.commentReplies!.total.toString()} ${getTranslated("REPLY", context)}',
                        style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                      ),
                    ]
                  )
                ),
                const SizedBox(height: 10.0,)
              ]
            ),
          );
        },
      )
    );
  }

  Future<void> delete(BuildContext context, String replyId) async {
    await context.read<FeedProvider>().deleteReply(
      context, 
      postId: widget.postId,
      replyId: replyId,
    );               
  }

  @override 
  void initState() {
    super.initState();
    replyC = TextEditingController();
    replyFn = FocusNode();
    Future.delayed(Duration.zero, () {
      if(mounted) {
        context.read<FeedProvider>().fetchForumDetail(context, widget.postId);
      }
    }); 
  }

  @override 
  void dispose() {
    replyC.dispose();
    replyFn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      backgroundColor: ColorResources.greyLightPrimary,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          buildAppBar(context),
          comment(context)
        ];
      }, 
      body: buildBodyContent()
  ),
  bottomNavigationBar: buildNavBar(context));
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: ColorResources.white,
      title: Text(getTranslated("REPLY_COMMENT", context), 
        style: poppinsRegular.copyWith(
          color: ColorResources.black,
          fontSize: Dimensions.fontSizeLarge,
          fontWeight: FontWeight.bold
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
        child: IconButton(
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: ColorResources.black,
            size: Dimensions.iconSizeExtraLarge,
          ),
          onPressed: () => Navigator.of(context).pop()
        ),
      ),
      elevation: 0.0,
      pinned: false,
      centerTitle: false,
      floating: true,
    );
  }

  Widget buildNavBar(BuildContext context) {
    return Container(
    padding: MediaQuery.of(context).viewInsets,
    decoration: const BoxDecoration(
      color: ColorResources.white
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(width: 16.0),
        Expanded(
          child: TextField(
            controller: replyC,
            focusNode: replyFn,
            style: poppinsRegular.copyWith(
              color: ColorResources.black,
              fontSize: Dimensions.fontSizeDefault
            ),
            decoration: InputDecoration.collapsed(
              hintText: '${getTranslated("WRITE_REPLY", context)} ...',
              hintStyle: poppinsRegular.copyWith(
                color: ColorResources.black.withOpacity(0.6),
                fontSize: Dimensions.fontSizeDefault
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.send,
            color: ColorResources.primary
          ),
          onPressed: () async {
            final String membershipStatus = SharedPrefs.getUserMemberType().trim(); 
            if(membershipStatus != "PLATINUM" || membershipStatus == "-"){
              context.read<ProfileProvider>().showNonPlatinumLimit(context);
            } else {
              String replyText = replyC.text;
              if (replyText.trim().isEmpty) {
                return;
              }
              replyFn.unfocus();
              replyC.clear();
              await context.read<FeedProvider>().sendReply(
                context,
                text: replyText,
                commentId: widget.id,
                postId: widget.postId
              );
            }
          }
        ),
      ],
    ));
  }

  Consumer<FeedProvider> buildBodyContent() {
    return Consumer<FeedProvider>(
      builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
        if (feedProvider.forumDetailStatus == ForumDetailStatus.loading) {
          return const Center(
            child: SpinKitThreeBounce(
              size: 20.0,
              color: ColorResources.primary
            )
          );
        }
        CommentReplies data = feedProvider.forumDetailData!.forumComments!.comments![widget.i].commentReplies!;
        if (data.replies!.isEmpty) {
          return Center(
            child: Text(getTranslated("THERE_IS_NO_REPLY", context),
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault
              ),
            )
          );
        }
        return NotificationListener<ScrollNotification>(
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int i) {
              return const SizedBox(
                height: 16.0
              );
            },
            physics: const BouncingScrollPhysics(),
            itemCount: data.replies!.length,
            itemBuilder: (BuildContext context, int i) {
              if (data.replies!.length == i) {
                return const Center(
                  child: CupertinoActivityIndicator()
                );
              }
            return InkWell(
              onLongPress: () async {
                if (data.replies![i].user!.uid == SharedPrefs.getUserId()) {
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
                      color: ColorResources.black
                    ),
                    desc: getTranslated('DELETE_REPLY', context),
                    descTextStyle: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: ColorResources.black
                    ),
                    btnCancelColor: ColorResources.primary,
                    btnCancelText: getTranslated('CANCEL', context),
                    btnCancelOnPress: () {},
                    btnOkColor: ColorResources.error,
                    btnOkText: "Ok",
                    btnOkOnPress: () async {
                      await delete(context, data.replies![i].uid!);
                    },
                  ).show();
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: ListTile(
                  dense: true,
                  leading: CachedNetworkImage( 
                    imageUrl: "${data.replies![i].user!.profilePic}",
                    imageBuilder: (BuildContext context, ImageProvider imageProvider) {
                      return CircleAvatar(
                        backgroundColor: ColorResources.transparent,
                        backgroundImage: imageProvider,
                        radius: 20.0,
                      );
                    },
                    placeholder: (BuildContext context, _) {
                      return const CircleAvatar(
                        backgroundColor: ColorResources.black,
                        backgroundImage: AssetImage('assets/images/icons/ic-person.png'),
                        radius: 20.0,
                      );
                    },
                    errorWidget: (BuildContext context, _, dynamic data) {
                      return const CircleAvatar(
                        backgroundColor: ColorResources.black,
                        backgroundImage: AssetImage('assets/images/icons/ic-person.png'),
                        radius: 20.0,
                      ); 
                    },
                  ),
                  title: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: ColorResources.white,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
            
                      Text(data.replies![i].user?.fullname ?? "....",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black
                        ),
                      ),
            
                      Container(
                        margin: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            replyText(data.replies![i]),
                          ],
                        )
                      ),
                    ]
                  ),
                ),
              ),
                      ),
            );
        },
      ),
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {

        }
          return false;
        },
      );
    },
  );
  }
}