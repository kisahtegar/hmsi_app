import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hmsi_app/features/data/models/article/article_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../const.dart';
import '../../../domain/entities/article/article_entity.dart';
import '../../../domain/entities/user/user_entity.dart';
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
      articleCollection.doc(articleEntity.articleId).delete();
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
  Future<void> updateArticle(ArticleEntity articleEntity) async {
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
}
