import '../../entities/user/user_entity.dart';
import '../../repositories/firebase_repository.dart';

class GetSingleOtherUserUseCase {
  final FirebaseRepository firebaseRepository;

  GetSingleOtherUserUseCase({required this.firebaseRepository});

  Stream<List<UserEntity>> call(String otherUid) {
    return firebaseRepository.getSingleOtherUser(otherUid);
  }
}
