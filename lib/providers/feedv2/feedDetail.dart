import 'package:flutter/widgets.dart';
import 'package:hp3ki/providers/profile/profile.dart';

import 'package:provider/provider.dart';

import 'package:flutter_mentions/flutter_mentions.dart';

import 'package:hp3ki/data/models/feedv2/feedDetail.dart';
import 'package:hp3ki/data/models/feedv2/user_mention.dart';

import 'package:hp3ki/data/repository/auth/auth.dart';
import 'package:hp3ki/data/repository/feedv2/feed.dart';
import 'package:hp3ki/maps/src/utils/uuid.dart';

import 'package:hp3ki/utils/exceptions.dart';

enum FeedDetailStatus { idle, loading, loaded, empty, error }
enum UserMentionStatus { idle, loading, loaded, empty, error }

class FeedDetailProviderV2 with ChangeNotifier {
  final AuthRepo ar;
  final FeedRepoV2 fr;
  FeedDetailProviderV2({
    required this.ar,
    required this.fr
  });

  String isReplyId = "";
  String inputVal = "";

  String highlightedComment = "";
  String highlightedReply = "";

  Set<String> ids = {}; 

  bool hasMore = true;
  int pageKey = 1;

  final List<Map<String, dynamic>> _userMentions = [];
  List<Map<String, dynamic>> get userMentions  => [..._userMentions];

  List<CommentElement> _comments = [];
  List<CommentElement> get comments => [..._comments];

  FeedDetailData _feedDetailData = FeedDetailData();
  FeedDetailData get feedDetailData => _feedDetailData;

  FeedDetailStatus _feedDetailStatus = FeedDetailStatus.loading;
  FeedDetailStatus get feedDetailStatus => _feedDetailStatus;

  UserMentionStatus _userMentionStatus = UserMentionStatus.loading;
  UserMentionStatus get userMentionStatus => _userMentionStatus;

  void setStateFeedDetailStatus(FeedDetailStatus feedDetailStatus) {
    _feedDetailStatus = feedDetailStatus;

    notifyListeners();
  }

  void setStateUserMentionStatus(UserMentionStatus userMentionStatus) {
    _userMentionStatus = userMentionStatus;

    notifyListeners();
  } 

  void onListenComment(String val) {
    inputVal = val;

    notifyListeners();
  }

  void onUpdateHighlightComment(String val) {
    highlightedComment = val;

    notifyListeners();
  }

  void onUpdateHighlightReply(String val) {
    highlightedReply = val;

    notifyListeners();
  }

  void onUpdateIsReplyId(String val) {
    isReplyId = val;

    notifyListeners();
  }

  Future<void> getFeedDetail(BuildContext context, String forumId) async {
    pageKey = 1;
    hasMore = true;

    try {
      FeedDetailModel? fdm = await fr.fetchDetail(context, pageKey, forumId);
      _feedDetailData = fdm!.data;

      _comments = [];
      _comments.addAll(fdm.data.forum!.comment!.comments);

      setStateFeedDetailStatus(FeedDetailStatus.loaded);

      if (comments.isEmpty) {
        setStateFeedDetailStatus(FeedDetailStatus.empty);
      }

    } on CustomException catch (e) {
      setStateFeedDetailStatus(FeedDetailStatus.error);
      debugPrint(e.toString());
    } catch (_) {
      setStateFeedDetailStatus(FeedDetailStatus.error);
    }
  }

  Future<void> getUserMentions(BuildContext context, String username) async {
    setStateUserMentionStatus(UserMentionStatus.loading);

    try {

      List<UserMention>? mentions = await fr.userMentions(context, username.replaceAll('@', ''));

      for (UserMention mention in mentions!) {

        if(!ids.contains(mention.id)) {

          _userMentions.add({
            "id": mention.id.toString(),
            "photo": mention.photo.toString(),
            "display": mention.username.toString(),
            "fullname": mention.display.toString()
          });
          ids.add(mention.id);

        }

      }
      
      setStateUserMentionStatus(UserMentionStatus.loaded);
    } on CustomException catch(e) {
      debugPrint(e.toString());
      setStateUserMentionStatus(UserMentionStatus.error);
    } catch(e) {
      debugPrint(e.toString());
      setStateUserMentionStatus(UserMentionStatus.error);
    } 
  }

  Future<void> loadMoreComment({required BuildContext context, required String postId}) async {
    pageKey++;

    FeedDetailModel? g = await fr.fetchDetail(context, pageKey, postId);

    hasMore = g!.data.pageDetail!.hasMore;
    _comments.addAll(g.data.forum!.comment!.comments);
    Future.delayed(Duration.zero, () => notifyListeners());
  }

