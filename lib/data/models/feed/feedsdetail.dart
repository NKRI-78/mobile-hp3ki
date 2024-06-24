import 'package:equatable/equatable.dart';
import 'package:hp3ki/data/models/feed/feedmedia.dart';

class ForumDetail {
  ForumDetail({
    this.status,
    this.error,
    this.message,
    this.forumDetailPaginate,
    this.data,
  });

  int? status;
  bool? error;
  String? message;
  ForumDetailPaginate? forumDetailPaginate;
  ForumDetailBody? data;

  factory ForumDetail.fromJson(Map<String, dynamic> json) => ForumDetail(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        forumDetailPaginate:
            ForumDetailPaginate.fromJson(json["comment_paginate"]),
        data: ForumDetailBody.fromJson(json["data"]),
      );
}

class ForumDetailPaginate {
  ForumDetailPaginate({
    this.total,
    this.perPage,
    this.nextPage,
    this.prevPage,
    this.currentPage,
    this.nextUrl,
    this.prevUrl,
  });

  int? total;
  int? perPage;
  int? nextPage;
  int? prevPage;
  int? currentPage;
  String? nextUrl;
  String? prevUrl;

  factory ForumDetailPaginate.fromJson(Map<String, dynamic> json) =>
      ForumDetailPaginate(
        total: json["total"],
        perPage: json["per_page"],
        nextPage: json["next_page"],
        prevPage: json["prev_page"],
        currentPage: json["current_page"],
        nextUrl: json["next_url"],
        prevUrl: json["prev_url"],
      );
}

class ForumDetailBody extends Equatable {
  const ForumDetailBody({
    this.uid,
    this.caption,
    this.media,
    this.user,
    this.forumComments,
    this.forumLikes,
    this.forumType,
    this.createdAt,
  });

  final String? uid;
  final String? caption;
  final List<FeedMedia>? media;
  final User? user;
  final ForumComments? forumComments;
  final Likes? forumLikes;
  final String? forumType;
  final DateTime? createdAt;

  factory ForumDetailBody.fromJson(Map<String, dynamic> json) =>
      ForumDetailBody(
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
  const ForumComments({
    this.total,
    this.comments,
  });

  final int? total;
  final List<CommentElement>? comments;

  factory ForumComments.fromJson(Map<String, dynamic> json) => ForumComments(
        total: json["total"],
        comments: List<CommentElement>.from(
            json["comments"].map((x) => CommentElement.fromJson(x))),
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

class CommentElement extends Equatable {
  const CommentElement({
    this.uid,
    this.comment,
    this.commentLikes,
    this.commentReplies,
    this.user,
  });

  final String? uid;
  final String? comment;
  final Likes? commentLikes;
  final CommentReplies? commentReplies;
  final User? user;

  factory CommentElement.fromJson(Map<String, dynamic> json) => CommentElement(
        uid: json["uid"],
        comment: json["comment"],
        commentLikes: Likes.fromJson(json["comment_likes"]),
        commentReplies: CommentReplies.fromJson(json["comment_replies"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "comment": comment,
        "comment_likes": commentLikes?.toJson(),
        "comment_replies": commentReplies?.toJson(),
        "user": user?.toJson(),
      };

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
  const Likes({
    this.total,
    this.likes,
  });

  final int? total;
  final List<Like>? likes;

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
  const Like({
    this.user,
  });

  final User? user;

  factory Like.fromJson(Map<String, dynamic> json) => Like(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
      };

  @override
  List<Object?> get props => [
        user,
      ];
}

class User extends Equatable {
  const User({
    this.uid,
    this.profilePic,
    this.email,
    this.fullname,
  });

  final String? uid;
  final String? profilePic;
  final String? email;
  final String? fullname;

  factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"],
        profilePic: json["avatar"],
        email: json["email"],
        fullname: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": fullname,
        "avatar": profilePic,
        "email": email,
      };

  @override
  List<Object?> get props => [
        uid,
        profilePic,
        email,
        fullname,
      ];
}

class CommentReplies extends Equatable {
  const CommentReplies({
    this.total,
    this.replies,
  });

  final int? total;
  final List<CommentReply>? replies;

  factory CommentReplies.fromJson(Map<String, dynamic> json) => CommentReplies(
        total: json["total"],
        replies: List<CommentReply>.from(
            json["replies"].map((x) => CommentReply.fromJson(x))),
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

class CommentReply extends Equatable {
  const CommentReply({
    this.uid,
    this.reply,
    this.user,
  });

  final String? uid;
  final String? reply;
  final User? user;

  factory CommentReply.fromJson(Map<String, dynamic> json) => CommentReply(
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
