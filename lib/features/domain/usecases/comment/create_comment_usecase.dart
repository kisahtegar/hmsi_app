import '../../entities/comment/comment_entity.dart';
import '../../repositories/firebase_repository.dart';

class CreateCommentUseCase {
  final FirebaseRepository firebaseRepository;

  const CreateCommentUseCase({required this.firebaseRepository});

  Future<void> call(CommentEntity commentEntity) {
    return firebaseRepository.createComment(commentEntity);
  }
}
