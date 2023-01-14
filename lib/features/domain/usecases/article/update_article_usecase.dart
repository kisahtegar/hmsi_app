import '../../entities/article/article_entity.dart';
import '../../repositories/firebase_repository.dart';

class UpdateArticleUseCase {
  final FirebaseRepository firebaseRepository;

  const UpdateArticleUseCase({required this.firebaseRepository});

  Future<void> call(ArticleEntity articleEntity) {
    return firebaseRepository.updateArticle(articleEntity);
  }
}
