import '../../entities/article/article_entity.dart';
import '../../repositories/firebase_repository.dart';

class CreateArticleUseCase {
  final FirebaseRepository firebaseRepository;
  const CreateArticleUseCase({required this.firebaseRepository});

  Future<void> call(ArticleEntity articleEntity) {
    return firebaseRepository.createArticle(articleEntity);
  }
}
