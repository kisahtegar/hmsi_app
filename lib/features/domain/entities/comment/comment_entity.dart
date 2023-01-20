import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String? commentId;
  final String? articleId;
  final String? creatorUid;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;
  final num? totalLikes;
  final num? totalReply;

  const CommentEntity({
    this.commentId,
    this.articleId,
    this.creatorUid,
    this.description,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.totalLikes,
    this.totalReply,
  });

  @override
  List<Object?> get props => [
        commentId,
        articleId,
        creatorUid,
        description,
        username,
        userProfileUrl,
        createAt,
        likes,
        totalLikes,
        totalReply,
      ];
}
