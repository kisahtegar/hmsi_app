import '../../entities/reply/reply_entity.dart';
import '../../repositories/firebase_repository.dart';

class DeleteReplyUseCase {
  final FirebaseRepository firebaseRepository;

  const DeleteReplyUseCase({required this.firebaseRepository});

  Future<void> call(ReplyEntity replyEntity) {
    return firebaseRepository.deleteReply(replyEntity);
  }
}
