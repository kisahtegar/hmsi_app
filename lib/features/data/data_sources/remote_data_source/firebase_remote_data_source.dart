import 'dart:io';

import '../../../domain/entities/article/article_entity.dart';
import '../../../domain/entities/comment/comment_entity.dart';
import '../../../domain/entities/event/event_entity.dart';
import '../../../domain/entities/reply/reply_entity.dart';
import '../../../domain/entities/user/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  // Credential Features
  Future<void> signInUser(UserEntity userEntity);
  Future<void> signUpUser(UserEntity userEntity);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User Features
  Stream<List<UserEntity>> getUsers(UserEntity userEntity);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity userEntity);
  Future<void> updateUser(UserEntity userEntity);

  // Cloud Storage Features
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName);

  // Article Features
  Future<void> createArticle(ArticleEntity articleEntity);
  Stream<List<ArticleEntity>> readArticles(ArticleEntity articleEntity);
  Stream<List<ArticleEntity>> readSingleArticle(String articleId);
  Future<void> updateArticle(ArticleEntity articleEntity);
  Future<void> deleteArticle(ArticleEntity articleEntity);
  Future<void> likeArticle(ArticleEntity articleEntity);

  // Comment Features
  Future<void> createComment(CommentEntity commentEntity);
  Stream<List<CommentEntity>> readComments(String articleId);
  Future<void> updateComment(CommentEntity commentEntity);
  Future<void> deleteComment(CommentEntity commentEntity);
  Future<void> likeComment(CommentEntity commentEntity);

  // Reply Features
  Future<void> createReply(ReplyEntity replyEntity);
  Stream<List<ReplyEntity>> readReplys(ReplyEntity replyEntity);
  Future<void> updateReply(ReplyEntity replyEntity);
  Future<void> deleteReply(ReplyEntity replyEntity);
  Future<void> likeReply(ReplyEntity replyEntity);

  // Event Features
  Future<void> createEvent(EventEntity eventEntity);
  Stream<List<EventEntity>> readEvents(EventEntity eventEntity);
  Stream<List<EventEntity>> readSingleEvent(String eventId);
  Future<void> updateEvent(EventEntity eventEntity);
  Future<void> deleteEvent(EventEntity eventEntity);
}
