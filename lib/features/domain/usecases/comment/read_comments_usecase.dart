import '../../entities/comment/comment_entity.dart';
import '../../repositories/firebase_repository.dart';

class ReadCommentsUseCase {
  final FirebaseRepository firebaseRepository;

  const ReadCommentsUseCase({required this.firebaseRepository});

  Stream<List<CommentEntity>> call(String articleId) {
    return firebaseRepository.readComments(articleId);
  }
}
