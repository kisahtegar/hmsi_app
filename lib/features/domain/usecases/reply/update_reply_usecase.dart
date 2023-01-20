import '../../entities/reply/reply_entity.dart';
import '../../repositories/firebase_repository.dart';

class UpdateReplyUseCase {
  final FirebaseRepository firebaseRepository;

  const UpdateReplyUseCase({required this.firebaseRepository});

  Future<void> call(ReplyEntity replyEntity) {
    return firebaseRepository.updateReply(replyEntity);
  }
}
