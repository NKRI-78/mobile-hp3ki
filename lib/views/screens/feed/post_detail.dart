import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hp3ki/providers/profile/profile.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:hp3ki/localization/language_constraints.dart';
import 'package:hp3ki/providers/feed/feed.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/data/models/feed/feedsdetail.dart';
import 'package:hp3ki/views/screens/feed/widgets/post_link.dart';
import 'package:hp3ki/views/screens/feed/widgets/post_text.dart';
import 'package:hp3ki/views/screens/feed/replies.dart';
import 'package:hp3ki/views/screens/feed/widgets/post_doc.dart';
import 'package:hp3ki/views/screens/feed/widgets/post_img.dart';
import 'package:hp3ki/views/screens/feed/widgets/post_video.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({
    Key? key, 
    required this.postId,
  }) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool deletePostBtn = false;
  
  TextEditingController commentC = TextEditingController();
  FocusNode commentFn = FocusNode();

  @override
  void initState() {  
    super.initState();
    Future.delayed(Duration.zero, () {
      if(mounted) {
        context.read<FeedProvider>().fetchForumDetail(context, widget.postId);
      }
    });
  }

  Future<void> deleteComment(BuildContext context, String commentId) async {
    await context.read<FeedProvider>().deleteComment(
      context,
      commentId: commentId,
      postId: widget.postId,
    );               
  }

  Future<void> deletePost(BuildContext context, String postId) async {
    try {         
      await context.read<FeedProvider>().deleteForum(context, postId);               
      setState(() => deletePostBtn = false); 
    } catch(e, stacktrace) {
      setState(() => deletePostBtn = false);
      debugPrint(stacktrace.toString()); 
    }
  }

  Widget commentText(BuildContext context, CommentElement comment) {
    return ReadMoreText(
      comment.comment ?? "...",
      style: poppinsRegular.copyWith(
        fontSize: Dimensions.fontSizeDefault
      ),
      trimLines: 2,
      colorClickableText: ColorResources.black,
      trimMode: TrimMode.Line,
      trimCollapsedText: getTranslated("READ_MORE", context),
      trimExpandedText: getTranslated("LESS", context),
      moreStyle: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w600),
      lessStyle: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.w600),
    );
  }

  SliverToBoxAdapter post(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<FeedProvider>(
        builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
          if (feedProvider.forumDetailStatus == ForumDetailStatus.loading) {
            return const SizedBox(
              height: 100.0,
              child: Center(
                child: SpinKitThreeBounce(
                  size: 20.0,
                  color: ColorResources.primary,
                )
              ),
            );
          }
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
                    imageUrl: feedProvider.forumDetail.data!.user!.profilePic ?? "https://p7.hiclipart.com/preview/92/319/609/computer-icons-person-clip-art-name.jpg",
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
                  title: Text(feedProvider.forumDetail.data!.user?.fullname ?? "...",
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: ColorResources.black
                    ),
                  ),
                  subtitle: Text(timeago.format((feedProvider.forumDetail.data!.createdAt!.toLocal()), locale: getTranslated('LOCALE', context)),
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: ColorResources.dimGrey
                    ),
                  ),
                  trailing: SharedPrefs.getUserId() == feedProvider.forumDetail.data!.user!.uid 
                  ? grantedDeletePost(context, feedProvider.forumDetail.data!.uid!) 
                  : const SizedBox()
                ),

                const SizedBox(height: 5.0),
                  if(feedProvider.forumDetail.data!.forumType == 'link')
                    PostLink(
                      url: feedProvider.forumDetail.data!.media!.first.path,
                      caption: feedProvider.forumDetail.data!.caption ?? "..."),
                  if(feedProvider.forumDetail.data!.forumType == 'text') 
                    PostText(feedProvider.forumDetail.data!.caption ?? "..."),
                  if(feedProvider.forumDetail.data!.forumType == "document")
                    PostDoc(
                      medias: feedProvider.forumDetail.data!.media ?? [], 
                      caption: feedProvider.forumDetail.data!.caption!
                    ),
                  if(feedProvider.forumDetail.data!.forumType == 'image')
                    PostImage(
                      false,
                      feedProvider.forumDetail.data!.media ?? [], 
                      feedProvider.forumDetail.data!.caption ?? "..."
                    ),
                  if(feedProvider.forumDetail.data!.forumType == 'video')
                    PostVideo(
                      media : feedProvider.forumDetail.data!.media!.first, 
                      caption: feedProvider.forumDetail.data!.caption!
                    ),
                Container(
                  margin: const EdgeInsets.only(top: Dimensions.marginSizeExtraSmall, left: Dimensions.marginSizeDefault, right: Dimensions.marginSizeDefault),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(feedProvider.forumDetail.data!.forumLikes!.total.toString(),
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
                                  feedProvider.likeForum(context, widget.postId,);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(Icons.thumb_up,
                                  size: 16.0,
                                  color: feedProvider.forumDetail.data!.forumLikes!.likes!.isNotEmpty ? ColorResources.primary : ColorResources.black
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text('${feedProvider.forumDetail.data!.forumComments!.total.toString()} ${getTranslated("COMMENT", context)}',
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.greyLightPrimary,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return [
            buildAppBar(context),
            post(context)
          ];
        },
        body: buildBodyContent()
      ),
      bottomNavigationBar: buildNavBar(context)
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: ColorResources.white,
      title: Text('Post', 
        style: poppinsRegular.copyWith(
          color: ColorResources.black,
          fontSize: Dimensions.fontSizeLarge,
          fontWeight: FontWeight.bold
        ),
      ),
      leading: IconButton(
        icon: Padding(
          padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
          child: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: ColorResources.black,
            size: Dimensions.iconSizeExtraLarge,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
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
              focusNode: commentFn,
              controller: commentC,
              style: poppinsRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeDefault
              ),
              decoration: InputDecoration.collapsed(
                hintText: '${getTranslated("WRITE_COMMENT", context)} ...',
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
              color: ColorResources.primary,
            ),
            onPressed: () async {
              final String membershipStatus = SharedPrefs.getUserMemberType().trim(); 
              if(membershipStatus != "PLATINUM" || membershipStatus == "-"){
                context.read<ProfileProvider>().showNonPlatinumLimit(context);
              } else {
                String commentText = commentC.text;
                if (commentText.trim().isEmpty) {
                  return;
                }
                commentFn.unfocus();
                commentC.clear();
                await context.read<FeedProvider>().sendComment(context, commentText, widget.postId);
              }
            }
          ),
        ],
      ),
    );
  }

  Consumer<FeedProvider> buildBodyContent() {
    return Consumer<FeedProvider>(
        builder: (BuildContext context, FeedProvider feedProvider, Widget? child) {
          if (feedProvider.forumDetailStatus == ForumDetailStatus.loading) {
            return const Center(
              child: SpinKitThreeBounce(
                size: 20.0,
                color: ColorResources.primary,
              )
            );
          } 
          if (feedProvider.forumDetailStatus == ForumDetailStatus.empty) {
            return Center(
              child: Text(getTranslated("THERE_IS_NO_COMMENT", context),
                style: poppinsRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault
                ),
              )
            );
          }
          return NotificationListener<ScrollNotification>(
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int i) {
                return const SizedBox(height: 8.0);
              },
              physics: const BouncingScrollPhysics(),
              itemCount: feedProvider.loadMoreComment == true ? feedProvider.commentList.length + 1 :feedProvider.commentList.length,
              itemBuilder: (BuildContext context, int i) {
                if (feedProvider.commentList.length == i) {
                  return const Center(
                    child: SpinKitThreeBounce(
                      size: 20.0,
                      color: ColorResources.primary
                    )
                  );
                }
                return InkWell(
                  onLongPress: () {
                    if (SharedPrefs.getUserId() == feedProvider.commentList[i].user!.uid) {
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
                        desc: getTranslated('DELETE_COMMENT', context),
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
                          await deleteComment(context, feedProvider.commentList[i].uid!);
                        },
                      ).show();
                    }
                  },
                  child: Column(
                    children: [
                    ListTile(
                      leading: CachedNetworkImage( 
                      imageUrl: feedProvider.commentList[i].user!.profilePic ?? "https://p7.hiclipart.com/preview/92/319/609/computer-icons-person-clip-art-name.jpg",
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
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0)
                          )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(feedProvider.commentList[i].user?.fullname ?? "...",
                                style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    commentText(context, feedProvider.commentList[i])
                                  ],
                                ),
                              ),
                            ]
                          ),
                        )
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 150.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 50.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(feedProvider.commentList[i].commentLikes!.total.toString(),
                                    style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      final String membershipStatus = SharedPrefs.getUserMemberType().trim(); 
                                      if(membershipStatus != "PLATINUM" || membershipStatus == "-"){
                                        context.read<ProfileProvider>().showNonPlatinumLimit(context);
                                      } else {
                                        feedProvider.likeComment(
                                          context,
                                          postId: widget.postId,
                                          commentId: feedProvider.commentList[i].uid!
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(Icons.thumb_up,
                                        size: 16.0,
                                        color: feedProvider.commentList[i].commentLikes!.likes!.isNotEmpty ? ColorResources.primary : ColorResources.black),
                                    ),
                                  ),
                                ]
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => RepliesScreen(
                                      id: feedProvider.commentList[i].uid!,
                                      postId: widget.postId,
                                      i: i,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${getTranslated("REPLY",context)} (${feedProvider.commentList[i].commentReplies!.total!})',
                                style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontStyle: FontStyle.italic)
                                ),
                              )
                            ),
                          ]
                        ),
                      ),
                    )
                  ]),
                );
              },
            ),
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                feedProvider.loadMoreComment = true;
                feedProvider.fetchMoreComment(context);
                feedProvider.stopLoadMoreComment();
              }
              return false;
            },
          );
        },
      );
  }

  Widget grantedDeletePost(context, String postId) {
    return PopupMenuButton(
      itemBuilder: (BuildContext buildContext) { 
        return [
          PopupMenuItem(
            child: Text(getTranslated("DELETE_POST", context),
              style: poppinsRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeDefault
              )
            ), 
            value: "/delete-post"
          )
        ];
      },
      onSelected: (route) {
        if(route == "/delete-post") {
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
            desc: getTranslated('DELETE_POST', context),
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
              await deletePost(context, postId);
            },
          ).show();
        }
      },
    );
  }
}