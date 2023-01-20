import '../../entities/reply/reply_entity.dart';
import '../../repositories/firebase_repository.dart';

class CreateReplyUseCase {
  final FirebaseRepository firebaseRepository;

  const CreateReplyUseCase({required this.firebaseRepository});

  Future<void> call(ReplyEntity replyEntity) {
    return firebaseRepository.createReply(replyEntity);
  }
}
