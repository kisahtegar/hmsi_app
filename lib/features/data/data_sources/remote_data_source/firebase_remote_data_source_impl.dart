import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hmsi_app/const.dart';
import 'package:hmsi_app/features/data/data_sources/remote_data_source/firebase_remote_data_source.dart';
import 'package:hmsi_app/features/data/models/user/user_model.dart';
import 'package:hmsi_app/features/domain/entities/user/user_entity.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  FirebaseRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.firebaseAuth,
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

    userCollection.doc(userEntity.uid).update(userInformation);
  }
}
