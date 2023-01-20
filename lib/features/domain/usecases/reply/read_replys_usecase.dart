import '../../entities/reply/reply_entity.dart';
import '../../repositories/firebase_repository.dart';

class ReadReplysUseCase {
  final FirebaseRepository firebaseRepository;

  const ReadReplysUseCase({required this.firebaseRepository});

  Stream<List<ReplyEntity>> call(ReplyEntity replyEntity) {
    return firebaseRepository.readReplys(replyEntity);
  }
}
