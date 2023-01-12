import '../../entities/article/article_entity.dart';
import '../../repositories/firebase_repository.dart';

class DeleteArticleUseCase {
  final FirebaseRepository firebaseRepository;

  const DeleteArticleUseCase({required this.firebaseRepository});

  Future<void> call(ArticleEntity articleEntity) {
    return firebaseRepository.deleteArticle(articleEntity);
  }
}
