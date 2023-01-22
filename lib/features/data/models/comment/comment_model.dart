import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/comment/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    String? commentId,
    String? articleId,
    String? creatorUid,
    String? description,
    String? username,
    String? userProfileUrl,
    Timestamp? createAt,
    List<String>? likes,
    num? totalLikes,
    num? totalReply,
  }) : super(
          commentId: commentId,
          articleId: articleId,
          creatorUid: creatorUid,
          description: description,
          username: username,
          userProfileUrl: userProfileUrl,
          createAt: createAt,
          likes: likes,
          totalLikes: totalLikes,
          totalReply: totalReply,
        );

  factory CommentModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CommentModel(
      commentId: snapshot['commentId'],
      articleId: snapshot['articleId'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      username: snapshot['username'],
      userProfileUrl: snapshot['userProfileUrl'],
      createAt: snapshot['createAt'],
      likes: List.from(snap.get("likes")),
      totalLikes: snapshot['totalLikes'],
      totalReply: snapshot['totalReplys'],
    );
  }

  Map<String, dynamic> toJson() => {
        "commentId": commentId,
        "articleId": articleId,
        "creatorUid": creatorUid,
        "description": description,
        "username": username,
        "userProfileUrl": userProfileUrl,
        "createAt": createAt,
        "likes": likes,
        "totalLikes": totalLikes,
        "totalReplys": totalReply,
      };
}
