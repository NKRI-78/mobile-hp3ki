import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hp3ki/data/models/feed/feedsdetail.dart';
import 'package:hp3ki/data/models/feed/feeds.dart';
import 'package:hp3ki/data/repository/feed/feed.dart';
import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/exceptions.dart';
import 'package:hp3ki/utils/helper.dart';
import 'package:hp3ki/utils/shared_preferences.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';

enum AllMemberStatus { idle, loading, loaded, empty }

enum NotificationStatus { idle, loading, loaded, empty }

enum PostStatus { idle, loading, loaded, empty }

enum WritePostStatus { idle, loading, loaded, empty }

enum ForumDetailStatus { idle, loading, loaded, error, empty }

enum CommentMostPopularStatus { idle, loading, loaded, error, empty }

enum CommentSelfStatus { idle, loading, loaded, error, empty }

enum SingleReplyStatus { idle, loading, loaded, error, empty }

enum SingleCommentStatus { idle, loading, loaded, error, empty }

enum SingleFeedtatus { idle, loading, loaded, error, empty }

enum ReplyStatus { idle, loading, loaded, error, empty }

enum StickerStatus { idle, loading, loaded, empty }

enum FeedMostRecentStatus { idle, loading, loaded, error, empty }

enum FeedMostPopularStatus { idle, loading, loaded, error, empty }

enum FeedSelfStatus { idle, loading, loaded, error, empty }

enum FeedMostRecentStatusC { idle, loading, loaded, empty }

enum FeedMostPopularStatusC { idle, loading, loaded, empty }

enum FeedSelfStatusC { idle, loading, loaded, empty }

enum FeedMemberStatus { idle, loading, loaded, empty }

enum FeedMetaDataStatus { idle, loading, loaded, empty }

class FeedProvider with ChangeNotifier {
  final FeedRepo fr;
  FeedProvider({required this.fr});

  int pageRecent = 0;
  int pagePopular = 0;
  int pageSelf = 0;
  int commentPage = 0;
  int prevCommentPage = 0;

  bool loadPageRecent = false;
  bool loadPagePopular = false;
  bool loadPageSelf = false;
  bool loadMoreComment = false;

  bool nullPageRecent = false;
  bool nullPagePopular = false;
  bool nullPageSelf = false;
  bool nullMoreComment = false;

  String? nextCommentURL;
  String? currentPostId;

  WritePostStatus _writePostStatus = WritePostStatus.idle;
  WritePostStatus get writePostStatus => _writePostStatus;

  AllMemberStatus _allMemberStatus = AllMemberStatus.loading;
  AllMemberStatus get allMemberStatus => _allMemberStatus;

  NotificationStatus _notificationStatus = NotificationStatus.loading;
  NotificationStatus get notificationStatus => _notificationStatus;

  PostStatus _postStatus = PostStatus.loading;
  PostStatus get postStatus => _postStatus;

  ForumDetailStatus _forumDetailStatus = ForumDetailStatus.loading;
  ForumDetailStatus get forumDetailStatus => _forumDetailStatus;

  StickerStatus _stickerStatus = StickerStatus.loading;
  StickerStatus get stickerStatus => _stickerStatus;

  SingleCommentStatus _singleCommentStatus = SingleCommentStatus.loading;
  SingleCommentStatus get singleCommentStatus => _singleCommentStatus;

  SingleFeedtatus _singleFeedtatus = SingleFeedtatus.loading;
  SingleFeedtatus get singleFeedtatus => _singleFeedtatus;

  ReplyStatus _replyStatus = ReplyStatus.loading;
  ReplyStatus get replyStatus => _replyStatus;

  FeedMostRecentStatus _feedMostRecentStatus = FeedMostRecentStatus.loading;
  FeedMostRecentStatus get feedMostRecentStatus => _feedMostRecentStatus;

  FeedMostPopularStatus _feedMostPopularStatus = FeedMostPopularStatus.loading;
  FeedMostPopularStatus get feedMostPopularStatus => _feedMostPopularStatus;

  FeedSelfStatus _feedSelfStatus = FeedSelfStatus.loading;
  FeedSelfStatus get feedSelfStatus => _feedSelfStatus;

  FeedMostRecentStatusC _feedMostRecentStatusC = FeedMostRecentStatusC.loading;
  FeedMostRecentStatusC get feedMostRecentStatusC => _feedMostRecentStatusC;

