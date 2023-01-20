import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/reply/reply_entity.dart';

class ReplyModel extends ReplyEntity {
  const ReplyModel({
    String? replyId,
    String? commentId,
    String? articleId,
    String? creatorUid,
    String? description,
    String? username,
    String? userProfileUrl,
    Timestamp? createAt,
    List<String>? likes,
    num? totalLikes,
  }) : super(
          replyId: replyId,
          commentId: commentId,
          articleId: articleId,
          creatorUid: creatorUid,
          description: description,
          username: username,
          userProfileUrl: userProfileUrl,
          createAt: createAt,
          likes: likes,
          totalLikes: totalLikes,
        );

  factory ReplyModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ReplyModel(
      replyId: snapshot['replyId'],
      commentId: snapshot['commentId'],
      articleId: snapshot['articleId'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      username: snapshot['username'],
      userProfileUrl: snapshot['userProfileUrl'],
      createAt: snapshot['createAt'],
      likes: List.from(snap.get("likes")),
      totalLikes: snapshot['totalLikes'],
    );
  }

  Map<String, dynamic> toJson() => {
        "replyId": replyId,
        "commentId": commentId,
        "articleId": articleId,
        "creatorUid": creatorUid,
        "description": description,
        "username": username,
        "userProfileUrl": userProfileUrl,
        "createAt": createAt,
        "likes": likes,
        "totalLikes": totalLikes,
      };
}
