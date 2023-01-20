import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReplyEntity extends Equatable {
  final String? replyId;
  final String? commentId;
  final String? articleId;
  final String? creatorUid;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;
  final num? totalLikes;

  const ReplyEntity(
    {this.replyId,
    this.commentId,
    this.articleId,
    this.creatorUid,
    this.description,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.totalLikes,}
  );

  @override
  List<Object?> get props => [
        replyId,
        commentId,
        articleId,
        creatorUid,
        description,
        username,
        userProfileUrl,
        createAt,
        likes,
        totalLikes,
      ];
}
