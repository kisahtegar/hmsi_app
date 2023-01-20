import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/user/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    final String? uid,
    final String? npm,
    final String? username,
    final String? name,
    final String? bio,
    final String? email,
    final String? profileUrl,
    final String? role,
  }) : super(
          uid: uid,
          npm: npm,
          username: username,
          name: name,
          bio: bio,
          email: email,
          profileUrl: profileUrl,
          role: role,
        );

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshot['uid'],
      npm: snapshot['npm'],
      username: snapshot['username'],
      name: snapshot['name'],
      bio: snapshot['bio'],
      email: snapshot['email'],
      profileUrl: snapshot['profileUrl'],
      role: snapshot['role'],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "npm": npm,
        "username": username,
        "name": name,
        "bio": bio,
        "email": email,
        "profileUrl": profileUrl,
        "role": role,
      };
}
