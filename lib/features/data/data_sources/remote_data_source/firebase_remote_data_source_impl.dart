import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../models/event/event_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../const.dart';
import '../../../domain/entities/article/article_entity.dart';
import '../../../domain/entities/comment/comment_entity.dart';
import '../../../domain/entities/event/event_entity.dart';
import '../../../domain/entities/reply/reply_entity.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../models/article/article_model.dart';
import '../../models/comment/comment_model.dart';
import '../../models/reply/reply_model.dart';
import '../../models/user/user_model.dart';
import 'firebase_remote_data_source.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  FirebaseRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.firebaseStorage,
  });

  @override
  Future<void> createUser(UserEntity userEntity) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        npm: userEntity.npm,
        username: userEntity.username,
        name: userEntity.name,
        bio: userEntity.bio,
        email: userEntity.email,
        profileUrl: userEntity.profileUrl,
        role: userEntity.role,
      ).toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      debugPrint(
          "[FirebaseRemoteDataSourceImpl]createUser: Some error occur! ($error)");
    });
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConst.users)
        .where('uid', isEqualTo: otherUid)
        .limit(1);

    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConst.users)
        .where('uid', isEqualTo: uid)
        .limit(1);

    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity userEntity) {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signInUser(UserEntity userEntity) async {
    try {
      if (userEntity.email!.isNotEmpty || userEntity.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: userEntity.email!, password: userEntity.password!);
      } else {
        toast("Fields cannot be empty");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        toast("User not found");
      } else if (e.code == "wrong-password") {
        toast("Invalid email or password");
      }
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity userEntity) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: userEntity.email!, password: userEntity.password!)
          .then((value) async {
        if (value.user?.uid != null) {
          await createUser(userEntity);
        }
      });
    } on FirebaseException catch (e) {
      if (e.code == "email-already-in-use") {
        toast("Email is already taken");
      } else {
        toast("Something wrong");
      }
    }
  }

  @override
  Future<void> updateUser(UserEntity userEntity) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    Map<String, dynamic> userInformation = {};

    if (userEntity.npm != "" && userEntity.npm != null) {
      userInformation['npm'] = userEntity.npm;
    }

    if (userEntity.username != "" && userEntity.username != null) {
      userInformation['username'] = userEntity.username;
    }

    if (userEntity.name != "" && userEntity.name != null) {
      userInformation['name'] = userEntity.name;
    }

    if (userEntity.bio != "" && userEntity.bio != null) {
      userInformation['bio'] = userEntity.bio;
    }

    if (userEntity.email != "" && userEntity.email != null) {
      userInformation['email'] = userEntity.email;
    }

    if (userEntity.profileUrl != "" && userEntity.profileUrl != null) {
      userInformation['profileUrl'] = userEntity.profileUrl;
    }
    if (userEntity.role != "" && userEntity.role != null) {
      userInformation['role'] = userEntity.role;
    }

    userCollection.doc(userEntity.uid).update(userInformation);
  }

  @override
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    final uploadTask = ref.putFile(file!);

    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return await imageUrl;
  }

  @override
  Future<void> createArticle(ArticleEntity articleEntity) async {
    final articleCollection =
        firebaseFirestore.collection(FirebaseConst.articles);

    final newArticle = ArticleModel(
      articleId: articleEntity.articleId,
      creatorUid: articleEntity.creatorUid,
      username: articleEntity.username,
      name: articleEntity.name,
      title: articleEntity.title,
      description: articleEntity.description,
      articleImageUrl: articleEntity.articleImageUrl,
      userProfileUrl: articleEntity.userProfileUrl,
      likes: const [],
      totalLikes: 0,
      totalComments: 0,
      createAt: articleEntity.createAt,
    ).toJson();

    try {
      final articleDocRef =
          await articleCollection.doc(articleEntity.articleId).get();

      if (!articleDocRef.exists) {
        articleCollection.doc(articleEntity.articleId).set(newArticle);
      } else {
        articleCollection.doc(articleEntity.articleId).update(newArticle);
      }
    } catch (e) {
      toast("some error occured");
    }
  }

  @override
  Future<void> deleteArticle(ArticleEntity articleEntity) async {
    final articleCollection =
        firebaseFirestore.collection(FirebaseConst.articles);

    try {
      // This logic will deleting Collection document reply and comment because if you
      // delete article document, cannot automatically delete subCollection.
      articleCollection.doc(articleEntity.articleId).delete().then((_) {
        articleCollection
            .doc(articleEntity.articleId)
            .collection(FirebaseConst.comment)
            .get()
            .then((value) {
          for (var doc in value.docs) {
            doc.reference.delete();
            articleCollection
                .doc(articleEntity.articleId)
                .collection(FirebaseConst.comment)
                .doc(doc.reference.id)
                .collection(FirebaseConst.reply)
                .get()
                .then((value) {
              for (var doc in value.docs) {
                doc.reference.delete();
              }
            });
          }
        });
      });
    } catch (e) {
      toast("some error occured");
    }
  }

  @override
  Future<void> likeArticle(ArticleEntity articleEntity) async {
    final articleCollection =
        firebaseFirestore.collection(FirebaseConst.articles);
    final currentUid = await getCurrentUid();
    final articleRef =
        await articleCollection.doc(articleEntity.articleId).get();

    if (articleRef.exists) {
      List likes = articleRef.get("likes");
      final totalLikes = articleRef.get("totalLikes");

      if (likes.contains(currentUid)) {
        articleCollection.doc(articleEntity.articleId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLikes": totalLikes - 1,
        });
      } else {
        articleCollection.doc(articleEntity.articleId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLikes": totalLikes + 1,
        });
      }
    }
  }

  @override
  Stream<List<ArticleEntity>> readArticles(ArticleEntity articleEntity) {
    final articleCollection = firebaseFirestore
        .collection(FirebaseConst.articles)
        .orderBy("createAt", descending: true);

    return articleCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ArticleModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<ArticleEntity>> readSingleArticle(String articleId) {
    final articleCollection = firebaseFirestore
        .collection(FirebaseConst.articles)
        .orderBy("createAt", descending: true)
        .where("articleId", isEqualTo: articleId);

    return articleCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ArticleModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateArticle(ArticleEntity articleEntity) async {
    debugPrint("Passing ");
    final articleCollection =
        firebaseFirestore.collection(FirebaseConst.articles);
    Map<String, dynamic> articleInfo = {};

    if (articleEntity.title != "" && articleEntity.title != null) {
      articleInfo['title'] = articleEntity.title;
    }
    if (articleEntity.description != "" && articleEntity.description != null) {
      articleInfo['description'] = articleEntity.description;
    }
    if (articleEntity.articleImageUrl != "" &&
        articleEntity.articleImageUrl != null) {
      articleInfo['articleImageUrl'] = articleEntity.articleImageUrl;
    }

    articleCollection.doc(articleEntity.articleId).update(articleInfo);
  }

  @override
  Future<void> createComment(CommentEntity commentEntity) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.articles)
        .doc(commentEntity.articleId)
        .collection(FirebaseConst.comment);

    final newComment = CommentModel(
      commentId: commentEntity.commentId,
      articleId: commentEntity.articleId,
      creatorUid: commentEntity.creatorUid,
      description: commentEntity.description,
      username: commentEntity.username,
      userProfileUrl: commentEntity.userProfileUrl,
      createAt: commentEntity.createAt,
      likes: const [],
      totalLikes: commentEntity.totalLikes,
      totalReply: commentEntity.totalReply,
    ).toJson();

    try {
      final commentDocRef =
          await commentCollection.doc(commentEntity.commentId).get();

      if (!commentDocRef.exists) {
        commentCollection.doc(commentEntity.commentId).set(newComment).then(
          (value) {
            final articleSelection = firebaseFirestore
                .collection(FirebaseConst.articles)
                .doc(commentEntity.articleId);

            articleSelection.get().then((value) {
              if (value.exists) {
                final totalComments = value.get('totalComments');
                articleSelection.update({"totalComments": totalComments + 1});
                return;
              }
            });
          },
        );
      } else {
        commentCollection.doc(commentEntity.commentId).update(newComment);
      }
    } catch (e) {
      toast("Some error occured");
    }
  }

  @override
  Future<void> deleteComment(CommentEntity commentEntity) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.articles)
        .doc(commentEntity.articleId)
        .collection(FirebaseConst.comment);

    try {
      commentCollection.doc(commentEntity.commentId).delete().then((value) {
        final articleCollection = firebaseFirestore
            .collection(FirebaseConst.articles)
            .doc(commentEntity.articleId);

        articleCollection.get().then((value) {
          if (value.exists) {
            final totalComments = value.get('totalComments');
            articleCollection.update({"totalComments": totalComments - 1});
            return;
          }
        });
      });
    } catch (e) {
      toast("Some error occured");
    }
  }

  @override
  Future<void> likeComment(CommentEntity commentEntity) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.articles)
        .doc(commentEntity.articleId)
        .collection(FirebaseConst.comment);
    final currentUid = await getCurrentUid();
    final commentDocRef =
        await commentCollection.doc(commentEntity.commentId).get();

    if (commentDocRef.exists) {
      List likes = commentDocRef.get("likes");
      final totalLikes = commentDocRef.get("totalLikes");
      if (likes.contains(currentUid)) {
        commentCollection.doc(commentEntity.commentId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLikes": totalLikes - 1,
        });
      } else {
        commentCollection.doc(commentEntity.commentId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLikes": totalLikes + 1,
        });
      }
    }
  }

  @override
  Stream<List<CommentEntity>> readComments(String articleId) {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.articles)
        .doc(articleId)
        .collection(FirebaseConst.comment)
        .orderBy("createAt", descending: true);

    return commentCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => CommentModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateComment(CommentEntity commentEntity) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConst.articles)
        .doc(commentEntity.articleId)
        .collection(FirebaseConst.comment);

    Map<String, dynamic> commentInfo = {};

    if (commentEntity.description != "" && commentEntity.description != null) {
      commentInfo['description'] = commentEntity.description;
    }

    commentCollection.doc(commentEntity.commentId).update(commentInfo);
  }

  @override
  Future<void> createReply(ReplyEntity replyEntity) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.articles)
        .doc(replyEntity.articleId)
        .collection(FirebaseConst.comment)
        .doc(replyEntity.commentId)
        .collection(FirebaseConst.reply);

    final newReply = ReplyModel(
      replyId: replyEntity.replyId,
      commentId: replyEntity.commentId,
      articleId: replyEntity.articleId,
      creatorUid: replyEntity.creatorUid,
      description: replyEntity.description,
      username: replyEntity.username,
      userProfileUrl: replyEntity.userProfileUrl,
      createAt: replyEntity.createAt,
      likes: const [],
      totalLikes: replyEntity.totalLikes,
    ).toJson();

    try {
      final replyDocRef = await replyCollection.doc(replyEntity.replyId).get();

      if (!replyDocRef.exists) {
        replyCollection.doc(replyEntity.replyId).set(newReply).then((value) {
          final commentSelection = firebaseFirestore
              .collection(FirebaseConst.articles)
              .doc(replyEntity.articleId)
              .collection(FirebaseConst.comment)
              .doc(replyEntity.commentId);

          commentSelection.get().then((value) {
            if (value.exists) {
              final totalReplys = value.get('totalReplys');
              commentSelection.update({"totalReplys": totalReplys + 1});
              return;
            }
          });
        });
      }
    } catch (e) {
      toast("Some error occured");
    }
  }

  @override
  Future<void> deleteReply(ReplyEntity replyEntity) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.articles)
        .doc(replyEntity.articleId)
        .collection(FirebaseConst.comment)
        .doc(replyEntity.commentId)
        .collection(FirebaseConst.reply);

    try {
      replyCollection.doc(replyEntity.replyId).delete().then((value) {
        final commentSelection = firebaseFirestore
            .collection(FirebaseConst.articles)
            .doc(replyEntity.articleId)
            .collection(FirebaseConst.comment)
            .doc(replyEntity.commentId);

        commentSelection.get().then((value) {
          if (value.exists) {
            final totalReplys = value.get('totalReplys');
            commentSelection.update({"totalReplys": totalReplys - 1});
            return;
          }
        });
      });
    } catch (e) {
      toast("Some error occured");
    }
  }

  @override
  Future<void> likeReply(ReplyEntity replyEntity) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.articles)
        .doc(replyEntity.articleId)
        .collection(FirebaseConst.comment)
        .doc(replyEntity.commentId)
        .collection(FirebaseConst.reply);
    final currentUid = await getCurrentUid();
    final replyDocRef = await replyCollection.doc(replyEntity.replyId).get();

    if (replyDocRef.exists) {
      List likes = replyDocRef.get("likes");
      final totalLikes = replyDocRef.get("totalLikes");

      if (likes.contains(currentUid)) {
        replyCollection.doc(replyEntity.replyId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLikes": totalLikes - 1,
        });
      } else {
        replyCollection.doc(replyEntity.replyId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLikes": totalLikes + 1,
        });
      }
    }
  }

  @override
  Stream<List<ReplyEntity>> readReplys(ReplyEntity replyEntity) {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.articles)
        .doc(replyEntity.articleId)
        .collection(FirebaseConst.comment)
        .doc(replyEntity.commentId)
        .collection(FirebaseConst.reply);

    return replyCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ReplyModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateReply(ReplyEntity replyEntity) async {
    final replyCollection = firebaseFirestore
        .collection(FirebaseConst.articles)
        .doc(replyEntity.articleId)
        .collection(FirebaseConst.comment)
        .doc(replyEntity.commentId)
        .collection(FirebaseConst.reply);
    Map<String, dynamic> replyInfo = {};

    if (replyEntity.description != "" && replyEntity.description != null) {
      replyInfo['description'] = replyEntity.description;
    }

    replyCollection.doc(replyEntity.replyId).update(replyInfo);
  }

  @override
  Future<void> createEvent(EventEntity eventEntity) async {
    final eventCollection = firebaseFirestore.collection(FirebaseConst.event);

    final newEvent = EventModel(
      eventId: eventEntity.eventId,
      creatorUid: eventEntity.creatorUid,
      username: eventEntity.username,
      name: eventEntity.name,
      userProfileUrl: eventEntity.userProfileUrl,
      type: eventEntity.type,
      title: eventEntity.title,
      description: eventEntity.description,
      location: eventEntity.location,
      link: eventEntity.link,
      interested: const [],
      totalInterested: 0,
      date: eventEntity.date,
      time: eventEntity.time,
      createAt: eventEntity.createAt,
    ).toJson();

    try {
      final eventDocRef = await eventCollection.doc(eventEntity.eventId).get();

      if (!eventDocRef.exists) {
        eventCollection.doc(eventEntity.eventId).set(newEvent);
      } else {
        eventCollection.doc(eventEntity.eventId).update(newEvent);
      }
    } catch (e) {
      toast("Some error occured");
    }
  }

  @override
  Future<void> deleteEvent(EventEntity eventEntity) async {
    final eventCollection = firebaseFirestore.collection(FirebaseConst.event);

    try {
      eventCollection.doc(eventEntity.eventId).delete();
    } catch (e) {
      toast("Some error occured");
    }
  }

  @override
  Stream<List<EventEntity>> readEvents(EventEntity eventEntity) {
    final eventCollection = firebaseFirestore
        .collection(FirebaseConst.event)
        .orderBy("createAt", descending: true);

    return eventCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => EventModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> interestedEvent(EventEntity eventEntity) async {
    final eventCollection = firebaseFirestore.collection(FirebaseConst.event);
    final currentUid = await getCurrentUid();
    final eventRef = await eventCollection.doc(eventEntity.eventId).get();

    if (eventRef.exists) {
      List interested = eventRef.get("interested");
      final totalInterested = eventRef.get("totalInterested");

      if (interested.contains(currentUid)) {
        eventCollection.doc(eventEntity.eventId).update({
          "interested": FieldValue.arrayRemove([currentUid]),
          "totalInterested": totalInterested - 1,
        });
      } else {
        eventCollection.doc(eventEntity.eventId).update({
          "interested": FieldValue.arrayUnion([currentUid]),
          "totalInterested": totalInterested + 1,
        });
      }
    }
  }

  @override
  Stream<List<EventEntity>> readSingleEvent(String eventId) {
    final eventCollection = firebaseFirestore
        .collection(FirebaseConst.event)
        .orderBy("createAt", descending: true)
        .where("eventId", isEqualTo: eventId);

    return eventCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => EventModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateEvent(EventEntity eventEntity) async {
    final eventCollection = firebaseFirestore.collection(FirebaseConst.event);

    Map<String, dynamic> eventInfo = {};

    if (eventEntity.title != "" && eventEntity.title != null) {
      eventInfo['title'] = eventEntity.title;
    }
    if (eventEntity.description != "" && eventEntity.description != null) {
      eventInfo['description'] = eventEntity.description;
    }
    if (eventEntity.date != null) {
      eventInfo['date'] = eventEntity.date;
    }
    if (eventEntity.time != null) {
      eventInfo['time'] = eventEntity.time;
    }
    if (eventEntity.type != "" && eventEntity.type != null) {
      eventInfo['type'] = eventEntity.type;
    }
    if (eventEntity.location != "" && eventEntity.location != null) {
      eventInfo['location'] = eventEntity.location;
    }
    if (eventEntity.link != "" && eventEntity.link != null) {
      eventInfo['link'] = eventEntity.link;
    }

    eventCollection.doc(eventEntity.eventId).update(eventInfo);
  }
}
