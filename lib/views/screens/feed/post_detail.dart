import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hp3ki/data/models/feedv2/feedDetail.dart';
import 'package:hp3ki/providers/feedv2/feedReply.dart';
import 'package:hp3ki/views/basewidgets/button/custom.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:hp3ki/data/models/feedv2/feedDetail.dart' as m;

import 'package:hp3ki/providers/feedv2/feed.dart';
import 'package:hp3ki/providers/feedv2/feedDetail.dart' as p;
import 'package:hp3ki/providers/profile/profile.dart';

import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';

import 'package:hp3ki/utils/date_util.dart';

import 'package:hp3ki/views/screens/feed/widgets/post_doc.dart';
import 'package:hp3ki/views/screens/feed/widgets/post_img.dart';
import 'package:hp3ki/views/screens/feed/widgets/post_link.dart';
import 'package:hp3ki/views/screens/feed/widgets/post_video.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/views/basewidgets/loader/circular.dart';

import 'package:hp3ki/views/screens/feed/widgets/post_text.dart';

class PostDetailScreen extends StatefulWidget {
  final String forumId;
  final String commentId;
  final String replyId;
  final String from;

  const PostDetailScreen({
    Key? key, 
    required this.forumId,
    required this.commentId,
    required this.replyId,
    required this.from
  }) : super(key: key);

  @override
  PostDetailScreenState createState() => PostDetailScreenState();
}

class PostDetailScreenState extends State<PostDetailScreen> {

  GlobalKey<FlutterMentionsState> mentionKey = GlobalKey<FlutterMentionsState>();

  ValueNotifier<TextStyle> textStyleNotifier = ValueNotifier<TextStyle>(robotoRegular.copyWith(
    color: ColorResources.black,
    fontSize: Dimensions.fontSizeDefault
  ));

  String previousText = "";

  late FeedReplyProvider frp;
  late p.FeedDetailProviderV2 feedDetailProvider;
  
  bool deletePostBtn = false;

  Timer? debounce;
  
  FocusNode commentFn = FocusNode();

  Widget commentText(BuildContext context, String comment) {
    return ReadMoreText(
      comment,
      style: robotoRegular.copyWith(
        fontSize: Dimensions.fontSizeDefault
      ),
      trimLines: 2,
      colorClickableText: ColorResources.black,
      trimMode: TrimMode.Line,
      trimCollapsedText: getTranslated("READ_MORE", context),
      trimExpandedText: getTranslated("LESS_MORE", context),
      moreStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
      lessStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
    );
  }