  Future<void> postComment(
    BuildContext context,
    GlobalKey<FlutterMentionsState> mentionKey,
    String forumId,
  ) async {
    try {

      if (mentionKey.currentState!.controller!.text.trim() == "") {
        mentionKey.currentState!.controller!.text = "";
        return;
      }

      if(isReplyId != "") {

        String replyId = Uuid().generateV4();

        await fr.postReply(
          context: context, replyId: replyId, commentId: isReplyId, 
          reply: inputVal, userId: ar.getUserId().toString(),
        );

        int i = comments.indexWhere((el) => el.id == isReplyId);

        _comments[i].reply.replies.add(ReplyElement(
          id: replyId, 
          reply: inputVal, 
          createdAt: "beberapa detik yang lalu", 
          user: UserReply(
            id: context.read<ProfileProvider>().user!.id.toString(), 
            avatar: context.read<ProfileProvider>().user!.avatar.toString(), 
            username: context.read<ProfileProvider>().user!.fullname.toString(),
            mention: ar.getUserEmail().split('@')[0]
          ), 
          key: GlobalKey()
        ));

        mentionKey.currentState!.controller!.text = "";

        onUpdateIsReplyId("");

        highlightedReply = comments[i].reply.replies.last.id;

        Future.delayed(const Duration(milliseconds: 100), () {
          GlobalKey targetContext = comments[i].reply.replies.last.key;
          Scrollable.ensureVisible(targetContext.currentContext!,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        });

        Future.delayed(const Duration(milliseconds: 1000), () {
          highlightedReply = "";

          notifyListeners();
        });

      } else {

        String commentId = Uuid().generateV4();

        await fr.postComment(
          context: context, commentId: commentId, forumId: forumId, 
          comment: inputVal, userId: ar.getUserId().toString(),
        );

        _comments.add(
          CommentElement(
            id: commentId, 
            comment: inputVal, 
            createdAt: "beberapa detik yang lalu", 
            user: User(
              id: context.read<ProfileProvider>().user!.id.toString(), 
              avatar: context.read<ProfileProvider>().user!.avatar.toString(), 
              username: context.read<ProfileProvider>().user!.fullname.toString(),
              mention: ar.getUserEmail().split('@')[0]
            ),
            reply: CommentReply(total: 0, replies: []), 
            like: CommentLike(total: 0, likes: []),
            key: GlobalKey()
          )
        );

        mentionKey.currentState!.controller!.text = "";

        highlightedComment = comments.last.id;

        Future.delayed(const Duration(milliseconds: 100), () {
          GlobalKey targetContext = comments.last.key;
          Scrollable.ensureVisible(targetContext.currentContext!,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        });

        Future.delayed(const Duration(milliseconds: 1000), () {
          highlightedComment = "";

          notifyListeners();
        });

      }

      setStateFeedDetailStatus(FeedDetailStatus.loaded);

    } on CustomException catch (e) {
      setStateFeedDetailStatus(FeedDetailStatus.error);
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
      setStateFeedDetailStatus(FeedDetailStatus.error);
    }
  }

  Future<void> toggleLike({
    required BuildContext context,
    required String forumId, 
    required ForumLike forumLikes
  }) async {
    try {
      int idxLikes = forumLikes.likes.indexWhere((el) => el.user!.id == ar.getUserId().toString());
      if (idxLikes != -1) {
        forumLikes.likes.removeAt(idxLikes);
        forumLikes.total = forumLikes.total - 1;
      } else {
        forumLikes.likes.add(UserLikes(
          user: UserLike(
          id: ar.getUserId(),
          avatar: '-',
          username: ar.getUserFullname(),
        ),
          
        ));
        forumLikes.total = forumLikes.total + 1;
      }
      await fr.toggleLike(context: context, feedId: forumId, userId: ar.getUserId().toString());
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> toggleLikeComment({
    required BuildContext context,
    required String forumId, 
    required String commentId, 
    required CommentLike commentLikes
  }) async {
    try {
      int idxLikes = commentLikes.likes.indexWhere((el) => el.user!.id == ar.getUserId().toString());
      if (idxLikes != -1) {
        commentLikes.likes.removeAt(idxLikes);
        commentLikes.total = commentLikes.total - 1;
      } else {
        commentLikes.likes.add(UserLikes(
          user: UserLike(
            id: ar.getUserId().toString(),
            avatar: "-",
            username: ar.getUserFullname(),
          )
        ));
        commentLikes.total = commentLikes.total + 1;
      }
      await fr.toggleLikeComment(context: context, feedId: forumId, userId: ar.getUserId().toString(), commentId: commentId);
      Future.delayed(Duration.zero, () => notifyListeners());
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteComment({
    required BuildContext context, 
    required String forumId, 
    required String commentId
  }) async {
    try {
      await fr.deleteComment(context, commentId);

      FeedDetailModel? fdm = await fr.fetchDetail(context, 1, forumId);
      _feedDetailData = fdm!.data;

      _comments.clear();
      _comments.addAll(fdm.data.forum!.comment!.comments);
      
      setStateFeedDetailStatus(FeedDetailStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }


  Future<void> deleteReply({
    required BuildContext context,
    required String forumId, 
    required String replyId
  }) async {
    try {
      await fr.deleteReply(context, replyId);

      FeedDetailModel? fdm = await fr.fetchDetail(context, 1, forumId);
      _feedDetailData = fdm!.data;

      _comments.clear();
      _comments.addAll(fdm.data.forum!.comment!.comments);
      
      setStateFeedDetailStatus(FeedDetailStatus.loaded);
    } on CustomException catch (e) {
      debugPrint(e.toString());
    } catch (_) {}
  }
}