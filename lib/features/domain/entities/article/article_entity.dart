import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String? articleId;
  final String? creatorUid;
  final String? username;
  final String? name;
  final String? title;
  final String? description;
  final String? articleImageUrl;
  final String? userProfileUrl;
  final List<String>? likes;
  final num? totalLikes;
  final num? totalComments;
  final Timestamp? createAt;

  const ArticleEntity({
    this.articleId,
    this.creatorUid,
    this.username,
    this.name,
    this.title,
    this.description,
    this.articleImageUrl,
    this.userProfileUrl,
    this.likes,
    this.totalLikes,
    this.totalComments,
    this.createAt,
  });

  @override
  List<Object?> get props => [
        articleId,
        creatorUid,
        username,
        name,
        title,
        description,
        articleImageUrl,
        likes,
        totalLikes,
        totalComments,
        createAt,
        userProfileUrl,
      ];
}
