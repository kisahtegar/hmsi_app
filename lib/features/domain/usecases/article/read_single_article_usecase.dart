import '../../entities/article/article_entity.dart';
import '../../repositories/firebase_repository.dart';

class ReadSingleArticleUseCase {
  final FirebaseRepository firebaseRepository;

  const ReadSingleArticleUseCase({required this.firebaseRepository});

  Stream<List<ArticleEntity>> call(String articleId) {
    return firebaseRepository.readSingleArticle(articleId);
  }
}