  FeedMostPopularStatusC _feedMostPopularStatusC =
      FeedMostPopularStatusC.loading;
  FeedMostPopularStatusC get feedMostPopularStatusC => _feedMostPopularStatusC;

  FeedSelfStatusC _feedSelfStatusC = FeedSelfStatusC.loading;
  FeedSelfStatusC get feedelfStatusC => _feedSelfStatusC;

  FeedMemberStatus _feedMemberStatus = FeedMemberStatus.loading;
  FeedMemberStatus get feedMemberStatus => _feedMemberStatus;

  FeedMetaDataStatus _feedMetaDataStatus = FeedMetaDataStatus.loading;
  FeedMetaDataStatus get feedMetaDataStatus => _feedMetaDataStatus;

  void setStateWritePost(WritePostStatus writePostStatus) {
    _writePostStatus = writePostStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateMemberStatus(AllMemberStatus allMemberStatus) {
    _allMemberStatus = allMemberStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateNotificationStatus(NotificationStatus notificationStatus) {
    _notificationStatus = notificationStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStatePostStatus(PostStatus postStatus) {
    _postStatus = postStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateForumDetailStatus(ForumDetailStatus forumDetailStatus) {
    _forumDetailStatus = forumDetailStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateStickerStatus(StickerStatus stickerStatus) {
    _stickerStatus = stickerStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSingleCommentStatus(SingleCommentStatus singleCommentStatus) {
    _singleCommentStatus = singleCommentStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateSingleFeedtatus(SingleFeedtatus singleFeedtatus) {
    _singleFeedtatus = singleFeedtatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateReplyStatus(ReplyStatus replyStatus) {
    _replyStatus = replyStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFeedMostRecentStatus(FeedMostRecentStatus feedMostRecentStatus) {
    _feedMostRecentStatus = feedMostRecentStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFeedMostPopularStatus(
      FeedMostPopularStatus feedMostPopularStatus) {
    _feedMostPopularStatus = feedMostPopularStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFeedSelfStatus(FeedSelfStatus feedSelfStatus) {
    _feedSelfStatus = feedSelfStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFeedMostRecentStatusC(
      FeedMostRecentStatusC feedMostRecentStatusC) {
    _feedMostRecentStatusC = feedMostRecentStatusC;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFeedMostPopularStatusC(
      FeedMostPopularStatusC feedMostPopularStatusC) {
    _feedMostPopularStatusC = feedMostPopularStatusC;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFeedSelfStatusC(FeedSelfStatusC feedSelfStatusC) {
    _feedSelfStatusC = feedSelfStatusC;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateFeedMemberStatus(FeedMemberStatus feedMemberStatus) {
    _feedMemberStatus = feedMemberStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void setStateMetaDataStatus(FeedMetaDataStatus feedMetaDataStatus) {
    _feedMetaDataStatus = feedMetaDataStatus;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  ForumDetail? _forumDetail;
  ForumDetail get forumDetail => _forumDetail!;

  FeedModel? _g1;
  FeedModel get g1 => _g1!;

  FeedModel? _g2;
  FeedModel get g2 => _g2!;

  FeedModel? _g3;
  FeedModel get g3 => _g3!;

  ForumDetailBody? _forumDetailData;
  ForumDetailBody? get forumDetailData => _forumDetailData!;

  List<CommentElement> _commentList = [];
  List<CommentElement> get commentList => [..._commentList];

  List<FeedData> _g1List = [];
  List<FeedData> get g1List => [..._g1List];

  List<FeedData> _g2List = [];
  List<FeedData> get g2List => [..._g2List];

  List<FeedData> _g3List = [];
  List<FeedData> get g3List => [..._g3List];

  void nextPageRecent() {
    pageRecent++;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void nextPagePopular() {
    pagePopular++;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void nextPageSelf() {
    pageSelf++;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void nextCommentPage() {
    commentPage++;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void stopLoadMoreComment() {
    loadMoreComment = false;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void stopLoadPageRecent() {
    loadPageRecent = false;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void stopLoadPagePopular() {
    loadPagePopular = false;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void stopLoadPageSelf() {
    loadPageSelf = false;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void emptyMoreComment() {
    nullMoreComment = true;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void emptyPageRecent() {
    nullPageRecent = true;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void emptyPagePopular() {
    nullPagePopular = true;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  void emptyPageSelf() {
    nullPageSelf = true;
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> deleteForum(BuildContext context, String forumId) async {
    try {
      await fr.deleteForum(forumId);
      setStateFeedMostRecentStatus(FeedMostRecentStatus.loading);
      setStateFeedMostPopularStatus(FeedMostPopularStatus.loading);
      setStateFeedSelfStatus(FeedSelfStatus.loading);
      Future.sync(() {
        fetchFeedMostRecent(context);
        fetchFeedMostPopular(context);
        fetchFeedSelf(context);
      });
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
    } catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> likeForum(BuildContext context, String forumId) async {
    try {
      await fr.likeForum(forumId, SharedPrefs.getUserId());
      setStateFeedMostRecentStatus(FeedMostRecentStatus.loading);
      setStateFeedMostPopularStatus(FeedMostPopularStatus.loading);
      setStateFeedSelfStatus(FeedSelfStatus.loading);
      Future.sync(() {
        fetchForumDetail(context, forumId);
        fetchFeedMostRecent(context);
        fetchFeedMostPopular(context);
        fetchFeedSelf(context);
      });
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
    } catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> fetchForumDetail(BuildContext context, String targetId) async {
    setStateForumDetailStatus(ForumDetailStatus.loading);
    try {
      loadMoreComment = true;
      nullMoreComment = false;
      commentPage = 1;
      ForumDetail? fd = await fr.fetchForumDetail(targetId);
      _forumDetail = fd;
      currentPostId = targetId;
      if (fd!.forumDetailPaginate!.total != 0) {
        _forumDetailData = fd.data;
        _commentList = [];
        _commentList.addAll(fd.data!.forumComments!.comments!);
        loadMoreComment = false;
        setStateForumDetailStatus(ForumDetailStatus.loaded);
      } else {
        loadMoreComment = false;
        setStateForumDetailStatus(ForumDetailStatus.empty);
      }
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
      setStateForumDetailStatus(ForumDetailStatus.error);
    } catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
      setStateForumDetailStatus(ForumDetailStatus.error);
    }
  }

  Future<void> fetchMoreComment(BuildContext context) async {
    try {
      if (nullMoreComment == false) {
        if (loadMoreComment == true) {
          nextCommentPage();
          ForumDetail? fd =
              await fr.fetchMoreComment(currentPostId!, commentPage);
          if (fd!.forumDetailPaginate!.total == 0) {
            emptyMoreComment();
          }
          _commentList.addAll(fd.data!.forumComments!.comments!);
          setStateForumDetailStatus(ForumDetailStatus.loaded);
        }
      }
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
    } catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> fetchFeedMostRecent(BuildContext context) async {
    setStateFeedMostRecentStatus(FeedMostRecentStatus.loading);
    try {
      loadPageRecent = true;
      nullPageRecent = false;
      pageRecent = 1;
      FeedModel? g = await fr.fetchFeedMostRecent(pageRecent);
      _g1 = g;
      if (g?.data?.isNotEmpty == true) {
        _g1List = [];
        _g1List.addAll(g!.data!);
        setStateFeedMostRecentStatus(FeedMostRecentStatus.loaded);
      } else {
        setStateFeedMostRecentStatus(FeedMostRecentStatus.empty);
      }
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
      setStateFeedMostRecentStatus(FeedMostRecentStatus.error);
    } catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
      setStateFeedMostRecentStatus(FeedMostRecentStatus.error);
    }
  }

  Future<void> fetchFeedMostPopular(BuildContext context) async {
    setStateFeedMostPopularStatus(FeedMostPopularStatus.loading);
    try {
      loadPagePopular = true;
      nullPagePopular = false;
      pagePopular = 1;
      FeedModel? g = await fr.fetchFeedMostPopular(pagePopular);
      _g2 = g;
      if (g?.data?.isNotEmpty == true) {
        _g2List = [];
        _g2List.addAll(g!.data!);
        setStateFeedMostPopularStatus(FeedMostPopularStatus.loaded);
      } else {
        setStateFeedMostPopularStatus(FeedMostPopularStatus.empty);
      }
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
      setStateFeedMostPopularStatus(FeedMostPopularStatus.error);
    } catch (e) {
      debugPrint(e.toString());
      setStateFeedMostPopularStatus(FeedMostPopularStatus.error);
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> fetchFeedSelf(BuildContext context) async {
    setStateFeedSelfStatus(FeedSelfStatus.loading);
    try {
      loadPageSelf = true;
      nullPageSelf = false;
      pageSelf = 1;
      FeedModel? g = await fr.fetchFeedSelf(pageSelf, SharedPrefs.getUserId());
      _g3 = g;
      if (g?.data?.isNotEmpty == true) {
        _g3List = [];
        _g3List.addAll(g!.data!);
        setStateFeedSelfStatus(FeedSelfStatus.loaded);
      } else {
        setStateFeedSelfStatus(FeedSelfStatus.empty);
      }
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
      setStateFeedSelfStatus(FeedSelfStatus.error);
    } catch (e) {
      debugPrint(e.toString());
      setStateFeedSelfStatus(FeedSelfStatus.error);
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi',
          '',
          ColorResources.error);
    }
  }

  Future<void> fetchFeedMostRecentLoad(BuildContext context) async {
    try {
      if (nullPageRecent == false) {
        if (loadPageRecent == true) {
          nextPageRecent();
          FeedModel? g = await fr.fetchFeedMostRecent(pageRecent);
          if (g!.pageDetail!.total! == 0) {
            emptyPageRecent();
          }
          _g1 = g;
          _g1List.addAll(g.data!);
          setStateFeedMostRecentStatus(FeedMostRecentStatus.loaded);
        }
      }
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
      setStateFeedMostRecentStatus(FeedMostRecentStatus.error);
    } catch (e) {
      debugPrint(e.toString());
      setStateFeedMostRecentStatus(FeedMostRecentStatus.error);
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> fetchFeedMostPopularLoad(BuildContext context) async {
    try {
      if (nullPagePopular == false) {
        if (loadPagePopular == true) {
          nextPagePopular();
          FeedModel? g = await fr.fetchFeedMostPopular(pagePopular);
          if (g!.pageDetail!.total! == 0) {
            emptyPagePopular();
          }
          _g2 = g;
          _g2List.addAll(g.data!);
          setStateFeedMostPopularStatus(FeedMostPopularStatus.loaded);
        }
      }
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
      setStateFeedMostPopularStatus(FeedMostPopularStatus.error);
    } catch (e) {
      debugPrint(e.toString());
      setStateFeedMostPopularStatus(FeedMostPopularStatus.error);
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> fetchFeedSelfLoad(BuildContext context) async {
    try {
      if (nullPageSelf == false) {
        if (loadPageSelf == true) {
          nextPageSelf();
          FeedModel? g =
              await fr.fetchFeedSelf(pageSelf, SharedPrefs.getUserId());
          if (g!.pageDetail!.total! == 0) {
            emptyPageSelf();
          }
          _g3 = g;
          _g3List.addAll(g.data!);
          setStateFeedSelfStatus(FeedSelfStatus.loaded);
        }
      }
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
      setStateFeedSelfStatus(FeedSelfStatus.error);
    } catch (e) {
      debugPrint(e.toString());
      setStateFeedSelfStatus(FeedSelfStatus.error);
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> sendPostText(BuildContext context, String text) async {
    setStateWritePost(WritePostStatus.loading);
    try {
      await fr.sendPostText(
          text, SharedPrefs.getUserId(), Helper.createUniqueV4Id());
      setStateWritePost(WritePostStatus.loaded);
      Future.sync(() {
        fetchFeedMostRecent(context);
        fetchFeedMostPopular(context);
        fetchFeedSelf(context);
      });
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
      setStateWritePost(WritePostStatus.empty);
    } catch (e) {
      debugPrint(e.toString());
      setStateWritePost(WritePostStatus.empty);
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> sendComment(
      BuildContext context, String text, String postId) async {
    try {
      await fr.sendComment(text, postId, SharedPrefs.getUserId());
      Future.sync(() {
        fetchForumDetail(context, postId);
      });
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
    } catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> likeComment(BuildContext context,
      {required String postId, required String commentId}) async {
    try {
      await fr.likeComment(postId, commentId, SharedPrefs.getUserId());
      Future.sync(() {
        fetchForumDetail(context, postId);
      });
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
    } catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> deleteComment(BuildContext context,
      {required String postId, required String commentId}) async {
    try {
      await fr.deleteComment(commentId);
      Future.sync(() {
        fetchForumDetail(context, postId);
      });
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
    } catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> sendReply(BuildContext context,
      {required String text,
      required String commentId,
      required String postId}) async {
    try {
      await fr.sendReply(postId, commentId, SharedPrefs.getUserId(), text);
      Future.sync(() {
        fetchForumDetail(context, postId);
      });
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
    } catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> deleteReply(BuildContext context,
      {required String replyId, required String postId}) async {
    try {
      await fr.deleteReply(replyId);
      Future.sync(() {
        fetchForumDetail(context, postId);
      });
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
    } catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> sendPostLink(
      BuildContext context, String caption, String url) async {
    setStateWritePost(WritePostStatus.loading);
    try {
      final String forumId = Helper.createUniqueV4Id();
      Future.wait([
        fr.sendPostLink(caption, url, SharedPrefs.getUserId(), forumId),
        fr.createForumMedia(forumId, url),
      ]);
      setStateWritePost(WritePostStatus.loaded);
      Future.sync(() {
        fetchFeedMostRecent(context);
        fetchFeedMostPopular(context);
        fetchFeedSelf(context);
      });
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
      setStateWritePost(WritePostStatus.empty);
    } catch (e) {
      debugPrint(e.toString());
      setStateWritePost(WritePostStatus.empty);
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> sendPostImage(
      BuildContext context, String caption, List<File> files) async {
    try {
      String forumId = Helper.createUniqueV4Id();
      String path = "-";
      if (files.length > 1) {
        for (int i = 0; i < files.length; i++) {
          Response? resPath = await fr.uploadMedia("images", files[i]);
          path = resPath!.data!["data"]["path"];
          await fr.createForumMedia(forumId, path);
        }
      } else {
        Response? resPath = await fr.uploadMedia("images", files.first);
        path = resPath!.data["data"]["path"];
        await fr.createForumMedia(forumId, path);
      }
      await fr.sendPostImage(forumId, caption, SharedPrefs.getUserId());
      Future.sync(() {
        fetchFeedMostRecent(context);
        fetchFeedMostPopular(context);
        fetchFeedSelf(context);
      });
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
    } catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> sendPostImageCamera(
      BuildContext context, String caption, File file) async {
    setStateWritePost(WritePostStatus.loading);
    try {
      String forumId = Helper.createUniqueV4Id();
      Response? resPath = await fr.uploadMedia("images", file);
      String path = resPath!.data["data"]["path"];

      Future.wait([
        fr.createForumMedia(forumId, path),
        fr.sendPostImageCamera(forumId, caption, SharedPrefs.getUserId()),
      ]);
      setStateWritePost(WritePostStatus.loaded);
      Future.sync(() {
        fetchFeedMostRecent(context);
        fetchFeedMostPopular(context);
        fetchFeedSelf(context);
      });
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
      setStateWritePost(WritePostStatus.empty);
    } catch (e) {
      debugPrint(e.toString());
      setStateWritePost(WritePostStatus.empty);
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> sendPostDoc(
      BuildContext context, String caption, FilePickerResult files) async {
    try {
      final String forumId = Helper.createUniqueV4Id();
      Response? resPath = await fr.uploadMediaFilePicker("documents", files);
      String path = resPath!.data["data"]["path"];

      Future.wait([
        fr.sendPostDoc(forumId, caption, SharedPrefs.getUserId()),
        fr.createForumMedia(forumId, path),
      ]);
      Future.sync(() {
        fetchFeedMostRecent(context);
        fetchFeedMostPopular(context);
        fetchFeedSelf(context);
      });
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
    } catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }

  Future<void> sendPostVideo(
      BuildContext context, String caption, File? file) async {
    try {
      String forumId = Helper.createUniqueV4Id();
      Response? resPath = await fr.uploadMedia("videos", file!);
      String path = resPath!.data["data"]["path"];

      Future.wait([
        fr.createForumMedia(forumId, path),
        fr.sendPostVideo(forumId, caption, SharedPrefs.getUserId()),
      ]);
      Future.sync(() {
        fetchFeedMostRecent(context);
        fetchFeedMostPopular(context);
        fetchFeedSelf(context);
      });
    } on CustomException catch (e) {
      ShowSnackbar.snackbar(context, '${e.cause}', '', ColorResources.error);
    } catch (e) {
      debugPrint(e.toString());
      ShowSnackbar.snackbar(
          context,
          'Terjadi error tidak terduga pada aplikasi.',
          '',
          ColorResources.error);
    }
  }
}
