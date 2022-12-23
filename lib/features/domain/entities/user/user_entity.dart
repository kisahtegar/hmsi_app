import 'dart:io';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uid;
  final String? npm;
  final String? username;
  final String? name;
  final String? bio;
  final String? email;
  final String? profileUrl;

  // will not going to store in DB
  final String? password;
  final String? otherUid;
  final File? imageFile;

  const UserEntity({
    this.uid,
    this.npm,
    this.username,
    this.name,
    this.bio,
    this.email,
    this.profileUrl,
    this.password,
    this.otherUid,
    this.imageFile,
  });

  @override
  List<Object?> get props => [
        uid,
        npm,
        username,
        name,
        bio,
        email,
        profileUrl,
        password,
        otherUid,
        imageFile,
      ];
}
