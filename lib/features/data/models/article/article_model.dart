import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/article/article_entity.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    String? articleId,
    String? creatorUid,
    String? username,
    String? title,
    String? description,
    String? articleImageUrl,
    String? userProfileUrl,
    List<String>? likes,
    num? totalLikes,
    num? totalComments,
    Timestamp? createAt,
  }) : super(
          articleId: articleId,
          creatorUid: creatorUid,
          username: username,
          title: title,
          description: description,
          articleImageUrl: articleImageUrl,
          userProfileUrl: userProfileUrl,
          likes: likes,
          totalLikes: totalLikes,
          totalComments: totalComments,
          createAt: createAt,
        );

  factory ArticleModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ArticleModel(
      articleId: snapshot['articleId'],
      creatorUid: snapshot['creatorUid'],
      username: snapshot['username'],
      title: snapshot['title'],
      description: snapshot['description'],
      articleImageUrl: snapshot['articleImageUrl'],
      userProfileUrl: snapshot['userProfileUrl'],
      likes: List.from(snap.get("likes")),
      totalLikes: snapshot['totalLikes'],
      totalComments: snapshot['totalComments'],
      createAt: snapshot['createAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        "articleId": articleId,
        "creatorUid": creatorUid,
        "username": username,
        "title": title,
        "description": description,
        "articleImageUrl": articleImageUrl,
        "userProfileUrl": userProfileUrl,
        "likes": likes,
        "totalLikes": totalLikes,
        "totalComments": totalComments,
        "createAt": createAt,
      };
}
