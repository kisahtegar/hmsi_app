import '../../entities/comment/comment_entity.dart';
import '../../repositories/firebase_repository.dart';

class LikeCommentUseCase {
  final FirebaseRepository firebaseRepository;

  const LikeCommentUseCase({required this.firebaseRepository});

  Future<void> call(CommentEntity commentEntity) {
    return firebaseRepository.likeComment(commentEntity);
  }
}
