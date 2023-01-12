import '../../entities/article/article_entity.dart';
import '../../repositories/firebase_repository.dart';

class LikeArticleUseCase {
  final FirebaseRepository firebaseRepository;

  const LikeArticleUseCase({required this.firebaseRepository});

  Future<void> call(ArticleEntity articleEntity) {
    return firebaseRepository.likeArticle(articleEntity);
  }
}
