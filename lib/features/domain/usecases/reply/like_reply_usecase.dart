import '../../entities/reply/reply_entity.dart';
import '../../repositories/firebase_repository.dart';

class LikeReplyUseCase {
  final FirebaseRepository firebaseRepository;

  const LikeReplyUseCase({required this.firebaseRepository});

  Future<void> call(ReplyEntity replyEntity) {
    return firebaseRepository.likeReply(replyEntity);
  }
}
