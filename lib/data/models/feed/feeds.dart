import 'package:equatable/equatable.dart';
import 'package:hp3ki/data/models/feed/feedmedia.dart';

class FeedModel {
  int? status;
  bool? error;
  String? message;
  PageDetail? pageDetail;
  List<FeedData>? data;

  FeedModel({
    this.status,
    this.error,
    this.message,
    this.pageDetail,
    this.data,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        pageDetail: PageDetail.fromJson(json["pageDetail"]),
        data:
            List<FeedData>.from(json["data"].map((x) => FeedData.fromJson(x))),
      );
}

class FeedData extends Equatable {
  final String? uid;
  final String? caption;
  final List<FeedMedia>? media;
  final User? user;
  final ForumComments? forumComments;
  final Likes? forumLikes;
  final String? forumType;
  final DateTime? createdAt;

  const FeedData({
    this.uid,
    this.caption,
    this.media,
    this.user,
    this.forumComments,
    this.forumLikes,
    this.forumType,
    this.createdAt,
  });

  factory FeedData.fromJson(Map<String, dynamic> json) => FeedData(
        uid: json["uid"],
        caption: json["caption"],
        media: List<FeedMedia>.from(
            json["media"].map((x) => FeedMedia.fromJson(x))),
        user: User.fromJson(json["user"]),
        forumComments: ForumComments.fromJson(json["forum_comments"]),
        forumLikes: Likes.fromJson(json["forum_likes"]),
        forumType: json["forum_type"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "caption": caption,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "user": user?.toJson(),
        "forum_comments": forumComments?.toJson(),
        "forum_likes": forumLikes?.toJson(),
        "forum_type": forumType,
        "created_at": createdAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        uid,
        caption,
        media,
        user,
        forumComments,
        forumLikes,
        forumType,
        createdAt,
      ];
}

class ForumComments extends Equatable {
  final int? total;
  final List<Comment>? comments;

  const ForumComments({
    this.total,
    this.comments,
  });

  factory ForumComments.fromJson(Map<String, dynamic> json) => ForumComments(
        total: json["total"],
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "comments": comments == null
            ? []
            : List<dynamic>.from(comments!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        total,
        comments,
      ];
}

class Comment extends Equatable {
  final String? uid;
  final String? comment;
  final Likes? commentLikes;
  final CommentReplies? commentReplies;
  final User? user;

  const Comment({
    this.uid,
    this.comment,
    this.commentLikes,
    this.commentReplies,
    this.user,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "comment": comment,
        "comment_likes": commentLikes?.toJson(),
        "comment_replies": commentReplies?.toJson(),
        "user": user?.toJson(),
      };

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        uid: json["uid"],
        comment: json["comment"],
        commentLikes: Likes.fromJson(json["comment_likes"]),
        commentReplies: CommentReplies.fromJson(json["comment_replies"]),
        user: User.fromJson(json["user"]),
      );

  @override
  List<Object?> get props => [
        uid,
        comment,
        commentLikes,
        commentReplies,
        user,
      ];
}

class Likes extends Equatable {
  final int? total;
  final List<Like>? likes;

  const Likes({
    this.total,
    this.likes,
  });

  factory Likes.fromJson(Map<String, dynamic> json) => Likes(
        total: json["total"],
        likes: List<Like>.from(json["likes"].map((x) => Like.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "likes": likes == null
            ? []
            : List<dynamic>.from(likes!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        total,
        likes,
      ];
}

class Like extends Equatable {
  final String? uid;
  final User? user;

  const Like({
    this.uid,
    this.user,
  });

  factory Like.fromJson(Map<String, dynamic> json) => Like(
        uid: json["uid"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "user": user?.toJson(),
      };

  @override
  List<Object?> get props => [
        uid,
        user,
      ];
}

class User extends Equatable {
  final String? uid;
  final String? fullname;
  final String? profilePic;

  const User({
    this.uid,
    this.fullname,
    this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"],
        fullname: json["name"],
        profilePic: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": fullname,
        "avatar": profilePic,
      };

  @override
  List<Object?> get props => [
        uid,
        fullname,
        profilePic,
      ];
}

class CommentReplies extends Equatable {
  final int? total;
  final List<Reply>? replies;

  const CommentReplies({
    this.total,
    this.replies,
  });

  factory CommentReplies.fromJson(Map<String, dynamic> json) => CommentReplies(
        total: json["total"],
        replies:
            List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "replies": replies == null
            ? []
            : List<dynamic>.from(replies!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        total,
        replies,
      ];
}

class Reply extends Equatable {
  final String? uid;
  final String? reply;
  final User? user;

  const Reply({
    this.uid,
    this.reply,
    this.user,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        uid: json["uid"],
        reply: json["reply"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "reply": reply,
        "user": user?.toJson(),
      };

  @override
  List<Object?> get props => [
        uid,
        reply,
        user,
      ];
}

class PageDetail {
  int? total;
  int? perPage;
  int? nextPage;
  int? prevPage;
  int? currentPage;
  String? nextUrl;
  String? prevUrl;

  PageDetail({
    this.total,
    this.perPage,
    this.nextPage,
    this.prevPage,
    this.currentPage,
    this.nextUrl,
    this.prevUrl,
  });

  factory PageDetail.fromJson(Map<String, dynamic> json) => PageDetail(
        total: json["total"],
        perPage: json["per_page"],
        nextPage: json["next_page"],
        prevPage: json["prev_page"],
        currentPage: json["current_page"],
        nextUrl: json["next_url"],
        prevUrl: json["prev_url"],
      );
}
