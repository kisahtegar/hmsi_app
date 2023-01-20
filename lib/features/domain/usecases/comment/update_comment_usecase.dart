import '../../entities/comment/comment_entity.dart';
import '../../repositories/firebase_repository.dart';

class UpdateCommentUseCase {
  final FirebaseRepository firebaseRepository;

  const UpdateCommentUseCase({required this.firebaseRepository});

  Future<void> call(CommentEntity commentEntity) {
    return firebaseRepository.updateComment(commentEntity);
  }
}