  Widget post(BuildContext context) {
    return Consumer<p.FeedDetailProviderV2>(
      builder: (BuildContext context, p.FeedDetailProviderV2 feedDetailProviderV2, Widget? child) {

        if (feedDetailProviderV2.feedDetailStatus == p.FeedDetailStatus.loading) {
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
          margin: const EdgeInsets.only(top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            mainAxisSize: MainAxisSize.min,
            children: [

              ListTile(
                dense: true,
                leading: CachedNetworkImage(
                imageUrl: feedDetailProviderV2.feedDetailData.forum!.user?.avatar ?? "-",
                  imageBuilder: (BuildContext context, dynamic imageProvider) => CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: imageProvider,
                    radius: 20.0,
                  ),
                  placeholder: (BuildContext context, String url) => const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                    radius: 20.0,
                  ),
                  errorWidget: (BuildContext context, String url, dynamic error) => const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                    radius: 20.0,
                  )
                ),
                title: Text(feedDetailProviderV2.feedDetailData.forum!.user!.username.toString(),
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.black
                  ),
                ),
                subtitle: Text(DateHelper.formatDateTime(feedDetailProviderV2.feedDetailData.forum!.createdAt!, context),
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: ColorResources.dimGrey
                  ),
                ),
                trailing: context.read<ProfileProvider>().user!.id == feedDetailProviderV2.feedDetailData.forum!.user?.id
                ? grantedDeletePost(context) 
                :  PopupMenuButton(
                    itemBuilder: (BuildContext buildContext) { 
                      return [
                        PopupMenuItem(
                          child: Text("block user",
                            style: robotoRegular.copyWith(
                              color: ColorResources.error,
                              fontSize: Dimensions.fontSizeSmall
                            )
                          ), 
                          value: "/report-user"
                        ),
                        PopupMenuItem(
                          child: Text("It's spam",
                            style: robotoRegular.copyWith(
                              color: ColorResources.error,
                              fontSize: Dimensions.fontSizeSmall
                            )
                          ), 
                          value: "/report-user"
                        ),
                        PopupMenuItem(
                          child: Text("Nudity or sexual activity",
                            style: robotoRegular.copyWith(
                              color: ColorResources.error,
                              fontSize: Dimensions.fontSizeSmall
                            )
                          ), 
                          value: "/report-user"
                        ),
                        PopupMenuItem(
                          child: Text("False Information",
                            style: robotoRegular.copyWith(
                              color: ColorResources.error,
                              fontSize: Dimensions.fontSizeSmall
                            )
                          ), 
                          value: "/report-user"
                        )
                      ];
                    },
                    onSelected: (route) {
                      if(route == "/report-user") {
                        showAnimatedDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Container(
                              height: 150.0,
                              padding: const EdgeInsets.all(10.0),
                              margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 10.0),
                                  const Icon(Icons.delete,
                                    color: ColorResources.black,
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(getTranslated("ARE_YOU_SURE_REPORT", context),
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
    
                                      ElevatedButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text(getTranslated("NO", context),
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall
                                          )
                                        )
                                      ), 
    
                                      StatefulBuilder(
                                        builder: (BuildContext context, Function s) {
                                        return ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                            ColorResources.error
                                          ),
                                        ),
                                        onPressed: () async { 
                                          Navigator.of(context, rootNavigator: true).pop(); 
                                        },
                                        child: Text(getTranslated("YES", context), 
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall
                                          ),
                                        ),                           
                                      );
                                    })
    
                                  ],
                                ) 
                              ])
                            )
                          );
                        },
                      );
                    }
                  },
                )
              ),
        
              const SizedBox(height: 5.0),
              
              Container(
                margin: const EdgeInsets.only(left: 15.0),
                child: PostText(feedDetailProviderV2.feedDetailData.forum!.caption ?? "-")
              ),
              if(feedDetailProviderV2.feedDetailData.forum!.type == "link")
                PostLink(url: feedDetailProviderV2.feedDetailData.forum!.link ?? "-"),
              if (feedDetailProviderV2.feedDetailData.forum!.type == "document")
                feedDetailProviderV2.feedDetailData.forum!.media!.isNotEmpty ? 
                PostDoc(
                  medias: feedDetailProviderV2.feedDetailData.forum!.media!, 
                ) : Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular),
              if (feedDetailProviderV2.feedDetailData.forum!.type == "image")
                feedDetailProviderV2.feedDetailData.forum!.media!.isNotEmpty ? 
              PostImage(
                true,
                feedDetailProviderV2.feedDetailData.forum!.media!, 
              ): Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular),
              if (feedDetailProviderV2.feedDetailData.forum!.type == "video")
                feedDetailProviderV2.feedDetailData.forum!.media!.isNotEmpty ? 
                PostVideo(
                  media: feedDetailProviderV2.feedDetailData.forum!.media![0].path,
                ): Text(getTranslated("THERE_WAS_PROBLEM", context), style: robotoRegular),
          
              Container(
                margin: const EdgeInsets.only(
                  top: 5.0, 
                  left: 15.0, 
                  right: 15.0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
    
                    SizedBox(
                      width: 40.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.thumb_up,
                              size: 18.0,
                              color: feedDetailProviderV2.feedDetailData.forum!.like!.likes.where((el) => el.user!.id ==  feedDetailProviderV2.ar.getUserId()).isEmpty ? ColorResources.black : ColorResources.blue
                            ),
                          ),
                          
                          Text("${feedDetailProviderV2.feedDetailData.forum!.like!.total}",
                            style: robotoRegular.copyWith(
                              color: ColorResources.black,
                              fontSize: Dimensions.fontSizeDefault
                            )
                          ),

                        ],
                      ),
                    ),
    
                    Text('${feedDetailProviderV2.feedDetailData.forum!.comment!.total} ${getTranslated("COMMENT", context)}',
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault
                      ),
                    ),
                    
                  ]
                )
              ),

              Container(
                margin: const EdgeInsets.only(
                  top: 15.0,
                  bottom: 15.0,
                  left: 15.0, 
                  right: 15.0
                ),
                child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: feedDetailProviderV2.feedDetailData.forum!.like!.likes.where(
                        (el) => el.user!.id == feedDetailProviderV2.ar.getUserId()).isEmpty 
                        ? ColorResources.primary 
                        : ColorResources.error
                      ),
                      onPressed: () {
                        context.read<p.FeedDetailProviderV2>().toggleLike(
                          context: context, 
                          forumId: feedDetailProviderV2.feedDetailData.forum!.id!, 
                          forumLikes: feedDetailProviderV2.feedDetailData.forum!.like!
                        );
                      }, 
                      child: Text(getTranslated("LIKE", context),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.fontSizeDefault
                        ),
                      )
                    ),
                  ),

                  const SizedBox(width: 12.0),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        
                      }, 
                      child: Text(getTranslated("COMMENT", context),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.fontSizeDefault
                        ),
                      )
                    ),
                  ),

                ],
              ),
            ),
        
            ]
          ),
        );
      },
    );
  }

  Future<void> getData() async {
    if(!mounted) return; 
      await feedDetailProvider.getUserMentions(context, '');

    if(!mounted) return;
      await feedDetailProvider.getFeedDetail(context, widget.forumId);

    if(widget.from == "notification-comment") {

      int index = feedDetailProvider.comments.indexWhere((el) => el.id == widget.commentId);

      feedDetailProvider.onUpdateHighlightComment(widget.commentId);

      Future.delayed(const Duration(milliseconds: 100), () {
        GlobalKey targetContext = feedDetailProvider.comments[index].key;
        Scrollable.ensureVisible(targetContext.currentContext!,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      });

      Future.delayed(const Duration(milliseconds: 1000), () {
        feedDetailProvider.onUpdateHighlightComment("");
      });

    }

    if(widget.from == "notification-reply") {

      int indexC = feedDetailProvider.comments.indexWhere((el) => el.id == widget.commentId);

      feedDetailProvider.onUpdateHighlightReply(widget.replyId);

      Future.delayed(const Duration(milliseconds: 100), () {
        if(feedDetailProvider.comments[indexC].reply.replies.isNotEmpty) {
          GlobalKey targetContext = feedDetailProvider.comments[indexC].reply.replies.last.key;
          Scrollable.ensureVisible(targetContext.currentContext!,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      });

      Future.delayed(const Duration(milliseconds: 1000), () {
        feedDetailProvider.onUpdateHighlightReply("");
      });

    }

  }

  @override
  void initState() {  
    super.initState();

    frp = context.read<FeedReplyProvider>();
    feedDetailProvider = context.read<p.FeedDetailProviderV2>();

    Future.microtask(() => getData());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: () {
          return Future.sync(() {
            feedDetailProvider.getFeedDetail(context, widget.forumId);
          });
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
        
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              backgroundColor: ColorResources.white,
              title: Text('Post', 
                style: robotoRegular.copyWith(
                  color: ColorResources.black,
                  fontWeight: FontWeight.w600,
                  fontSize: Dimensions.fontSizeDefault
                )
              ),
              leading: CupertinoNavigationBarBackButton(
                color: ColorResources.black,
                onPressed: () {
                  NS.pop(context);
                },
              ),
              elevation: 0.0,
              pinned: false,
              centerTitle: false,
              floating: true,
            ),
        
            SliverList(
              delegate: SliverChildListDelegate([
        
                post(context),
                
                Consumer<p.FeedDetailProviderV2>(
                  builder: (BuildContext context, p.FeedDetailProviderV2 feedDetailProviderV2, Widget? child) {
                    if (feedDetailProviderV2.feedDetailStatus == p.FeedDetailStatus.loading) {
                      return const Center(
                        child: SpinKitThreeBounce(
                          size: 20.0,
                          color: ColorResources.primary,
                        )
                      );
                    } 
                    if (feedDetailProviderV2.feedDetailStatus == p.FeedDetailStatus.empty) {
                      return Center(
                        child: Text(getTranslated("THERE_IS_NO_COMMENT", context),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault
                          ),
                        )
                      );
                    }
                    return NotificationListener(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification) {
                          if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                            if (feedDetailProviderV2.hasMore) {
                              feedDetailProviderV2.loadMoreComment(context: context, postId: widget.forumId);
                            }
                          }
                        }
                        return false;
                      },
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int i) {
                          return const SizedBox(height: 8.0);
                        },
                        physics: const BouncingScrollPhysics(),
                        itemCount: feedDetailProviderV2.comments.length,
                        itemBuilder: (BuildContext context, int i) {

                          m.CommentElement comment = feedDetailProviderV2.comments[i];
                                          
                          return Container(
                            key: comment.key,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: CachedNetworkImage(
                                  imageUrl: comment.user.avatar,
                                    imageBuilder: (BuildContext context, dynamic imageProvider) => CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: imageProvider,
                                      radius: 20.0,
                                    ),
                                    placeholder: (BuildContext context, String url) => const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                                      radius: 20.0,
                                    ),
                                    errorWidget: (BuildContext context, String url, dynamic error) => const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                                      radius: 20.0,
                                    )
                                  ),
                                  title: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: context.watch<p.FeedDetailProviderV2>().highlightedComment == comment.id 
                                      ? ColorResources.backgroundLive
                                      : ColorResources.blueGrey,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)
                                      )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(comment.user.username,
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                            ),
                                          ),

                                          const SizedBox(height: 8.0),
                                          
                                          Text(DateHelper.formatDateTime(comment.createdAt, context),
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeExtraSmall,
                                              color: ColorResources.dimGrey
                                            ),
                                          ),
                                          
                                          const SizedBox(height: 8.0),

                                          commentText(context, comment.comment),
                                          
                                        ]
                                      ),
                                    ),
                                    trailing: context.read<ProfileProvider>().user!.id == comment.user.id 
                                    ? grantedDeleteComment(context, comment.id)
                                    : PopupMenuButton(
                                      itemBuilder: (BuildContext buildContext) { 
                                        return [
                                          PopupMenuItem(
                                            child: Text("block user",
                                              style: robotoRegular.copyWith(
                                                color: ColorResources.error,
                                                fontSize: Dimensions.fontSizeSmall
                                              )
                                            ), 
                                            value: "/report-user"
                                          ),
                                          PopupMenuItem(
                                            child: Text("It's spam",
                                              style: robotoRegular.copyWith(
                                                color: ColorResources.error,
                                                fontSize: Dimensions.fontSizeSmall
                                              )
                                            ), 
                                            value: "/report-user"
                                          ),
                                          PopupMenuItem(
                                            child: Text("Nudity or sexual activity",
                                              style: robotoRegular.copyWith(
                                                color: ColorResources.error,
                                                fontSize: Dimensions.fontSizeSmall
                                              )
                                            ), 
                                            value: "/report-user"
                                          ),
                                          PopupMenuItem(
                                            child: Text("False Information",
                                              style: robotoRegular.copyWith(
                                                color: ColorResources.error,
                                                fontSize: Dimensions.fontSizeSmall
                                              )
                                            ), 
                                            value: "/report-user"
                                          )
                                        ];
                                      },
                                      onSelected: (route) {
                                        if(route == "/report-user") {
                                          showAnimatedDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                child: Container(
                                                height: 150.0,
                                                padding: const EdgeInsets.all(10.0),
                                                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const SizedBox(height: 10.0),
                                                    const Icon(Icons.delete,
                                                      color: ColorResources.black,
                                                    ),
                                                    const SizedBox(height: 10.0),
                                                    Text(getTranslated("ARE_YOU_SURE_REPORT", context),
                                                      style: robotoRegular.copyWith(
                                                        fontSize: Dimensions.fontSizeSmall,
                                                        fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10.0),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () => Navigator.of(context).pop(),
                                                          child: Text(getTranslated("NO", context),
                                                            style: robotoRegular.copyWith(
                                                              fontSize: Dimensions.fontSizeSmall
                                                            )
                                                          )
                                                        ), 
                                                        StatefulBuilder(
                                                          builder: (BuildContext context, Function s) {
                                                          return ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all(
                                                              ColorResources.error
                                                            ),
                                                          ),
                                                          onPressed: () async { 
                                                            Navigator.of(context, rootNavigator: true).pop(); 
                                                          },
                                                          child: Text(getTranslated("YES", context), 
                                                            style: robotoRegular.copyWith(
                                                              fontSize: Dimensions.fontSizeSmall
                                                            ),
                                                          ),                           
                                                        );
                                                      })
                                                    ],
                                                  ) 
                                                ])
                                              )
                                            );
                                          },
                                        );
                                      }
                                    },
                                  )
                                ),

                                Container(
                                  width: 140.0,
                                  margin: const EdgeInsets.only(
                                    left: 65.0,
                                    right: 65.0
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      InkWell(
                                        onTap: () {
                                          feedDetailProviderV2.toggleLikeComment(
                                            context: context, 
                                            forumId: widget.forumId, 
                                            commentId: comment.id, 
                                            commentLikes: comment.like
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(Icons.thumb_up,
                                            size: 18.0,
                                            color: comment.like.likes.where(
                                            (el) => el.user!.id == feedDetailProviderV2.ar.getUserId()
                                            ).isEmpty ? ColorResources.black : ColorResources.blue
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 8.0),
                                                                          
                                      Text(comment.like.total.toString(),
                                        style: robotoRegular.copyWith(
                                          color: ColorResources.black,
                                          fontSize: Dimensions.fontSizeDefault
                                        ),
                                      ),

                                      const SizedBox(width: 8.0),

                                      InkWell(
                                        onTap: () {

                                          mentionKey.currentState!.controller!.text = "@${comment.user.mention} ";
                                          previousText = "@${comment.user.mention} ";

                                          feedDetailProvider.onUpdateIsReplyId(comment.id);

                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(getTranslated("REPLY",context),
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              fontWeight: FontWeight.bold
                                            )
                                          ),
                                        ),
                                      ),

                                    ]
                                  ),
                                ),

                                comment.reply.replies.isEmpty 
                                ? const SizedBox() 
                                : Container(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                      left: 40.0
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: comment.reply.replies.length,
                                      itemBuilder: (BuildContext context, int i) {
                                      ReplyElement reply = comment.reply.replies[i];
                                  
                                      return Container(
                                        key: reply.key,
                                        child: ListTile(
                                          leading: CachedNetworkImage(
                                          imageUrl: reply.user.avatar.toString(),
                                            imageBuilder: (BuildContext context, dynamic imageProvider) => CircleAvatar(
                                              backgroundColor: Colors.transparent,
                                              backgroundImage: imageProvider,
                                              radius: 20.0,
                                            ),
                                            placeholder: (BuildContext context, String url) => const CircleAvatar(
                                              backgroundColor: Colors.transparent,
                                              backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                                              radius: 20.0,
                                            ),
                                            errorWidget: (BuildContext context, String url, dynamic error) => const CircleAvatar(
                                              backgroundColor: Colors.transparent,
                                              backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                                              radius: 20.0,
                                            )
                                          ),
                                          title: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                            color: context.watch<p.FeedDetailProviderV2>().highlightedReply == reply.id 
                                              ? ColorResources.backgroundLive
                                              : ColorResources.blueGrey,
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(8.0)
                                              )
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                                          
                                                Text(reply.user.username.toString(),
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeDefault,
                                                  ),
                                                ),
                                                
                                                const SizedBox(height: 8.0),
                                                                        
                                                Text(DateHelper.formatDateTime(reply.createdAt.toString(), context),
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeExtraSmall,
                                                    color: ColorResources.dimGrey
                                                  ),
                                                ),
                                                  
                                                const SizedBox(height: 8.0),
                                                                        
                                                commentText(context, reply.reply.toString()),
                                        
                                              ]
                                            ),
                                          ),
                                          trailing: context.read<ProfileProvider>().user!.id == reply.user.id 
                                          ? grantedDeleteReply(context, widget.forumId, reply.id)
                                          : PopupMenuButton(
                                              itemBuilder: (BuildContext buildContext) { 
                                                return [
                                                  PopupMenuItem(
                                                    child: Text("block user",
                                                      style: robotoRegular.copyWith(
                                                        color: ColorResources.error,
                                                        fontSize: Dimensions.fontSizeSmall
                                                      )
                                                    ), 
                                                    value: "/report-user"
                                                  ),
                                                  PopupMenuItem(
                                                    child: Text("It's spam",
                                                      style: robotoRegular.copyWith(
                                                        color: ColorResources.error,
                                                        fontSize: Dimensions.fontSizeSmall
                                                      )
                                                    ), 
                                                    value: "/report-user"
                                                  ),
                                                  PopupMenuItem(
                                                    child: Text("Nudity or sexual activity",
                                                      style: robotoRegular.copyWith(
                                                        color: ColorResources.error,
                                                        fontSize: Dimensions.fontSizeSmall
                                                      )
                                                    ), 
                                                    value: "/report-user"
                                                  ),
                                                  PopupMenuItem(
                                                    child: Text("False Information",
                                                      style: robotoRegular.copyWith(
                                                        color: ColorResources.error,
                                                        fontSize: Dimensions.fontSizeSmall
                                                      )
                                                    ), 
                                                    value: "/report-user"
                                                  )
                                                ];
                                              },
                                              onSelected: (route) {
                                                if(route == "/report-user") {
                                                  showAnimatedDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        child: Container(
                                                        height: 150.0,
                                                        padding: const EdgeInsets.all(10.0),
                                                        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            const SizedBox(height: 10.0),
                                                            const Icon(Icons.delete,
                                                              color: ColorResources.black,
                                                            ),
                                                            const SizedBox(height: 10.0),
                                                            Text(getTranslated("ARE_YOU_SURE_REPORT", context),
                                                              style: robotoRegular.copyWith(
                                                                fontSize: Dimensions.fontSizeSmall,
                                                                fontWeight: FontWeight.w600
                                                              ),
                                                            ),
                                                            const SizedBox(height: 10.0),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed: () => Navigator.of(context).pop(),
                                                                  child: Text(getTranslated("NO", context),
                                                                    style: robotoRegular.copyWith(
                                                                      fontSize: Dimensions.fontSizeSmall
                                                                    )
                                                                  )
                                                                ), 
                                                                StatefulBuilder(
                                                                  builder: (BuildContext context, Function s) {
                                                                  return ElevatedButton(
                                                                  style: ButtonStyle(
                                                                    backgroundColor: MaterialStateProperty.all(
                                                                      ColorResources.error
                                                                    ),
                                                                  ),
                                                                  onPressed: () async { 
                                                                    Navigator.of(context, rootNavigator: true).pop(); 
                                                                  },
                                                                  child: Text(getTranslated("YES", context), 
                                                                    style: robotoRegular.copyWith(
                                                                      fontSize: Dimensions.fontSizeSmall
                                                                    ),
                                                                  ),                           
                                                                );
                                                              })
                                                            ],
                                                          ) 
                                                        ])
                                                      )
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          )
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              ]
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        
              ])
            )
        
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: MediaQuery.of(context).viewInsets,
        decoration: const BoxDecoration(
          color: ColorResources.white
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            
            Expanded(
              child: ValueListenableBuilder<TextStyle>(
                valueListenable: textStyleNotifier,
                builder: (context, textStyle, child) {
                  return FlutterMentions(
                    key: mentionKey,
                    appendSpaceOnAdd: true,
                    suggestionPosition: SuggestionPosition.Top,
                    onSearchChanged: (String trigger, String val) async {
                      await feedDetailProvider.getUserMentions(context, val);
                    },
                    onChanged: (String val) {
                      feedDetailProvider.onListenComment(val);

                      // if (val.contains('@')) {
                      //   textStyleNotifier.value =robotoRegular.copyWith(
                      //     color: ColorResources.blue,
                      //     fontSize: Dimensions.fontSizeDefault
                      //   );
                      // } else {
                      //   textStyleNotifier.value =robotoRegular.copyWith(
                      //     color: ColorResources.black,
                      //     fontSize: Dimensions.fontSizeDefault
                      //   );
                      // }
        
                      final currentText = mentionKey.currentState!.controller!.text;

                      if (previousText.length - currentText.length == 1) {
                        feedDetailProvider.onUpdateIsReplyId("");
                      }
                    },
                    style: textStyle,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0
                      ),
                      hintText: '${getTranslated("WRITE_COMMENT", context)} ...',
                      hintStyle: robotoRegular.copyWith(
                        color: ColorResources.greyDarkPrimary,
                        fontSize: Dimensions.fontSizeDefault
                      ),
                    ),
                    mentions: [
                      
                      Mention(
                        trigger: '@',
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                        data: context.watch<p.FeedDetailProviderV2>().userMentions,
                        suggestionBuilder: (Map<String, dynamic> data) {

                          return Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [

                              CachedNetworkImage(
                                imageUrl: data['photo'].toString(),
                                imageBuilder: (context, imageProvider) {
                                  return CircleAvatar(
                                    backgroundImage: imageProvider,
                                  );
                                },
                                placeholder: (_, __) {
                                  return const CircleAvatar(
                                    backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                                  );
                                },
                                errorWidget: (_, ___, __) {
                                  return const CircleAvatar(
                                    backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                                  );
                                },
                              ),

                              const SizedBox(
                                width: 20.0,
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(data['fullname']),
                                  Text('@${data['display']}',
                                    style: robotoRegular.copyWith(
                                      color: Colors.blue
                                    ),
                                  ),
                                ],
                              )

                            ],
                          ),
                        );
                      }),

                    ]
                  );
              }),
            ),
            
            IconButton(
              icon: const Icon(
                Icons.send,
                color: ColorResources.black,
              ),
              onPressed: () async {
                await feedDetailProvider.postComment(
                  context, mentionKey, widget.forumId
                );
              } 
            ),
            
          ],
        ),
      )
    );
  }

  Widget grantedDeletePost(context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext buildContext) { 
        return [
          PopupMenuItem(
            child: Text(getTranslated("DELETE_POST", context),
              style: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeSmall
              )
            ), 
            value: "/delete-post"
          )
        ];
      },
      onSelected: (route) {
        if(route == "/delete-post") {
          showAnimatedDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                height: 150.0,
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10.0),
                    const Icon(
                      Icons.delete,
                      color: ColorResources.white,
                    ),
                    const SizedBox(height: 10.0),
                    Text(getTranslated("DELETE_POST", context),
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(getTranslated("NO", context),
                            style: robotoRegular,
                          )
                        ), 
                        StatefulBuilder(
                          builder: (BuildContext context, Function s) {
                          return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorResources.error
                          ),
                          onPressed: () async { 
                          s(() => deletePostBtn = true);
                            try {         
                              await context.read<FeedProviderV2>().deletePost(context, feedDetailProvider.feedDetailData.forum!.id!);               
                              s(() => deletePostBtn = false);
                              Navigator.of(context).pop();             
                            } catch(e) {
                              s(() => deletePostBtn = false);
                              debugPrint(e.toString()); 
                            }
                          },
                          child: deletePostBtn 
                          ? const Loader(
                              color: ColorResources.white,
                            )
                          : Text(getTranslated("YES", context),
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall
                              ),
                            )
                          );
                        })
                      ],
                    ) 
                  ])
                )
              );
            },
          );
        }
      },
    );
  }

  Widget grantedDeleteReply(
    context, 
    forumId,
    replyId
  ) {
    return PopupMenuButton(
      itemBuilder: (BuildContext buildContext) { 
        return [
          PopupMenuItem(
            child: Text(getTranslated("DELETE_REPLY", context),
              style: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeSmall
              )
            ), 
            value: "/delete-post"
          )
        ];
      },
      onSelected: (route) {
        if(route == "/delete-post") {
          showAnimatedDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.only(
                      left: 25.0,
                      right: 25.0
                    ),
                    child: CustomDialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      minWidth: 180.0,
                      child: Transform.rotate(
                        angle: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: ColorResources.white,
                              width: 1.0
                            )
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Transform.rotate(
                                    angle: 56.5,
                                    child: Container(
                                      margin: const EdgeInsets.all(5.0),
                                      height: 270.0,
                                      decoration: BoxDecoration(
                                        color: ColorResources.white,
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        top: 50.0,
                                        left: 25.0,
                                        right: 25.0,
                                        bottom: 25.0
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [

                                          Image.asset("assets/imagesv2/remove.png",
                                            width: 60.0,
                                            height: 60.0,
                                          ),
                                          
                                          const SizedBox(height: 15.0),

                                          Text(getTranslated("DELETE_POST", context),
                                            style: poppinsRegular.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              color: ColorResources.black
                                            ),
                                          ),

                                          const SizedBox(height: 20.0),

                                          StatefulBuilder(
                                            builder: (BuildContext context, Function setState) {
                                              return  Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                
                                                  Expanded(
                                                    child: CustomButton(
                                                      isBorderRadius: true,
                                                      isBoxShadow: true,
                                                      btnColor: ColorResources.error,
                                                      isBorder: false,
                                                      onTap: () {
                                                        Navigator.of(context).pop();
                                                      }, 
                                                      btnTxt: getTranslated("NO", context)
                                                    ),
                                                  ),
                                
                                                  const SizedBox(width: 8.0),
                                
                                                  Expanded(
                                                    child: CustomButton(
                                                      isBorderRadius: true,
                                                      isBoxShadow: true,
                                                      btnColor: ColorResources.success,
                                                      onTap: () async {
                                                        setState(() => deletePostBtn = true);
                                                        try {         
                                                          await context.read<p.FeedDetailProviderV2>().deleteReply(
                                                            context: context,
                                                            forumId: forumId,
                                                            replyId: replyId,
                                                          );               
                                                          setState(() => deletePostBtn = false);     
                                                          Navigator.of(context).pop();       
                                                        } catch(e, stacktrace) {
                                                          setState(() => deletePostBtn = false);
                                                          debugPrint(stacktrace.toString()); 
                                                        }
                                                      }, 
                                                      btnTxt: deletePostBtn 
                                                      ? "..." 
                                                      : getTranslated("YES", context)
                                                    ),
                                                  )
                                
                                                ],
                                              );
                                            },
                                          ),

                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ) 
                        ),
                      ),
                    ),
                  );
                },
              ); 
            },
          );
        }
      },
    );
  }

  Widget grantedDeleteComment(context, String idComment) {
    return PopupMenuButton(
      itemBuilder: (BuildContext buildContext) { 
        return [
          PopupMenuItem(
            child: Text(getTranslated("DELETE_COMMENT", context),
              style: robotoRegular.copyWith(
                color: ColorResources.black,
                fontSize: Dimensions.fontSizeSmall
              )
            ), 
            value: "/delete-post"
          )
        ];
      },
      onSelected: (route) {
        if(route == "/delete-post") {
          showAnimatedDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                height: 150.0,
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10.0),
                    const Icon(
                      Icons.delete,
                      color: ColorResources.white,
                    ),
                    const SizedBox(height: 10.0),
                    Text(getTranslated("DELETE_COMMENT", context),
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(getTranslated("NO", context),
                            style: robotoRegular,
                          )
                        ), 
                        StatefulBuilder(
                          builder: (BuildContext context, Function s) {
                          return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorResources.error
                          ),
                          onPressed: () async { 
                          s(() => deletePostBtn = true);
                            try {         
                              await context.read<p.FeedDetailProviderV2>().deleteComment(
                                context: context, 
                                forumId: feedDetailProvider.feedDetailData.forum!.id!, 
                                deleteId: idComment
                              );               
                              s(() => deletePostBtn = false);
                              Navigator.of(context).pop();             
                            } catch(e) {
                              s(() => deletePostBtn = false);
                              debugPrint(e.toString()); 
                            }
                          },
                          child: deletePostBtn 
                          ? const Loader(
                              color: ColorResources.white,
                            )
                          : Text(getTranslated("YES", context),
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall
                              ),
                            )
                          );
                        })
                      ],
                    ) 
                  ])
                )
              );
            },
          );
        }
      },
    );
  }


}
