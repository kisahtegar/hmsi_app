import 'package:hmsi_app/features/domain/entities/article/article_entity.dart';
import 'package:hmsi_app/features/domain/entities/user/user_entity.dart';

class AppEntity {
  final UserEntity? currentUser;
  final ArticleEntity? articleEntity;

  // UserEntity
  final String? uid;

  // ArticleEntity
  final String? articleId;
  final String? creatorUid;

  AppEntity({
    this.currentUser,
    this.articleEntity,
    this.uid,
    this.articleId,
    this.creatorUid,
  });
}
