import '../../entities/article/article_entity.dart';
import '../../repositories/firebase_repository.dart';

class ReadArticlesUseCase {
  final FirebaseRepository firebaseRepository;

  const ReadArticlesUseCase({required this.firebaseRepository});

  Stream<List<ArticleEntity>> call(ArticleEntity articleEntity) {
    return firebaseRepository.readArticles(articleEntity);
  }
}
