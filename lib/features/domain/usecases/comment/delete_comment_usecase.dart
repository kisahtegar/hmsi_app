import '../../entities/comment/comment_entity.dart';
import '../../repositories/firebase_repository.dart';

class DeleteCommentUseCase {
  final FirebaseRepository firebaseRepository;

  const DeleteCommentUseCase({required this.firebaseRepository});

  Future<void> call(CommentEntity commentEntity) {
    return firebaseRepository.deleteComment(commentEntity);
  }
}
